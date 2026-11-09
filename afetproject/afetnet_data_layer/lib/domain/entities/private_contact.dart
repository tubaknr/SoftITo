import 'package:equatable/equatable.dart';

/// Kişisel / gizli bilgiler (İş Kuralı 5). Sadece sahibi ve doğrulanmış koordinatör okuyabilir.
///
/// Firestore: `users/{uid}/private/contact  ve  help_requests/{id}/private/contact`
class PrivateContact extends Equatable {
  const PrivateContact({
    required this.id,
    required this.ownerId,
    required this.fullName,
    required this.phone,
    this.identityNo,
    this.emergencyContactPhones = const [],
    this.updatedAt,
  });

  /// Firestore doküman id'si (dokümanın içine yazılmaz).
  final String id;
  /// Bilgi sahibi uid
  final String ownerId;
  final String fullName;
  /// Sadece doğrulanmış STK/AFAD hesaplarına görünür
  final String phone;
  /// Opsiyonel açık kimlik bilgisi (KVKK: mümkünse isteme)
  final String? identityNo;
  /// Panik butonunda bilgilendirilecek yakınlar
  final List<String> emergencyContactPhones;
  final DateTime? updatedAt;

  PrivateContact copyWith({
    String? id,
    String? ownerId,
    String? fullName,
    String? phone,
    String? identityNo,
    List<String>? emergencyContactPhones,
    DateTime? updatedAt,
  }) {
    return PrivateContact(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      identityNo: identityNo ?? this.identityNo,
      emergencyContactPhones: emergencyContactPhones ?? this.emergencyContactPhones,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, ownerId, fullName, phone, identityNo, emergencyContactPhones, updatedAt];
}
