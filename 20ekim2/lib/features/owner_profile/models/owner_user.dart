import 'package:flutter/foundation.dart';
import '../../vehicle_list/models/review.dart';

@immutable
class OwnerUser {
  const OwnerUser({
    required this.id,
    required this.firstName,
    required this.lastNameInitial,
    required this.ageRange,
    required this.city,
    required this.district,
    required this.avatar,
    required this.about,
    required this.memberSince,
    required this.ownerRating,
    required this.ownerReviewCount,
    required this.totalRentCount,
    required this.responseTime,
    required this.vehicleIds,
    this.reviews = const <Review>[],
  });

  final String id;
  final String firstName;
  final String lastNameInitial;
  final String ageRange;
  final String city;
  final String district;
  final String avatar;
  final String about;
  final String memberSince;
  final double ownerRating;
  final int ownerReviewCount;
  final int totalRentCount;
  final String responseTime;
  final List<String> vehicleIds;
  final List<Review> reviews;

  String get displayName => '$firstName $lastNameInitial';
  String get location => '$district, $city';

  OwnerUser copyWith({
    String? id,
    String? firstName,
    String? lastNameInitial,
    String? ageRange,
    String? city,
    String? district,
    String? avatar,
    String? about,
    String? memberSince,
    double? ownerRating,
    int? ownerReviewCount,
    int? totalRentCount,
    String? responseTime,
    List<String>? vehicleIds,
    List<Review>? reviews,
  }) {
    return OwnerUser(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastNameInitial: lastNameInitial ?? this.lastNameInitial,
      ageRange: ageRange ?? this.ageRange,
      city: city ?? this.city,
      district: district ?? this.district,
      avatar: avatar ?? this.avatar,
      about: about ?? this.about,
      memberSince: memberSince ?? this.memberSince,
      ownerRating: ownerRating ?? this.ownerRating,
      ownerReviewCount: ownerReviewCount ?? this.ownerReviewCount,
      totalRentCount: totalRentCount ?? this.totalRentCount,
      responseTime: responseTime ?? this.responseTime,
      vehicleIds: vehicleIds ?? this.vehicleIds,
      reviews: reviews ?? this.reviews,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastNameInitial': lastNameInitial,
      'ageRange': ageRange,
      'city': city,
      'district': district,
      'avatar': avatar,
      'about': about,
      'memberSince': memberSince,
      'ownerRating': ownerRating,
      'ownerReviewCount': ownerReviewCount,
      'totalRentCount': totalRentCount,
      'responseTime': responseTime,
      'vehicleIds': vehicleIds,
      'reviews': reviews.map((Review r) => r.toJson()).toList(),
    };
  }

  factory OwnerUser.fromJson(Map<String, dynamic> json) {
    return OwnerUser(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastNameInitial: json['lastNameInitial'] as String,
      ageRange: json['ageRange'] as String,
      city: json['city'] as String,
      district: json['district'] as String,
      avatar: json['avatar'] as String,
      about: json['about'] as String,
      memberSince: json['memberSince'] as String,
      ownerRating: (json['ownerRating'] as num).toDouble(),
      ownerReviewCount: json['ownerReviewCount'] as int,
      totalRentCount: json['totalRentCount'] as int,
      responseTime: json['responseTime'] as String,
      vehicleIds: List<String>.from(json['vehicleIds'] as List<dynamic>),
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((dynamic e) => Review.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Review>[],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OwnerUser && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
