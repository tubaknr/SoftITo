import 'package:flutter/foundation.dart';
import '../../vehicle_list/data/mock_vehicle_data.dart';
import '../../vehicle_list/models/vehicle.dart';

class MyVehiclesController extends ValueNotifier<List<Vehicle>> {
  MyVehiclesController({String ownerId = 'owner_1'})
      : super(
          MockVehicleData.vehicles
              .where((Vehicle v) => v.ownerId == ownerId)
              .toList(),
        );

  void addVehicle(Vehicle vehicle) {
    value = <Vehicle>[vehicle, ...value];
  }

  void updateVehicle(Vehicle updated) {
    value = value.map((Vehicle v) => v.id == updated.id ? updated : v).toList();
  }

  void removeVehicle(String id) {
    value = value.where((Vehicle v) => v.id != id).toList();
  }
}
