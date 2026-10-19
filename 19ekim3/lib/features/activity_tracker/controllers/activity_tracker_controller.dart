import 'package:flutter/foundation.dart';
import '../models/activity_tracker_model.dart';

class ActivityTrackerController {
  final ValueNotifier<ActivityTrackerModel> state =
      ValueNotifier<ActivityTrackerModel>(
    ActivityTrackerModel(
      id: 'default_id',
      title: 'ActivityTracker',
      value: 0,
      isCompleted: false,
      lastUpdated: DateTime.now(),
    ),
  );

  ActivityTrackerModel get current => state.value;

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
