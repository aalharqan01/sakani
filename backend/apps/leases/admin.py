from django.contrib import admin

from .models import Lease


@admin.register(Lease)
class LeaseAdmin(admin.ModelAdmin):
    list_display = [
        "unit", "tenant", "start_date", "end_date",
        "monthly_rent", "status",
    ]
    list_filter = ["status", "payment_frequency"]
    search_fields = [
        "tenant__full_name_en", "tenant__phone_number",
        "unit__unit_number",
    ]
    date_hierarchy = "start_date"
