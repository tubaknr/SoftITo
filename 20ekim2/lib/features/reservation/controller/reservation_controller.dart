import 'package:flutter/foundation.dart';
import '../data/mock_reservation_data.dart';
import '../models/reservation.dart';
import '../../vehicle_list/models/enums.dart';

class ReservationController extends ValueNotifier<List<Reservation>> {
  ReservationController({List<Reservation>? initialReservations})
      : super(List<Reservation>.from(initialReservations ?? MockReservationData.reservations));

  List<Reservation> get upcomingReservations {
    return value.where((Reservation r) {
      return r.status == ReservationStatus.pending ||
          r.status == ReservationStatus.confirmed ||
          r.status == ReservationStatus.active;
    }).toList();
  }

  List<Reservation> get pastReservations {
    return value.where((Reservation r) {
      return r.status == ReservationStatus.completed ||
          r.status == ReservationStatus.cancelled;
    }).toList();
  }

  void addReservation(Reservation reservation) {
    value = <Reservation>[reservation, ...value];
  }

  bool cancelReservation(String id) {
    bool updated = false;
    value = value.map((Reservation r) {
      if (r.id == id && r.status != ReservationStatus.completed) {
        updated = true;
        return r.copyWith(status: ReservationStatus.cancelled);
      }
      return r;
    }).toList();
    return updated;
  }
}
