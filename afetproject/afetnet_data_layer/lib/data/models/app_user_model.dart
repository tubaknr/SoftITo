import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/entities/enums.dart';
import 'firestore_converters.dart';

/// [AppUser] için DTO. Firestore <-> Dart dönüşümü burada yapılır.
class AppUserModel extends AppUser {
  const AppUserModel({
    required super.id,
    required super.displayName,
    required super.email,
    super.role = UserRole.citizen,
    super.isVerified = false,
    super.organization,
    super.photoUrl,
    super.fcmTokens = const [],
    super.lastLocation,
    required super.createdAt,
    super.updatedAt,
  });

  factory AppUserModel.fromEntity(AppUser e) => AppUserModel(
      id: e.id,
      displayName: e.displayName,
      email: e.email,
      role: e.role,
      isVerified: e.isVerified,
      organization: e.organization,
      photoUrl: e.photoUrl,
      fcmTokens: e.fcmTokens,
      lastLocation: e.lastLocation,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    );

  /// Firestore dokümanından okur (id = doc.id).
  factory AppUserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      AppUserModel.fromJson({...?doc.data(), 'id': doc.id});

  /// Hem Firestore map'ini hem de [toLocalJson] çıktısını (Hive) okur.
  factory AppUserModel.fromJson(Map<String, dynamic> json) => AppUserModel(
      id: json['id'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: UserRole.tryParse(json['role']) ?? UserRole.citizen,
      isVerified: json['isVerified'] as bool? ?? false,
      organization: json['organization'] as String?,
      photoUrl: json['photoUrl'] as String?,
      fcmTokens: FsConverters.toStringList(json['fcmTokens']),
      lastLocation: FsConverters.toGeo(json['lastLocation']),
      createdAt: FsConverters.toDate(json['createdAt']) ?? DateTime.now(),
      updatedAt: FsConverters.toDate(json['updatedAt']),
    );

  AppUser toEntity() => AppUser(
      id: id,
      displayName: displayName,
      email: email,
      role: role,
      isVerified: isVerified,
      organization: organization,
      photoUrl: photoUrl,
      fcmTokens: fcmTokens,
      lastLocation: lastLocation,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

  /// Firestore'a yazılacak map (Timestamp / GeoPoint). `id` yazılmaz, null alanlar atılır.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'displayName': displayName,
      'email': email,
      'role': role.value,
      'isVerified': isVerified,
      'organization': organization,
      'photoUrl': photoUrl,
      'fcmTokens': fcmTokens,
      'lastLocation': FsConverters.fromGeo(lastLocation),
      'createdAt': FsConverters.fromDate(createdAt),
      'updatedAt': FsConverters.fromDate(updatedAt),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }

  /// Hive / SharedPreferences için JSON-uyumlu map (tarih = ISO string, konum = {lat, lng}).
  Map<String, dynamic> toLocalJson() {
    final map = <String, dynamic>{
      'id': id,
      'displayName': displayName,
      'email': email,
      'role': role.value,
      'isVerified': isVerified,
      'organization': organization,
      'photoUrl': photoUrl,
      'fcmTokens': fcmTokens,
      'lastLocation': lastLocation?.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }
}
