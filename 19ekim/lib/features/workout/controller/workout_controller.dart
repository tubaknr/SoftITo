import 'package:flutter/foundation.dart';
import '../models/workout_item.dart';

class WorkoutController extends ChangeNotifier {
  WorkoutController({int initialCalorieGoal = 600})
      : _dailyCalorieGoal = initialCalorieGoal;

  int _dailyCalorieGoal;
  final List<WorkoutItem> _workouts = [];

  int get dailyCalorieGoal => _dailyCalorieGoal;
  List<WorkoutItem> get workouts => List.unmodifiable(_workouts);

  int get totalCaloriesBurned {
    return _workouts.fold<int>(0, (sum, item) => sum + item.caloriesBurned);
  }

  int get totalDurationMinutes {
    return _workouts.fold<int>(0, (sum, item) => sum + item.durationMinutes);
  }

  double get calorieProgressRatio {
    if (_dailyCalorieGoal <= 0) return 0.0;
    final ratio = totalCaloriesBurned / _dailyCalorieGoal;
    return ratio > 1.0 ? 1.0 : ratio;
  }

  void addWorkout({
    required String title,
    required int durationMinutes,
    required int caloriesBurned,
  }) {
    if (title.isEmpty || durationMinutes <= 0 || caloriesBurned <= 0) return;
    _workouts.insert(
      0,
      WorkoutItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        durationMinutes: durationMinutes,
        caloriesBurned: caloriesBurned,
        completedAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void removeWorkout(String id) {
    _workouts.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateCalorieGoal(int newGoal) {
    if (newGoal <= 0) return;
    _dailyCalorieGoal = newGoal;
    notifyListeners();
  }
}
