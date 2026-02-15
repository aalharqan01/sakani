import '../../../core/enums/cheque_status.dart';

class ChequeModel {
  final String id;
  final String leaseId;
  final String chequeNumber;
  final String bankName;
  final String? bankBranch;
  final double amount;
  final String currency;
  final DateTime dueDate;
  final String? payeeName;
  final ChequeStatus status;
  final DateTime? depositedDate;
  final DateTime? clearedDate;
  final DateTime? bouncedDate;
  final String? bounceReason;
  final String? replacesId;
  final String? imageUrl;
  final int sequenceNumber;
  final String? notes;
  final bool isOverdue;
  final String? tenantName;
  final String? unitNumber;
  final List<ChequeStatusLogModel>? statusLogs;
  final DateTime? createdAt;

  const ChequeModel({
    required this.id,
    required this.leaseId,
    required this.chequeNumber,
    required this.bankName,
    this.bankBranch,
    required this.amount,
    this.currency = 'QAR',
    required this.dueDate,
    this.payeeName,
    required this.status,
    this.depositedDate,
    this.clearedDate,
    this.bouncedDate,
    this.bounceReason,
    this.replacesId,
    this.imageUrl,
    required this.sequenceNumber,
    this.notes,
    this.isOverdue = false,
    this.tenantName,
    this.unitNumber,
    this.statusLogs,
    this.createdAt,
  });

  factory ChequeModel.fromJson(Map<String, dynamic> json) {
    return ChequeModel(
      id: json['id'] as String,
      leaseId: json['lease'] as String,
      chequeNumber: json['cheque_number'] as String,
      bankName: json['bank_name'] as String,
      bankBranch: json['bank_branch'] as String?,
      amount: double.parse(json['amount'].toString()),
      currency: json['currency'] as String? ?? 'QAR',
      dueDate: DateTime.parse(json['due_date'] as String),
      payeeName: json['payee_name'] as String?,
      status: ChequeStatus.fromString(json['status'] as String),
      depositedDate: json['deposited_date'] != null
          ? DateTime.parse(json['deposited_date'] as String)
          : null,
      clearedDate: json['cleared_date'] != null
          ? DateTime.parse(json['cleared_date'] as String)
          : null,
      bouncedDate: json['bounced_date'] != null
          ? DateTime.parse(json['bounced_date'] as String)
          : null,
      bounceReason: json['bounce_reason'] as String?,
      replacesId: json['replaces'] as String?,
      imageUrl: json['image'] as String?,
      sequenceNumber: json['sequence_number'] as int,
      notes: json['notes'] as String?,
      isOverdue: json['is_overdue'] as bool? ?? false,
      tenantName: json['tenant_name'] as String?,
      unitNumber: json['unit_number'] as String?,
      statusLogs: json['status_logs'] != null
          ? (json['status_logs'] as List)
              .map((e) =>
                  ChequeStatusLogModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lease': leaseId,
      'cheque_number': chequeNumber,
      'bank_name': bankName,
      'bank_branch': bankBranch,
      'amount': amount.toString(),
      'currency': currency,
      'due_date': dueDate.toIso8601String().split('T').first,
      'payee_name': payeeName,
      'sequence_number': sequenceNumber,
      'notes': notes,
    };
  }
}

class ChequeStatusLogModel {
  final String id;
  final String fromStatus;
  final String toStatus;
  final String? changedBy;
  final String? changedByName;
  final String? notes;
  final DateTime createdAt;

  const ChequeStatusLogModel({
    required this.id,
    required this.fromStatus,
    required this.toStatus,
    this.changedBy,
    this.changedByName,
    this.notes,
    required this.createdAt,
  });

  factory ChequeStatusLogModel.fromJson(Map<String, dynamic> json) {
    return ChequeStatusLogModel(
      id: json['id'] as String,
      fromStatus: json['from_status'] as String,
      toStatus: json['to_status'] as String,
      changedBy: json['changed_by'] as String?,
      changedByName: json['changed_by_name'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
