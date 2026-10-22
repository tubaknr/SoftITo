import '../../habits/models/habit.dart';
import '../../home/models/habit_completion.dart';
import '../models/badge_model.dart';

/// Pure Dart calculation engine for habit streaks and badge award rules
class BadgeEngine {
  const BadgeEngine();

  /// Calculates consecutive completed planned days for [habit] up to [referenceDate]
  /// Unscheduled days (not in repeatDays) DO NOT break the streak!
  int calculateStreak({
    required Habit habit,
    required List<HabitCompletion> completions,
    required DateTime referenceDate,
  }) {
    if (habit.repeatDays.isEmpty) return 0;

    // Build quick lookup set of normalized completion dates for this habit
    final completedDays = <String>{};
    for (final c in completions) {
      if (c.habitId == habit.id) {
        completedDays.add(_dateKey(c.date));
      }
    }

    final normalizedRef = DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
    );

    int streak = 0;
    // Check backwards day by day (up to 365 days max)
    DateTime checkDay = normalizedRef;

    // If today is scheduled and NOT completed, start streak check from yesterday
    final isTodayScheduled = habit.repeatDays.contains(checkDay.weekday);
    final isTodayCompleted = completedDays.contains(_dateKey(checkDay));

    if (isTodayScheduled && isTodayCompleted) {
      streak++;
      checkDay = checkDay.subtract(const Duration(days: 1));
    } else if (isTodayScheduled && !isTodayCompleted) {
      // Today is not yet completed; see if yesterday was part of an active streak
      checkDay = checkDay.subtract(const Duration(days: 1));
    } else {
      // Today is not scheduled, start looking backwards from yesterday
      checkDay = checkDay.subtract(const Duration(days: 1));
    }

    for (int i = 0; i < 365; i++) {
      final isScheduled = habit.repeatDays.contains(checkDay.weekday);
      if (isScheduled) {
        if (completedDays.contains(_dateKey(checkDay))) {
          streak++;
        } else {
          // Missed scheduled day -> streak broken!
          break;
        }
      }
      // If not scheduled, continue backwards without breaking streak
      checkDay = checkDay.subtract(const Duration(days: 1));
    }

    return streak;
  }

  /// Evaluates new badges that should be awarded given the habit, its current streak,
  /// and previously earned badges.
  List<BadgeModel> evaluateBadges({
    required Habit habit,
    required int streak,
    required List<BadgeModel> existingBadges,
    required DateTime awardDate,
  }) {
    final newBadges = <BadgeModel>[];

    // 1. Milestone Badges: 21 (Silver), 42 (Gold), 66 (Diamond), 84 (Master)
    const milestones = [
      (21, 'badge_silver', 'Gümüş Penguen', '21 Günlük Alışkanlık Eşiği'),
      (42, 'badge_gold', 'Altın Penguen', '42 Günlük Kalıcı Alışkanlık'),
      (66, 'badge_diamond', 'Elmas Penguen', '66 Günlük Otomasyon Zirvesi'),
      (84, 'badge_master', 'Usta Penguen', '84 Günlük Hayat Tarzı Ustası'),
    ];

    for (final (level, idPrefix, title, desc) in milestones) {
      if (streak >= level) {
        final badgeId = '${idPrefix}_${habit.id}';
        final alreadyAwarded = existingBadges.any((b) => b.id == badgeId);
        if (!alreadyAwarded) {
          newBadges.add(
            BadgeModel(
              id: badgeId,
              level: level,
              title: title,
              habitId: habit.id,
              description: desc,
              earnedAt: awardDate,
            ),
          );
        }
      }
    }

    // 2. Micro Milestone Badges (Every 5 completed days in streak: 5, 10, 15, 20...)
    for (int step = 5; step <= streak; step += 5) {
      final microId = 'badge_step_${step}_${habit.id}';
      final alreadyAwarded = existingBadges.any((b) => b.id == microId);
      if (!alreadyAwarded) {
        newBadges.add(
          BadgeModel(
            id: microId,
            level: step,
            title: '$step Günlük Seri Rozeti',
            habitId: habit.id,
            description: '${habit.title} için $step gün kesintisiz devamlılık!',
            earnedAt: awardDate,
          ),
        );
      }
    }

    return newBadges;
  }

  String _dateKey(DateTime dt) => '${dt.year}-${dt.month}-${dt.day}';
}
