from django.utils import timezone
from rest_framework import mixins, status, viewsets
from rest_framework.decorators import action
from rest_framework.parsers import FormParser, MultiPartParser
from rest_framework.response import Response

from apps.core.permissions import IsAdminOrLandlord, IsMaintenance, IsTenant

from .models import (
    MaintenanceCategory,
    MaintenanceComment,
    MaintenanceImage,
    MaintenanceQuote,
    MaintenanceRequest,
)
from .serializers import (
    MaintenanceCategorySerializer,
    MaintenanceCommentSerializer,
    MaintenanceImageSerializer,
    MaintenanceQuoteSerializer,
    MaintenanceRequestCreateSerializer,
    MaintenanceRequestDetailSerializer,
    MaintenanceRequestListSerializer,
)


class MaintenanceCategoryViewSet(
    mixins.ListModelMixin, viewsets.GenericViewSet
):
    queryset = MaintenanceCategory.objects.filter(is_active=True, is_deleted=False)
    serializer_class = MaintenanceCategorySerializer


class MaintenanceRequestViewSet(viewsets.ModelViewSet):
    queryset = MaintenanceRequest.objects.filter(is_deleted=False).select_related(
        "unit__building__compound", "tenant", "category", "assigned_to"
    )
    filterset_fields = ["unit", "tenant", "category", "urgency", "status", "assigned_to"]
    search_fields = ["title", "reference_number", "description"]
    ordering_fields = ["created_at", "urgency", "status"]

    def get_serializer_class(self):
        if self.action == "list":
            return MaintenanceRequestListSerializer
        if self.action == "create":
            return MaintenanceRequestCreateSerializer
        return MaintenanceRequestDetailSerializer

    def perform_create(self, serializer):
        serializer.save(tenant=self.request.user, created_by=self.request.user)

    @action(
        detail=True,
        methods=["post"],
        parser_classes=[MultiPartParser, FormParser],
    )
    def images(self, request, pk=None):
        """Upload images to a maintenance request."""
        maintenance_request = self.get_object()
        serializer = MaintenanceImageSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save(
            request=maintenance_request, uploaded_by=request.user
        )
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    @action(detail=True, methods=["post"])
    def quote(self, request, pk=None):
        """Maintenance team submits a quote."""
        maintenance_request = self.get_object()
        serializer = MaintenanceQuoteSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save(
            request=maintenance_request, provided_by=request.user
        )
        maintenance_request.status = MaintenanceRequest.Status.QUOTED
        maintenance_request.save(update_fields=["status", "updated_at"])
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    @action(detail=True, methods=["post"])
    def accept_quote(self, request, pk=None):
        """Tenant accepts a quote."""
        maintenance_request = self.get_object()
        quote_id = request.data.get("quote_id")
        try:
            quote = maintenance_request.quotes.get(id=quote_id)
        except MaintenanceQuote.DoesNotExist:
            return Response(
                {"detail": "Quote not found."},
                status=status.HTTP_404_NOT_FOUND,
            )
        quote.status = MaintenanceQuote.QuoteStatus.ACCEPTED
        quote.save(update_fields=["status", "updated_at"])
        maintenance_request.status = MaintenanceRequest.Status.QUOTE_ACCEPTED
        maintenance_request.save(update_fields=["status", "updated_at"])
        return Response(MaintenanceQuoteSerializer(quote).data)

    @action(detail=True, methods=["post"])
    def reject_quote(self, request, pk=None):
        """Tenant rejects a quote."""
        maintenance_request = self.get_object()
        quote_id = request.data.get("quote_id")
        try:
            quote = maintenance_request.quotes.get(id=quote_id)
        except MaintenanceQuote.DoesNotExist:
            return Response(
                {"detail": "Quote not found."},
                status=status.HTTP_404_NOT_FOUND,
            )
        quote.status = MaintenanceQuote.QuoteStatus.REJECTED
        quote.save(update_fields=["status", "updated_at"])
        maintenance_request.status = MaintenanceRequest.Status.QUOTE_REJECTED
        maintenance_request.save(update_fields=["status", "updated_at"])
        return Response(MaintenanceQuoteSerializer(quote).data)

    @action(detail=True, methods=["post"])
    def complete(self, request, pk=None):
        """Mark maintenance request as completed."""
        maintenance_request = self.get_object()
        maintenance_request.status = MaintenanceRequest.Status.COMPLETED
        maintenance_request.completed_at = timezone.now()
        maintenance_request.save(
            update_fields=["status", "completed_at", "updated_at"]
        )
        return Response(
            MaintenanceRequestDetailSerializer(
                maintenance_request, context={"request": request}
            ).data
        )

    @action(detail=True, methods=["post"])
    def rate(self, request, pk=None):
        """Tenant rates the completed maintenance service."""
        maintenance_request = self.get_object()
        rating = request.data.get("rating")
        comment = request.data.get("comment", "")
        if not rating or int(rating) not in range(1, 6):
            return Response(
                {"detail": "Rating must be between 1 and 5."},
                status=status.HTTP_400_BAD_REQUEST,
            )
        maintenance_request.rating = int(rating)
        maintenance_request.rating_comment = comment
        maintenance_request.status = MaintenanceRequest.Status.CONFIRMED
        maintenance_request.save(
            update_fields=[
                "rating", "rating_comment", "status", "updated_at"
            ]
        )
        return Response(
            MaintenanceRequestDetailSerializer(
                maintenance_request, context={"request": request}
            ).data
        )

    @action(detail=True, methods=["get", "post"])
    def comments(self, request, pk=None):
        """List or add comments to a maintenance request."""
        maintenance_request = self.get_object()
        if request.method == "GET":
            qs = maintenance_request.comments.all()
            if request.user.role == "tenant":
                qs = qs.filter(is_internal=False)
            serializer = MaintenanceCommentSerializer(qs, many=True)
            return Response(serializer.data)

        serializer = MaintenanceCommentSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save(request=maintenance_request, user=request.user)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
