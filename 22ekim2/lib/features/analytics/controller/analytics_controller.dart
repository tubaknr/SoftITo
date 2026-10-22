import '../../habits/models/habit.dart';
import '../../home/models/habit_completion.dart';
import '../../reflection/models/mood_entry.dart';

enum AnalyticsTimeRange {
  sevenDays(7),
  thirtyDays(30),
  ninetyDays(90),
  all(365);

  const AnalyticsTimeRange(this.days);
  final int days;
}

/// Pure Dart statistical calculations for progress, continuity, and mood trends
class AnalyticsEngine {
  const AnalyticsEngine();

  /// Calculates overall completion rate across all active habits within [days] window
  double calculateOverallContinuity({
    required List<Habit> habits,
    required List<HabitCompletion> completions,
    required DateTime referenceDate,
    int days = 30,
  }) {
    if (habits.isEmpty) return 0.0;

    int totalScheduled = 0;
    int totalCompleted = 0;

    final normToday = DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
    );

    for (int i = 0; i < days; i++) {
      final date = normToday.subtract(Duration(days: i));
      for (final habit in habits) {
        if (habit.isScheduledForWeekday(date.weekday)) {
          totalScheduled++;
          final isDone = completions.any(
            (c) =>
                c.habitId == habit.id &&
                c.date.year == date.year &&
                c.date.month == date.month &&
                c.date.day == date.day,
          );
          if (isDone) totalCompleted++;
        }
      }
    }

    if (totalScheduled == 0) return 0.0;
    return (totalCompleted / totalScheduled) * 100.0;
  }

  /// Calculates individual habit completion rate within [days]
  double calculateHabitRate({
    required Habit habit,
    required List<HabitCompletion> completions,
    required DateTime referenceDate,
    int days = 30,
  }) {
    int scheduled = 0;
    int completed = 0;

    final normToday = DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
    );

    for (int i = 0; i < days; i++) {
      final date = normToday.subtract(Duration(days: i));
      if (habit.isScheduledForWeekday(date.weekday)) {
        scheduled++;
        final isDone = completions.any(
          (c) =>
              c.habitId == habit.id &&
              c.date.year == date.year &&
              c.date.month == date.month &&
              c.date.day == date.day,
        );
        if (isDone) completed++;
      }
    }

    if (scheduled == 0) return 0.0;
    return (completed / scheduled) * 100.0;
  }

  /// Daily breakdown points for continuity chart
  List<double> calculateContinuityTimeline({
    required List<Habit> habits,
    required List<HabitCompletion> completions,
    required DateTime referenceDate,
    int days = 7,
  }) {
    final points = <double>[];
    final normToday = DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
    );

    for (int i = days - 1; i >= 0; i--) {
      final date = normToday.subtract(Duration(days: i));
      int scheduledOnDay = 0;
      int completedOnDay = 0;

      for (final h in habits) {
        if (h.isScheduledForWeekday(date.weekday)) {
          scheduledOnDay++;
          final isDone = completions.any(
            (c) =>
                c.habitId == h.id &&
                c.date.year == date.year &&
                c.date.month == date.month &&
                c.date.day == date.day,
          );
          if (isDone) completedOnDay++;
        }
      }

      final dayRate = scheduledOnDay == 0
          ? 0.0
          : (completedOnDay / scheduledOnDay).clamp(0.0, 1.0);
      points.add(dayRate);
    }

    return points;
  }

  /// Counts distribution of each emotion for given completions
  Map<Mood, int> calculateMoodDistribution(List<HabitCompletion> completions) {
    final dist = <Mood, int>{
      Mood.awesome: 0,
      Mood.happy: 0,
      Mood.calm: 0,
      Mood.tired: 0,
      Mood.challenging: 0,
    };

    for (final c in completions) {
      if (c.moodEntry != null) {
        final m = c.moodEntry!.mood;
        dist[m] = (dist[m] ?? 0) + 1;
      }
    }

    return dist;
  }

  /// Computes average mood score out of 5.0
  double calculateAverageMoodScore(List<HabitCompletion> completions) {
    int totalScore = 0;
    int count = 0;

    for (final c in completions) {
      if (c.moodEntry != null) {
        totalScore += c.moodEntry!.mood.score;
        count++;
      }
    }

    if (count == 0) return 0.0;
    return totalScore / count;
  }
}
