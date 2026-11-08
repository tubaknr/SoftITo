// ========================================
// DOSYA: health_screen.dart
// NE İŞE YARAR: Sağlık kazanımları zaman
// çizelgesini görüntüler.
// NASIL ÇALIŞIR: Geçen süreye göre kazanımların
// tamamlanma ve ilerleme oranını listeler.
// SOLID: SRP - Sağlık kazanımları ekranı.
// ========================================

import 'package:flutter/material.dart';
import '../features/quit/quit_controller.dart';
import '../models/health_milestone.dart';
import '../services/quit_calculator.dart';
import '../theme/app_theme.dart';
import '../widgets/health_timeline_tile.dart';

// SRP: Sağlık kazanımları takip ekranı.
class HealthScreen extends StatelessWidget {
  final QuitController quitController;

  const HealthScreen({super.key, required this.quitController});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: quitController,
      builder: (context, _) {
        final elapsed = quitController.elapsedDuration;
        final milestones = HealthMilestone.defaultMilestones;
        final completedCount = milestones
            .where((m) => QuitCalculator.isMilestoneCompleted(elapsed, m))
            .length;

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildHeader(completedCount, milestones.length),
            const SizedBox(height: 20),
            ..._buildTimelineList(elapsed, milestones),
            const SizedBox(height: 12),
            _buildDisclaimer(),
          ],
        );
      },
    );
  }

  Widget _buildHeader(int completed, int total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Biyolojik İyileşme', style: AppTheme.headlineLarge),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.outlineActive),
              ),
              child: Text(
                '$completed / $total Tamam',
                style: AppTheme.labelCaps.copyWith(color: AppTheme.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Vücudun her geçen dakika kendini onarır.',
          style: AppTheme.bodyMedium,
        ),
      ],
    );
  }

  List<Widget> _buildTimelineList(
    Duration elapsed,
    List<HealthMilestone> milestones,
  ) {
    return List.generate(milestones.length, (index) {
      final item = milestones[index];
      final isDone = QuitCalculator.isMilestoneCompleted(elapsed, item);
      final prog = QuitCalculator.milestoneProgress(elapsed, item);

      return HealthTimelineTile(
        milestone: item,
        isCompleted: isDone,
        progress: prog,
        isFirst: index == 0,
        isLast: index == milestones.length - 1,
      );
    });
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outline),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded,
              size: 18, color: AppTheme.onSurfaceMuted),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Genel bilgilendirmedir, tıbbi tavsiye değildir.',
              style: AppTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
