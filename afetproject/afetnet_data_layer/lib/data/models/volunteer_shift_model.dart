import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/volunteer_shift.dart';
import 'firestore_converters.dart';

/// [VolunteerShift] için DTO. Firestore <-> Dart dönüşümü burada yapılır.
class VolunteerShiftModel extends VolunteerShift {
  const VolunteerShiftModel({
    required super.id,
    required super.volunteerId,
    required super.startAt,
    required super.endAt,
    super.locationName,
    super.teamId,
    required super.createdBy,
  });

  factory VolunteerShiftModel.fromEntity(VolunteerShift e) => VolunteerShiftModel(
      id: e.id,
      volunteerId: e.volunteerId,
      startAt: e.startAt,
      endAt: e.endAt,
      locationName: e.locationName,
      teamId: e.teamId,
      createdBy: e.createdBy,
    );

  /// Firestore dokümanından okur (id = doc.id).
  factory VolunteerShiftModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      VolunteerShiftModel.fromJson({...?doc.data(), 'id': doc.id});

  /// Hem Firestore map'ini hem de [toLocalJson] çıktısını (Hive) okur.
  factory VolunteerShiftModel.fromJson(Map<String, dynamic> json) => VolunteerShiftModel(
      id: json['id'] as String? ?? '',
      volunteerId: json['volunteerId'] as String? ?? '',
      startAt: FsConverters.toDate(json['startAt']) ?? DateTime.now(),
      endAt: FsConverters.toDate(json['endAt']) ?? DateTime.now(),
      locationName: json['locationName'] as String?,
      teamId: json['teamId'] as String?,
      createdBy: json['createdBy'] as String? ?? '',
    );

  VolunteerShift toEntity() => VolunteerShift(
      id: id,
      volunteerId: volunteerId,
      startAt: startAt,
      endAt: endAt,
      locationName: locationName,
      teamId: teamId,
      createdBy: createdBy,
    );

  /// Firestore'a yazılacak map (Timestamp / GeoPoint). `id` yazılmaz, null alanlar atılır.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'volunteerId': volunteerId,
      'startAt': FsConverters.fromDate(startAt),
      'endAt': FsConverters.fromDate(endAt),
      'locationName': locationName,
      'teamId': teamId,
      'createdBy': createdBy,
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }

  /// Hive / SharedPreferences için JSON-uyumlu map (tarih = ISO string, konum = {lat, lng}).
  Map<String, dynamic> toLocalJson() {
    final map = <String, dynamic>{
      'id': id,
      'volunteerId': volunteerId,
      'startAt': startAt.toIso8601String(),
      'endAt': endAt.toIso8601String(),
      'locationName': locationName,
      'teamId': teamId,
      'createdBy': createdBy,
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }
}
