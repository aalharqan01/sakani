from django.urls import include, path
from rest_framework.routers import DefaultRouter

from . import views

app_name = "leases"

router = DefaultRouter()
router.register(r"leases", views.LeaseViewSet, basename="lease")

urlpatterns = [
    path("", include(router.urls)),
]
