enum UserRole {
  tenant,
  landlord,
  maintenance,
  admin;

  String get displayName {
    switch (this) {
      case UserRole.tenant:
        return 'Tenant';
      case UserRole.landlord:
        return 'Landlord';
      case UserRole.maintenance:
        return 'Maintenance';
      case UserRole.admin:
        return 'Admin';
    }
  }

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (e) => e.name == value,
      orElse: () => UserRole.tenant,
    );
  }
}
