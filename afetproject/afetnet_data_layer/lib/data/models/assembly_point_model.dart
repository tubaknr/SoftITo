import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/assembly_point.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/geo_location.dart';
import 'firestore_converters.dart';

/// [AssemblyPoint] için DTO. Firestore <-> Dart dönüşümü burada yapılır.
class AssemblyPointModel extends AssemblyPoint {
  const AssemblyPointModel({
    required super.id,
    required super.name,
    required super.kind,
    required super.location,
    required super.geohash,
    super.capacity = 0,
    super.currentOccupancy = 0,
    super.isOpen = true,
    super.address,
    super.updatedAt,
  });

  factory AssemblyPointModel.fromEntity(AssemblyPoint e) => AssemblyPointModel(
      id: e.id,
      name: e.name,
      kind: e.kind,
      location: e.location,
      geohash: e.geohash,
      capacity: e.capacity,
      currentOccupancy: e.currentOccupancy,
      isOpen: e.isOpen,
      address: e.address,
      updatedAt: e.updatedAt,
    );

  /// Firestore dokümanından okur (id = doc.id).
  factory AssemblyPointModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      AssemblyPointModel.fromJson({...?doc.data(), 'id': doc.id});

  /// Hem Firestore map'ini hem de [toLocalJson] çıktısını (Hive) okur.
  factory AssemblyPointModel.fromJson(Map<String, dynamic> json) => AssemblyPointModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      kind: AssemblyKind.fromValue(json['kind']),
      location: FsConverters.toGeo(json['location']) ?? const GeoLocation(0, 0),
      geohash: json['geohash'] as String? ?? '',
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      currentOccupancy: (json['currentOccupancy'] as num?)?.toInt() ?? 0,
      isOpen: json['isOpen'] as bool? ?? true,
      address: json['address'] as String?,
      updatedAt: FsConverters.toDate(json['updatedAt']),
    );

  AssemblyPoint toEntity() => AssemblyPoint(
      id: id,
      name: name,
      kind: kind,
      location: location,
      geohash: geohash,
      capacity: capacity,
      currentOccupancy: currentOccupancy,
      isOpen: isOpen,
      address: address,
      updatedAt: updatedAt,
    );

  /// Firestore'a yazılacak map (Timestamp / GeoPoint). `id` yazılmaz, null alanlar atılır.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'kind': kind.value,
      'location': FsConverters.fromGeo(location),
      'geohash': geohash,
      'capacity': capacity,
      'currentOccupancy': currentOccupancy,
      'isOpen': isOpen,
      'address': address,
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
      'location': location.toMap(),
      'geohash': geohash,
      'capacity': capacity,
      'currentOccupancy': currentOccupancy,
      'isOpen': isOpen,
      'address': address,
      'updatedAt': updatedAt?.toIso8601String(),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }
}
