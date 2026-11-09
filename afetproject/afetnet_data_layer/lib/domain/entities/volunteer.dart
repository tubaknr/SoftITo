import 'package:equatable/equatable.dart';
import 'enums.dart';
import 'geo_location.dart';

/// Gönüllü havuzu profili (users/{uid} ile aynı id).
///
/// Firestore: `volunteers/{uid}`
class Volunteer extends Equatable {
  const Volunteer({
    required this.id,
    required this.displayName,
    this.skills = const [],
    this.availability = VolunteerAvailability.available,
    this.isApproved = false,
    this.teamId,
    this.location,
    required this.createdAt,
  });

  /// Firestore doküman id'si (dokümanın içine yazılmaz).
  final String id;
  final String displayName;
  final List<VolunteerSkill> skills;
  final VolunteerAvailability availability;
  final bool isApproved;
  final String? teamId;
  final GeoLocation? location;
  final DateTime createdAt;

  Volunteer copyWith({
    String? id,
    String? displayName,
    List<VolunteerSkill>? skills,
    VolunteerAvailability? availability,
    bool? isApproved,
    String? teamId,
    GeoLocation? location,
    DateTime? createdAt,
  }) {
    return Volunteer(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      skills: skills ?? this.skills,
      availability: availability ?? this.availability,
      isApproved: isApproved ?? this.isApproved,
      teamId: teamId ?? this.teamId,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, displayName, skills, availability, isApproved, teamId, location, createdAt];
}
