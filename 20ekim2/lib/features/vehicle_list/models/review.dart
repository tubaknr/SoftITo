import 'package:flutter/foundation.dart';
import 'enums.dart';

@immutable
class Review {
  const Review({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.targetType,
    required this.targetId,
    required this.rating,
    required this.date,
    required this.text,
    this.authorAvatar,
    this.returnTags = const <ReturnTag>[],
    this.vehicleId,
  });

  final String id;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final TargetType targetType;
  final String targetId;
  final double rating;
  final DateTime date;
  final String text;
  final List<ReturnTag> returnTags;
  final String? vehicleId;

  Review copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    TargetType? targetType,
    String? targetId,
    double? rating,
    DateTime? date,
    String? text,
    List<ReturnTag>? returnTags,
    String? vehicleId,
  }) {
    return Review(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      rating: rating ?? this.rating,
      date: date ?? this.date,
      text: text ?? this.text,
      returnTags: returnTags ?? this.returnTags,
      vehicleId: vehicleId ?? this.vehicleId,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'targetType': targetType.name,
      'targetId': targetId,
      'rating': rating,
      'date': date.toIso8601String(),
      'text': text,
      'returnTags': returnTags.map((ReturnTag t) => t.name).toList(),
      'vehicleId': vehicleId,
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorAvatar: json['authorAvatar'] as String?,
      targetType: TargetType.values.byName(json['targetType'] as String),
      targetId: json['targetId'] as String,
      rating: (json['rating'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      text: json['text'] as String,
      returnTags: (json['returnTags'] as List<dynamic>?)
              ?.map((dynamic e) => ReturnTag.values.byName(e as String))
              .toList() ??
          const <ReturnTag>[],
      vehicleId: json['vehicleId'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Review &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          authorId == other.authorId &&
          targetId == other.targetId;

  @override
  int get hashCode => Object.hash(id, authorId, targetId);
}
