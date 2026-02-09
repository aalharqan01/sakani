from django.contrib.auth import get_user_model
from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

User = get_user_model()


class SakaniTokenObtainPairSerializer(TokenObtainPairSerializer):
    """Custom login serializer that uses phone_number and adds user data to response."""

    username_field = "phone_number"

    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)
        token["role"] = user.role
        token["full_name"] = user.full_name_en or user.full_name_ar
        return token

    def validate(self, attrs):
        data = super().validate(attrs)
        data["user"] = {
            "id": str(self.user.id),
            "phone_number": self.user.phone_number,
            "role": self.user.role,
            "full_name_en": self.user.full_name_en,
            "full_name_ar": self.user.full_name_ar,
            "preferred_language": self.user.preferred_language,
            "profile_photo": (
                self.user.profile_photo.url if self.user.profile_photo else None
            ),
        }
        return data


class UserRegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=8)
    password_confirm = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = [
            "phone_number",
            "password",
            "password_confirm",
            "first_name",
            "last_name",
            "full_name_en",
            "full_name_ar",
            "email",
            "role",
            "qid",
            "nationality",
            "preferred_language",
        ]

    def validate(self, attrs):
        if attrs["password"] != attrs.pop("password_confirm"):
            raise serializers.ValidationError(
                {"password_confirm": "Passwords do not match."}
            )
        return attrs

    def create(self, validated_data):
        password = validated_data.pop("password")
        user = User(**validated_data)
        user.set_password(password)
        user.save()
        return user


class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [
            "id",
            "phone_number",
            "email",
            "role",
            "full_name_en",
            "full_name_ar",
            "profile_photo",
            "preferred_language",
            "nationality",
            "qid",
            "qid_expiry",
            "is_phone_verified",
            "is_qid_verified",
            "date_joined",
        ]
        read_only_fields = [
            "id",
            "phone_number",
            "role",
            "is_phone_verified",
            "is_qid_verified",
            "date_joined",
        ]


class ChangePasswordSerializer(serializers.Serializer):
    old_password = serializers.CharField(required=True)
    new_password = serializers.CharField(required=True, min_length=8)

    def validate_old_password(self, value):
        user = self.context["request"].user
        if not user.check_password(value):
            raise serializers.ValidationError("Current password is incorrect.")
        return value
