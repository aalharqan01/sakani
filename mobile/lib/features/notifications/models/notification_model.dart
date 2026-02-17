class NotificationModel {
  final String id;
  final String titleEn;
  final String titleAr;
  final String bodyEn;
  final String bodyAr;
  final String notificationType;
  final String? relatedObjectType;
  final String? relatedObjectId;
  final bool isRead;
  final DateTime? readAt;
  final Map<String, dynamic>? data;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.bodyEn,
    required this.bodyAr,
    required this.notificationType,
    this.relatedObjectType,
    this.relatedObjectId,
    this.isRead = false,
    this.readAt,
    this.data,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      titleEn: json['title_en'] as String? ?? '',
      titleAr: json['title_ar'] as String? ?? '',
      bodyEn: json['body_en'] as String? ?? '',
      bodyAr: json['body_ar'] as String? ?? '',
      notificationType: json['notification_type'] as String? ?? 'system',
      relatedObjectType: json['related_object_type'] as String?,
      relatedObjectId: json['related_object_id'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
      data: json['data'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  String title(String languageCode) =>
      languageCode == 'ar' ? titleAr : titleEn;

  String body(String languageCode) =>
      languageCode == 'ar' ? bodyAr : bodyEn;
}
