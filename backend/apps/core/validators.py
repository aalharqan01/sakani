from django.core.validators import RegexValidator

qatar_phone_validator = RegexValidator(
    regex=r"^\+974[0-9]{8}$",
    message="Phone number must be in Qatar format: +974XXXXXXXX",
)

qatar_id_validator = RegexValidator(
    regex=r"^[0-9]{11}$",
    message="Qatar ID must be exactly 11 digits.",
)
