from rest_framework import serializers

from .models import (
    MaintenanceCategory,
    MaintenanceComment,
    MaintenanceImage,
    MaintenanceQuote,
    MaintenanceRequest,
)


class MaintenanceCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = MaintenanceCategory
        fields = ["id", "name_en", "name_ar", "icon", "is_active", "sort_order"]


class MaintenanceImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaintenanceImage
        fields = ["id", "image", "image_type", "caption", "uploaded_by", "created_at"]
        read_only_fields = ["uploaded_by"]


class MaintenanceQuoteSerializer(serializers.ModelSerializer):
    provided_by_name = serializers.CharField(
        source="provided_by.display_name", read_only=True, default=""
    )

    class Meta:
        model = MaintenanceQuote
        fields = [
            "id", "request", "provided_by", "provided_by_name",
            "labor_cost", "material_cost", "total_cost", "currency",
            "estimated_hours", "proposed_date", "description",
            "status", "valid_until", "created_at",
        ]
        read_only_fields = ["provided_by"]


class MaintenanceCommentSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(
        source="user.display_name", read_only=True, default=""
    )
    user_role = serializers.CharField(
        source="user.role", read_only=True, default=""
    )

    class Meta:
        model = MaintenanceComment
        fields = [
            "id", "request", "user", "user_name", "user_role",
            "text", "is_internal", "created_at",
        ]
        read_only_fields = ["user"]


class MaintenanceRequestListSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(
        source="category.name_en", read_only=True, default=""
    )
    tenant_name = serializers.CharField(
        source="tenant.full_name_en", read_only=True
    )
    unit_number = serializers.CharField(
        source="unit.unit_number", read_only=True
    )
    compound_name = serializers.CharField(
        source="unit.building.compound.name_en", read_only=True
    )
    image_count = serializers.SerializerMethodField()

    class Meta:
        model = MaintenanceRequest
        fields = [
            "id", "reference_number", "title", "category", "category_name",
            "urgency", "status", "tenant", "tenant_name", "unit",
            "unit_number", "compound_name", "image_count", "created_at",
        ]

    def get_image_count(self, obj):
        return obj.images.count()


class MaintenanceRequestDetailSerializer(serializers.ModelSerializer):
    images = MaintenanceImageSerializer(many=True, read_only=True)
    quotes = MaintenanceQuoteSerializer(many=True, read_only=True)
    comments = serializers.SerializerMethodField()
    category_name = serializers.CharField(
        source="category.name_en", read_only=True, default=""
    )
    tenant_name = serializers.CharField(
        source="tenant.full_name_en", read_only=True
    )
    unit_number = serializers.CharField(
        source="unit.unit_number", read_only=True
    )

    class Meta:
        model = MaintenanceRequest
        fields = "__all__"

    def get_comments(self, obj):
        user = self.context.get("request", None)
        qs = obj.comments.all()
        # Hide internal comments from tenants
        if user and hasattr(user, "user") and user.user.role == "tenant":
            qs = qs.filter(is_internal=False)
        return MaintenanceCommentSerializer(qs, many=True).data


class MaintenanceRequestCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaintenanceRequest
        fields = [
            "unit", "category", "title", "description", "urgency",
            "preferred_date_1", "preferred_date_2", "preferred_time_slot",
        ]
