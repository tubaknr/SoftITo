import 'package:equatable/equatable.dart';
import 'enums.dart';
import 'geo_location.dart';

/// Toplanma alanı / sahra hastanesi / barınma alanı.
///
/// Firestore: `assembly_points/{pointId}`
class AssemblyPoint extends Equatable {
  const AssemblyPoint({
    required this.id,
    required this.name,
    required this.kind,
    required this.location,
    required this.geohash,
    this.capacity = 0,
    this.currentOccupancy = 0,
    this.isOpen = true,
    this.address,
    this.updatedAt,
  });

  /// Firestore doküman id'si (dokümanın içine yazılmaz).
  final String id;
  final String name;
  final AssemblyKind kind;
  final GeoLocation location;
  final String geohash;
  final int capacity;
  final int currentOccupancy;
  final bool isOpen;
  final String? address;
  final DateTime? updatedAt;

  AssemblyPoint copyWith({
    String? id,
    String? name,
    AssemblyKind? kind,
    GeoLocation? location,
    String? geohash,
    int? capacity,
    int? currentOccupancy,
    bool? isOpen,
    String? address,
    DateTime? updatedAt,
  }) {
    return AssemblyPoint(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      location: location ?? this.location,
      geohash: geohash ?? this.geohash,
      capacity: capacity ?? this.capacity,
      currentOccupancy: currentOccupancy ?? this.currentOccupancy,
      isOpen: isOpen ?? this.isOpen,
      address: address ?? this.address,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  double get occupancyRatio => capacity == 0 ? 0 : currentOccupancy / capacity;

  @override
  List<Object?> get props => [id, name, kind, location, geohash, capacity, currentOccupancy, isOpen, address, updatedAt];
}
