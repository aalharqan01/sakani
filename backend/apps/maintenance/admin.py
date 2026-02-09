from django.contrib import admin

from .models import (
    MaintenanceCategory,
    MaintenanceComment,
    MaintenanceImage,
    MaintenanceQuote,
    MaintenanceRequest,
)


@admin.register(MaintenanceCategory)
class MaintenanceCategoryAdmin(admin.ModelAdmin):
    list_display = ["name_en", "name_ar", "icon", "is_active", "sort_order"]
    list_filter = ["is_active"]


class MaintenanceImageInline(admin.TabularInline):
    model = MaintenanceImage
    extra = 0


class MaintenanceQuoteInline(admin.TabularInline):
    model = MaintenanceQuote
    extra = 0


@admin.register(MaintenanceRequest)
class MaintenanceRequestAdmin(admin.ModelAdmin):
    list_display = [
        "reference_number", "title", "category", "urgency",
        "status", "tenant", "unit", "created_at",
    ]
    list_filter = ["status", "urgency", "category"]
    search_fields = ["reference_number", "title", "description"]
    date_hierarchy = "created_at"
    inlines = [MaintenanceImageInline, MaintenanceQuoteInline]


@admin.register(MaintenanceComment)
class MaintenanceCommentAdmin(admin.ModelAdmin):
    list_display = ["request", "user", "is_internal", "created_at"]
    list_filter = ["is_internal"]
