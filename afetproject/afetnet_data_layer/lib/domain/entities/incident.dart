import 'package:equatable/equatable.dart';
import 'enums.dart';
import 'geo_location.dart';

/// Olay dosyası: aynı bina / 50 m çemberindeki mükerrer çağrılar tek dosyada birleşir (İş Kuralı 2). Koordinatör paneli bunu dinler.
///
/// Firestore: `incidents/{incidentId}`
class Incident extends Equatable {
  const Incident({
    required this.id,
    required this.primaryRequestId,
    this.requestIds = const [],
    required this.type,
    required this.priority,
    this.status = CaseStatus.open,
    required this.location,
    required this.geohash,
    this.addressText = '',
    this.requestCount = 1,
    this.totalPeople = 0,
    this.assignedTeamId,
    required this.createdAt,
    this.updatedAt,
  });

  /// Firestore doküman id'si (dokümanın içine yazılmaz).
  final String id;
  final String primaryRequestId;
  final List<String> requestIds;
  final HelpType type;
  /// Birleşen çağrıların en yükseği
  final RequestPriority priority;
  final CaseStatus status;
  final GeoLocation location;
  final String geohash;
  final String addressText;
  final int requestCount;
  final int totalPeople;
  final String? assignedTeamId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Incident copyWith({
    String? id,
    String? primaryRequestId,
    List<String>? requestIds,
    HelpType? type,
    RequestPriority? priority,
    CaseStatus? status,
    GeoLocation? location,
    String? geohash,
    String? addressText,
    int? requestCount,
    int? totalPeople,
    String? assignedTeamId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Incident(
      id: id ?? this.id,
      primaryRequestId: primaryRequestId ?? this.primaryRequestId,
      requestIds: requestIds ?? this.requestIds,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      location: location ?? this.location,
      geohash: geohash ?? this.geohash,
      addressText: addressText ?? this.addressText,
      requestCount: requestCount ?? this.requestCount,
      totalPeople: totalPeople ?? this.totalPeople,
      assignedTeamId: assignedTeamId ?? this.assignedTeamId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, primaryRequestId, requestIds, type, priority, status, location, geohash, addressText, requestCount, totalPeople, assignedTeamId, createdAt, updatedAt];
}
