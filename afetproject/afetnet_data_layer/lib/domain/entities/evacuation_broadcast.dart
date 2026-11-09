import 'package:equatable/equatable.dart';
import 'enums.dart';
import 'geo_location.dart';

/// Bölgesel tahliye / artçı uyarısı yayını (FCM).
///
/// Firestore: `broadcasts/{broadcastId}`
class EvacuationBroadcast extends Equatable {
  const EvacuationBroadcast({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.center,
    this.radiusMeters = 1000,
    this.targetTopics = const [],
    required this.sentBy,
    required this.createdAt,
    this.expiresAt,
  });

  /// Firestore doküman id'si (dokümanın içine yazılmaz).
  final String id;
  final BroadcastType type;
  final String title;
  final String message;
  final GeoLocation center;
  final int radiusMeters;
  /// Çemberi kaplayan geohash topic'leri (geo_<geohash5>)
  final List<String> targetTopics;
  final String sentBy;
  final DateTime createdAt;
  final DateTime? expiresAt;

  EvacuationBroadcast copyWith({
    String? id,
    BroadcastType? type,
    String? title,
    String? message,
    GeoLocation? center,
    int? radiusMeters,
    List<String>? targetTopics,
    String? sentBy,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    return EvacuationBroadcast(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      center: center ?? this.center,
      radiusMeters: radiusMeters ?? this.radiusMeters,
      targetTopics: targetTopics ?? this.targetTopics,
      sentBy: sentBy ?? this.sentBy,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  List<Object?> get props => [id, type, title, message, center, radiusMeters, targetTopics, sentBy, createdAt, expiresAt];
}
