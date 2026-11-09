import 'package:equatable/equatable.dart';
import 'enums.dart';
import 'geo_location.dart';

/// Arama-kurtarma timi / kurye ekibi.
///
/// Firestore: `teams/{teamId}`
class Team extends Equatable {
  const Team({
    required this.id,
    required this.name,
    required this.kind,
    this.status = TeamStatus.available,
    this.memberIds = const [],
    this.leaderId,
    this.organization,
    this.location,
    this.updatedAt,
  });

  /// Firestore doküman id'si (dokümanın içine yazılmaz).
  final String id;
  final String name;
  final TeamKind kind;
  final TeamStatus status;
  final List<String> memberIds;
  final String? leaderId;
  final String? organization;
  final GeoLocation? location;
  final DateTime? updatedAt;

  Team copyWith({
    String? id,
    String? name,
    TeamKind? kind,
    TeamStatus? status,
    List<String>? memberIds,
    String? leaderId,
    String? organization,
    GeoLocation? location,
    DateTime? updatedAt,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      status: status ?? this.status,
      memberIds: memberIds ?? this.memberIds,
      leaderId: leaderId ?? this.leaderId,
      organization: organization ?? this.organization,
      location: location ?? this.location,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, kind, status, memberIds, leaderId, organization, location, updatedAt];
}
