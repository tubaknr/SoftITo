import 'package:flutter/material.dart';
import 'enums.dart';
import 'review.dart';

@immutable
class Vehicle {
  const Vehicle({
    required this.id,
    required this.ownerId,
    required this.type,
    required this.brand,
    required this.model,
    required this.year,
    required this.plate,
    required this.chassisOrIdNo,
    required this.transmission,
    required this.fuelType,
    required this.seatCount,
    required this.mileageKm,
    required this.accidentHistory,
    required this.accidentDescription,
    required this.expertiseReportImage,
    required this.images,
    required this.hourlyPrice,
    required this.dailyPrice,
    required this.weeklyPrice,
    required this.monthlyPrice,
    required this.rating,
    required this.ratingCount,
    required this.rentCount,
    required this.hasInteriorCamera,
    required this.insurancePolicyName,
    this.bookedRanges = const <DateTimeRange>[],
    this.reviews = const <Review>[],
  });

  final String id;
  final String ownerId;
  final VehicleType type;
  final String brand;
  final String model;
  final int year;
  final String plate;
  final String chassisOrIdNo;
  final TransmissionType transmission;
  final FuelType fuelType;
  final int seatCount;
  final int mileageKm;
  final AccidentHistory accidentHistory;
  final String accidentDescription;
  final String expertiseReportImage;
  final List<String> images;
  final double hourlyPrice;
  final double dailyPrice;
  final double weeklyPrice;
  final double monthlyPrice;
  final double rating;
  final int ratingCount;
  final int rentCount;
  final bool hasInteriorCamera;
  final String insurancePolicyName;
  final List<DateTimeRange> bookedRanges;
  final List<Review> reviews;

  String get fullName => '$brand $model ($year)';

  Vehicle copyWith({
    String? id,
    String? ownerId,
    VehicleType? type,
    String? brand,
    String? model,
    int? year,
    String? plate,
    String? chassisOrIdNo,
    TransmissionType? transmission,
    FuelType? fuelType,
    int? seatCount,
    int? mileageKm,
    AccidentHistory? accidentHistory,
    String? accidentDescription,
    String? expertiseReportImage,
    List<String>? images,
    double? hourlyPrice,
    double? dailyPrice,
    double? weeklyPrice,
    double? monthlyPrice,
    double? rating,
    int? ratingCount,
    int? rentCount,
    bool? hasInteriorCamera,
    String? insurancePolicyName,
    List<DateTimeRange>? bookedRanges,
    List<Review>? reviews,
  }) {
    return Vehicle(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      type: type ?? this.type,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      plate: plate ?? this.plate,
      chassisOrIdNo: chassisOrIdNo ?? this.chassisOrIdNo,
      transmission: transmission ?? this.transmission,
      fuelType: fuelType ?? this.fuelType,
      seatCount: seatCount ?? this.seatCount,
      mileageKm: mileageKm ?? this.mileageKm,
      accidentHistory: accidentHistory ?? this.accidentHistory,
      accidentDescription: accidentDescription ?? this.accidentDescription,
      expertiseReportImage: expertiseReportImage ?? this.expertiseReportImage,
      images: images ?? this.images,
      hourlyPrice: hourlyPrice ?? this.hourlyPrice,
      dailyPrice: dailyPrice ?? this.dailyPrice,
      weeklyPrice: weeklyPrice ?? this.weeklyPrice,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      rentCount: rentCount ?? this.rentCount,
      hasInteriorCamera: hasInteriorCamera ?? this.hasInteriorCamera,
      insurancePolicyName: insurancePolicyName ?? this.insurancePolicyName,
      bookedRanges: bookedRanges ?? this.bookedRanges,
      reviews: reviews ?? this.reviews,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'ownerId': ownerId,
      'type': type.name,
      'brand': brand,
      'model': model,
      'year': year,
      'plate': plate,
      'chassisOrIdNo': chassisOrIdNo,
      'transmission': transmission.name,
      'fuelType': fuelType.name,
      'seatCount': seatCount,
      'mileageKm': mileageKm,
      'accidentHistory': accidentHistory.name,
      'accidentDescription': accidentDescription,
      'expertiseReportImage': expertiseReportImage,
      'images': images,
      'hourlyPrice': hourlyPrice,
      'dailyPrice': dailyPrice,
      'weeklyPrice': weeklyPrice,
      'monthlyPrice': monthlyPrice,
      'rating': rating,
      'ratingCount': ratingCount,
      'rentCount': rentCount,
      'hasInteriorCamera': hasInteriorCamera,
      'insurancePolicyName': insurancePolicyName,
      'bookedRanges': bookedRanges
          .map((DateTimeRange r) => <String, dynamic>{
                'start': r.start.toIso8601String(),
                'end': r.end.toIso8601String(),
              })
          .toList(),
      'reviews': reviews.map((Review r) => r.toJson()).toList(),
    };
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      type: VehicleType.values.byName(json['type'] as String),
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      plate: json['plate'] as String,
      chassisOrIdNo: json['chassisOrIdNo'] as String,
      transmission: TransmissionType.values.byName(json['transmission'] as String),
      fuelType: FuelType.values.byName(json['fuelType'] as String),
      seatCount: json['seatCount'] as int,
      mileageKm: json['mileageKm'] as int,
      accidentHistory: AccidentHistory.values.byName(json['accidentHistory'] as String),
      accidentDescription: json['accidentDescription'] as String,
      expertiseReportImage: json['expertiseReportImage'] as String,
      images: List<String>.from(json['images'] as List<dynamic>),
      hourlyPrice: (json['hourlyPrice'] as num).toDouble(),
      dailyPrice: (json['dailyPrice'] as num).toDouble(),
      weeklyPrice: (json['weeklyPrice'] as num).toDouble(),
      monthlyPrice: (json['monthlyPrice'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      ratingCount: json['ratingCount'] as int,
      rentCount: json['rentCount'] as int,
      hasInteriorCamera: json['hasInteriorCamera'] as bool,
      insurancePolicyName: json['insurancePolicyName'] as String,
      bookedRanges: (json['bookedRanges'] as List<dynamic>?)
              ?.map((dynamic e) => DateTimeRange(
                    start: DateTime.parse((e as Map<String, dynamic>)['start'] as String),
                    end: DateTime.parse(e['end'] as String),
                  ))
              .toList() ??
          const <DateTimeRange>[],
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((dynamic e) => Review.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Review>[],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vehicle && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
