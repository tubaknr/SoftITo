import 'package:flutter/foundation.dart';
import '../../../core/services/date_time_service.dart';
import '../../badges/controller/badge_engine.dart';
import '../../badges/models/badge_model.dart';
import '../../home/models/habit_completion.dart';
import '../../reflection/models/mood_entry.dart';
import '../data/habits_repository.dart';
import '../models/habit.dart';

/// Pure Dart controller for habit management, completions, and badge triggers
class HabitsController {
  HabitsController({
    required this.repository,
    required this.dateTimeService,
    this.badgeEngine = const BadgeEngine(),
  });

  final HabitsRepository repository;
  final DateTimeService dateTimeService;
  final BadgeEngine badgeEngine;

  final ValueNotifier<List<Habit>> habits = ValueNotifier<List<Habit>>([]);
  final ValueNotifier<List<HabitCompletion>> completions =
      ValueNotifier<List<HabitCompletion>>([]);
  final ValueNotifier<List<BadgeModel>> badges =
      ValueNotifier<List<BadgeModel>>([]);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<int> celebrationTrigger = ValueNotifier<int>(0);

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final hList = await repository.getHabits();
      final cList = await repository.getCompletions();
      final bList = await repository.getBadges();
      habits.value = hList;
      completions.value = cList;
      badges.value = bList;
    } finally {
      isLoading.value = false;
    }
  }

  List<Habit> habitsForDate(DateTime date) {
    return habits.value.where((h) => h.isScheduledForWeekday(date.weekday)).toList();
  }

  bool isCompleted(String habitId, DateTime date) {
    final norm = DateTime(date.year, date.month, date.day);
    return completions.value.any(
      (c) =>
          c.habitId == habitId &&
          c.date.year == norm.year &&
          c.date.month == norm.month &&
          c.date.day == norm.day,
    );
  }

  HabitCompletion? getCompletion(String habitId, DateTime date) {
    final norm = DateTime(date.year, date.month, date.day);
    try {
      return completions.value.firstWhere(
        (c) =>
            c.habitId == habitId &&
            c.date.year == norm.year &&
            c.date.month == norm.month &&
            c.date.day == norm.day,
      );
    } catch (_) {
      return null;
    }
  }

  int getStreak(String habitId) {
    try {
      final habit = habits.value.firstWhere((h) => h.id == habitId);
      return badgeEngine.calculateStreak(
        habit: habit,
        completions: completions.value,
        referenceDate: dateTimeService.today(),
      );
    } catch (_) {
      return 0;
    }
  }

  Future<HabitCompletion?> toggleHabit(
    String habitId,
    DateTime date, {
    MoodEntry? moodEntry,
  }) async {
    final result = await repository.toggleCompletion(
      habitId,
      date,
      moodEntry: moodEntry,
    );

    // Refresh completions
    completions.value = await repository.getCompletions();

    if (result != null) {
      // Trigger confetti celebration
      celebrationTrigger.value++;
      // Check and award badges
      await _checkBadgesForHabit(habitId);
    }

    return result;
  }

  Future<void> saveMoodAndNote(
    String habitId,
    DateTime date,
    Mood mood,
    String note,
  ) async {
    final entry = MoodEntry(
      mood: mood,
      note: note.trim(),
      recordedAt: dateTimeService.now(),
    );
    await repository.saveReflection(habitId, date, entry);
    completions.value = await repository.getCompletions();
  }

  Future<void> saveHabit(Habit habit) async {
    await repository.saveHabit(habit);
    habits.value = await repository.getHabits();
  }

  Future<void> deleteHabit(String habitId) async {
    await repository.deleteHabit(habitId);
    habits.value = await repository.getHabits();
    completions.value = await repository.getCompletions();
  }

  Future<void> _checkBadgesForHabit(String habitId) async {
    final habit = habits.value.firstWhere((h) => h.id == habitId);
    final streak = badgeEngine.calculateStreak(
      habit: habit,
      completions: completions.value,
      referenceDate: dateTimeService.today(),
    );

    final newBadges = badgeEngine.evaluateBadges(
      habit: habit,
      streak: streak,
      existingBadges: badges.value,
      awardDate: dateTimeService.now(),
    );

    for (final b in newBadges) {
      await repository.saveBadge(b);
    }

    if (newBadges.isNotEmpty) {
      badges.value = await repository.getBadges();
      celebrationTrigger.value++;
    }
  }

  void dispose() {
    habits.dispose();
    completions.dispose();
    badges.dispose();
    isLoading.dispose();
    celebrationTrigger.dispose();
  }
}
