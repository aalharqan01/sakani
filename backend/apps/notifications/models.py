from django.conf import settings
from django.db import models

from apps.core.models import BaseModel


class DeviceToken(BaseModel):
    """FCM device tokens for push notifications."""

    class DeviceType(models.TextChoices):
        IOS = "ios", "iOS"
        ANDROID = "android", "Android"

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="devices"
    )
    token = models.TextField(unique=True)
    device_type = models.CharField(max_length=10, choices=DeviceType.choices)
    device_name = models.CharField(max_length=100, blank=True)
    is_active = models.BooleanField(default=True)
    last_used = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "notifications_devicetoken"

    def __str__(self):
        return f"{self.user} - {self.device_type} ({self.device_name})"


class Notification(BaseModel):
    """Stored notification records."""

    class NotificationType(models.TextChoices):
        CHEQUE_REMINDER = "cheque_reminder", "Cheque Reminder"
        CHEQUE_BOUNCED = "cheque_bounced", "Cheque Bounced"
        CHEQUE_CLEARED = "cheque_cleared", "Cheque Cleared"
        MAINTENANCE_UPDATE = "maintenance_update", "Maintenance Update"
        MAINTENANCE_QUOTE = "maintenance_quote", "Maintenance Quote"
        LEASE_EXPIRY = "lease_expiry", "Lease Expiry Warning"
        ANNOUNCEMENT = "announcement", "Compound Announcement"
        SYSTEM = "system", "System Notification"

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="notifications",
    )
    title_en = models.CharField(max_length=255)
    title_ar = models.CharField(max_length=255, blank=True)
    body_en = models.TextField()
    body_ar = models.TextField(blank=True)
    notification_type = models.CharField(
        max_length=30, choices=NotificationType.choices
    )

    # Generic relation to the object this notification is about
    related_object_type = models.CharField(max_length=50, blank=True)
    related_object_id = models.UUIDField(null=True, blank=True)

    # Status
    is_read = models.BooleanField(default=False, db_index=True)
    read_at = models.DateTimeField(null=True, blank=True)
    is_sent = models.BooleanField(default=False)
    sent_at = models.DateTimeField(null=True, blank=True)

    # Push notification data payload
    data = models.JSONField(default=dict, blank=True)

    class Meta:
        db_table = "notifications_notification"
        ordering = ["-created_at"]
        indexes = [
            models.Index(fields=["user", "is_read", "-created_at"]),
        ]

    def __str__(self):
        return f"{self.notification_type}: {self.title_en} -> {self.user}"
