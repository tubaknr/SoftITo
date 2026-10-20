import 'package:flutter_test/flutter_test.dart';
import 'package:kiralago/core/controllers/session_controller.dart';
import 'package:kiralago/features/reservation/controller/reservation_controller.dart';
import 'package:kiralago/features/reservation/models/reservation.dart';
import 'package:kiralago/features/vehicle_list/controller/vehicle_list_controller.dart';
import 'package:kiralago/features/vehicle_list/models/enums.dart';
import 'package:kiralago/features/vehicle_list/models/vehicle.dart';
import 'package:kiralago/features/vehicle_list/models/vehicle_filter.dart';

void main() {
  group('VehicleListController Tests', () {
    test('initializes with default sorting: highest rating', () {
      final VehicleListController controller = VehicleListController();
      final List<Vehicle> vehicles = controller.value;

      expect(vehicles.isNotEmpty, isTrue);
      // İlk araç en yüksek puana sahip olmalı
      for (int i = 0; i < vehicles.length - 1; i++) {
        expect(vehicles[i].rating >= vehicles[i + 1].rating, isTrue);
      }
    });

    test('filters by vehicle type correctly', () {
      final VehicleListController controller = VehicleListController();
      controller.setFilter(const VehicleFilter(type: VehicleType.motorcycle));

      final List<Vehicle> filtered = controller.value;
      expect(filtered.every((Vehicle v) => v.type == VehicleType.motorcycle), isTrue);
    });

    test('filters by search query matching brand or model', () {
      final VehicleListController controller = VehicleListController();
      controller.updateSearchQuery('Tesla');

      final List<Vehicle> results = controller.value;
      expect(results.length, equals(1));
      expect(results.first.brand, equals('Tesla'));
    });

    test('sorts by price ascending', () {
      final VehicleListController controller = VehicleListController();
      controller.setSortOption(SortByOption.priceAsc);

      final List<Vehicle> results = controller.value;
      for (int i = 0; i < results.length - 1; i++) {
        expect(results[i].dailyPrice <= results[i + 1].dailyPrice, isTrue);
      }
    });
  });

  group('SessionController Tests', () {
    test('initializes as guest and updates on login', () async {
      final SessionController controller = SessionController();
      expect(controller.value.isLoggedIn, isFalse);
      expect(controller.value.role, equals(UserRole.guest));

      await controller.login(
        role: UserRole.renter,
        userId: 'test_renter_1',
        displayName: 'Test Renter',
        email: 'test@kiralago.com',
        rememberMe: false,
      );

      expect(controller.value.isLoggedIn, isTrue);
      expect(controller.value.isRenter, isTrue);
      expect(controller.value.userId, equals('test_renter_1'));

      await controller.logout();
      expect(controller.value.isLoggedIn, isFalse);
    });
  });

  group('ReservationController Tests', () {
    test('creates and cancels reservation correctly', () {
      final ReservationController controller = ReservationController();
      final int initialCount = controller.value.length;

      final Reservation newRes = Reservation(
        id: 'test_res_100',
        vehicleId: 'v_1',
        ownerId: 'owner_1',
        renterId: 'renter_1',
        pickupDateTime: DateTime.now().add(const Duration(days: 1)),
        pickupLocation: 'Kadıköy',
        returnDateTime: DateTime.now().add(const Duration(days: 3)),
        returnLocation: 'Kadıköy',
        totalPrice: 2500,
        paymentStatus: PaymentStatus.paid,
        status: ReservationStatus.confirmed,
      );

      controller.addReservation(newRes);
      expect(controller.value.length, equals(initialCount + 1));
      expect(controller.value.first.id, equals('test_res_100'));

      final bool cancelled = controller.cancelReservation('test_res_100');
      expect(cancelled, isTrue);
      expect(controller.value.first.status, equals(ReservationStatus.cancelled));
    });
  });
}
