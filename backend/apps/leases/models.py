from django.conf import settings
from django.db import models
from django.utils import timezone

from apps.core.models import BaseModel


class Lease(BaseModel):
    """A lease agreement between a tenant and a unit."""

    class LeaseStatus(models.TextChoices):
        DRAFT = "draft", "Draft"
        ACTIVE = "active", "Active"
        EXPIRED = "expired", "Expired"
        TERMINATED = "terminated", "Terminated Early"
        RENEWED = "renewed", "Renewed"

    class PaymentFrequency(models.TextChoices):
        MONTHLY = "monthly", "Monthly"
        QUARTERLY = "quarterly", "Quarterly"
        SEMI_ANNUAL = "semi_annual", "Semi-Annual"
        ANNUAL = "annual", "Annual"

    unit = models.ForeignKey(
        "compounds.Unit", on_delete=models.PROTECT, related_name="leases"
    )
    tenant = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.PROTECT,
        related_name="tenant_leases",
        limit_choices_to={"role": "tenant"},
    )
    landlord = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.PROTECT,
        related_name="landlord_leases",
        null=True,
        blank=True,
    )

    # Lease terms
    start_date = models.DateField()
    end_date = models.DateField()
    monthly_rent = models.DecimalField(max_digits=10, decimal_places=2)
    annual_rent = models.DecimalField(max_digits=12, decimal_places=2)
    security_deposit = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    security_deposit_status = models.CharField(
        max_length=20,
        choices=[
            ("pending", "Pending"),
            ("paid", "Paid"),
            ("returned", "Returned"),
            ("partially_returned", "Partially Returned"),
            ("forfeited", "Forfeited"),
        ],
        default="pending",
    )
    payment_frequency = models.CharField(
        max_length=20,
        choices=PaymentFrequency.choices,
        default=PaymentFrequency.MONTHLY,
    )
    number_of_cheques = models.PositiveIntegerField(
        default=12, help_text="Number of post-dated cheques per year"
    )

    # Documents
    contract_document = models.FileField(
        upload_to="leases/contracts/%Y/%m/", blank=True, null=True
    )

    # Status
    status = models.CharField(
        max_length=20, choices=LeaseStatus.choices, default=LeaseStatus.DRAFT
    )
    move_in_date = models.DateField(null=True, blank=True)
    move_out_date = models.DateField(null=True, blank=True)
    termination_reason = models.TextField(blank=True)

    # Renewal
    previous_lease = models.ForeignKey(
        "self",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="renewal",
    )

    notes = models.TextField(blank=True)

    class Meta:
        db_table = "leases_lease"
        ordering = ["-start_date"]

    def __str__(self):
        return f"Lease: {self.unit} - {self.tenant} ({self.start_date} to {self.end_date})"

    @property
    def is_active(self):
        today = timezone.now().date()
        return (
            self.status == self.LeaseStatus.ACTIVE
            and self.start_date <= today <= self.end_date
        )
