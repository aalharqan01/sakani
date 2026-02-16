class MaintenanceCategoryModel {
  final String id;
  final String nameEn;
  final String? nameAr;
  final String? icon;
  final bool isActive;
  final int sortOrder;

  const MaintenanceCategoryModel({
    required this.id,
    required this.nameEn,
    this.nameAr,
    this.icon,
    this.isActive = true,
    this.sortOrder = 0,
  });

  factory MaintenanceCategoryModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceCategoryModel(
      id: json['id'] as String,
      nameEn: json['name_en'] as String,
      nameAr: json['name_ar'] as String?,
      icon: json['icon'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }
}
