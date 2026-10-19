import 'package:flutter/foundation.dart';
import '../models/water_log.dart';

class WaterTrackerController extends ChangeNotifier {
  WaterTrackerController({int initialBaseGoalMl = 2200})
      : _baseGoalMl = initialBaseGoalMl;

  int _baseGoalMl;
  int _workoutBonusMl = 0;
  final List<WaterLog> _logs = [];

  int get baseGoalMl => _baseGoalMl;
  int get workoutBonusMl => _workoutBonusMl;
  int get totalGoalMl => _baseGoalMl + _workoutBonusMl;
  List<WaterLog> get logs => List.unmodifiable(_logs);

  int get currentAmountMl {
    return _logs.fold<int>(0, (sum, log) => sum + log.amountMl);
  }

  double get progressRatio {
    if (totalGoalMl <= 0) return 0.0;
    final ratio = currentAmountMl / totalGoalMl;
    return ratio > 1.0 ? 1.0 : ratio;
  }

  int get progressPercentage {
    if (totalGoalMl <= 0) return 0;
    return ((currentAmountMl / totalGoalMl) * 100).toInt();
  }

  int get remainingMl {
    final remaining = totalGoalMl - currentAmountMl;
    return remaining < 0 ? 0 : remaining;
  }

  bool get isGoalReached => currentAmountMl >= totalGoalMl && totalGoalMl > 0;

  void addWater(int amountMl) {
    if (amountMl <= 0) return;
    _logs.insert(
      0,
      WaterLog(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        amountMl: amountMl,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void setWorkoutBonusMl(int bonusMl) {
    final safeBonus = bonusMl < 0 ? 0 : bonusMl;
    if (_workoutBonusMl == safeBonus) return;
    _workoutBonusMl = safeBonus;
    notifyListeners();
  }

  void updateBaseGoal(int newGoalMl) {
    if (newGoalMl <= 0) return;
    _baseGoalMl = newGoalMl;
    notifyListeners();
  }

  void reset() {
    _logs.clear();
    _workoutBonusMl = 0;
    notifyListeners();
  }
}
