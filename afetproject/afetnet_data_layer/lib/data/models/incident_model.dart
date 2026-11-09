import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/incident.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/geo_location.dart';
import 'firestore_converters.dart';

/// [Incident] için DTO. Firestore <-> Dart dönüşümü burada yapılır.
class IncidentModel extends Incident {
  const IncidentModel({
    required super.id,
    required super.primaryRequestId,
    super.requestIds = const [],
    required super.type,
    required super.priority,
    super.status = CaseStatus.open,
    required super.location,
    required super.geohash,
    super.addressText = '',
    super.requestCount = 1,
    super.totalPeople = 0,
    super.assignedTeamId,
    required super.createdAt,
    super.updatedAt,
  });

  factory IncidentModel.fromEntity(Incident e) => IncidentModel(
      id: e.id,
      primaryRequestId: e.primaryRequestId,
      requestIds: e.requestIds,
      type: e.type,
      priority: e.priority,
      status: e.status,
      location: e.location,
      geohash: e.geohash,
      addressText: e.addressText,
      requestCount: e.requestCount,
      totalPeople: e.totalPeople,
      assignedTeamId: e.assignedTeamId,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    );

  /// Firestore dokümanından okur (id = doc.id).
  factory IncidentModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      IncidentModel.fromJson({...?doc.data(), 'id': doc.id});

  /// Hem Firestore map'ini hem de [toLocalJson] çıktısını (Hive) okur.
  factory IncidentModel.fromJson(Map<String, dynamic> json) => IncidentModel(
      id: json['id'] as String? ?? '',
      primaryRequestId: json['primaryRequestId'] as String? ?? '',
      requestIds: FsConverters.toStringList(json['requestIds']),
      type: HelpType.fromValue(json['type']),
      priority: RequestPriority.fromValue(json['priority']),
      status: CaseStatus.tryParse(json['status']) ?? CaseStatus.open,
      location: FsConverters.toGeo(json['location']) ?? const GeoLocation(0, 0),
      geohash: json['geohash'] as String? ?? '',
      addressText: json['addressText'] as String? ?? '',
      requestCount: (json['requestCount'] as num?)?.toInt() ?? 1,
      totalPeople: (json['totalPeople'] as num?)?.toInt() ?? 0,
      assignedTeamId: json['assignedTeamId'] as String?,
      createdAt: FsConverters.toDate(json['createdAt']) ?? DateTime.now(),
      updatedAt: FsConverters.toDate(json['updatedAt']),
    );

  Incident toEntity() => Incident(
      id: id,
      primaryRequestId: primaryRequestId,
      requestIds: requestIds,
      type: type,
      priority: priority,
      status: status,
      location: location,
      geohash: geohash,
      addressText: addressText,
      requestCount: requestCount,
      totalPeople: totalPeople,
      assignedTeamId: assignedTeamId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

  /// Firestore'a yazılacak map (Timestamp / GeoPoint). `id` yazılmaz, null alanlar atılır.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'primaryRequestId': primaryRequestId,
      'requestIds': requestIds,
      'type': type.value,
      'priority': priority.value,
      'status': status.value,
      'location': FsConverters.fromGeo(location),
      'geohash': geohash,
      'addressText': addressText,
      'requestCount': requestCount,
      'totalPeople': totalPeople,
      'assignedTeamId': assignedTeamId,
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
      'primaryRequestId': primaryRequestId,
      'requestIds': requestIds,
      'type': type.value,
      'priority': priority.value,
      'status': status.value,
      'location': location.toMap(),
      'geohash': geohash,
      'addressText': addressText,
      'requestCount': requestCount,
      'totalPeople': totalPeople,
      'assignedTeamId': assignedTeamId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }
}
