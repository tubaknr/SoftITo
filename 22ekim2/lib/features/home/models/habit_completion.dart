import '../../reflection/models/mood_entry.dart';

/// Immutable habit completion record tied to a specific calendar day
class HabitCompletion {
  const HabitCompletion({
    required this.id,
    required this.habitId,
    required this.date, // Normalized day (year, month, day)
    required this.completedAt,
    this.moodEntry,
  });

  final String id;
  final String habitId;
  final DateTime date;
  final DateTime completedAt;
  final MoodEntry? moodEntry;

  HabitCompletion copyWith({
    String? id,
    String? habitId,
    DateTime? date,
    DateTime? completedAt,
    MoodEntry? moodEntry,
    bool clearMoodEntry = false,
  }) {
    return HabitCompletion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      completedAt: completedAt ?? this.completedAt,
      moodEntry: clearMoodEntry ? null : (moodEntry ?? this.moodEntry),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habitId': habitId,
      'date': date.toIso8601String(),
      'completedAt': completedAt.toIso8601String(),
      'moodEntry': moodEntry?.toJson(),
    };
  }

  factory HabitCompletion.fromJson(Map<String, dynamic> json) {
    return HabitCompletion(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      date: DateTime.parse(json['date'] as String),
      completedAt: DateTime.parse(json['completedAt'] as String),
      moodEntry: json['moodEntry'] != null
          ? MoodEntry.fromJson(json['moodEntry'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitCompletion &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          habitId == other.habitId &&
          date.year == other.date.year &&
          date.month == other.date.month &&
          date.day == other.date.day &&
          moodEntry == other.moodEntry;

  @override
  int get hashCode => Object.hash(id, habitId, date.year, date.month, date.day);
}
