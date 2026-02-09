from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

from apps.core.permissions import IsAdminOrLandlord

from .models import Building, Compound, CompoundMembership, Unit
from .serializers import (
    BuildingCreateUpdateSerializer,
    BuildingListSerializer,
    CompoundCreateUpdateSerializer,
    CompoundDetailSerializer,
    CompoundListSerializer,
    CompoundMembershipSerializer,
    UnitCreateUpdateSerializer,
    UnitDetailSerializer,
    UnitListSerializer,
)


class CompoundViewSet(viewsets.ModelViewSet):
    queryset = Compound.objects.filter(is_deleted=False)
    filterset_fields = ["status", "area", "city"]
    search_fields = ["name_en", "name_ar", "area"]

    def get_serializer_class(self):
        if self.action == "list":
            return CompoundListSerializer
        if self.action in ("create", "update", "partial_update"):
            return CompoundCreateUpdateSerializer
        return CompoundDetailSerializer

    def get_permissions(self):
        if self.action in ("create", "update", "partial_update", "destroy"):
            return [IsAdminOrLandlord()]
        return super().get_permissions()

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)

    @action(detail=True, methods=["get"])
    def occupancy(self, request, pk=None):
        compound = self.get_object()
        units = Unit.objects.filter(
            building__compound=compound, is_deleted=False
        )
        return Response(
            {
                "total": units.count(),
                "occupied": units.filter(status="occupied").count(),
                "vacant": units.filter(status="vacant").count(),
                "maintenance": units.filter(status="maintenance").count(),
                "notice": units.filter(status="notice").count(),
            }
        )

    @action(detail=True, methods=["get"])
    def buildings(self, request, pk=None):
        compound = self.get_object()
        buildings = compound.buildings.filter(is_deleted=False)
        serializer = BuildingListSerializer(buildings, many=True)
        return Response(serializer.data)


class BuildingViewSet(viewsets.ModelViewSet):
    queryset = Building.objects.filter(is_deleted=False).select_related("compound")
    filterset_fields = ["compound", "status"]
    search_fields = ["name_en", "name_ar"]

    def get_serializer_class(self):
        if self.action in ("create", "update", "partial_update"):
            return BuildingCreateUpdateSerializer
        return BuildingListSerializer

    def get_permissions(self):
        if self.action in ("create", "update", "partial_update", "destroy"):
            return [IsAdminOrLandlord()]
        return super().get_permissions()

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)

    @action(detail=True, methods=["get"])
    def units(self, request, pk=None):
        building = self.get_object()
        units = building.units.filter(is_deleted=False)
        serializer = UnitListSerializer(units, many=True)
        return Response(serializer.data)


class UnitViewSet(viewsets.ModelViewSet):
    queryset = Unit.objects.filter(is_deleted=False).select_related(
        "building__compound"
    )
    filterset_fields = ["building", "unit_type", "status", "bedrooms"]
    search_fields = ["unit_number"]

    def get_serializer_class(self):
        if self.action == "list":
            return UnitListSerializer
        if self.action in ("create", "update", "partial_update"):
            return UnitCreateUpdateSerializer
        return UnitDetailSerializer

    def get_permissions(self):
        if self.action in ("create", "update", "partial_update", "destroy"):
            return [IsAdminOrLandlord()]
        return super().get_permissions()

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)


class CompoundMembershipViewSet(viewsets.ModelViewSet):
    queryset = CompoundMembership.objects.filter(is_deleted=False).select_related(
        "user", "compound"
    )
    serializer_class = CompoundMembershipSerializer
    filterset_fields = ["compound", "role"]
    permission_classes = [IsAdminOrLandlord]

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)
