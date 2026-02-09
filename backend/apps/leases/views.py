from rest_framework import status, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

from apps.core.permissions import IsAdminOrLandlord

from .models import Lease
from .serializers import (
    LeaseCreateUpdateSerializer,
    LeaseDetailSerializer,
    LeaseListSerializer,
)


class LeaseViewSet(viewsets.ModelViewSet):
    queryset = Lease.objects.filter(is_deleted=False).select_related(
        "unit__building__compound", "tenant", "landlord"
    )
    filterset_fields = ["unit", "tenant", "status", "payment_frequency"]
    search_fields = ["tenant__full_name_en", "unit__unit_number"]
    ordering_fields = ["start_date", "end_date", "monthly_rent"]

    def get_serializer_class(self):
        if self.action == "list":
            return LeaseListSerializer
        if self.action in ("create", "update", "partial_update"):
            return LeaseCreateUpdateSerializer
        return LeaseDetailSerializer

    def get_permissions(self):
        if self.action in ("create", "update", "partial_update", "destroy"):
            return [IsAdminOrLandlord()]
        return super().get_permissions()

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)

    @action(detail=True, methods=["post"])
    def activate(self, request, pk=None):
        lease = self.get_object()
        if lease.status != Lease.LeaseStatus.DRAFT:
            return Response(
                {"detail": "Only draft leases can be activated."},
                status=status.HTTP_400_BAD_REQUEST,
            )
        lease.status = Lease.LeaseStatus.ACTIVE
        lease.save(update_fields=["status", "updated_at"])
        # Mark unit as occupied
        lease.unit.status = "occupied"
        lease.unit.save(update_fields=["status", "updated_at"])
        return Response(LeaseDetailSerializer(lease).data)

    @action(detail=True, methods=["post"])
    def terminate(self, request, pk=None):
        lease = self.get_object()
        if lease.status != Lease.LeaseStatus.ACTIVE:
            return Response(
                {"detail": "Only active leases can be terminated."},
                status=status.HTTP_400_BAD_REQUEST,
            )
        lease.status = Lease.LeaseStatus.TERMINATED
        lease.termination_reason = request.data.get("reason", "")
        lease.save(update_fields=["status", "termination_reason", "updated_at"])
        # Mark unit as vacant
        lease.unit.status = "vacant"
        lease.unit.save(update_fields=["status", "updated_at"])
        return Response(LeaseDetailSerializer(lease).data)
