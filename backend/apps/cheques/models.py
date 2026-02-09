from django.conf import settings
from django.db import models
from django.utils import timezone

from apps.core.models import BaseModel


class Cheque(BaseModel):
    """A single post-dated cheque linked to a lease."""

    class ChequeStatus(models.TextChoices):
        PENDING = "pending", "Pending"
        DEPOSITED = "deposited", "Deposited"
        CLEARED = "cleared", "Cleared"
        BOUNCED = "bounced", "Bounced"
        REPLACED = "replaced", "Replaced"
        CANCELLED = "cancelled", "Cancelled"
        VOID = "void", "Void"

    lease = models.ForeignKey(
        "leases.Lease", on_delete=models.CASCADE, related_name="cheques"
    )

    # Cheque details
    cheque_number = models.CharField(max_length=20)
    bank_name = models.CharField(max_length=100)
    bank_branch = models.CharField(max_length=100, blank=True)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    currency = models.CharField(max_length=3, default="QAR")
    due_date = models.DateField(db_index=True)
    payee_name = models.CharField(max_length=255, blank=True)

    # Status tracking
    status = models.CharField(
        max_length=20, choices=ChequeStatus.choices, default=ChequeStatus.PENDING
    )
    deposited_date = models.DateField(null=True, blank=True)
    cleared_date = models.DateField(null=True, blank=True)
    bounced_date = models.DateField(null=True, blank=True)
    bounce_reason = models.CharField(max_length=255, blank=True)

    # Replacement chain
    replaces = models.OneToOneField(
        "self",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="replaced_by",
        help_text="The bounced cheque that this cheque replaces",
    )

    # Image (from camera capture / OCR)
    image = models.ImageField(
        upload_to="cheques/images/%Y/%m/", blank=True, null=True
    )

    # Sequence tracking
    sequence_number = models.PositiveIntegerField(
        help_text="Position in the cheque schedule (1 of 12, 2 of 12, etc.)"
    )

    notes = models.TextField(blank=True)

    class Meta:
        db_table = "cheques_cheque"
        ordering = ["due_date"]
        unique_together = ["lease", "sequence_number"]

    def __str__(self):
        return f"Cheque #{self.cheque_number} - {self.amount} QAR - {self.due_date}"

    @property
    def is_overdue(self):
        return (
            self.status == self.ChequeStatus.PENDING
            and self.due_date < timezone.now().date()
        )


class ChequeStatusLog(BaseModel):
    """Audit log for cheque status transitions."""

    cheque = models.ForeignKey(
        Cheque, on_delete=models.CASCADE, related_name="status_logs"
    )
    from_status = models.CharField(max_length=20, choices=Cheque.ChequeStatus.choices)
    to_status = models.CharField(max_length=20, choices=Cheque.ChequeStatus.choices)
    changed_by = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True
    )
    notes = models.TextField(blank=True)

    class Meta:
        db_table = "cheques_statuslog"
        ordering = ["-created_at"]

    def __str__(self):
        return (
            f"Cheque {self.cheque.cheque_number}: "
            f"{self.from_status} -> {self.to_status}"
        )
