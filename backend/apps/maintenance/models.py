import random

from django.conf import settings
from django.db import models
from django.utils import timezone

from apps.core.models import BaseModel


class MaintenanceCategory(BaseModel):
    """Categories for maintenance requests."""

    name_en = models.CharField(max_length=100)
    name_ar = models.CharField(max_length=100, blank=True)
    icon = models.CharField(max_length=50, blank=True)
    is_active = models.BooleanField(default=True)
    sort_order = models.PositiveIntegerField(default=0)

    class Meta:
        db_table = "maintenance_category"
        ordering = ["sort_order", "name_en"]
        verbose_name_plural = "Maintenance Categories"

    def __str__(self):
        return self.name_en


class MaintenanceRequest(BaseModel):
    """A maintenance request submitted by a tenant."""

    class Urgency(models.TextChoices):
        ROUTINE = "routine", "Routine"
        URGENT = "urgent", "Urgent"
        EMERGENCY = "emergency", "Emergency"

    class Status(models.TextChoices):
        SUBMITTED = "submitted", "Submitted"
        ACKNOWLEDGED = "acknowledged", "Acknowledged"
        QUOTED = "quoted", "Quote Provided"
        QUOTE_ACCEPTED = "quote_accepted", "Quote Accepted"
        QUOTE_REJECTED = "quote_rejected", "Quote Rejected"
        SCHEDULED = "scheduled", "Scheduled"
        IN_PROGRESS = "in_progress", "In Progress"
        COMPLETED = "completed", "Completed"
        CONFIRMED = "confirmed", "Confirmed by Tenant"
        CANCELLED = "cancelled", "Cancelled"

    # References
    unit = models.ForeignKey(
        "compounds.Unit",
        on_delete=models.CASCADE,
        related_name="maintenance_requests",
    )
    tenant = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="maintenance_requests",
    )
    category = models.ForeignKey(
        MaintenanceCategory,
        on_delete=models.SET_NULL,
        null=True,
        related_name="requests",
    )
    assigned_to = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="assigned_maintenance",
        limit_choices_to={"role": "maintenance"},
    )

    # Request details
    title = models.CharField(max_length=255)
    description = models.TextField()
    urgency = models.CharField(
        max_length=20, choices=Urgency.choices, default=Urgency.ROUTINE
    )
    status = models.CharField(
        max_length=20, choices=Status.choices, default=Status.SUBMITTED
    )

    # Scheduling
    preferred_date_1 = models.DateField(null=True, blank=True)
    preferred_date_2 = models.DateField(null=True, blank=True)
    preferred_time_slot = models.CharField(
        max_length=20,
        choices=[
            ("morning", "Morning (8AM-12PM)"),
            ("afternoon", "Afternoon (12PM-5PM)"),
            ("evening", "Evening (5PM-9PM)"),
        ],
        blank=True,
    )
    scheduled_date = models.DateTimeField(null=True, blank=True)
    completed_at = models.DateTimeField(null=True, blank=True)

    # Rating (after completion)
    rating = models.PositiveIntegerField(null=True, blank=True)
    rating_comment = models.TextField(blank=True)

    # Reference number (human-readable)
    reference_number = models.CharField(
        max_length=20,
        unique=True,
        editable=False,
        help_text="Auto-generated: MR-YYYYMMDD-XXXX",
    )

    class Meta:
        db_table = "maintenance_request"
        ordering = ["-created_at"]

    def __str__(self):
        return f"{self.reference_number} - {self.title}"

    def save(self, *args, **kwargs):
        if not self.reference_number:
            date_str = timezone.now().strftime("%Y%m%d")
            rand = random.randint(1000, 9999)
            self.reference_number = f"MR-{date_str}-{rand}"
        super().save(*args, **kwargs)


class MaintenanceImage(BaseModel):
    """Photos attached to maintenance requests."""

    class ImageType(models.TextChoices):
        ISSUE = "issue", "Issue Photo"
        BEFORE = "before", "Before Work"
        AFTER = "after", "After Work"
        RECEIPT = "receipt", "Receipt"

    request = models.ForeignKey(
        MaintenanceRequest, on_delete=models.CASCADE, related_name="images"
    )
    image = models.ImageField(upload_to="maintenance/images/%Y/%m/")
    image_type = models.CharField(
        max_length=20, choices=ImageType.choices, default=ImageType.ISSUE
    )
    caption = models.CharField(max_length=255, blank=True)
    uploaded_by = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True
    )

    class Meta:
        db_table = "maintenance_image"

    def __str__(self):
        return f"{self.request.reference_number} - {self.image_type}"


class MaintenanceQuote(BaseModel):
    """A quote provided by maintenance team for a request."""

    class QuoteStatus(models.TextChoices):
        PENDING = "pending", "Pending Review"
        ACCEPTED = "accepted", "Accepted"
        REJECTED = "rejected", "Rejected"
        EXPIRED = "expired", "Expired"

    request = models.ForeignKey(
        MaintenanceRequest, on_delete=models.CASCADE, related_name="quotes"
    )
    provided_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        related_name="provided_quotes",
    )

    # Cost breakdown
    labor_cost = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    material_cost = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    total_cost = models.DecimalField(max_digits=10, decimal_places=2)
    currency = models.CharField(max_length=3, default="QAR")

    # Time estimate
    estimated_hours = models.DecimalField(
        max_digits=5, decimal_places=1, null=True, blank=True
    )
    proposed_date = models.DateTimeField(null=True, blank=True)

    description = models.TextField(blank=True)
    status = models.CharField(
        max_length=20, choices=QuoteStatus.choices, default=QuoteStatus.PENDING
    )
    valid_until = models.DateField(null=True, blank=True)

    class Meta:
        db_table = "maintenance_quote"
        ordering = ["-created_at"]

    def __str__(self):
        return f"Quote for {self.request.reference_number}: {self.total_cost} QAR"


class MaintenanceComment(BaseModel):
    """Comments/updates on a maintenance request."""

    request = models.ForeignKey(
        MaintenanceRequest, on_delete=models.CASCADE, related_name="comments"
    )
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True
    )
    text = models.TextField()
    is_internal = models.BooleanField(
        default=False, help_text="Internal notes not visible to tenant"
    )

    class Meta:
        db_table = "maintenance_comment"
        ordering = ["created_at"]

    def __str__(self):
        return f"Comment on {self.request.reference_number} by {self.user}"
