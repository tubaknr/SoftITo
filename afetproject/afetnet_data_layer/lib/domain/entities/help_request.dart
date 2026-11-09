import 'package:equatable/equatable.dart';
import 'enums.dart';
import 'geo_location.dart';

/// Acil yardım / ihtiyaç çağrısı. Telefon ve ad bilgisi alt dokümanda (private/contact).
///
/// Firestore: `help_requests/{requestId}`
class HelpRequest extends Equatable {
  const HelpRequest({
    required this.id,
    required this.createdBy,
    required this.type,
    required this.priority,
    this.status = CaseStatus.open,
    this.peopleCount = 1,
    this.addressText = '',
    this.description,
    required this.location,
    required this.geohash,
    this.photoUrls = const [],
    this.incidentId,
    this.assignedTeamId,
    this.createdOffline = false,
    required this.createdAt,
    this.updatedAt,
    this.resolvedAt,
  });

  /// Firestore doküman id'si (dokümanın içine yazılmaz).
  final String id;
  final String createdBy;
  final HelpType type;
  /// int: 1 kritik, 2 acil, 3 normal (sıralama için)
  final RequestPriority priority;
  final CaseStatus status;
  final int peopleCount;
  final String addressText;
  final String? description;
  final GeoLocation location;
  /// 50 m mükerrer filtresi için (precision 8)
  final String geohash;
  /// Storage URL'leri
  final List<String> photoUrls;
  /// Bağlı olay dosyası
  final String? incidentId;
  final String? assignedTeamId;
  /// Hive kuyruğundan geldiyse true
  final bool createdOffline;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? resolvedAt;

  HelpRequest copyWith({
    String? id,
    String? createdBy,
    HelpType? type,
    RequestPriority? priority,
    CaseStatus? status,
    int? peopleCount,
    String? addressText,
    String? description,
    GeoLocation? location,
    String? geohash,
    List<String>? photoUrls,
    String? incidentId,
    String? assignedTeamId,
    bool? createdOffline,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
  }) {
    return HelpRequest(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      peopleCount: peopleCount ?? this.peopleCount,
      addressText: addressText ?? this.addressText,
      description: description ?? this.description,
      location: location ?? this.location,
      geohash: geohash ?? this.geohash,
      photoUrls: photoUrls ?? this.photoUrls,
      incidentId: incidentId ?? this.incidentId,
      assignedTeamId: assignedTeamId ?? this.assignedTeamId,
      createdOffline: createdOffline ?? this.createdOffline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }

  @override
  List<Object?> get props => [id, createdBy, type, priority, status, peopleCount, addressText, description, location, geohash, photoUrls, incidentId, assignedTeamId, createdOffline, createdAt, updatedAt, resolvedAt];
}
