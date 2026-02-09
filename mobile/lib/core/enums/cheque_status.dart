enum ChequeStatus {
  pending,
  deposited,
  cleared,
  bounced,
  replaced,
  cancelled,
  void_;

  static ChequeStatus fromString(String value) {
    if (value == 'void') return ChequeStatus.void_;
    return ChequeStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ChequeStatus.pending,
    );
  }
}
