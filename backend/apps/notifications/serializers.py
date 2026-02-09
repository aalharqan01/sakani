from rest_framework import serializers

from .models import DeviceToken, Notification


class DeviceTokenSerializer(serializers.ModelSerializer):
    class Meta:
        model = DeviceToken
        fields = ["id", "token", "device_type", "device_name", "is_active"]
        read_only_fields = ["is_active"]


class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = [
            "id", "title_en", "title_ar", "body_en", "body_ar",
            "notification_type", "related_object_type", "related_object_id",
            "is_read", "read_at", "data", "created_at",
        ]
        read_only_fields = [
            "title_en", "title_ar", "body_en", "body_ar",
            "notification_type", "related_object_type", "related_object_id",
            "data", "created_at",
        ]
