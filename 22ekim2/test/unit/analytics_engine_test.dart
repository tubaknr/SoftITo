import 'package:flutter_test/flutter_test.dart';
import 'package:penguhabit/features/analytics/controller/analytics_controller.dart';
import 'package:penguhabit/features/habits/models/habit.dart';
import 'package:penguhabit/features/home/models/habit_completion.dart';
import 'package:penguhabit/features/reflection/models/mood_entry.dart';

void main() {
  group('AnalyticsEngine Unit Tests', () {
    const engine = AnalyticsEngine();
    final today = DateTime(2026, 10, 22);

    test('Overall continuity: calculates exact completion percentage', () {
      final habit1 = Habit(
        id: 'h1',
        title: 'Habit 1',
        repeatDays: const [1, 2, 3, 4, 5, 6, 7], // everyday
        createdAt: today.subtract(const Duration(days: 30)),
      );

      // In the last 10 days, 10 scheduled days. Suppose 5 days completed -> 50%
      final completions = <HabitCompletion>[];
      for (int i = 0; i < 5; i++) {
        completions.add(
          HabitCompletion(
            id: 'c_$i',
            habitId: 'h1',
            date: today.subtract(Duration(days: i)),
            completedAt: today.subtract(Duration(days: i)),
          ),
        );
      }

      final rate = engine.calculateOverallContinuity(
        habits: [habit1],
        completions: completions,
        referenceDate: today,
        days: 10,
      );

      expect(rate, equals(50.0));
    });

    test('Average mood score: computes accurate arithmetic mean', () {
      final completions = [
        HabitCompletion(
          id: 'c1',
          habitId: 'h1',
          date: today,
          completedAt: today,
          moodEntry: MoodEntry(
            mood: Mood.awesome, // score 5
            note: 'Awesome!',
            recordedAt: today,
          ),
        ),
        HabitCompletion(
          id: 'c2',
          habitId: 'h1',
          date: today.subtract(const Duration(days: 1)),
          completedAt: today.subtract(const Duration(days: 1)),
          moodEntry: MoodEntry(
            mood: Mood.happy, // score 4
            note: 'Happy!',
            recordedAt: today.subtract(const Duration(days: 1)),
          ),
        ),
        HabitCompletion(
          id: 'c3',
          habitId: 'h1',
          date: today.subtract(const Duration(days: 2)),
          completedAt: today.subtract(const Duration(days: 2)),
          moodEntry: MoodEntry(
            mood: Mood.calm, // score 3
            note: 'Calm!',
            recordedAt: today.subtract(const Duration(days: 2)),
          ),
        ),
      ];

      // (5 + 4 + 3) / 3 = 4.0
      final avg = engine.calculateAverageMoodScore(completions);
      expect(avg, equals(4.0));
    });

    test('Mood distribution: correctly categorizes all recorded entries', () {
      final completions = [
        HabitCompletion(
          id: 'c1',
          habitId: 'h1',
          date: today,
          completedAt: today,
          moodEntry: MoodEntry(mood: Mood.awesome, note: '', recordedAt: today),
        ),
        HabitCompletion(
          id: 'c2',
          habitId: 'h1',
          date: today.subtract(const Duration(days: 1)),
          completedAt: today.subtract(const Duration(days: 1)),
          moodEntry: MoodEntry(mood: Mood.awesome, note: '', recordedAt: today),
        ),
        HabitCompletion(
          id: 'c3',
          habitId: 'h1',
          date: today.subtract(const Duration(days: 2)),
          completedAt: today.subtract(const Duration(days: 2)),
          moodEntry: MoodEntry(mood: Mood.tired, note: '', recordedAt: today),
        ),
      ];

      final dist = engine.calculateMoodDistribution(completions);
      expect(dist[Mood.awesome], equals(2));
      expect(dist[Mood.tired], equals(1));
      expect(dist[Mood.happy], equals(0));
    });
  });
}
