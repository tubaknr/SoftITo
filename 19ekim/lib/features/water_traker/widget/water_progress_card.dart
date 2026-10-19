import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WaterProgressCard extends StatelessWidget {
  const WaterProgressCard({
    super.key,
    required this.currentMl,
    required this.baseGoalMl,
    required this.workoutBonusMl,
    required this.totalGoalMl,
    required this.progress,
    required this.progressPercentage,
    required this.remainingMl,
    required this.isGoalReached,
  });

  final int currentMl;
  final int baseGoalMl;
  final int workoutBonusMl;
  final int totalGoalMl;
  final double progress;
  final int progressPercentage;
  final int remainingMl;
  final bool isGoalReached;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('GÜNLÜK HİDRASYON DURUMU', style: theme.textTheme.labelSmall),
            const SizedBox(height: 16),
            _ProgressIndicatorSection(
              progress: progress,
              currentMl: currentMl,
              percentage: progressPercentage,
            ),
            const SizedBox(height: 16),
            _GoalStatusBanner(
              isGoalReached: isGoalReached,
              remainingMl: remainingMl,
              percentage: progressPercentage,
            ),
            const SizedBox(height: 16),
            _GoalBreakdownRow(
              baseGoalMl: baseGoalMl,
              workoutBonusMl: workoutBonusMl,
              totalGoalMl: totalGoalMl,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressIndicatorSection extends StatelessWidget {
  const _ProgressIndicatorSection({
    required this.progress,
    required this.currentMl,
    required this.percentage,
  });

  final double progress;
  final int currentMl;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 150,
      width: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 12,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.neonCyan,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$currentMl',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.neonCyan,
                ),
              ),
              Text('ml içildi', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 2),
              Text(
                '%$percentage ulaşıldı',
                style: const TextStyle(
                  color: AppColors.neonLime,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalStatusBanner extends StatelessWidget {
  const _GoalStatusBanner({
    required this.isGoalReached,
    required this.remainingMl,
    required this.percentage,
  });

  final bool isGoalReached;
  final int remainingMl;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    if (isGoalReached) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.neonLime.withAlpha(30),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.neonLime.withAlpha(80)),
        ),
        child: const Center(
          child: Text(
            '🎉 Tebrikler! Günlük su hedefinize ulaştınız.',
            style: TextStyle(
              color: AppColors.neonLime,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Text(
          'Hedefe %$percentage ulaşıldı • Kalan: $remainingMl ml',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _GoalBreakdownRow extends StatelessWidget {
  const _GoalBreakdownRow({
    required this.baseGoalMl,
    required this.workoutBonusMl,
    required this.totalGoalMl,
  });

  final int baseGoalMl;
  final int workoutBonusMl;
  final int totalGoalMl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatColumn(
            label: 'Temel Hedef',
            value: '$baseGoalMl ml',
            theme: theme,
          ),
          _StatColumn(
            label: 'Antrenman Ek',
            value: '+$workoutBonusMl ml',
            theme: theme,
            valueColor: AppColors.neonCoral,
          ),
          _StatColumn(
            label: 'Gereken Toplam',
            value: '$totalGoalMl ml',
            theme: theme,
            valueColor: AppColors.neonCyan,
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.label,
    required this.value,
    required this.theme,
    this.valueColor,
  });

  final String label;
  final String value;
  final ThemeData theme;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: theme.textTheme.labelSmall),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
