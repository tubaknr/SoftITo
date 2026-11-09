import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/assignment.dart';
import '../../domain/entities/enums.dart';
import 'firestore_converters.dart';

/// [Assignment] için DTO. Firestore <-> Dart dönüşümü burada yapılır.
class AssignmentModel extends Assignment {
  const AssignmentModel({
    required super.id,
    required super.requestId,
    super.incidentId,
    required super.teamId,
    required super.assignedBy,
    super.status = CaseStatus.assigned,
    super.note,
    required super.assignedAt,
    super.enRouteAt,
    super.onSiteAt,
    super.resolvedAt,
  });

  factory AssignmentModel.fromEntity(Assignment e) => AssignmentModel(
      id: e.id,
      requestId: e.requestId,
      incidentId: e.incidentId,
      teamId: e.teamId,
      assignedBy: e.assignedBy,
      status: e.status,
      note: e.note,
      assignedAt: e.assignedAt,
      enRouteAt: e.enRouteAt,
      onSiteAt: e.onSiteAt,
      resolvedAt: e.resolvedAt,
    );

  /// Firestore dokümanından okur (id = doc.id).
  factory AssignmentModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      AssignmentModel.fromJson({...?doc.data(), 'id': doc.id});

  /// Hem Firestore map'ini hem de [toLocalJson] çıktısını (Hive) okur.
  factory AssignmentModel.fromJson(Map<String, dynamic> json) => AssignmentModel(
      id: json['id'] as String? ?? '',
      requestId: json['requestId'] as String? ?? '',
      incidentId: json['incidentId'] as String?,
      teamId: json['teamId'] as String? ?? '',
      assignedBy: json['assignedBy'] as String? ?? '',
      status: CaseStatus.tryParse(json['status']) ?? CaseStatus.assigned,
      note: json['note'] as String?,
      assignedAt: FsConverters.toDate(json['assignedAt']) ?? DateTime.now(),
      enRouteAt: FsConverters.toDate(json['enRouteAt']),
      onSiteAt: FsConverters.toDate(json['onSiteAt']),
      resolvedAt: FsConverters.toDate(json['resolvedAt']),
    );

  Assignment toEntity() => Assignment(
      id: id,
      requestId: requestId,
      incidentId: incidentId,
      teamId: teamId,
      assignedBy: assignedBy,
      status: status,
      note: note,
      assignedAt: assignedAt,
      enRouteAt: enRouteAt,
      onSiteAt: onSiteAt,
      resolvedAt: resolvedAt,
    );

  /// Firestore'a yazılacak map (Timestamp / GeoPoint). `id` yazılmaz, null alanlar atılır.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'requestId': requestId,
      'incidentId': incidentId,
      'teamId': teamId,
      'assignedBy': assignedBy,
      'status': status.value,
      'note': note,
      'assignedAt': FsConverters.fromDate(assignedAt),
      'enRouteAt': FsConverters.fromDate(enRouteAt),
      'onSiteAt': FsConverters.fromDate(onSiteAt),
      'resolvedAt': FsConverters.fromDate(resolvedAt),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }

  /// Hive / SharedPreferences için JSON-uyumlu map (tarih = ISO string, konum = {lat, lng}).
  Map<String, dynamic> toLocalJson() {
    final map = <String, dynamic>{
      'id': id,
      'requestId': requestId,
      'incidentId': incidentId,
      'teamId': teamId,
      'assignedBy': assignedBy,
      'status': status.value,
      'note': note,
      'assignedAt': assignedAt.toIso8601String(),
      'enRouteAt': enRouteAt?.toIso8601String(),
      'onSiteAt': onSiteAt?.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }
}
