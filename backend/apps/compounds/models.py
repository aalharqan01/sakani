from django.conf import settings
from django.db import models

from apps.core.models import BaseModel


class Compound(BaseModel):
    """A gated community or compound. Top-level organizational entity."""

    class Status(models.TextChoices):
        ACTIVE = "active", "Active"
        INACTIVE = "inactive", "Inactive"
        ONBOARDING = "onboarding", "Onboarding"

    name_en = models.CharField(max_length=255)
    name_ar = models.CharField(max_length=255, blank=True)
    slug = models.SlugField(unique=True, max_length=255)

    # Location
    address_en = models.TextField(blank=True)
    address_ar = models.TextField(blank=True)
    city = models.CharField(max_length=100, default="Doha")
    area = models.CharField(max_length=100, blank=True)
    latitude = models.DecimalField(
        max_digits=9, decimal_places=6, null=True, blank=True
    )
    longitude = models.DecimalField(
        max_digits=9, decimal_places=6, null=True, blank=True
    )

    # Details
    total_units = models.PositiveIntegerField(default=0)
    description_en = models.TextField(blank=True)
    description_ar = models.TextField(blank=True)
    amenities = models.JSONField(default=list, blank=True)
    rules_en = models.TextField(blank=True)
    rules_ar = models.TextField(blank=True)
    logo = models.ImageField(upload_to="compounds/logos/", blank=True, null=True)
    cover_image = models.ImageField(
        upload_to="compounds/covers/", blank=True, null=True
    )

    # Management contact
    management_phone = models.CharField(max_length=15, blank=True)
    management_email = models.EmailField(blank=True)
    emergency_phone = models.CharField(max_length=15, blank=True)

    status = models.CharField(
        max_length=20, choices=Status.choices, default=Status.ONBOARDING
    )

    class Meta:
        db_table = "compounds_compound"
        ordering = ["name_en"]

    def __str__(self):
        return self.name_en


class Building(BaseModel):
    """A building or block within a compound."""

    compound = models.ForeignKey(
        Compound, on_delete=models.CASCADE, related_name="buildings"
    )
    name_en = models.CharField(max_length=100)
    name_ar = models.CharField(max_length=100, blank=True)
    number = models.CharField(max_length=20, blank=True)
    total_floors = models.PositiveIntegerField(default=1)
    has_elevator = models.BooleanField(default=False)
    status = models.CharField(
        max_length=20,
        choices=[("active", "Active"), ("inactive", "Inactive")],
        default="active",
    )

    class Meta:
        db_table = "compounds_building"
        unique_together = ["compound", "name_en"]
        ordering = ["compound", "name_en"]

    def __str__(self):
        return f"{self.compound.name_en} - {self.name_en}"


class Unit(BaseModel):
    """An individual residential unit (apartment, villa, studio)."""

    class UnitType(models.TextChoices):
        STUDIO = "studio", "Studio"
        ONE_BR = "1br", "1 Bedroom"
        TWO_BR = "2br", "2 Bedrooms"
        THREE_BR = "3br", "3 Bedrooms"
        FOUR_BR = "4br", "4 Bedrooms"
        FIVE_BR = "5br", "5+ Bedrooms"
        VILLA = "villa", "Villa"
        TOWNHOUSE = "townhouse", "Townhouse"
        PENTHOUSE = "penthouse", "Penthouse"
        DUPLEX = "duplex", "Duplex"

    class UnitStatus(models.TextChoices):
        VACANT = "vacant", "Vacant"
        OCCUPIED = "occupied", "Occupied"
        MAINTENANCE = "maintenance", "Under Maintenance"
        NOTICE = "notice", "Notice Given"
        RESERVED = "reserved", "Reserved"

    building = models.ForeignKey(
        Building, on_delete=models.CASCADE, related_name="units"
    )
    unit_number = models.CharField(max_length=20)
    floor = models.PositiveIntegerField(default=0)
    unit_type = models.CharField(max_length=20, choices=UnitType.choices)
    size_sqm = models.DecimalField(
        max_digits=8, decimal_places=2, null=True, blank=True
    )
    bedrooms = models.PositiveIntegerField(default=0)
    bathrooms = models.PositiveIntegerField(default=1)
    has_balcony = models.BooleanField(default=False)
    has_parking = models.BooleanField(default=False)
    parking_spot = models.CharField(max_length=20, blank=True)
    monthly_rent = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        null=True,
        blank=True,
        help_text="Default monthly rent in QAR",
    )
    status = models.CharField(
        max_length=20, choices=UnitStatus.choices, default=UnitStatus.VACANT
    )
    notes = models.TextField(blank=True)

    class Meta:
        db_table = "compounds_unit"
        unique_together = ["building", "unit_number"]
        ordering = ["building", "floor", "unit_number"]

    def __str__(self):
        return f"{self.building} - Unit {self.unit_number}"

    @property
    def compound(self):
        return self.building.compound


class CompoundMembership(BaseModel):
    """Tracks which users belong to which compounds and in what role."""

    class MemberRole(models.TextChoices):
        MANAGER = "manager", "Compound Manager"
        STAFF = "staff", "Compound Staff"
        MAINTENANCE = "maintenance", "Maintenance Team"
        SECURITY = "security", "Security"

    compound = models.ForeignKey(
        Compound, on_delete=models.CASCADE, related_name="memberships"
    )
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="compound_memberships",
    )
    role = models.CharField(max_length=20, choices=MemberRole.choices)
    is_primary = models.BooleanField(default=False)

    class Meta:
        db_table = "compounds_membership"
        unique_together = ["compound", "user"]

    def __str__(self):
        return f"{self.user} - {self.compound} ({self.role})"
