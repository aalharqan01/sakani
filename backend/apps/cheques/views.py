from datetime import timedelta

from django.db.models import Count, Q, Sum
from django.utils import timezone
from rest_framework import status, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

from apps.core.permissions import IsAdminOrLandlord

from .models import Cheque, ChequeStatusLog
from .serializers import (
    ChequeBulkCreateSerializer,
    ChequeCreateSerializer,
    ChequeDetailSerializer,
    ChequeListSerializer,
    ChequeStatusUpdateSerializer,
)


class ChequeViewSet(viewsets.ModelViewSet):
    queryset = Cheque.objects.filter(is_deleted=False).select_related(
        "lease__tenant", "lease__unit__building__compound"
    )
    filterset_fields = ["lease", "status", "bank_name"]
    search_fields = ["cheque_number", "bank_name", "payee_name"]
    ordering_fields = ["due_date", "amount", "status"]

    def get_serializer_class(self):
        if self.action == "list":
            return ChequeListSerializer
        if self.action in ("create",):
            return ChequeCreateSerializer
        return ChequeDetailSerializer

    def get_permissions(self):
        if self.action in ("create", "update", "partial_update", "destroy"):
            return [IsAdminOrLandlord()]
        return super().get_permissions()

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)

    def _update_status(self, request, pk, new_status):
        """Helper to update cheque status with audit log."""
        cheque = self.get_object()
        serializer = ChequeStatusUpdateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        old_status = cheque.status
        cheque.status = new_status
        today = timezone.now().date()

        if new_status == Cheque.ChequeStatus.DEPOSITED:
            cheque.deposited_date = today
        elif new_status == Cheque.ChequeStatus.CLEARED:
            cheque.cleared_date = today
        elif new_status == Cheque.ChequeStatus.BOUNCED:
            cheque.bounced_date = today
            cheque.bounce_reason = serializer.validated_data.get(
                "bounce_reason", ""
            )

        cheque.save()

        ChequeStatusLog.objects.create(
            cheque=cheque,
            from_status=old_status,
            to_status=new_status,
            changed_by=request.user,
            notes=serializer.validated_data.get("notes", ""),
        )

        return Response(ChequeDetailSerializer(cheque).data)

    @action(detail=True, methods=["post"])
    def deposit(self, request, pk=None):
        return self._update_status(request, pk, Cheque.ChequeStatus.DEPOSITED)

    @action(detail=True, methods=["post"])
    def clear(self, request, pk=None):
        return self._update_status(request, pk, Cheque.ChequeStatus.CLEARED)

    @action(detail=True, methods=["post"])
    def bounce(self, request, pk=None):
        return self._update_status(request, pk, Cheque.ChequeStatus.BOUNCED)

    @action(detail=True, methods=["post"])
    def replace(self, request, pk=None):
        """Register a replacement cheque for a bounced one."""
        bounced_cheque = self.get_object()
        if bounced_cheque.status != Cheque.ChequeStatus.BOUNCED:
            return Response(
                {"detail": "Only bounced cheques can be replaced."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        serializer = ChequeCreateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        new_cheque = serializer.save(
            replaces=bounced_cheque, created_by=request.user
        )

        bounced_cheque.status = Cheque.ChequeStatus.REPLACED
        bounced_cheque.save(update_fields=["status", "updated_at"])

        ChequeStatusLog.objects.create(
            cheque=bounced_cheque,
            from_status=Cheque.ChequeStatus.BOUNCED,
            to_status=Cheque.ChequeStatus.REPLACED,
            changed_by=request.user,
            notes=f"Replaced by cheque #{new_cheque.cheque_number}",
        )

        return Response(
            ChequeDetailSerializer(new_cheque).data,
            status=status.HTTP_201_CREATED,
        )

    @action(detail=False, methods=["post"])
    def bulk_create(self, request):
        """Create a full cheque schedule for a lease."""
        serializer = ChequeBulkCreateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        cheques_data = serializer.validated_data["cheques"]
        created = []
        for cheque_data in cheques_data:
            cheque_data["created_by"] = request.user
            cheque = Cheque.objects.create(**cheque_data)
            created.append(cheque)

        return Response(
            ChequeListSerializer(created, many=True).data,
            status=status.HTTP_201_CREATED,
        )

    @action(detail=False, methods=["get"])
    def upcoming(self, request):
        """Cheques due in the next 30 days."""
        today = timezone.now().date()
        cheques = self.get_queryset().filter(
            status=Cheque.ChequeStatus.PENDING,
            due_date__gte=today,
            due_date__lte=today + timedelta(days=30),
        )
        serializer = ChequeListSerializer(cheques, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=["get"])
    def overdue(self, request):
        """All overdue cheques."""
        today = timezone.now().date()
        cheques = self.get_queryset().filter(
            status=Cheque.ChequeStatus.PENDING, due_date__lt=today
        )
        serializer = ChequeListSerializer(cheques, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=["get"])
    def dashboard(self, request):
        """Summary stats for cheque dashboard."""
        today = timezone.now().date()
        qs = self.get_queryset()
        return Response(
            {
                "total": qs.count(),
                "pending": qs.filter(status="pending").count(),
                "cleared": qs.filter(status="cleared").count(),
                "bounced": qs.filter(status="bounced").count(),
                "overdue": qs.filter(
                    status="pending", due_date__lt=today
                ).count(),
                "upcoming_30_days": qs.filter(
                    status="pending",
                    due_date__gte=today,
                    due_date__lte=today + timedelta(days=30),
                ).count(),
                "total_amount": qs.aggregate(total=Sum("amount"))["total"] or 0,
                "cleared_amount": qs.filter(status="cleared").aggregate(
                    total=Sum("amount")
                )["total"]
                or 0,
            }
        )
