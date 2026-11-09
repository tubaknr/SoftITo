import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/warehouse.dart';
import '../../domain/entities/geo_location.dart';
import 'firestore_converters.dart';

/// [Warehouse] için DTO. Firestore <-> Dart dönüşümü burada yapılır.
class WarehouseModel extends Warehouse {
  const WarehouseModel({
    required super.id,
    required super.name,
    required super.location,
    super.address,
    super.managerId,
    super.isActive = true,
  });

  factory WarehouseModel.fromEntity(Warehouse e) => WarehouseModel(
      id: e.id,
      name: e.name,
      location: e.location,
      address: e.address,
      managerId: e.managerId,
      isActive: e.isActive,
    );

  /// Firestore dokümanından okur (id = doc.id).
  factory WarehouseModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      WarehouseModel.fromJson({...?doc.data(), 'id': doc.id});

  /// Hem Firestore map'ini hem de [toLocalJson] çıktısını (Hive) okur.
  factory WarehouseModel.fromJson(Map<String, dynamic> json) => WarehouseModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      location: FsConverters.toGeo(json['location']) ?? const GeoLocation(0, 0),
      address: json['address'] as String?,
      managerId: json['managerId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );

  Warehouse toEntity() => Warehouse(
      id: id,
      name: name,
      location: location,
      address: address,
      managerId: managerId,
      isActive: isActive,
    );

  /// Firestore'a yazılacak map (Timestamp / GeoPoint). `id` yazılmaz, null alanlar atılır.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'location': FsConverters.fromGeo(location),
      'address': address,
      'managerId': managerId,
      'isActive': isActive,
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }

  /// Hive / SharedPreferences için JSON-uyumlu map (tarih = ISO string, konum = {lat, lng}).
  Map<String, dynamic> toLocalJson() {
    final map = <String, dynamic>{
      'id': id,
      'name': name,
      'location': location.toMap(),
      'address': address,
      'managerId': managerId,
      'isActive': isActive,
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }
}
