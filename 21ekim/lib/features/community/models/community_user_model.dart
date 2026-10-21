import '../../../core/constants/app_constants.dart';

/// Topluluk Kullanıcısı Veri Modeli (Immutable).
class CommunityUserModel {
  final String id;
  final String name;
  final int age;
  final String country;
  final int totalFocusSeconds;
  final int streakDays;
  final FlowerStage flowerStage;
  final String? photoUrl;
  final bool isPrivate;
  final int dailySeconds;
  final int weeklySeconds;
  final int yearlySeconds;

  const CommunityUserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.country,
    required this.totalFocusSeconds,
    required this.streakDays,
    required this.flowerStage,
    this.photoUrl,
    this.isPrivate = false,
    required this.dailySeconds,
    required this.weeklySeconds,
    required this.yearlySeconds,
  });

  CommunityUserModel copyWith({
    String? id,
    String? name,
    int? age,
    String? country,
    int? totalFocusSeconds,
    int? streakDays,
    FlowerStage? flowerStage,
    String? photoUrl,
    bool? isPrivate,
    int? dailySeconds,
    int? weeklySeconds,
    int? yearlySeconds,
  }) {
    return CommunityUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      country: country ?? this.country,
      totalFocusSeconds: totalFocusSeconds ?? this.totalFocusSeconds,
      streakDays: streakDays ?? this.streakDays,
      flowerStage: flowerStage ?? this.flowerStage,
      photoUrl: photoUrl ?? this.photoUrl,
      isPrivate: isPrivate ?? this.isPrivate,
      dailySeconds: dailySeconds ?? this.dailySeconds,
      weeklySeconds: weeklySeconds ?? this.weeklySeconds,
      yearlySeconds: yearlySeconds ?? this.yearlySeconds,
    );
  }
}

/// Ülke sıralaması modeli
class CountryRankingModel {
  final int rank;
  final String country;
  final int totalFocusSeconds;
  final int userCount;

  const CountryRankingModel({
    required this.rank,
    required this.country,
    required this.totalFocusSeconds,
    required this.userCount,
  });
}
