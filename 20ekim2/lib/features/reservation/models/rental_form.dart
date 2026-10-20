import 'package:flutter/foundation.dart';

@immutable
class RentalForm {
  const RentalForm({
    required this.brand,
    required this.model,
    required this.year,
    required this.plate,
    required this.chassisOrIdNo,
    required this.ownerName,
    required this.ownerAgeRange,
    required this.renterName,
    required this.renterAge,
    required this.renterOccupation,
    required this.pickupPlace,
    required this.pickupTime,
    required this.returnPlace,
    required this.returnTime,
    required this.price,
    required this.paymentMethod,
    required this.paymentSummary,
    required this.insurancePolicyName,
    this.preRentalPhotos = const <String>['front', 'rear', 'right', 'left'],
    this.fuelLevelBefore = 1.0,
    this.hasInteriorCamera = true,
    this.ownerSigned = false,
    this.renterSigned = false,
  });

  final String brand;
  final String model;
  final int year;
  final String plate;
  final String chassisOrIdNo;
  final String ownerName;
  final String ownerAgeRange;
  final String renterName;
  final int renterAge;
  final String renterOccupation;
  final String pickupPlace;
  final DateTime pickupTime;
  final String returnPlace;
  final DateTime returnTime;
  final double price;
  final String paymentMethod;
  final String paymentSummary;
  final String insurancePolicyName;
  final List<String> preRentalPhotos;
  final double fuelLevelBefore;
  final bool hasInteriorCamera;
  final bool ownerSigned;
  final bool renterSigned;

  bool get isFullySigned => ownerSigned && renterSigned;

  RentalForm copyWith({
    String? brand,
    String? model,
    int? year,
    String? plate,
    String? chassisOrIdNo,
    String? ownerName,
    String? ownerAgeRange,
    String? renterName,
    int? renterAge,
    String? renterOccupation,
    String? pickupPlace,
    DateTime? pickupTime,
    String? returnPlace,
    DateTime? returnTime,
    double? price,
    String? paymentMethod,
    String? paymentSummary,
    String? insurancePolicyName,
    List<String>? preRentalPhotos,
    double? fuelLevelBefore,
    bool? hasInteriorCamera,
    bool? ownerSigned,
    bool? renterSigned,
  }) {
    return RentalForm(
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      plate: plate ?? this.plate,
      chassisOrIdNo: chassisOrIdNo ?? this.chassisOrIdNo,
      ownerName: ownerName ?? this.ownerName,
      ownerAgeRange: ownerAgeRange ?? this.ownerAgeRange,
      renterName: renterName ?? this.renterName,
      renterAge: renterAge ?? this.renterAge,
      renterOccupation: renterOccupation ?? this.renterOccupation,
      pickupPlace: pickupPlace ?? this.pickupPlace,
      pickupTime: pickupTime ?? this.pickupTime,
      returnPlace: returnPlace ?? this.returnPlace,
      returnTime: returnTime ?? this.returnTime,
      price: price ?? this.price,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentSummary: paymentSummary ?? this.paymentSummary,
      insurancePolicyName: insurancePolicyName ?? this.insurancePolicyName,
      preRentalPhotos: preRentalPhotos ?? this.preRentalPhotos,
      fuelLevelBefore: fuelLevelBefore ?? this.fuelLevelBefore,
      hasInteriorCamera: hasInteriorCamera ?? this.hasInteriorCamera,
      ownerSigned: ownerSigned ?? this.ownerSigned,
      renterSigned: renterSigned ?? this.renterSigned,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'brand': brand,
      'model': model,
      'year': year,
      'plate': plate,
      'chassisOrIdNo': chassisOrIdNo,
      'ownerName': ownerName,
      'ownerAgeRange': ownerAgeRange,
      'renterName': renterName,
      'renterAge': renterAge,
      'renterOccupation': renterOccupation,
      'pickupPlace': pickupPlace,
      'pickupTime': pickupTime.toIso8601String(),
      'returnPlace': returnPlace,
      'returnTime': returnTime.toIso8601String(),
      'price': price,
      'paymentMethod': paymentMethod,
      'paymentSummary': paymentSummary,
      'insurancePolicyName': insurancePolicyName,
      'preRentalPhotos': preRentalPhotos,
      'fuelLevelBefore': fuelLevelBefore,
      'hasInteriorCamera': hasInteriorCamera,
      'ownerSigned': ownerSigned,
      'renterSigned': renterSigned,
    };
  }

  factory RentalForm.fromJson(Map<String, dynamic> json) {
    return RentalForm(
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      plate: json['plate'] as String,
      chassisOrIdNo: json['chassisOrIdNo'] as String,
      ownerName: json['ownerName'] as String,
      ownerAgeRange: json['ownerAgeRange'] as String,
      renterName: json['renterName'] as String,
      renterAge: json['renterAge'] as int,
      renterOccupation: json['renterOccupation'] as String,
      pickupPlace: json['pickupPlace'] as String,
      pickupTime: DateTime.parse(json['pickupTime'] as String),
      returnPlace: json['returnPlace'] as String,
      returnTime: DateTime.parse(json['returnTime'] as String),
      price: (json['price'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      paymentSummary: json['paymentSummary'] as String,
      insurancePolicyName: json['insurancePolicyName'] as String,
      preRentalPhotos: List<String>.from(json['preRentalPhotos'] as List<dynamic>),
      fuelLevelBefore: (json['fuelLevelBefore'] as num).toDouble(),
      hasInteriorCamera: json['hasInteriorCamera'] as bool,
      ownerSigned: json['ownerSigned'] as bool,
      renterSigned: json['renterSigned'] as bool,
    );
  }
}
