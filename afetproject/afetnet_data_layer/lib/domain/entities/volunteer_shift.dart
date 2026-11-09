import 'package:equatable/equatable.dart';

/// Gönüllü vardiyası.
///
/// Firestore: `shifts/{shiftId}`
class VolunteerShift extends Equatable {
  const VolunteerShift({
    required this.id,
    required this.volunteerId,
    required this.startAt,
    required this.endAt,
    this.locationName,
    this.teamId,
    required this.createdBy,
  });

  /// Firestore doküman id'si (dokümanın içine yazılmaz).
  final String id;
  final String volunteerId;
  final DateTime startAt;
  final DateTime endAt;
  final String? locationName;
  final String? teamId;
  final String createdBy;

  VolunteerShift copyWith({
    String? id,
    String? volunteerId,
    DateTime? startAt,
    DateTime? endAt,
    String? locationName,
    String? teamId,
    String? createdBy,
  }) {
    return VolunteerShift(
      id: id ?? this.id,
      volunteerId: volunteerId ?? this.volunteerId,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      locationName: locationName ?? this.locationName,
      teamId: teamId ?? this.teamId,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  List<Object?> get props => [id, volunteerId, startAt, endAt, locationName, teamId, createdBy];
}
