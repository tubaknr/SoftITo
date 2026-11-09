import 'package:equatable/equatable.dart';
import 'enums.dart';
import 'geo_location.dart';

/// Kayıp / yakın arama panosu kaydı.
///
/// Firestore: `missing_persons/{personId}`
class MissingPerson extends Equatable {
  const MissingPerson({
    required this.id,
    required this.fullName,
    this.searchTokens = const [],
    this.status = PersonStatus.missing,
    required this.reportedBy,
    this.age,
    this.lastKnownAddress,
    this.lastKnownLocation,
    this.facilityName,
    this.photoUrl,
    this.description,
    required this.createdAt,
    this.updatedAt,
  });

  /// Firestore doküman id'si (dokümanın içine yazılmaz).
  final String id;
  final String fullName;
  /// küçük harf, aksansız kelimeler -> array-contains araması
  final List<String> searchTokens;
  final PersonStatus status;
  final String reportedBy;
  final int? age;
  final String? lastKnownAddress;
  final GeoLocation? lastKnownLocation;
  /// Bulunduğu hastane / tahliye noktası
  final String? facilityName;
  final String? photoUrl;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  MissingPerson copyWith({
    String? id,
    String? fullName,
    List<String>? searchTokens,
    PersonStatus? status,
    String? reportedBy,
    int? age,
    String? lastKnownAddress,
    GeoLocation? lastKnownLocation,
    String? facilityName,
    String? photoUrl,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MissingPerson(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      searchTokens: searchTokens ?? this.searchTokens,
      status: status ?? this.status,
      reportedBy: reportedBy ?? this.reportedBy,
      age: age ?? this.age,
      lastKnownAddress: lastKnownAddress ?? this.lastKnownAddress,
      lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
      facilityName: facilityName ?? this.facilityName,
      photoUrl: photoUrl ?? this.photoUrl,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, fullName, searchTokens, status, reportedBy, age, lastKnownAddress, lastKnownLocation, facilityName, photoUrl, description, createdAt, updatedAt];
}
