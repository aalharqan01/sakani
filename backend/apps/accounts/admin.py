from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin

from .models import User


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    list_display = [
        "phone_number",
        "full_name_en",
        "role",
        "is_phone_verified",
        "is_active",
        "date_joined",
    ]
    list_filter = ["role", "is_active", "is_phone_verified", "is_qid_verified"]
    search_fields = ["phone_number", "full_name_en", "full_name_ar", "email", "qid"]
    ordering = ["-date_joined"]

    fieldsets = (
        (None, {"fields": ("phone_number", "password")}),
        (
            "Personal Info",
            {
                "fields": (
                    "full_name_en",
                    "full_name_ar",
                    "first_name",
                    "last_name",
                    "email",
                    "profile_photo",
                    "nationality",
                    "preferred_language",
                )
            },
        ),
        (
            "Qatar ID",
            {"fields": ("qid", "qid_expiry", "is_qid_verified")},
        ),
        (
            "Role & Status",
            {"fields": ("role", "is_phone_verified", "is_active", "is_staff", "is_superuser")},
        ),
        ("Permissions", {"fields": ("groups", "user_permissions")}),
        ("Important dates", {"fields": ("last_login", "date_joined")}),
    )

    add_fieldsets = (
        (
            None,
            {
                "classes": ("wide",),
                "fields": (
                    "phone_number",
                    "password1",
                    "password2",
                    "role",
                    "full_name_en",
                ),
            },
        ),
    )
