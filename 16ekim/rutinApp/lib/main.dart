import 'package:flutter/material.dart';
import 'pages/habits_page.dart';
import 'pages/stats_page.dart';
import 'pages/today_page.dart';
import 'state/habit_store.dart';
import 'widgets/habit_form_sheet.dart';

void main() => runApp(const RutinApp());

// RUTIN APP GENERAL 
class RutinApp extends StatelessWidget {
  const RutinApp({super.key});

// BUILD RUTIN APP 
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rutin',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFEA580C)),
          scaffoldBackgroundColor: const Color(0xFFFFF8F1),
        ),
        // HOME: APP SHELL. ARAYÜZ KATMANI UI 
        home: const AppShell(),
      );
}

// APP SHELL CLASS 
class AppShell extends StatefulWidget {
  const AppShell({super.key});

// CREATE APP SHELL STATE
  @override
  State<AppShell> createState() => _AppShellState();
}

// APP SHELL STATE
class _AppShellState extends State<AppShell> {
  // STATE 
  final HabitStore _store = HabitStore();
  int _currentIndex = 0;

  static const _titles = ['Bugün', 'Alışkanlıklarım', 'İstatistikler'];

  @override
  void dispose() {
    // STATE DISPOSE
    _store.dispose();
    super.dispose();
  }

  void _openAddHabit() => showHabitFormSheet(context, _store);

// BUILD INSIDE APP SHELL STATE 
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      // LISTEN TO STATE 
      listenable: _store,
      builder: (context, _) => Scaffold(
        // APPBAR
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          title: Text(
            _titles[_currentIndex],
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        // BODY
        body: SafeArea(
          top: false,
          child: IndexedStack(
            index: _currentIndex,
            children: [
              // PAGES UI (içlerinde widgets (UI) var)
              // İÇERİDE STATE 
              TodayPage(store: _store, onAddHabit: _openAddHabit),
              HabitsPage(store: _store),
              StatsPage(store: _store),
            ],
          ),
        ),
        floatingActionButton: _currentIndex == 1
            ? FloatingActionButton.extended(
                onPressed: _openAddHabit,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Yeni alışkanlık'),
              )
            : null,
          // NAVIGATION BAR
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.today_rounded), label: 'Bugün'),
            NavigationDestination(icon: Icon(Icons.checklist_rounded), label: 'Alışkanlıklar'),
            NavigationDestination(icon: Icon(Icons.insights_rounded), label: 'İstatistik'),
          ],
        ),
      ),
    );
  }
}
