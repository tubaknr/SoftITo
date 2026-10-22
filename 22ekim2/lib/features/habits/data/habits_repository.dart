import 'dart:convert';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/date_time_service.dart';
import '../../../core/services/local_store.dart';
import '../../badges/models/badge_model.dart';
import '../../home/models/habit_completion.dart';
import '../../reflection/models/mood_entry.dart';
import '../models/habit.dart';
import 'mock_habits_data.dart';

/// Abstract repository for Habits, Completions, and Badges
abstract class HabitsRepository {
  Future<List<Habit>> getHabits();
  Future<void> saveHabit(Habit habit);
  Future<void> deleteHabit(String id);

  Future<List<HabitCompletion>> getCompletions();
  Future<HabitCompletion?> toggleCompletion(
    String habitId,
    DateTime date, {
    MoodEntry? moodEntry,
  });
  Future<void> saveReflection(
    String habitId,
    DateTime date,
    MoodEntry entry,
  );

  Future<List<BadgeModel>> getBadges();
  Future<void> saveBadge(BadgeModel badge);
}

/// SharedPreferences-backed HabitsRepository
class LocalHabitsRepository implements HabitsRepository {
  LocalHabitsRepository({
    required this.localStore,
    required this.dateTimeService,
  });

  final LocalStore localStore;
  final DateTimeService dateTimeService;

  @override
  Future<List<Habit>> getHabits() async {
    final raw = await localStore.getString(AppConstants.keyHabits);
    if (raw == null || raw.isEmpty) {
      // Seed with mock habits
      final initial = MockHabitsData.initialHabits;
      final encoded = jsonEncode(initial.map((h) => h.toJson()).toList());
      await localStore.setString(AppConstants.keyHabits, encoded);
      return initial;
    }
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => Habit.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return MockHabitsData.initialHabits;
    }
  }

  @override
  Future<void> saveHabit(Habit habit) async {
    final habits = await getHabits();
    final index = habits.indexWhere((h) => h.id == habit.id);
    if (index >= 0) {
      habits[index] = habit;
    } else {
      habits.add(habit);
    }
    await localStore.setString(
      AppConstants.keyHabits,
      jsonEncode(habits.map((h) => h.toJson()).toList()),
    );
  }

  @override
  Future<void> deleteHabit(String id) async {
    final habits = await getHabits();
    habits.removeWhere((h) => h.id == id);
    await localStore.setString(
      AppConstants.keyHabits,
      jsonEncode(habits.map((h) => h.toJson()).toList()),
    );

    // Also remove associated completions
    final completions = await getCompletions();
    completions.removeWhere((c) => c.habitId == id);
    await localStore.setString(
      AppConstants.keyCompletions,
      jsonEncode(completions.map((c) => c.toJson()).toList()),
    );
  }

  @override
  Future<List<HabitCompletion>> getCompletions() async {
    final raw = await localStore.getString(AppConstants.keyCompletions);
    if (raw == null || raw.isEmpty) {
      final initial = MockHabitsData.initialCompletions(dateTimeService.today());
      final encoded = jsonEncode(initial.map((c) => c.toJson()).toList());
      await localStore.setString(AppConstants.keyCompletions, encoded);
      return initial;
    }
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => HabitCompletion.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<HabitCompletion?> toggleCompletion(
    String habitId,
    DateTime date, {
    MoodEntry? moodEntry,
  }) async {
    final normalized = DateTime(date.year, date.month, date.day);
    final completions = await getCompletions();

    final existingIndex = completions.indexWhere(
      (c) =>
          c.habitId == habitId &&
          c.date.year == normalized.year &&
          c.date.month == normalized.month &&
          c.date.day == normalized.day,
    );

    HabitCompletion? result;
    if (existingIndex >= 0) {
      // Toggle off (remove)
      completions.removeAt(existingIndex);
      result = null;
    } else {
      // Toggle on (create)
      final newCompletion = HabitCompletion(
        id: 'c_${DateTime.now().millisecondsSinceEpoch}',
        habitId: habitId,
        date: normalized,
        completedAt: dateTimeService.now(),
        moodEntry: moodEntry,
      );
      completions.add(newCompletion);
      result = newCompletion;
    }

    await localStore.setString(
      AppConstants.keyCompletions,
      jsonEncode(completions.map((c) => c.toJson()).toList()),
    );
    return result;
  }

  @override
  Future<void> saveReflection(
    String habitId,
    DateTime date,
    MoodEntry entry,
  ) async {
    final normalized = DateTime(date.year, date.month, date.day);
    final completions = await getCompletions();

    final index = completions.indexWhere(
      (c) =>
          c.habitId == habitId &&
          c.date.year == normalized.year &&
          c.date.month == normalized.month &&
          c.date.day == normalized.day,
    );

    if (index >= 0) {
      completions[index] = completions[index].copyWith(moodEntry: entry);
    } else {
      completions.add(
        HabitCompletion(
          id: 'c_${DateTime.now().millisecondsSinceEpoch}',
          habitId: habitId,
          date: normalized,
          completedAt: dateTimeService.now(),
          moodEntry: entry,
        ),
      );
    }

    await localStore.setString(
      AppConstants.keyCompletions,
      jsonEncode(completions.map((c) => c.toJson()).toList()),
    );
  }

  @override
  Future<List<BadgeModel>> getBadges() async {
    final raw = await localStore.getString(AppConstants.keyBadges);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => BadgeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveBadge(BadgeModel badge) async {
    final badges = await getBadges();
    if (!badges.any((b) => b.id == badge.id)) {
      badges.add(badge);
      await localStore.setString(
        AppConstants.keyBadges,
        jsonEncode(badges.map((b) => b.toJson()).toList()),
      );
    }
  }
}
