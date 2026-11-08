// ========================================
// DOSYA: home_shell_screen.dart
// NE İŞE YARAR: Alt gezinme çubuğu ile ana
// sekmeler arası geçişi sağlar.
// NASIL ÇALIŞIR: Seçili sekme indeksine göre
// ilgili ekranı gövdede görüntüler.
// SOLID: SRP - Sadece ana kabuk gezinmesini
// yönetir, sekmelerin içeriğini bilmez.
// ========================================

import 'package:flutter/material.dart';
import '../features/quit/quit_controller.dart';
import '../theme/app_theme.dart';
import 'craving_screen.dart';
import 'diary_screen.dart';
import 'health_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

// SRP: 4 sekmeli alt gezinme kabuk ekranı.
class HomeShellScreen extends StatefulWidget {
  final QuitController quitController;

  const HomeShellScreen({
    super.key,
    required this.quitController,
  });

  @override
  State<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends State<HomeShellScreen> {
  int _currentIndex = 0;

  // Sekme ekranları listesi
  late final List<Widget> _screens = [
    HomeScreen(quitController: widget.quitController),
    HealthScreen(quitController: widget.quitController),
    const DiaryScreen(),
    SettingsScreen(quitController: widget.quitController),
  ];

  void _openCravingModal() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CravingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceLowest,
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Lumina Recovery', style: AppTheme.headlineMedium),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.dangerSosGlow,
              foregroundColor: AppTheme.dangerSos,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: AppTheme.dangerSos),
              ),
            ),
            icon: const Icon(Icons.warning_amber_rounded, size: 18),
            label: const Text(
              'Kriz',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: _openCravingModal,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return NavigationBar(
      backgroundColor: AppTheme.surfaceLowest,
      indicatorColor: AppTheme.primaryContainer,
      selectedIndex: _currentIndex,
      onDestinationSelected: (index) {
        setState(() => _currentIndex = index);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.timer_outlined, color: AppTheme.onSurfaceVariant),
          selectedIcon: Icon(Icons.timer, color: AppTheme.primary),
          label: 'Sayaç',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_border, color: AppTheme.onSurfaceVariant),
          selectedIcon: Icon(Icons.favorite, color: AppTheme.primary),
          label: 'Sağlık',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.calendar_month_outlined,
            color: AppTheme.onSurfaceVariant,
          ),
          selectedIcon: Icon(Icons.calendar_month, color: AppTheme.primary),
          label: 'Günlük',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined, color: AppTheme.onSurfaceVariant),
          selectedIcon: Icon(Icons.settings, color: AppTheme.primary),
          label: 'Ayarlar',
        ),
      ],
    );
  }
}
