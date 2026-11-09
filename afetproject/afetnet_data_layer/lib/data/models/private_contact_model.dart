import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/private_contact.dart';
import 'firestore_converters.dart';

/// [PrivateContact] için DTO. Firestore <-> Dart dönüşümü burada yapılır.
class PrivateContactModel extends PrivateContact {
  const PrivateContactModel({
    required super.id,
    required super.ownerId,
    required super.fullName,
    required super.phone,
    super.identityNo,
    super.emergencyContactPhones = const [],
    super.updatedAt,
  });

  factory PrivateContactModel.fromEntity(PrivateContact e) => PrivateContactModel(
      id: e.id,
      ownerId: e.ownerId,
      fullName: e.fullName,
      phone: e.phone,
      identityNo: e.identityNo,
      emergencyContactPhones: e.emergencyContactPhones,
      updatedAt: e.updatedAt,
    );

  /// Firestore dokümanından okur (id = doc.id).
  factory PrivateContactModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      PrivateContactModel.fromJson({...?doc.data(), 'id': doc.id});

  /// Hem Firestore map'ini hem de [toLocalJson] çıktısını (Hive) okur.
  factory PrivateContactModel.fromJson(Map<String, dynamic> json) => PrivateContactModel(
      id: json['id'] as String? ?? '',
      ownerId: json['ownerId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      identityNo: json['identityNo'] as String?,
      emergencyContactPhones: FsConverters.toStringList(json['emergencyContactPhones']),
      updatedAt: FsConverters.toDate(json['updatedAt']),
    );

  PrivateContact toEntity() => PrivateContact(
      id: id,
      ownerId: ownerId,
      fullName: fullName,
      phone: phone,
      identityNo: identityNo,
      emergencyContactPhones: emergencyContactPhones,
      updatedAt: updatedAt,
    );

  /// Firestore'a yazılacak map (Timestamp / GeoPoint). `id` yazılmaz, null alanlar atılır.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'ownerId': ownerId,
      'fullName': fullName,
      'phone': phone,
      'identityNo': identityNo,
      'emergencyContactPhones': emergencyContactPhones,
      'updatedAt': FsConverters.fromDate(updatedAt),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }

  /// Hive / SharedPreferences için JSON-uyumlu map (tarih = ISO string, konum = {lat, lng}).
  Map<String, dynamic> toLocalJson() {
    final map = <String, dynamic>{
      'id': id,
      'ownerId': ownerId,
      'fullName': fullName,
      'phone': phone,
      'identityNo': identityNo,
      'emergencyContactPhones': emergencyContactPhones,
      'updatedAt': updatedAt?.toIso8601String(),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }
}
