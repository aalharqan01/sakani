enum MaintenanceStatus {
  submitted,
  acknowledged,
  quoted,
  quoteAccepted,
  quoteRejected,
  scheduled,
  inProgress,
  completed,
  confirmed,
  cancelled;

  static MaintenanceStatus fromString(String value) {
    switch (value) {
      case 'quote_accepted':
        return MaintenanceStatus.quoteAccepted;
      case 'quote_rejected':
        return MaintenanceStatus.quoteRejected;
      case 'in_progress':
        return MaintenanceStatus.inProgress;
      default:
        return MaintenanceStatus.values.firstWhere(
          (e) => e.name == value,
          orElse: () => MaintenanceStatus.submitted,
        );
    }
  }
}

enum UrgencyLevel {
  routine,
  urgent,
  emergency;

  static UrgencyLevel fromString(String value) {
    return UrgencyLevel.values.firstWhere(
      (e) => e.name == value,
      orElse: () => UrgencyLevel.routine,
    );
  }
}
