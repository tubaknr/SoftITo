import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/inventory_item.dart';
import '../../domain/entities/enums.dart';
import 'firestore_converters.dart';

/// [InventoryItem] için DTO. Firestore <-> Dart dönüşümü burada yapılır.
class InventoryItemModel extends InventoryItem {
  const InventoryItemModel({
    required super.id,
    required super.warehouseId,
    required super.name,
    super.category = ItemCategory.other,
    super.quantity = 0,
    super.unit = 'koli',
    super.criticalThreshold = 0,
    super.isCritical = false,
    super.updatedAt,
  });

  factory InventoryItemModel.fromEntity(InventoryItem e) => InventoryItemModel(
      id: e.id,
      warehouseId: e.warehouseId,
      name: e.name,
      category: e.category,
      quantity: e.quantity,
      unit: e.unit,
      criticalThreshold: e.criticalThreshold,
      isCritical: e.isCritical,
      updatedAt: e.updatedAt,
    );

  /// Firestore dokümanından okur (id = doc.id).
  factory InventoryItemModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      InventoryItemModel.fromJson({...?doc.data(), 'id': doc.id});

  /// Hem Firestore map'ini hem de [toLocalJson] çıktısını (Hive) okur.
  factory InventoryItemModel.fromJson(Map<String, dynamic> json) => InventoryItemModel(
      id: json['id'] as String? ?? '',
      warehouseId: json['warehouseId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: ItemCategory.tryParse(json['category']) ?? ItemCategory.other,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unit: json['unit'] as String? ?? 'koli',
      criticalThreshold: (json['criticalThreshold'] as num?)?.toInt() ?? 0,
      isCritical: json['isCritical'] as bool? ?? false,
      updatedAt: FsConverters.toDate(json['updatedAt']),
    );

  InventoryItem toEntity() => InventoryItem(
      id: id,
      warehouseId: warehouseId,
      name: name,
      category: category,
      quantity: quantity,
      unit: unit,
      criticalThreshold: criticalThreshold,
      isCritical: isCritical,
      updatedAt: updatedAt,
    );

  /// Firestore'a yazılacak map (Timestamp / GeoPoint). `id` yazılmaz, null alanlar atılır.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'warehouseId': warehouseId,
      'name': name,
      'category': category.value,
      'quantity': quantity,
      'unit': unit,
      'criticalThreshold': criticalThreshold,
      'isCritical': isCritical,
      'updatedAt': FsConverters.fromDate(updatedAt),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }

  /// Hive / SharedPreferences için JSON-uyumlu map (tarih = ISO string, konum = {lat, lng}).
  Map<String, dynamic> toLocalJson() {
    final map = <String, dynamic>{
      'id': id,
      'warehouseId': warehouseId,
      'name': name,
      'category': category.value,
      'quantity': quantity,
      'unit': unit,
      'criticalThreshold': criticalThreshold,
      'isCritical': isCritical,
      'updatedAt': updatedAt?.toIso8601String(),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }
}
