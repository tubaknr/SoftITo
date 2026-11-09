import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/evacuation_broadcast.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/geo_location.dart';
import 'firestore_converters.dart';

/// [EvacuationBroadcast] için DTO. Firestore <-> Dart dönüşümü burada yapılır.
class EvacuationBroadcastModel extends EvacuationBroadcast {
  const EvacuationBroadcastModel({
    required super.id,
    required super.type,
    required super.title,
    required super.message,
    required super.center,
    super.radiusMeters = 1000,
    super.targetTopics = const [],
    required super.sentBy,
    required super.createdAt,
    super.expiresAt,
  });

  factory EvacuationBroadcastModel.fromEntity(EvacuationBroadcast e) => EvacuationBroadcastModel(
      id: e.id,
      type: e.type,
      title: e.title,
      message: e.message,
      center: e.center,
      radiusMeters: e.radiusMeters,
      targetTopics: e.targetTopics,
      sentBy: e.sentBy,
      createdAt: e.createdAt,
      expiresAt: e.expiresAt,
    );

  /// Firestore dokümanından okur (id = doc.id).
  factory EvacuationBroadcastModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      EvacuationBroadcastModel.fromJson({...?doc.data(), 'id': doc.id});

  /// Hem Firestore map'ini hem de [toLocalJson] çıktısını (Hive) okur.
  factory EvacuationBroadcastModel.fromJson(Map<String, dynamic> json) => EvacuationBroadcastModel(
      id: json['id'] as String? ?? '',
      type: BroadcastType.fromValue(json['type']),
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      center: FsConverters.toGeo(json['center']) ?? const GeoLocation(0, 0),
      radiusMeters: (json['radiusMeters'] as num?)?.toInt() ?? 1000,
      targetTopics: FsConverters.toStringList(json['targetTopics']),
      sentBy: json['sentBy'] as String? ?? '',
      createdAt: FsConverters.toDate(json['createdAt']) ?? DateTime.now(),
      expiresAt: FsConverters.toDate(json['expiresAt']),
    );

  EvacuationBroadcast toEntity() => EvacuationBroadcast(
      id: id,
      type: type,
      title: title,
      message: message,
      center: center,
      radiusMeters: radiusMeters,
      targetTopics: targetTopics,
      sentBy: sentBy,
      createdAt: createdAt,
      expiresAt: expiresAt,
    );

  /// Firestore'a yazılacak map (Timestamp / GeoPoint). `id` yazılmaz, null alanlar atılır.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'type': type.value,
      'title': title,
      'message': message,
      'center': FsConverters.fromGeo(center),
      'radiusMeters': radiusMeters,
      'targetTopics': targetTopics,
      'sentBy': sentBy,
      'createdAt': FsConverters.fromDate(createdAt),
      'expiresAt': FsConverters.fromDate(expiresAt),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }

  /// Hive / SharedPreferences için JSON-uyumlu map (tarih = ISO string, konum = {lat, lng}).
  Map<String, dynamic> toLocalJson() {
    final map = <String, dynamic>{
      'id': id,
      'type': type.value,
      'title': title,
      'message': message,
      'center': center.toMap(),
      'radiusMeters': radiusMeters,
      'targetTopics': targetTopics,
      'sentBy': sentBy,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }
}
