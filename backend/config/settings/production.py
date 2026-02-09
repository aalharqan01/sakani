import os

from .base import *  # noqa: F401, F403

DEBUG = False
ALLOWED_HOSTS = [
    h.strip()
    for h in os.environ.get("ALLOWED_HOSTS", "").split(",")
    if h.strip()
]

# Cloud SQL via Unix socket (Cloud Run)
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": os.environ["DB_NAME"],
        "USER": os.environ["DB_USER"],
        "PASSWORD": os.environ["DB_PASSWORD"],
        "HOST": os.environ.get(
            "DB_HOST",
            f'/cloudsql/{os.environ.get("CLOUD_SQL_CONNECTION_NAME", "")}',
        ),
        "PORT": os.environ.get("DB_PORT", "5432"),
    }
}

# Security
SECURE_SSL_REDIRECT = True
SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
SECURE_HSTS_SECONDS = 31536000
SECURE_HSTS_INCLUDE_SUBDOMAINS = True

# Static files served by whitenoise
MIDDLEWARE.insert(1, "whitenoise.middleware.WhiteNoiseMiddleware")  # noqa: F405
STATICFILES_STORAGE = "whitenoise.storage.CompressedManifestStaticFilesStorage"

# Google Cloud Storage for media
DEFAULT_FILE_STORAGE = "storages.backends.gcloud.GoogleCloudStorage"
GS_BUCKET_NAME = os.environ.get("GCS_BUCKET_NAME", "sakani-media")
GS_DEFAULT_ACL = "publicRead"

# CORS: restrict to known origins
CORS_ALLOW_ALL_ORIGINS = False
