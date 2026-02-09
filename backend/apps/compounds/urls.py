from django.urls import include, path
from rest_framework.routers import DefaultRouter

from . import views

app_name = "compounds"

router = DefaultRouter()
router.register(r"compounds", views.CompoundViewSet, basename="compound")
router.register(r"buildings", views.BuildingViewSet, basename="building")
router.register(r"units", views.UnitViewSet, basename="unit")
router.register(
    r"compound-memberships",
    views.CompoundMembershipViewSet,
    basename="compound-membership",
)

urlpatterns = [
    path("", include(router.urls)),
]
