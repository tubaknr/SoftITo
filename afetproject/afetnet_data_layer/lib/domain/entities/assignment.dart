import 'package:equatable/equatable.dart';
import 'enums.dart';

/// Çağrı -> ekip görev ataması ve durum akışı zaman damgaları.
///
/// Firestore: `assignments/{assignmentId}`
class Assignment extends Equatable {
  const Assignment({
    required this.id,
    required this.requestId,
    this.incidentId,
    required this.teamId,
    required this.assignedBy,
    this.status = CaseStatus.assigned,
    this.note,
    required this.assignedAt,
    this.enRouteAt,
    this.onSiteAt,
    this.resolvedAt,
  });

  /// Firestore doküman id'si (dokümanın içine yazılmaz).
  final String id;
  final String requestId;
  final String? incidentId;
  final String teamId;
  final String assignedBy;
  final CaseStatus status;
  final String? note;
  final DateTime assignedAt;
  final DateTime? enRouteAt;
  final DateTime? onSiteAt;
  final DateTime? resolvedAt;

  Assignment copyWith({
    String? id,
    String? requestId,
    String? incidentId,
    String? teamId,
    String? assignedBy,
    CaseStatus? status,
    String? note,
    DateTime? assignedAt,
    DateTime? enRouteAt,
    DateTime? onSiteAt,
    DateTime? resolvedAt,
  }) {
    return Assignment(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      incidentId: incidentId ?? this.incidentId,
      teamId: teamId ?? this.teamId,
      assignedBy: assignedBy ?? this.assignedBy,
      status: status ?? this.status,
      note: note ?? this.note,
      assignedAt: assignedAt ?? this.assignedAt,
      enRouteAt: enRouteAt ?? this.enRouteAt,
      onSiteAt: onSiteAt ?? this.onSiteAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }

  @override
  List<Object?> get props => [id, requestId, incidentId, teamId, assignedBy, status, note, assignedAt, enRouteAt, onSiteAt, resolvedAt];
}
