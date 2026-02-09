import uuid

from django.contrib.auth.models import AbstractUser
from django.db import models

from apps.core.validators import qatar_id_validator, qatar_phone_validator

from .managers import UserManager


class User(AbstractUser):
    """Custom user model with phone-based authentication and Qatar-specific fields."""

    class Role(models.TextChoices):
        TENANT = "tenant", "Tenant"
        LANDLORD = "landlord", "Landlord / Compound Management"
        MAINTENANCE = "maintenance", "Maintenance Team"
        ADMIN = "admin", "Platform Admin"

    class Language(models.TextChoices):
        ARABIC = "ar", "Arabic"
        ENGLISH = "en", "English"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)

    # Remove username, use phone_number as primary identifier
    username = None
    phone_number = models.CharField(
        max_length=15,
        unique=True,
        validators=[qatar_phone_validator],
        help_text="Qatar phone number in format +974XXXXXXXX",
    )
    email = models.EmailField(blank=True, null=True)

    # Qatar-specific
    qid = models.CharField(
        max_length=11,
        blank=True,
        null=True,
        unique=True,
        validators=[qatar_id_validator],
        verbose_name="Qatar ID (QID)",
    )
    qid_expiry = models.DateField(blank=True, null=True)

    # Profile
    role = models.CharField(max_length=20, choices=Role.choices, default=Role.TENANT)
    full_name_en = models.CharField(max_length=255, blank=True)
    full_name_ar = models.CharField(max_length=255, blank=True)
    profile_photo = models.ImageField(
        upload_to="profiles/%Y/%m/", blank=True, null=True
    )
    preferred_language = models.CharField(
        max_length=2, choices=Language.choices, default=Language.ENGLISH
    )
    nationality = models.CharField(max_length=100, blank=True)

    # Status
    is_phone_verified = models.BooleanField(default=False)
    is_qid_verified = models.BooleanField(default=False)

    USERNAME_FIELD = "phone_number"
    REQUIRED_FIELDS = ["first_name", "last_name"]

    objects = UserManager()

    class Meta:
        db_table = "accounts_user"
        verbose_name = "User"
        verbose_name_plural = "Users"

    def __str__(self):
        return f"{self.full_name_en or self.phone_number} ({self.role})"

    @property
    def display_name(self):
        return self.full_name_en or self.full_name_ar or self.phone_number
