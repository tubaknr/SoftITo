import 'package:equatable/equatable.dart';
import 'geo_location.dart';

/// Sahra deposu.
///
/// Firestore: `warehouses/{warehouseId}`
class Warehouse extends Equatable {
  const Warehouse({
    required this.id,
    required this.name,
    required this.location,
    this.address,
    this.managerId,
    this.isActive = true,
  });

  /// Firestore doküman id'si (dokümanın içine yazılmaz).
  final String id;
  final String name;
  final GeoLocation location;
  final String? address;
  final String? managerId;
  final bool isActive;

  Warehouse copyWith({
    String? id,
    String? name,
    GeoLocation? location,
    String? address,
    String? managerId,
    bool? isActive,
  }) {
    return Warehouse(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      address: address ?? this.address,
      managerId: managerId ?? this.managerId,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, name, location, address, managerId, isActive];
}
