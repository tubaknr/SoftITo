import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/help_request.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/geo_location.dart';
import 'firestore_converters.dart';

/// [HelpRequest] için DTO. Firestore <-> Dart dönüşümü burada yapılır.
class HelpRequestModel extends HelpRequest {
  const HelpRequestModel({
    required super.id,
    required super.createdBy,
    required super.type,
    required super.priority,
    super.status = CaseStatus.open,
    super.peopleCount = 1,
    super.addressText = '',
    super.description,
    required super.location,
    required super.geohash,
    super.photoUrls = const [],
    super.incidentId,
    super.assignedTeamId,
    super.createdOffline = false,
    required super.createdAt,
    super.updatedAt,
    super.resolvedAt,
  });

  factory HelpRequestModel.fromEntity(HelpRequest e) => HelpRequestModel(
      id: e.id,
      createdBy: e.createdBy,
      type: e.type,
      priority: e.priority,
      status: e.status,
      peopleCount: e.peopleCount,
      addressText: e.addressText,
      description: e.description,
      location: e.location,
      geohash: e.geohash,
      photoUrls: e.photoUrls,
      incidentId: e.incidentId,
      assignedTeamId: e.assignedTeamId,
      createdOffline: e.createdOffline,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
      resolvedAt: e.resolvedAt,
    );

  /// Firestore dokümanından okur (id = doc.id).
  factory HelpRequestModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      HelpRequestModel.fromJson({...?doc.data(), 'id': doc.id});

  /// Hem Firestore map'ini hem de [toLocalJson] çıktısını (Hive) okur.
  factory HelpRequestModel.fromJson(Map<String, dynamic> json) => HelpRequestModel(
      id: json['id'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      type: HelpType.fromValue(json['type']),
      priority: RequestPriority.fromValue(json['priority']),
      status: CaseStatus.tryParse(json['status']) ?? CaseStatus.open,
      peopleCount: (json['peopleCount'] as num?)?.toInt() ?? 1,
      addressText: json['addressText'] as String? ?? '',
      description: json['description'] as String?,
      location: FsConverters.toGeo(json['location']) ?? const GeoLocation(0, 0),
      geohash: json['geohash'] as String? ?? '',
      photoUrls: FsConverters.toStringList(json['photoUrls']),
      incidentId: json['incidentId'] as String?,
      assignedTeamId: json['assignedTeamId'] as String?,
      createdOffline: json['createdOffline'] as bool? ?? false,
      createdAt: FsConverters.toDate(json['createdAt']) ?? DateTime.now(),
      updatedAt: FsConverters.toDate(json['updatedAt']),
      resolvedAt: FsConverters.toDate(json['resolvedAt']),
    );

  HelpRequest toEntity() => HelpRequest(
      id: id,
      createdBy: createdBy,
      type: type,
      priority: priority,
      status: status,
      peopleCount: peopleCount,
      addressText: addressText,
      description: description,
      location: location,
      geohash: geohash,
      photoUrls: photoUrls,
      incidentId: incidentId,
      assignedTeamId: assignedTeamId,
      createdOffline: createdOffline,
      createdAt: createdAt,
      updatedAt: updatedAt,
      resolvedAt: resolvedAt,
    );

  /// Firestore'a yazılacak map (Timestamp / GeoPoint). `id` yazılmaz, null alanlar atılır.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'createdBy': createdBy,
      'type': type.value,
      'priority': priority.value,
      'status': status.value,
      'peopleCount': peopleCount,
      'addressText': addressText,
      'description': description,
      'location': FsConverters.fromGeo(location),
      'geohash': geohash,
      'photoUrls': photoUrls,
      'incidentId': incidentId,
      'assignedTeamId': assignedTeamId,
      'createdOffline': createdOffline,
      'createdAt': FsConverters.fromDate(createdAt),
      'updatedAt': FsConverters.fromDate(updatedAt),
      'resolvedAt': FsConverters.fromDate(resolvedAt),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }

  /// Hive / SharedPreferences için JSON-uyumlu map (tarih = ISO string, konum = {lat, lng}).
  Map<String, dynamic> toLocalJson() {
    final map = <String, dynamic>{
      'id': id,
      'createdBy': createdBy,
      'type': type.value,
      'priority': priority.value,
      'status': status.value,
      'peopleCount': peopleCount,
      'addressText': addressText,
      'description': description,
      'location': location.toMap(),
      'geohash': geohash,
      'photoUrls': photoUrls,
      'incidentId': incidentId,
      'assignedTeamId': assignedTeamId,
      'createdOffline': createdOffline,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }
}
