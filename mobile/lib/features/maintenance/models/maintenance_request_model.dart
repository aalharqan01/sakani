class MaintenanceRequestModel {
  final String id;
  final String referenceNumber;
  final String title;
  final String? categoryId;
  final String? categoryName;
  final String urgency;
  final String status;
  final String? tenantId;
  final String? tenantName;
  final String? unitId;
  final String? unitNumber;
  final String? compoundName;
  final int imageCount;
  final String? description;
  final String? assignedToId;
  final DateTime? preferredDate1;
  final DateTime? preferredDate2;
  final String? preferredTimeSlot;
  final DateTime? scheduledDate;
  final DateTime? completedAt;
  final int? rating;
  final String? ratingComment;
  final DateTime createdAt;

  const MaintenanceRequestModel({
    required this.id,
    required this.referenceNumber,
    required this.title,
    this.categoryId,
    this.categoryName,
    required this.urgency,
    required this.status,
    this.tenantId,
    this.tenantName,
    this.unitId,
    this.unitNumber,
    this.compoundName,
    this.imageCount = 0,
    this.description,
    this.assignedToId,
    this.preferredDate1,
    this.preferredDate2,
    this.preferredTimeSlot,
    this.scheduledDate,
    this.completedAt,
    this.rating,
    this.ratingComment,
    required this.createdAt,
  });

  factory MaintenanceRequestModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceRequestModel(
      id: json['id'] as String,
      referenceNumber: json['reference_number'] as String,
      title: json['title'] as String,
      categoryId: json['category'] as String?,
      categoryName: json['category_name'] as String?,
      urgency: json['urgency'] as String? ?? 'routine',
      status: json['status'] as String? ?? 'submitted',
      tenantId: json['tenant'] as String?,
      tenantName: json['tenant_name'] as String?,
      unitId: json['unit'] as String?,
      unitNumber: json['unit_number'] as String?,
      compoundName: json['compound_name'] as String?,
      imageCount: json['image_count'] as int? ?? 0,
      description: json['description'] as String?,
      assignedToId: json['assigned_to'] as String?,
      preferredDate1: json['preferred_date_1'] != null
          ? DateTime.parse(json['preferred_date_1'] as String)
          : null,
      preferredDate2: json['preferred_date_2'] != null
          ? DateTime.parse(json['preferred_date_2'] as String)
          : null,
      preferredTimeSlot: json['preferred_time_slot'] as String?,
      scheduledDate: json['scheduled_date'] != null
          ? DateTime.parse(json['scheduled_date'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      rating: json['rating'] as int?,
      ratingComment: json['rating_comment'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  bool get isActive =>
      status == 'submitted' ||
      status == 'acknowledged' ||
      status == 'quoted' ||
      status == 'quote_accepted' ||
      status == 'scheduled' ||
      status == 'in_progress';

  bool get isCompleted => status == 'completed' || status == 'confirmed';
}
