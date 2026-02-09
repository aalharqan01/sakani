from rest_framework import serializers

from .models import Cheque, ChequeStatusLog


class ChequeListSerializer(serializers.ModelSerializer):
    is_overdue = serializers.BooleanField(read_only=True)
    tenant_name = serializers.CharField(
        source="lease.tenant.full_name_en", read_only=True
    )
    unit_number = serializers.CharField(
        source="lease.unit.unit_number", read_only=True
    )

    class Meta:
        model = Cheque
        fields = [
            "id", "lease", "cheque_number", "bank_name", "amount",
            "currency", "due_date", "status", "sequence_number",
            "is_overdue", "tenant_name", "unit_number",
        ]


class ChequeDetailSerializer(serializers.ModelSerializer):
    is_overdue = serializers.BooleanField(read_only=True)
    status_logs = serializers.SerializerMethodField()

    class Meta:
        model = Cheque
        fields = "__all__"

    def get_status_logs(self, obj):
        logs = obj.status_logs.all()[:10]
        return ChequeStatusLogSerializer(logs, many=True).data


class ChequeCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cheque
        exclude = ["is_deleted", "created_by", "updated_by"]


class ChequeBulkCreateSerializer(serializers.Serializer):
    """Create a full cheque schedule for a lease."""

    lease = serializers.UUIDField()
    cheques = ChequeCreateSerializer(many=True)


class ChequeStatusUpdateSerializer(serializers.Serializer):
    """Update cheque status with notes."""

    status = serializers.ChoiceField(choices=Cheque.ChequeStatus.choices)
    notes = serializers.CharField(required=False, allow_blank=True, default="")
    bounce_reason = serializers.CharField(
        required=False, allow_blank=True, default=""
    )


class ChequeStatusLogSerializer(serializers.ModelSerializer):
    changed_by_name = serializers.CharField(
        source="changed_by.display_name", read_only=True, default=""
    )

    class Meta:
        model = ChequeStatusLog
        fields = [
            "id", "from_status", "to_status", "changed_by",
            "changed_by_name", "notes", "created_at",
        ]
