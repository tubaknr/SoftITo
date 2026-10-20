import 'package:flutter/foundation.dart';
import '../data/mock_vehicle_data.dart';
import '../models/enums.dart';
import '../models/vehicle.dart';
import '../models/vehicle_filter.dart';

class VehicleListController extends ValueNotifier<List<Vehicle>> {
  VehicleListController({List<Vehicle>? initialVehicles})
      : _allVehicles = List<Vehicle>.from(initialVehicles ?? MockVehicleData.vehicles),
        super(<Vehicle>[]) {
    _applyFilterAndSort();
  }

  final List<Vehicle> _allVehicles;
  VehicleFilter _filter = const VehicleFilter();

  VehicleFilter get filter => _filter;
  List<Vehicle> get allVehicles => List<Vehicle>.unmodifiable(_allVehicles);

  void setFilter(VehicleFilter newFilter) {
    _filter = newFilter;
    _applyFilterAndSort();
  }

  void updateSearchQuery(String query) {
    _filter = _filter.copyWith(searchQuery: query);
    _applyFilterAndSort();
  }

  void setSortOption(SortByOption sortBy) {
    _filter = _filter.copyWith(sortBy: sortBy);
    _applyFilterAndSort();
  }

  void clearFilter() {
    _filter = const VehicleFilter();
    _applyFilterAndSort();
  }

  void _applyFilterAndSort() {
    List<Vehicle> result = List<Vehicle>.from(_allVehicles);

    // 1. Arama sorgusu
    if (_filter.searchQuery.trim().isNotEmpty) {
      final String query = _filter.searchQuery.trim().toLowerCase();
      result = result.where((Vehicle v) {
        final String fullName = '${v.brand} ${v.model} ${v.plate}'.toLowerCase();
        return fullName.contains(query);
      }).toList();
    }

    // 2. Araç tipi
    if (_filter.type != null) {
      result = result.where((Vehicle v) => v.type == _filter.type).toList();
    }

    // 3. Marka & Model
    if (_filter.brand != null && _filter.brand!.isNotEmpty) {
      result = result.where((Vehicle v) => v.brand.toLowerCase() == _filter.brand!.toLowerCase()).toList();
    }
    if (_filter.model != null && _filter.model!.isNotEmpty) {
      result = result.where((Vehicle v) => v.model.toLowerCase() == _filter.model!.toLowerCase()).toList();
    }

    // 4. Vites türü
    if (_filter.transmission != null) {
      result = result.where((Vehicle v) => v.transmission == _filter.transmission).toList();
    }

    // 5. Yakıt türü
    if (_filter.fuelType != null) {
      result = result.where((Vehicle v) => v.fuelType == _filter.fuelType).toList();
    }

    // 6. Minimum koltuk sayısı
    if (_filter.minSeats != null) {
      result = result.where((Vehicle v) => v.seatCount >= _filter.minSeats!).toList();
    }

    // 7. Yıl aralığı
    if (_filter.minYear != null) {
      result = result.where((Vehicle v) => v.year >= _filter.minYear!).toList();
    }
    if (_filter.maxYear != null) {
      result = result.where((Vehicle v) => v.year <= _filter.maxYear!).toList();
    }

    // Sıralama (Varsayılan: En Yüksek Puan)
    switch (_filter.sortBy) {
      case SortByOption.highestRating:
        result.sort((Vehicle a, Vehicle b) => b.rating.compareTo(a.rating));
        break;
      case SortByOption.priceAsc:
        result.sort((Vehicle a, Vehicle b) => a.dailyPrice.compareTo(b.dailyPrice));
        break;
      case SortByOption.priceDesc:
        result.sort((Vehicle a, Vehicle b) => b.dailyPrice.compareTo(a.dailyPrice));
        break;
      case SortByOption.yearDesc:
        result.sort((Vehicle a, Vehicle b) => b.year.compareTo(a.year));
        break;
      case SortByOption.yearAsc:
        result.sort((Vehicle a, Vehicle b) => a.year.compareTo(b.year));
        break;
    }

    value = result;
  }
}
