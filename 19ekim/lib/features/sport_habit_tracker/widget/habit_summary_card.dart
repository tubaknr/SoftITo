import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class HabitSummaryCard extends StatelessWidget {
  const HabitSummaryCard({
    super.key,
    required this.completedCount,
    required this.targetCount,
    required this.consistencyRatio,
    required this.highestStreak,
  });

  final int completedCount;
  final int targetCount;
  final double consistencyRatio;
  final int highestStreak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('HAFTALIK SPOR ALIŞKANLIKLARI',
                style: theme.textTheme.labelSmall),
            const SizedBox(height: 16),
            _SummaryHeaderRow(
              completedCount: completedCount,
              targetCount: targetCount,
              highestStreak: highestStreak,
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: consistencyRatio,
                minHeight: 10,
                backgroundColor: AppColors.surfaceVariant,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.neonCyan,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryHeaderRow extends StatelessWidget {
  const _SummaryHeaderRow({
    required this.completedCount,
    required this.targetCount,
    required this.highestStreak,
  });

  final int completedCount;
  final int targetCount;
  final int highestStreak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '$completedCount / $targetCount',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.neonCyan,
                  ),
                ),
                const SizedBox(width: 6),
                Text('Antrenman', style: theme.textTheme.bodyMedium),
              ],
            ),
            Text('Haftalık Tamamlanma', style: theme.textTheme.labelSmall),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.neonCoral.withAlpha(30),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.neonCoral.withAlpha(80)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_fire_department,
                  color: AppColors.neonCoral, size: 20),
              const SizedBox(width: 4),
              Text(
                '$highestStreak Gün Seri',
                style: const TextStyle(
                  color: AppColors.neonCoral,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
