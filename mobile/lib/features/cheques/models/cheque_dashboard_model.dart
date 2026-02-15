class ChequeDashboardModel {
  final int total;
  final int pending;
  final int cleared;
  final int bounced;
  final int deposited;
  final int overdue;
  final double totalAmount;
  final double clearedAmount;

  const ChequeDashboardModel({
    this.total = 0,
    this.pending = 0,
    this.cleared = 0,
    this.bounced = 0,
    this.deposited = 0,
    this.overdue = 0,
    this.totalAmount = 0,
    this.clearedAmount = 0,
  });

  factory ChequeDashboardModel.fromJson(Map<String, dynamic> json) {
    return ChequeDashboardModel(
      total: json['total'] as int? ?? 0,
      pending: json['pending'] as int? ?? 0,
      cleared: json['cleared'] as int? ?? 0,
      bounced: json['bounced'] as int? ?? 0,
      deposited: json['deposited'] as int? ?? 0,
      overdue: json['overdue'] as int? ?? 0,
      totalAmount: double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0,
      clearedAmount:
          double.tryParse(json['cleared_amount']?.toString() ?? '0') ?? 0,
    );
  }
}
