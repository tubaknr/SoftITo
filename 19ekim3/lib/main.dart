import 'package:flutter/material.dart';
import 'features/activity_tracker/controllers/activity_tracker_controller.dart';
import 'features/activity_tracker/views/activity_tracker_view.dart';
import 'features/water_tracker/controllers/water_tracker_controller.dart';
import 'features/water_tracker/views/water_tracker_view.dart';

void main() {
  runApp(const FitnessTrackerApp());
}

/// Uygulama Kök Widget'ı
class FitnessTrackerApp extends StatefulWidget {
  const FitnessTrackerApp({super.key});

  @override
  State<FitnessTrackerApp> createState() => _FitnessTrackerAppState();
}

class _FitnessTrackerAppState extends State<FitnessTrackerApp> {
  final ValueNotifier<ThemeMode> _themeMode = ValueNotifier(ThemeMode.dark);

  void _toggleTheme() {
    _themeMode.value = _themeMode.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  @override
  void dispose() {
    _themeMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Fitness & Habit Tracker',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: Colors.cyan,
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            cardTheme: const CardThemeData(
              color: Colors.white,
              elevation: 1,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.cyan,
            scaffoldBackgroundColor: const Color(0xFF0B0F19),
            cardTheme: const CardThemeData(
              color: Color(0xFF131B2E),
              elevation: 2,
            ),
          ),
          home: MainNavigationScreen(onToggleTheme: _toggleTheme),
        );
      },
    );
  }
}

/// Ana Navigasyon Ekranı
class MainNavigationScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const MainNavigationScreen({
    super.key,
    required this.onToggleTheme,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);

  late final ActivityTrackerController _activityController;
  late final WaterTrackerController _waterController;

  @override
  void initState() {
    super.initState();
    _activityController = ActivityTrackerController();
    _waterController = WaterTrackerController();
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    _activityController.dispose();
    _waterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (context, index, _) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Row(
              children: const [
                Icon(Icons.bolt_rounded, color: Colors.cyan),
                SizedBox(width: 8),
                Text(
                  'FitLife Pro',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Tema Değiştir',
                icon: const Icon(Icons.brightness_medium_rounded),
                onPressed: widget.onToggleTheme,
              ),
            ],
          ),
          body: IndexedStack(
            index: index,
            children: [
              ActivityTrackerView(controller: _activityController),
              WaterTrackerView(controller: _waterController),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (val) => _currentIndex.value = val,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.fitness_center_outlined),
                selectedIcon: Icon(Icons.fitness_center_rounded),
                label: 'Aktivite',
              ),
              NavigationDestination(
                icon: Icon(Icons.water_drop_outlined),
                selectedIcon: Icon(Icons.water_drop_rounded),
                label: 'Su Takibi',
              ),
            ],
          ),
        );
      },
    );
  }
}
