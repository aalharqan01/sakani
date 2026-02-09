from rest_framework import serializers

from .models import Building, Compound, CompoundMembership, Unit


class CompoundListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Compound
        fields = [
            "id", "name_en", "name_ar", "slug", "area", "city",
            "total_units", "status", "logo",
        ]


class CompoundDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Compound
        fields = "__all__"


class CompoundCreateUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Compound
        exclude = ["is_deleted", "created_by", "updated_by"]


class BuildingListSerializer(serializers.ModelSerializer):
    unit_count = serializers.SerializerMethodField()

    class Meta:
        model = Building
        fields = [
            "id", "compound", "name_en", "name_ar", "number",
            "total_floors", "has_elevator", "unit_count", "status",
        ]

    def get_unit_count(self, obj):
        return obj.units.filter(is_deleted=False).count()


class BuildingCreateUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Building
        exclude = ["is_deleted", "created_by", "updated_by"]


class UnitListSerializer(serializers.ModelSerializer):
    building_name = serializers.CharField(source="building.name_en", read_only=True)
    compound_name = serializers.CharField(
        source="building.compound.name_en", read_only=True
    )
    current_tenant = serializers.SerializerMethodField()

    class Meta:
        model = Unit
        fields = [
            "id", "unit_number", "floor", "unit_type", "bedrooms",
            "bathrooms", "size_sqm", "monthly_rent", "status",
            "building", "building_name", "compound_name", "current_tenant",
        ]

    def get_current_tenant(self, obj):
        active_lease = obj.leases.filter(status="active").first()
        if active_lease:
            return {
                "id": str(active_lease.tenant.id),
                "name": active_lease.tenant.full_name_en,
                "phone": active_lease.tenant.phone_number,
            }
        return None


class UnitDetailSerializer(serializers.ModelSerializer):
    building = BuildingListSerializer(read_only=True)

    class Meta:
        model = Unit
        fields = "__all__"


class UnitCreateUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Unit
        exclude = ["is_deleted", "created_by", "updated_by"]


class CompoundMembershipSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source="user.display_name", read_only=True)
    user_phone = serializers.CharField(source="user.phone_number", read_only=True)

    class Meta:
        model = CompoundMembership
        fields = [
            "id", "compound", "user", "user_name", "user_phone",
            "role", "is_primary",
        ]
