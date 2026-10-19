import 'package:flutter/foundation.dart';
import '../models/water_tracker_model.dart';

class WaterTrackerController {
  final ValueNotifier<WaterTrackerModel> state =
      ValueNotifier<WaterTrackerModel>(
    WaterTrackerModel(
      id: 'default_id',
      title: 'WaterTracker',
      value: 0,
      isCompleted: false,
      lastUpdated: DateTime.now(),
    ),
  );

  WaterTrackerModel get current => state.value;

  void increment() {
    state.value = current.copyWith(
      value: current.value + 1,
      lastUpdated: DateTime.now(),
    );
  }

  void toggleStatus() {
    state.value = current.copyWith(
      isCompleted: !current.isCompleted,
      lastUpdated: DateTime.now(),
    );
  }

  void reset() {
    state.value = current.copyWith(
      value: 0,
      isCompleted: false,
      lastUpdated: DateTime.now(),
    );
  }

  void dispose() {
    state.dispose();
  }
}
