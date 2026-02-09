from rest_framework.permissions import BasePermission


class IsAdmin(BasePermission):
    def has_permission(self, request, view):
        return request.user.is_authenticated and request.user.role == "admin"


class IsLandlord(BasePermission):
    def has_permission(self, request, view):
        return request.user.is_authenticated and request.user.role in (
            "landlord",
            "admin",
        )


class IsTenant(BasePermission):
    def has_permission(self, request, view):
        return request.user.is_authenticated and request.user.role == "tenant"


class IsMaintenance(BasePermission):
    def has_permission(self, request, view):
        return request.user.is_authenticated and request.user.role in (
            "maintenance",
            "admin",
        )


class IsAdminOrLandlord(BasePermission):
    def has_permission(self, request, view):
        return request.user.is_authenticated and request.user.role in (
            "landlord",
            "admin",
        )


class IsCompoundMember(BasePermission):
    """Check user belongs to the compound being accessed."""

    def has_object_permission(self, request, view, obj):
        if request.user.role == "admin":
            return True
        compound = getattr(obj, "compound", None) or obj
        return compound.memberships.filter(user=request.user).exists()


class IsOwnerOrAdmin(BasePermission):
    """Object-level: user is the object's owner or admin."""

    def has_object_permission(self, request, view, obj):
        if request.user.role == "admin":
            return True
        owner_field = getattr(view, "owner_field", "tenant")
        return getattr(obj, owner_field) == request.user
