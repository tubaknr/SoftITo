import 'package:flutter_test/flutter_test.dart';
import 'package:penguhabit/features/badges/controller/badge_engine.dart';
import 'package:penguhabit/features/badges/models/badge_model.dart';
import 'package:penguhabit/features/habits/models/habit.dart';
import 'package:penguhabit/features/home/models/habit_completion.dart';

void main() {
  group('BadgeEngine & Streak Calculation Tests', () {
    const engine = BadgeEngine();
    final today = DateTime(2026, 10, 22); // Thursday (weekday = 4)

    test('Daily habit: consecutive completed days increment streak', () {
      final habit = Habit(
        id: 'h1',
        title: 'Daily Habit',
        repeatDays: const [1, 2, 3, 4, 5, 6, 7],
        createdAt: today.subtract(const Duration(days: 30)),
      );

      // Completed for today, yesterday, 2 days ago, 3 days ago = 4 days
      final completions = [
        HabitCompletion(
          id: 'c1',
          habitId: 'h1',
          date: today,
          completedAt: today,
        ),
        HabitCompletion(
          id: 'c2',
          habitId: 'h1',
          date: today.subtract(const Duration(days: 1)),
          completedAt: today.subtract(const Duration(days: 1)),
        ),
        HabitCompletion(
          id: 'c3',
          habitId: 'h1',
          date: today.subtract(const Duration(days: 2)),
          completedAt: today.subtract(const Duration(days: 2)),
        ),
        HabitCompletion(
          id: 'c4',
          habitId: 'h1',
          date: today.subtract(const Duration(days: 3)),
          completedAt: today.subtract(const Duration(days: 3)),
        ),
      ];

      final streak = engine.calculateStreak(
        habit: habit,
        completions: completions,
        referenceDate: today,
      );

      expect(streak, equals(4));
    });

    test('Unscheduled days do NOT break the streak', () {
      // Habit scheduled only on weekdays: Mon(1), Tue(2), Wed(3), Thu(4), Fri(5)
      // Reference date: Thursday 2026-10-22
      final habit = Habit(
        id: 'h_weekdays',
        title: 'Weekday Habit',
        repeatDays: const [1, 2, 3, 4, 5],
        createdAt: today.subtract(const Duration(days: 20)),
      );

      // Suppose user completed Thu(today), Wed, Tue, Mon, and the preceding Friday!
      // Sat and Sun were NOT scheduled and should NOT break the streak.
      final completions = [
        HabitCompletion(
          id: 'c1',
          habitId: 'h_weekdays',
          date: DateTime(2026, 10, 22), // Thu
          completedAt: DateTime(2026, 10, 22),
        ),
        HabitCompletion(
          id: 'c2',
          habitId: 'h_weekdays',
          date: DateTime(2026, 10, 21), // Wed
          completedAt: DateTime(2026, 10, 21),
        ),
        HabitCompletion(
          id: 'c3',
          habitId: 'h_weekdays',
          date: DateTime(2026, 10, 20), // Tue
          completedAt: DateTime(2026, 10, 20),
        ),
        HabitCompletion(
          id: 'c4',
          habitId: 'h_weekdays',
          date: DateTime(2026, 10, 19), // Mon
          completedAt: DateTime(2026, 10, 19),
        ),
        // Sat (17) and Sun (18) skipped!
        HabitCompletion(
          id: 'c5',
          habitId: 'h_weekdays',
          date: DateTime(2026, 10, 16), // Preceding Friday
          completedAt: DateTime(2026, 10, 16),
        ),
      ];

      final streak = engine.calculateStreak(
        habit: habit,
        completions: completions,
        referenceDate: today,
      );

      expect(streak, equals(5));
    });

    test('Missed scheduled day breaks the streak', () {
      final habit = Habit(
        id: 'h1',
        title: 'Daily Habit',
        repeatDays: const [1, 2, 3, 4, 5, 6, 7],
        createdAt: today.subtract(const Duration(days: 30)),
      );

      // Completed today (Thu) and Wed, but Tuesday was missed, and Mon was done.
      final completions = [
        HabitCompletion(
          id: 'c1',
          habitId: 'h1',
          date: today,
          completedAt: today,
        ),
        HabitCompletion(
          id: 'c2',
          habitId: 'h1',
          date: today.subtract(const Duration(days: 1)),
          completedAt: today.subtract(const Duration(days: 1)),
        ),
        // Missing day -2 (Tuesday)!
        HabitCompletion(
          id: 'c4',
          habitId: 'h1',
          date: today.subtract(const Duration(days: 3)),
          completedAt: today.subtract(const Duration(days: 3)),
        ),
      ];

      final streak = engine.calculateStreak(
        habit: habit,
        completions: completions,
        referenceDate: today,
      );

      expect(streak, equals(2));
    });

    test('Badge evaluation: awards micro badges at step 5 and Silver Penguin at 21', () {
      final habit = Habit(
        id: 'h1',
        title: 'Daily Habit',
        repeatDays: const [1, 2, 3, 4, 5, 6, 7],
        createdAt: today.subtract(const Duration(days: 30)),
      );

      final badges = engine.evaluateBadges(
        habit: habit,
        streak: 21,
        existingBadges: [],
        awardDate: today,
      );

      // At streak 21: micro badges (5, 10, 15, 20) + Silver Penguin (21) = 5 badges
      expect(badges.any((b) => b.level == 21 && b.title == 'Gümüş Penguen'), isTrue);
      expect(badges.any((b) => b.level == 5), isTrue);
      expect(badges.any((b) => b.level == 10), isTrue);
      expect(badges.any((b) => b.level == 15), isTrue);
      expect(badges.any((b) => b.level == 20), isTrue);
      expect(badges.length, equals(5));
    });

    test('Badge evaluation: avoids duplicate awards if already present', () {
      final habit = Habit(
        id: 'h1',
        title: 'Daily Habit',
        repeatDays: const [1, 2, 3, 4, 5, 6, 7],
        createdAt: today.subtract(const Duration(days: 30)),
      );

      final existing = [
        BadgeModel(
          id: 'badge_step_5_h1',
          level: 5,
          title: '5 Günlük Seri Rozeti',
          earnedAt: today.subtract(const Duration(days: 5)),
        ),
      ];

      final newBadges = engine.evaluateBadges(
        habit: habit,
        streak: 7,
        existingBadges: existing,
        awardDate: today,
      );

      expect(newBadges.isEmpty, isTrue);
    });
  });
}
