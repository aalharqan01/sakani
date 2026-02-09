from django.contrib import admin

from .models import Building, Compound, CompoundMembership, Unit


@admin.register(Compound)
class CompoundAdmin(admin.ModelAdmin):
    list_display = ["name_en", "area", "city", "total_units", "status"]
    list_filter = ["status", "city", "area"]
    search_fields = ["name_en", "name_ar", "area"]
    prepopulated_fields = {"slug": ("name_en",)}


@admin.register(Building)
class BuildingAdmin(admin.ModelAdmin):
    list_display = ["name_en", "compound", "total_floors", "has_elevator", "status"]
    list_filter = ["status", "compound"]
    search_fields = ["name_en", "name_ar"]


@admin.register(Unit)
class UnitAdmin(admin.ModelAdmin):
    list_display = [
        "unit_number", "building", "unit_type", "bedrooms",
        "monthly_rent", "status",
    ]
    list_filter = ["status", "unit_type", "bedrooms", "building__compound"]
    search_fields = ["unit_number"]


@admin.register(CompoundMembership)
class CompoundMembershipAdmin(admin.ModelAdmin):
    list_display = ["user", "compound", "role", "is_primary"]
    list_filter = ["role", "compound"]
