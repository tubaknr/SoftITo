import 'package:flutter/material.dart';

import '../utils/date_utils.dart';
import 'habit_presets.dart';

/// Takip edilen tek bir alışkanlık.
/// Tamamlanan günler "yyyy-MM-dd" anahtarlarından oluşan bir küme olarak saklanır.
class Habit {
  final String id;
  final String name;
  final int iconIndex;
  final int colorIndex;
  final int weeklyGoal; // haftada kaç gün yapılmak isteniyor (1-7)
  final DateTime createdAt; // sadece gün (saat yok)
  final Set<String> completed;

  const Habit({
    required this.id,
    required this.name,
    required this.iconIndex,
    required this.colorIndex,
    required this.weeklyGoal,
    required this.createdAt,
    required this.completed,
  });

  IconData get icon => habitIcons[iconIndex];
  Color get color => habitColors[colorIndex];

  bool isDoneOn(DateTime day) => completed.contains(dateKey(day));

  /// Alışkanlık o gün zaten oluşturulmuş muydu?
  bool existsOn(DateTime day) => !dateOnly(day).isBefore(createdAt);

  Habit copyWith({
    String? name,
    int? iconIndex,
    int? colorIndex,
    int? weeklyGoal,
    Set<String>? completed,
  }) =>
      Habit(
        id: id,
        name: name ?? this.name,
        iconIndex: iconIndex ?? this.iconIndex,
        colorIndex: colorIndex ?? this.colorIndex,
        weeklyGoal: weeklyGoal ?? this.weeklyGoal,
        createdAt: createdAt,
        completed: completed ?? this.completed,
      );
}
