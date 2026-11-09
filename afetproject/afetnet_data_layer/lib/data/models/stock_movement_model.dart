import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/stock_movement.dart';
import '../../domain/entities/enums.dart';
import 'firestore_converters.dart';

/// [StockMovement] için DTO. Firestore <-> Dart dönüşümü burada yapılır.
class StockMovementModel extends StockMovement {
  const StockMovementModel({
    required super.id,
    required super.warehouseId,
    required super.itemId,
    required super.type,
    required super.quantity,
    super.teamId,
    super.assignmentId,
    required super.performedBy,
    super.note,
    required super.createdAt,
  });

  factory StockMovementModel.fromEntity(StockMovement e) => StockMovementModel(
      id: e.id,
      warehouseId: e.warehouseId,
      itemId: e.itemId,
      type: e.type,
      quantity: e.quantity,
      teamId: e.teamId,
      assignmentId: e.assignmentId,
      performedBy: e.performedBy,
      note: e.note,
      createdAt: e.createdAt,
    );

  /// Firestore dokümanından okur (id = doc.id).
  factory StockMovementModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      StockMovementModel.fromJson({...?doc.data(), 'id': doc.id});

  /// Hem Firestore map'ini hem de [toLocalJson] çıktısını (Hive) okur.
  factory StockMovementModel.fromJson(Map<String, dynamic> json) => StockMovementModel(
      id: json['id'] as String? ?? '',
      warehouseId: json['warehouseId'] as String? ?? '',
      itemId: json['itemId'] as String? ?? '',
      type: StockMovementType.fromValue(json['type']),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      teamId: json['teamId'] as String?,
      assignmentId: json['assignmentId'] as String?,
      performedBy: json['performedBy'] as String? ?? '',
      note: json['note'] as String?,
      createdAt: FsConverters.toDate(json['createdAt']) ?? DateTime.now(),
    );

  StockMovement toEntity() => StockMovement(
      id: id,
      warehouseId: warehouseId,
      itemId: itemId,
      type: type,
      quantity: quantity,
      teamId: teamId,
      assignmentId: assignmentId,
      performedBy: performedBy,
      note: note,
      createdAt: createdAt,
    );

  /// Firestore'a yazılacak map (Timestamp / GeoPoint). `id` yazılmaz, null alanlar atılır.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'warehouseId': warehouseId,
      'itemId': itemId,
      'type': type.value,
      'quantity': quantity,
      'teamId': teamId,
      'assignmentId': assignmentId,
      'performedBy': performedBy,
      'note': note,
      'createdAt': FsConverters.fromDate(createdAt),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }

  /// Hive / SharedPreferences için JSON-uyumlu map (tarih = ISO string, konum = {lat, lng}).
  Map<String, dynamic> toLocalJson() {
    final map = <String, dynamic>{
      'id': id,
      'warehouseId': warehouseId,
      'itemId': itemId,
      'type': type.value,
      'quantity': quantity,
      'teamId': teamId,
      'assignmentId': assignmentId,
      'performedBy': performedBy,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }
}
