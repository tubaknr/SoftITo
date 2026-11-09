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
        final milestones = HealthMilestone.timelineMilestones;
        final completed = milestones
            .where((m) => QuitCalculator.isMilestoneCompleted(elapsed, m))
            .length;

        return ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          children: [
            HealthHeaderCard(
              completed: completed,
              total: milestones.length,
            ),
            const SizedBox(height: 14),
            HealthMetricCards(elapsed: elapsed),
            const SizedBox(height: 20),
            _buildTimelineHeader(),
            const SizedBox(height: 16),
            ..._buildTimelineList(elapsed, milestones),
            const SizedBox(height: 14),
            const CellularRenewalCard(),
          ],
        );
      },
    );
  }

  // Zaman çizelgesi başlığı ve aktif izleme hapı.
  Widget _buildTimelineHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Zaman Çizelgesi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: const Color(0x2610B981),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x3310B981)),
          ),
          child: const Text(
            'AKTİF İZLEME',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  // Zaman çizelgesi satırları listesini üretir.
  List<Widget> _buildTimelineList(
    Duration elapsed,
    List<HealthMilestone> milestones,
  ) {
    const labels = [
      '20 DAKİKA',
      '8 SAAT',
      '24 SAAT',
      '48 SAAT',
      '72 SAAT',
      '2 HAFTA – 3 AY',
      '1 YIL',
      '5 YIL',
    ];

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
        durationLabel: labels[index],
        elapsed: elapsed,
      );
    });
  }
}
