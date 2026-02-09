from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path("admin/", admin.site.urls),
    path("api/v1/auth/", include("apps.accounts.urls")),
    path("api/v1/", include("apps.compounds.urls")),
    path("api/v1/", include("apps.leases.urls")),
    path("api/v1/", include("apps.cheques.urls")),
    path("api/v1/", include("apps.maintenance.urls")),
    path("api/v1/", include("apps.notifications.urls")),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
