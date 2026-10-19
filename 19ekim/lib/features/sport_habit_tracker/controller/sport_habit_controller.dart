import 'package:flutter/foundation.dart';
import '../models/sport_habit.dart';

class SportHabitController extends ChangeNotifier {
  SportHabitController() {
    // Başlangıç için örnek alışkanlıklar
    _habits.addAll([
      const SportHabit(
        id: 'habit_1',
        title: 'Kuvvet Antrenmanı',
        targetDaysPerWeek: 4,
        completedDayIndices: {0, 2},
        currentStreak: 3,
      ),
      const SportHabit(
        id: 'habit_2',
        title: 'Kardiyo & Koşu',
        targetDaysPerWeek: 3,
        completedDayIndices: {1},
        currentStreak: 2,
      ),
    ]);
  }

  final List<SportHabit> _habits = [];

  List<SportHabit> get habits => List.unmodifiable(_habits);

  int get totalWeeklyCompleted {
    return _habits.fold<int>(0, (sum, h) => sum + h.completedThisWeekCount);
  }

  int get totalWeeklyTarget {
    return _habits.fold<int>(0, (sum, h) => sum + h.targetDaysPerWeek);
  }

  double get overallConsistencyRatio {
    if (totalWeeklyTarget <= 0) return 0.0;
    final ratio = totalWeeklyCompleted / totalWeeklyTarget;
    return ratio > 1.0 ? 1.0 : ratio;
  }

  int get highestStreak {
    if (_habits.isEmpty) return 0;
    return _habits
        .map((h) => h.currentStreak)
        .reduce((curr, next) => curr > next ? curr : next);
  }

  void toggleDayCompletion(String habitId, int dayIndex) {
    if (dayIndex < 0 || dayIndex > 6) return;
    final index = _habits.indexWhere((h) => h.id == habitId);
    if (index == -1) return;

    final habit = _habits[index];
    final updatedDays = Set<int>.from(habit.completedDayIndices);
    var updatedStreak = habit.currentStreak;

    if (updatedDays.contains(dayIndex)) {
      updatedDays.remove(dayIndex);
      if (updatedStreak > 0) updatedStreak--;
    } else {
      updatedDays.add(dayIndex);
      updatedStreak++;
    }

    _habits[index] = habit.copyWith(
      completedDayIndices: updatedDays,
      currentStreak: updatedStreak,
    );
    notifyListeners();
  }

  void addHabit({
    required String title,
    required int targetDaysPerWeek,
  }) {
    if (title.isEmpty || targetDaysPerWeek <= 0) return;
    _habits.add(
      SportHabit(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        targetDaysPerWeek: targetDaysPerWeek.clamp(1, 7),
        completedDayIndices: const {},
        currentStreak: 0,
      ),
    );
    notifyListeners();
  }

  void removeHabit(String id) {
    _habits.removeWhere((h) => h.id == id);
    notifyListeners();
  }
}
