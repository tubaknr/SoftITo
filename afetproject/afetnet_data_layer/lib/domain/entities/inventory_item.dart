import 'package:equatable/equatable.dart';
import 'enums.dart';

/// Depodaki stok kalemi. quantity sadece Transaction ile değişir (İş Kuralı 3).
///
/// Firestore: `warehouses/{warehouseId}/inventory/{itemId}`
class InventoryItem extends Equatable {
  const InventoryItem({
    required this.id,
    required this.warehouseId,
    required this.name,
    this.category = ItemCategory.other,
    this.quantity = 0,
    this.unit = 'koli',
    this.criticalThreshold = 0,
    this.isCritical = false,
    this.updatedAt,
  });

  /// Firestore doküman id'si (dokümanın içine yazılmaz).
  final String id;
  final String warehouseId;
  final String name;
  final ItemCategory category;
  final int quantity;
  final String unit;
  final int criticalThreshold;
  /// Transaction içinde quantity <= criticalThreshold ile güncellenir (Firestore iki alanı kıyaslayamaz)
  final bool isCritical;
  final DateTime? updatedAt;

  InventoryItem copyWith({
    String? id,
    String? warehouseId,
    String? name,
    ItemCategory? category,
    int? quantity,
    String? unit,
    int? criticalThreshold,
    bool? isCritical,
    DateTime? updatedAt,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      warehouseId: warehouseId ?? this.warehouseId,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      criticalThreshold: criticalThreshold ?? this.criticalThreshold,
      isCritical: isCritical ?? this.isCritical,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, warehouseId, name, category, quantity, unit, criticalThreshold, isCritical, updatedAt];
}
