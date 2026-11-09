import 'package:equatable/equatable.dart';
import 'enums.dart';

/// Stok giriş/çıkış kaydı (zimmet geçmişi).
///
/// Firestore: `warehouses/{warehouseId}/movements/{movementId}`
class StockMovement extends Equatable {
  const StockMovement({
    required this.id,
    required this.warehouseId,
    required this.itemId,
    required this.type,
    required this.quantity,
    this.teamId,
    this.assignmentId,
    required this.performedBy,
    this.note,
    required this.createdAt,
  });

  /// Firestore doküman id'si (dokümanın içine yazılmaz).
  final String id;
  final String warehouseId;
  final String itemId;
  final StockMovementType type;
  final int quantity;
  /// Zimmetlenen ekip
  final String? teamId;
  final String? assignmentId;
  final String performedBy;
  final String? note;
  final DateTime createdAt;

  StockMovement copyWith({
    String? id,
    String? warehouseId,
    String? itemId,
    StockMovementType? type,
    int? quantity,
    String? teamId,
    String? assignmentId,
    String? performedBy,
    String? note,
    DateTime? createdAt,
  }) {
    return StockMovement(
      id: id ?? this.id,
      warehouseId: warehouseId ?? this.warehouseId,
      itemId: itemId ?? this.itemId,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      teamId: teamId ?? this.teamId,
      assignmentId: assignmentId ?? this.assignmentId,
      performedBy: performedBy ?? this.performedBy,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, warehouseId, itemId, type, quantity, teamId, assignmentId, performedBy, note, createdAt];
}
