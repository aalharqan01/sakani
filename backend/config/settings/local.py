import os

from .base import *  # noqa: F401, F403

DEBUG = True
ALLOWED_HOSTS = ["*"]

# Local PostgreSQL from docker-compose
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": os.environ.get("DB_NAME", "sakani_dev"),
        "USER": os.environ.get("DB_USER", "sakani"),
        "PASSWORD": os.environ.get("DB_PASSWORD", "sakani_dev_password"),
        "HOST": os.environ.get("DB_HOST", "localhost"),
        "PORT": os.environ.get("DB_PORT", "5432"),
    }
}

# Add browsable API in dev
REST_FRAMEWORK["DEFAULT_RENDERER_CLASSES"] = [  # noqa: F405
    "rest_framework.renderers.JSONRenderer",
    "rest_framework.renderers.BrowsableAPIRenderer",
]

# CORS: allow all in development
CORS_ALLOW_ALL_ORIGINS = True

# Email: console backend for dev
EMAIL_BACKEND = "django.core.mail.backends.console.EmailBackend"

# Media files stored locally
MEDIA_ROOT = BASE_DIR / "media"  # noqa: F405
