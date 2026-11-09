import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/safety_signal.dart';
import '../../domain/entities/enums.dart';
import 'firestore_converters.dart';

/// [SafetySignal] için DTO. Firestore <-> Dart dönüşümü burada yapılır.
class SafetySignalModel extends SafetySignal {
  const SafetySignalModel({
    required super.id,
    required super.userId,
    required super.status,
    super.location,
    super.geohash,
    super.note,
    required super.createdAt,
  });

  factory SafetySignalModel.fromEntity(SafetySignal e) => SafetySignalModel(
      id: e.id,
      userId: e.userId,
      status: e.status,
      location: e.location,
      geohash: e.geohash,
      note: e.note,
      createdAt: e.createdAt,
    );

  /// Firestore dokümanından okur (id = doc.id).
  factory SafetySignalModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      SafetySignalModel.fromJson({...?doc.data(), 'id': doc.id});

  /// Hem Firestore map'ini hem de [toLocalJson] çıktısını (Hive) okur.
  factory SafetySignalModel.fromJson(Map<String, dynamic> json) => SafetySignalModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      status: SafetyStatus.fromValue(json['status']),
      location: FsConverters.toGeo(json['location']),
      geohash: json['geohash'] as String?,
      note: json['note'] as String?,
      createdAt: FsConverters.toDate(json['createdAt']) ?? DateTime.now(),
    );

  SafetySignal toEntity() => SafetySignal(
      id: id,
      userId: userId,
      status: status,
      location: location,
      geohash: geohash,
      note: note,
      createdAt: createdAt,
    );

  /// Firestore'a yazılacak map (Timestamp / GeoPoint). `id` yazılmaz, null alanlar atılır.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'userId': userId,
      'status': status.value,
      'location': FsConverters.fromGeo(location),
      'geohash': geohash,
      'note': note,
      'createdAt': FsConverters.fromDate(createdAt),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }

  /// Hive / SharedPreferences için JSON-uyumlu map (tarih = ISO string, konum = {lat, lng}).
  Map<String, dynamic> toLocalJson() {
    final map = <String, dynamic>{
      'id': id,
      'userId': userId,
      'status': status.value,
      'location': location?.toMap(),
      'geohash': geohash,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }
}
