import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/volunteer.dart';
import '../../domain/entities/enums.dart';
import 'firestore_converters.dart';

/// [Volunteer] için DTO. Firestore <-> Dart dönüşümü burada yapılır.
class VolunteerModel extends Volunteer {
  const VolunteerModel({
    required super.id,
    required super.displayName,
    super.skills = const [],
    super.availability = VolunteerAvailability.available,
    super.isApproved = false,
    super.teamId,
    super.location,
    required super.createdAt,
  });

  factory VolunteerModel.fromEntity(Volunteer e) => VolunteerModel(
      id: e.id,
      displayName: e.displayName,
      skills: e.skills,
      availability: e.availability,
      isApproved: e.isApproved,
      teamId: e.teamId,
      location: e.location,
      createdAt: e.createdAt,
    );

  /// Firestore dokümanından okur (id = doc.id).
  factory VolunteerModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      VolunteerModel.fromJson({...?doc.data(), 'id': doc.id});

  /// Hem Firestore map'ini hem de [toLocalJson] çıktısını (Hive) okur.
  factory VolunteerModel.fromJson(Map<String, dynamic> json) => VolunteerModel(
      id: json['id'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      skills: FsConverters.toList(json['skills']).map(VolunteerSkill.fromValue).toList(),
      availability: VolunteerAvailability.tryParse(json['availability']) ?? VolunteerAvailability.available,
      isApproved: json['isApproved'] as bool? ?? false,
      teamId: json['teamId'] as String?,
      location: FsConverters.toGeo(json['location']),
      createdAt: FsConverters.toDate(json['createdAt']) ?? DateTime.now(),
    );

  Volunteer toEntity() => Volunteer(
      id: id,
      displayName: displayName,
      skills: skills,
      availability: availability,
      isApproved: isApproved,
      teamId: teamId,
      location: location,
      createdAt: createdAt,
    );

  /// Firestore'a yazılacak map (Timestamp / GeoPoint). `id` yazılmaz, null alanlar atılır.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'displayName': displayName,
      'skills': skills.map((e) => e.value).toList(),
      'availability': availability.value,
      'isApproved': isApproved,
      'teamId': teamId,
      'location': FsConverters.fromGeo(location),
      'createdAt': FsConverters.fromDate(createdAt),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }

  /// Hive / SharedPreferences için JSON-uyumlu map (tarih = ISO string, konum = {lat, lng}).
  Map<String, dynamic> toLocalJson() {
    final map = <String, dynamic>{
      'id': id,
      'displayName': displayName,
      'skills': skills.map((e) => e.value).toList(),
      'availability': availability.value,
      'isApproved': isApproved,
      'teamId': teamId,
      'location': location?.toMap(),
      'createdAt': createdAt.toIso8601String(),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }
}
