import 'package:flutter/foundation.dart';
import 'enums.dart';

@immutable
class VehicleFilter {
  const VehicleFilter({
    this.sortBy = SortByOption.highestRating,
    this.type,
    this.minYear,
    this.maxYear,
    this.brand,
    this.model,
    this.transmission,
    this.fuelType,
    this.minSeats,
    this.searchQuery = '',
  });

  final SortByOption sortBy;
  final VehicleType? type;
  final int? minYear;
  final int? maxYear;
  final String? brand;
  final String? model;
  final TransmissionType? transmission;
  final FuelType? fuelType;
  final int? minSeats;
  final String searchQuery;

  bool get hasActiveFilters =>
      type != null ||
      minYear != null ||
      maxYear != null ||
      brand != null ||
      model != null ||
      transmission != null ||
      fuelType != null ||
      minSeats != null ||
      searchQuery.trim().isNotEmpty ||
      sortBy != SortByOption.highestRating;

  VehicleFilter copyWith({
    SortByOption? sortBy,
    VehicleType? type,
    bool clearType = false,
    int? minYear,
    int? maxYear,
    String? brand,
    bool clearBrand = false,
    String? model,
    bool clearModel = false,
    TransmissionType? transmission,
    bool clearTransmission = false,
    FuelType? fuelType,
    bool clearFuelType = false,
    int? minSeats,
    bool clearMinSeats = false,
    String? searchQuery,
  }) {
    return VehicleFilter(
      sortBy: sortBy ?? this.sortBy,
      type: clearType ? null : (type ?? this.type),
      minYear: minYear ?? this.minYear,
      maxYear: maxYear ?? this.maxYear,
      brand: clearBrand ? null : (brand ?? this.brand),
      model: clearModel ? null : (model ?? this.model),
      transmission:
          clearTransmission ? null : (transmission ?? this.transmission),
      fuelType: clearFuelType ? null : (fuelType ?? this.fuelType),
      minSeats: clearMinSeats ? null : (minSeats ?? this.minSeats),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  VehicleFilter clearAll() {
    return const VehicleFilter();
  }
}
