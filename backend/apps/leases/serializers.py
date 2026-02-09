from rest_framework import serializers

from .models import Lease


class LeaseListSerializer(serializers.ModelSerializer):
    tenant_name = serializers.CharField(
        source="tenant.full_name_en", read_only=True
    )
    tenant_phone = serializers.CharField(
        source="tenant.phone_number", read_only=True
    )
    unit_number = serializers.CharField(
        source="unit.unit_number", read_only=True
    )
    compound_name = serializers.CharField(
        source="unit.building.compound.name_en", read_only=True
    )

    class Meta:
        model = Lease
        fields = [
            "id", "unit", "tenant", "tenant_name", "tenant_phone",
            "unit_number", "compound_name", "start_date", "end_date",
            "monthly_rent", "annual_rent", "status", "payment_frequency",
            "number_of_cheques",
        ]


class LeaseDetailSerializer(serializers.ModelSerializer):
    tenant_name = serializers.CharField(
        source="tenant.full_name_en", read_only=True
    )
    is_active = serializers.BooleanField(read_only=True)

    class Meta:
        model = Lease
        fields = "__all__"


class LeaseCreateUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Lease
        exclude = ["is_deleted", "created_by", "updated_by"]
