from django.contrib import admin

from .models import Cheque, ChequeStatusLog


@admin.register(Cheque)
class ChequeAdmin(admin.ModelAdmin):
    list_display = [
        "cheque_number", "bank_name", "amount", "due_date",
        "status", "lease",
    ]
    list_filter = ["status", "bank_name"]
    search_fields = ["cheque_number", "bank_name", "payee_name"]
    date_hierarchy = "due_date"


@admin.register(ChequeStatusLog)
class ChequeStatusLogAdmin(admin.ModelAdmin):
    list_display = ["cheque", "from_status", "to_status", "changed_by", "created_at"]
    list_filter = ["to_status"]
