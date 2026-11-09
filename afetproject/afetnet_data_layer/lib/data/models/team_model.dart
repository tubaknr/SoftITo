import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/team.dart';
import '../../domain/entities/enums.dart';
import 'firestore_converters.dart';

/// [Team] için DTO. Firestore <-> Dart dönüşümü burada yapılır.
class TeamModel extends Team {
  const TeamModel({
    required super.id,
    required super.name,
    required super.kind,
    super.status = TeamStatus.available,
    super.memberIds = const [],
    super.leaderId,
    super.organization,
    super.location,
    super.updatedAt,
  });

  factory TeamModel.fromEntity(Team e) => TeamModel(
      id: e.id,
      name: e.name,
      kind: e.kind,
      status: e.status,
      memberIds: e.memberIds,
      leaderId: e.leaderId,
      organization: e.organization,
      location: e.location,
      updatedAt: e.updatedAt,
    );

  /// Firestore dokümanından okur (id = doc.id).
  factory TeamModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      TeamModel.fromJson({...?doc.data(), 'id': doc.id});

  /// Hem Firestore map'ini hem de [toLocalJson] çıktısını (Hive) okur.
  factory TeamModel.fromJson(Map<String, dynamic> json) => TeamModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      kind: TeamKind.fromValue(json['kind']),
      status: TeamStatus.tryParse(json['status']) ?? TeamStatus.available,
      memberIds: FsConverters.toStringList(json['memberIds']),
      leaderId: json['leaderId'] as String?,
      organization: json['organization'] as String?,
      location: FsConverters.toGeo(json['location']),
      updatedAt: FsConverters.toDate(json['updatedAt']),
    );

  Team toEntity() => Team(
      id: id,
      name: name,
      kind: kind,
      status: status,
      memberIds: memberIds,
      leaderId: leaderId,
      organization: organization,
      location: location,
      updatedAt: updatedAt,
    );

  /// Firestore'a yazılacak map (Timestamp / GeoPoint). `id` yazılmaz, null alanlar atılır.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'kind': kind.value,
      'status': status.value,
      'memberIds': memberIds,
      'leaderId': leaderId,
      'organization': organization,
      'location': FsConverters.fromGeo(location),
      'updatedAt': FsConverters.fromDate(updatedAt),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }

  /// Hive / SharedPreferences için JSON-uyumlu map (tarih = ISO string, konum = {lat, lng}).
  Map<String, dynamic> toLocalJson() {
    final map = <String, dynamic>{
      'id': id,
      'name': name,
      'kind': kind.value,
      'status': status.value,
      'memberIds': memberIds,
      'leaderId': leaderId,
      'organization': organization,
      'location': location?.toMap(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }
}
