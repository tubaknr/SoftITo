import 'package:equatable/equatable.dart';
import 'enums.dart';
import 'geo_location.dart';

/// Giriş yapan kullanıcının herkese açık profili. doc id = Firebase Auth uid.
///
/// Firestore: `users/{uid}`
class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.displayName,
    required this.email,
    this.role = UserRole.citizen,
    this.isVerified = false,
    this.organization,
    this.photoUrl,
    this.fcmTokens = const [],
    this.lastLocation,
    required this.createdAt,
    this.updatedAt,
  });

  /// Firestore doküman id'si (dokümanın içine yazılmaz).
  final String id;
  final String displayName;
  final String email;
  /// Auth custom claim ile aynı tutulur
  final UserRole role;
  /// Koordinatör hesabı doğrulandı mı (gizlilik kalkanı)
  final bool isVerified;
  /// AFAD / Kızılay / STK adı
  final String? organization;
  final String? photoUrl;
  /// Cihaz token'ları
  final List<String> fcmTokens;
  final GeoLocation? lastLocation;
  final DateTime createdAt;
  final DateTime? updatedAt;

  AppUser copyWith({
    String? id,
    String? displayName,
    String? email,
    UserRole? role,
    bool? isVerified,
    String? organization,
    String? photoUrl,
    List<String>? fcmTokens,
    GeoLocation? lastLocation,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      organization: organization ?? this.organization,
      photoUrl: photoUrl ?? this.photoUrl,
      fcmTokens: fcmTokens ?? this.fcmTokens,
      lastLocation: lastLocation ?? this.lastLocation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isVerifiedCoordinator => role == UserRole.coordinator && isVerified;

  @override
  List<Object?> get props => [id, displayName, email, role, isVerified, organization, photoUrl, fcmTokens, lastLocation, createdAt, updatedAt];
}
