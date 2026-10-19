import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WorkoutSummaryCard extends StatelessWidget {
  const WorkoutSummaryCard({
    super.key,
    required this.caloriesBurned,
    required this.calorieGoal,
    required this.totalMinutes,
    required this.progress,
  });

  final int caloriesBurned;
  final int calorieGoal;
  final int totalMinutes;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('GÜNLÜK KALORİ & EGZERSİZ', style: theme.textTheme.labelSmall),
            const SizedBox(height: 16),
            _CalorieHeroStats(caloriesBurned: caloriesBurned, goal: calorieGoal),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: AppColors.surfaceVariant,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.neonCoral,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _QuickMetaRow(totalMinutes: totalMinutes, goal: calorieGoal),
          ],
        ),
      ),
    );
  }
}

class _CalorieHeroStats extends StatelessWidget {
  const _CalorieHeroStats({
    required this.caloriesBurned,
    required this.goal,
  });

  final int caloriesBurned;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '$caloriesBurned',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: AppColors.neonCoral,
              ),
            ),
            const SizedBox(width: 4),
            Text('kcal', style: theme.textTheme.bodyMedium),
          ],
        ),
        Text('Hedef: $goal kcal', style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _QuickMetaRow extends StatelessWidget {
  const _QuickMetaRow({
    required this.totalMinutes,
    required this.goal,
  });

  final int totalMinutes;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        const Icon(Icons.timer_outlined, size: 18, color: AppColors.neonLime),
        const SizedBox(width: 6),
        Text(
          'Toplam Süre: $totalMinutes dk',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
