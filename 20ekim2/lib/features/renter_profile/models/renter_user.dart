import 'package:flutter/foundation.dart';
import '../../vehicle_list/models/review.dart';

@immutable
class RenterUser {
  const RenterUser({
    required this.id,
    required this.firstName,
    required this.lastNameInitial,
    required this.age,
    required this.occupation,
    required this.city,
    required this.avatar,
    required this.memberSince,
    required this.trustScore,
    required this.reviewCount,
    required this.totalRentCount,
    this.reviews = const <Review>[],
  });

  final String id;
  final String firstName;
  final String lastNameInitial;
  final int age;
  final String occupation;
  final String city;
  final String avatar;
  final String memberSince;
  final double trustScore;
  final int reviewCount;
  final int totalRentCount;
  final List<Review> reviews;

  String get displayName => '$firstName $lastNameInitial';

  RenterUser copyWith({
    String? id,
    String? firstName,
    String? lastNameInitial,
    int? age,
    String? occupation,
    String? city,
    String? avatar,
    String? memberSince,
    double? trustScore,
    int? reviewCount,
    int? totalRentCount,
    List<Review>? reviews,
  }) {
    return RenterUser(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastNameInitial: lastNameInitial ?? this.lastNameInitial,
      age: age ?? this.age,
      occupation: occupation ?? this.occupation,
      city: city ?? this.city,
      avatar: avatar ?? this.avatar,
      memberSince: memberSince ?? this.memberSince,
      trustScore: trustScore ?? this.trustScore,
      reviewCount: reviewCount ?? this.reviewCount,
      totalRentCount: totalRentCount ?? this.totalRentCount,
      reviews: reviews ?? this.reviews,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastNameInitial': lastNameInitial,
      'age': age,
      'occupation': occupation,
      'city': city,
      'avatar': avatar,
      'memberSince': memberSince,
      'trustScore': trustScore,
      'reviewCount': reviewCount,
      'totalRentCount': totalRentCount,
      'reviews': reviews.map((Review r) => r.toJson()).toList(),
    };
  }

  factory RenterUser.fromJson(Map<String, dynamic> json) {
    return RenterUser(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastNameInitial: json['lastNameInitial'] as String,
      age: json['age'] as int,
      occupation: json['occupation'] as String,
      city: json['city'] as String,
      avatar: json['avatar'] as String,
      memberSince: json['memberSince'] as String,
      trustScore: (json['trustScore'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      totalRentCount: json['totalRentCount'] as int,
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((dynamic e) => Review.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Review>[],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RenterUser && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
