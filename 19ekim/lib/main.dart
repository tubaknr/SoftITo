import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/sport_habit_tracker/controller/sport_habit_controller.dart';
import 'features/sport_habit_tracker/view/sport_habit_tracker_view.dart';
import 'features/water_traker/controller/water_tracker_controller.dart';
import 'features/water_traker/view/water_tracker_view.dart';
import 'features/workout/controller/workout_controller.dart';
import 'features/workout/view/workout_view.dart';

void main() {
  runApp(const SusadimApp());
}

class SusadimApp extends StatelessWidget {
  const SusadimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Susadım',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  late final WaterTrackerController _waterController;
  late final WorkoutController _workoutController;
  late final SportHabitController _habitController;

  @override
  void initState() {
    super.initState();
    _waterController = WaterTrackerController();
    _workoutController = WorkoutController();
    _habitController = SportHabitController();
    _workoutController.addListener(_syncWorkoutBonusToWater);
  }

  void _syncWorkoutBonusToWater() {
    final extraWaterMl = _workoutController.totalDurationMinutes * 12;
    _waterController.setWorkoutBonusMl(extraWaterMl);
  }

  @override
  void dispose() {
    _workoutController.removeListener(_syncWorkoutBonusToWater);
    _waterController.dispose();
    _workoutController.dispose();
    _habitController.dispose();
    super.dispose();
  }

  String _getTitle() {
    return switch (_currentIndex) {
      0 => 'SUSADIM • SU',
      1 => 'SUSADIM • ANTRENMAN',
      2 => 'SUSADIM • ALIŞKANLIKLAR',
      _ => 'SUSADIM',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getTitle())),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          WaterTrackerView(controller: _waterController),
          WorkoutView(controller: _workoutController),
          SportHabitTrackerView(controller: _habitController),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.water_drop_outlined),
            selectedIcon: Icon(Icons.water_drop),
            label: 'Su Takibi',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Egzersiz',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_repeat_outlined),
            selectedIcon: Icon(Icons.event_repeat),
            label: 'Alışkanlık',
          ),
        ],
      ),
    );
  }
}
