import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/missing_person.dart';
import '../../domain/entities/enums.dart';
import 'firestore_converters.dart';

/// [MissingPerson] için DTO. Firestore <-> Dart dönüşümü burada yapılır.
class MissingPersonModel extends MissingPerson {
  const MissingPersonModel({
    required super.id,
    required super.fullName,
    super.searchTokens = const [],
    super.status = PersonStatus.missing,
    required super.reportedBy,
    super.age,
    super.lastKnownAddress,
    super.lastKnownLocation,
    super.facilityName,
    super.photoUrl,
    super.description,
    required super.createdAt,
    super.updatedAt,
  });

  factory MissingPersonModel.fromEntity(MissingPerson e) => MissingPersonModel(
      id: e.id,
      fullName: e.fullName,
      searchTokens: e.searchTokens,
      status: e.status,
      reportedBy: e.reportedBy,
      age: e.age,
      lastKnownAddress: e.lastKnownAddress,
      lastKnownLocation: e.lastKnownLocation,
      facilityName: e.facilityName,
      photoUrl: e.photoUrl,
      description: e.description,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    );

  /// Firestore dokümanından okur (id = doc.id).
  factory MissingPersonModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      MissingPersonModel.fromJson({...?doc.data(), 'id': doc.id});

  /// Hem Firestore map'ini hem de [toLocalJson] çıktısını (Hive) okur.
  factory MissingPersonModel.fromJson(Map<String, dynamic> json) => MissingPersonModel(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      searchTokens: FsConverters.toStringList(json['searchTokens']),
      status: PersonStatus.tryParse(json['status']) ?? PersonStatus.missing,
      reportedBy: json['reportedBy'] as String? ?? '',
      age: (json['age'] as num?)?.toInt(),
      lastKnownAddress: json['lastKnownAddress'] as String?,
      lastKnownLocation: FsConverters.toGeo(json['lastKnownLocation']),
      facilityName: json['facilityName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      description: json['description'] as String?,
      createdAt: FsConverters.toDate(json['createdAt']) ?? DateTime.now(),
      updatedAt: FsConverters.toDate(json['updatedAt']),
    );

  MissingPerson toEntity() => MissingPerson(
      id: id,
      fullName: fullName,
      searchTokens: searchTokens,
      status: status,
      reportedBy: reportedBy,
      age: age,
      lastKnownAddress: lastKnownAddress,
      lastKnownLocation: lastKnownLocation,
      facilityName: facilityName,
      photoUrl: photoUrl,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

  /// Firestore'a yazılacak map (Timestamp / GeoPoint). `id` yazılmaz, null alanlar atılır.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'fullName': fullName,
      'searchTokens': searchTokens,
      'status': status.value,
      'reportedBy': reportedBy,
      'age': age,
      'lastKnownAddress': lastKnownAddress,
      'lastKnownLocation': FsConverters.fromGeo(lastKnownLocation),
      'facilityName': facilityName,
      'photoUrl': photoUrl,
      'description': description,
      'createdAt': FsConverters.fromDate(createdAt),
      'updatedAt': FsConverters.fromDate(updatedAt),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }

  /// Hive / SharedPreferences için JSON-uyumlu map (tarih = ISO string, konum = {lat, lng}).
  Map<String, dynamic> toLocalJson() {
    final map = <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'searchTokens': searchTokens,
      'status': status.value,
      'reportedBy': reportedBy,
      'age': age,
      'lastKnownAddress': lastKnownAddress,
      'lastKnownLocation': lastKnownLocation?.toMap(),
      'facilityName': facilityName,
      'photoUrl': photoUrl,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }
}
