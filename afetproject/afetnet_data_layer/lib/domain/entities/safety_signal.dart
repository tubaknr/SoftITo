import 'package:equatable/equatable.dart';
import 'enums.dart';
import 'geo_location.dart';

/// "GÜVENDEYİM / TEHLİKEDEYİM" panik butonu sinyali.
///
/// Firestore: `safety_signals/{signalId}`
class SafetySignal extends Equatable {
  const SafetySignal({
    required this.id,
    required this.userId,
    required this.status,
    this.location,
    this.geohash,
    this.note,
    required this.createdAt,
  });

  /// Firestore doküman id'si (dokümanın içine yazılmaz).
  final String id;
  final String userId;
  final SafetyStatus status;
  final GeoLocation? location;
  final String? geohash;
  final String? note;
  final DateTime createdAt;

  SafetySignal copyWith({
    String? id,
    String? userId,
    SafetyStatus? status,
    GeoLocation? location,
    String? geohash,
    String? note,
    DateTime? createdAt,
  }) {
    return SafetySignal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      location: location ?? this.location,
      geohash: geohash ?? this.geohash,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, status, location, geohash, note, createdAt];
}
