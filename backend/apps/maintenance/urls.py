from django.urls import include, path
from rest_framework.routers import DefaultRouter

from . import views

app_name = "maintenance"

router = DefaultRouter()
router.register(r"maintenance/categories", views.MaintenanceCategoryViewSet, basename="maintenance-category")
router.register(r"maintenance/requests", views.MaintenanceRequestViewSet, basename="maintenance-request")

urlpatterns = [
    path("", include(router.urls)),
]
