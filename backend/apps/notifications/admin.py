from django.contrib import admin

from .models import DeviceToken, Notification


@admin.register(Notification)
class NotificationAdmin(admin.ModelAdmin):
    list_display = [
        "title_en", "notification_type", "user", "is_read",
        "is_sent", "created_at",
    ]
    list_filter = ["notification_type", "is_read", "is_sent"]
    search_fields = ["title_en", "title_ar", "body_en"]
    date_hierarchy = "created_at"


@admin.register(DeviceToken)
class DeviceTokenAdmin(admin.ModelAdmin):
    list_display = ["user", "device_type", "device_name", "is_active", "last_used"]
    list_filter = ["device_type", "is_active"]
