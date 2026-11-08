// ========================================
// DOSYA: home_screen.dart
// NE İŞE YARAR: Canlı sayaç, tasarruf kartları
// ve kriz butonunu ana ekranda sunar.
// NASIL ÇALIŞIR: QuitController durumunu
// dinleyerek canlı metrikleri günceller.
// SOLID: SRP - Sadece ana ekran arayüzü.
// ========================================

import 'package:flutter/material.dart';
import '../features/quit/quit_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/timer_display.dart';
import 'craving_screen.dart';

// SRP: Ana gösterge paneli ekranı.
class HomeScreen extends StatelessWidget {
  final QuitController quitController;

  const HomeScreen({super.key, required this.quitController});

  void _openCravingScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CravingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: quitController,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildWelcomeHeader(),
            const SizedBox(height: 16),
            TimerDisplay(elapsed: quitController.elapsedDuration),
            const SizedBox(height: 16),
            _buildStatsSection(),
            const SizedBox(height: 16),
            CrisisSectionCard(onPanicTap: () => _openCravingScreen(context)),
            const SizedBox(height: 14),
            const MentalReminderCard(),
          ],
        );
      },
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Özgürlük Takibi', style: AppTheme.headlineLarge),
        SizedBox(height: 4),
        Text(
          'Her temiz saniye yeni bir başlangıçtır.',
          style: AppTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    final money = quitController.moneySaved.toStringAsFixed(2);
    final count = quitController.unsmokedCigarettes;
    final life = quitController.lifeRegained;
    final lifeStr = '${life.inDays}G ${life.inHours % 24}S';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('KAZANIMLARIN', style: AppTheme.labelCaps),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Tasarruf',
                value: '$money ₺',
                subtitle: 'Cebinde kalan',
                icon: Icons.savings_rounded,
                accentColor: AppTheme.warningAmber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'İçilmeyen',
                value: '$count Adet',
                subtitle: 'Kurtarılan dal',
                icon: Icons.smoke_free_rounded,
                accentColor: AppTheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        StatCard(
          title: 'Kazanılan Yaşam Süresi',
          value: lifeStr,
          subtitle: 'Her sigara ≈ 11 dakika ömür kazandırır',
          icon: Icons.favorite_rounded,
          accentColor: AppTheme.secondaryCyan,
        ),
      ],
    );
  }
}
