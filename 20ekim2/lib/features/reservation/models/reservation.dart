import 'package:flutter/foundation.dart';
import '../../vehicle_list/models/enums.dart';
import 'rental_form.dart';

@immutable
class Reservation {
  const Reservation({
    required this.id,
    required this.vehicleId,
    required this.ownerId,
    required this.renterId,
    required this.pickupDateTime,
    required this.pickupLocation,
    required this.returnDateTime,
    required this.returnLocation,
    required this.totalPrice,
    required this.paymentStatus,
    required this.status,
    this.rentalForm,
  });

  final String id;
  final String vehicleId;
  final String ownerId;
  final String renterId;
  final DateTime pickupDateTime;
  final String pickupLocation;
  final DateTime returnDateTime;
  final String returnLocation;
  final double totalPrice;
  final PaymentStatus paymentStatus;
  final ReservationStatus status;
  final RentalForm? rentalForm;

  Reservation copyWith({
    String? id,
    String? vehicleId,
    String? ownerId,
    String? renterId,
    DateTime? pickupDateTime,
    String? pickupLocation,
    DateTime? returnDateTime,
    String? returnLocation,
    double? totalPrice,
    PaymentStatus? paymentStatus,
    ReservationStatus? status,
    RentalForm? rentalForm,
  }) {
    return Reservation(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      ownerId: ownerId ?? this.ownerId,
      renterId: renterId ?? this.renterId,
      pickupDateTime: pickupDateTime ?? this.pickupDateTime,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      returnDateTime: returnDateTime ?? this.returnDateTime,
      returnLocation: returnLocation ?? this.returnLocation,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      status: status ?? this.status,
      rentalForm: rentalForm ?? this.rentalForm,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'vehicleId': vehicleId,
      'ownerId': ownerId,
      'renterId': renterId,
      'pickupDateTime': pickupDateTime.toIso8601String(),
      'pickupLocation': pickupLocation,
      'returnDateTime': returnDateTime.toIso8601String(),
      'returnLocation': returnLocation,
      'totalPrice': totalPrice,
      'paymentStatus': paymentStatus.name,
      'status': status.name,
      'rentalForm': rentalForm?.toJson(),
    };
  }

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      ownerId: json['ownerId'] as String,
      renterId: json['renterId'] as String,
      pickupDateTime: DateTime.parse(json['pickupDateTime'] as String),
      pickupLocation: json['pickupLocation'] as String,
      returnDateTime: DateTime.parse(json['returnDateTime'] as String),
      returnLocation: json['returnLocation'] as String,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      paymentStatus: PaymentStatus.values.byName(json['paymentStatus'] as String),
      status: ReservationStatus.values.byName(json['status'] as String),
      rentalForm: json['rentalForm'] != null
          ? RentalForm.fromJson(json['rentalForm'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reservation && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
