import '../../../core/enums/user_role.dart';

class UserModel {
  final String id;
  final String phoneNumber;
  final UserRole role;
  final String? fullNameEn;
  final String? fullNameAr;
  final String? email;
  final String? profilePhoto;
  final String preferredLanguage;
  final String? nationality;
  final String? qid;
  final bool isPhoneVerified;
  final bool isQidVerified;
  final DateTime? dateJoined;

  const UserModel({
    required this.id,
    required this.phoneNumber,
    required this.role,
    this.fullNameEn,
    this.fullNameAr,
    this.email,
    this.profilePhoto,
    this.preferredLanguage = 'ar',
    this.nationality,
    this.qid,
    this.isPhoneVerified = false,
    this.isQidVerified = false,
    this.dateJoined,
  });

  String get displayName =>
      fullNameEn ?? fullNameAr ?? phoneNumber;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      phoneNumber: json['phone_number'] as String,
      role: UserRole.fromString(json['role'] as String? ?? 'tenant'),
      fullNameEn: json['full_name_en'] as String?,
      fullNameAr: json['full_name_ar'] as String?,
      email: json['email'] as String?,
      profilePhoto: json['profile_photo'] as String?,
      preferredLanguage: json['preferred_language'] as String? ?? 'ar',
      nationality: json['nationality'] as String?,
      qid: json['qid'] as String?,
      isPhoneVerified: json['is_phone_verified'] as bool? ?? false,
      isQidVerified: json['is_qid_verified'] as bool? ?? false,
      dateJoined: json['date_joined'] != null
          ? DateTime.parse(json['date_joined'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'role': role.name,
      'full_name_en': fullNameEn,
      'full_name_ar': fullNameAr,
      'email': email,
      'profile_photo': profilePhoto,
      'preferred_language': preferredLanguage,
      'nationality': nationality,
      'qid': qid,
      'is_phone_verified': isPhoneVerified,
      'is_qid_verified': isQidVerified,
    };
  }

  UserModel copyWith({
    String? fullNameEn,
    String? fullNameAr,
    String? email,
    String? profilePhoto,
    String? preferredLanguage,
    String? nationality,
    String? qid,
  }) {
    return UserModel(
      id: id,
      phoneNumber: phoneNumber,
      role: role,
      fullNameEn: fullNameEn ?? this.fullNameEn,
      fullNameAr: fullNameAr ?? this.fullNameAr,
      email: email ?? this.email,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      nationality: nationality ?? this.nationality,
      qid: qid ?? this.qid,
      isPhoneVerified: isPhoneVerified,
      isQidVerified: isQidVerified,
      dateJoined: dateJoined,
    );
  }
}
