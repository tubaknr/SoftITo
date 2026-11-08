// ========================================
// DOSYA: timer_display.dart
// NE İŞE YARAR: Sigarasız geçen gün, saat,
// dakika ve saniyeyi canlı gösterir.
// NASIL ÇALIŞIR: Duration nesnesini parçalar
// ve tabular rakam kutuları halinde çizer.
// SOLID: SRP - Sadece sayaç görseli sunar.
// ========================================

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// SRP: Canlı kronometre gösterge widget'ı.
class TimerDisplay extends StatelessWidget {
  final Duration elapsed;

  const TimerDisplay({super.key, required this.elapsed});

  @override
  Widget build(BuildContext context) {
    final days = elapsed.inDays;
    final hours = elapsed.inHours % 24;
    final minutes = elapsed.inMinutes % 60;
    final seconds = elapsed.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.outlineActive, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: AppTheme.primaryContainer,
            blurRadius: 20,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'DUMANSIZ GEÇEN SÜRE',
            style: AppTheme.labelCaps,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildUnit(days.toString(), 'GÜN'),
              _buildDivider(),
              _buildUnit(hours.toString().padLeft(2, '0'), 'SAAT'),
              _buildDivider(),
              _buildUnit(minutes.toString().padLeft(2, '0'), 'DK'),
              _buildDivider(),
              _buildUnit(seconds.toString().padLeft(2, '0'), 'SN'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnit(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.displayCounter.copyWith(
            color: AppTheme.primaryBright,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTheme.labelCaps),
      ],
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppTheme.onSurfaceMuted,
        ),
      ),
    );
  }
}
