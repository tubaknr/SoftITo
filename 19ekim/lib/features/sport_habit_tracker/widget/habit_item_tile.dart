import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/sport_habit.dart';

class HabitItemTile extends StatelessWidget {
  const HabitItemTile({
    super.key,
    required this.habit,
    required this.onToggleDay,
    required this.onRemove,
  });

  final SportHabit habit;
  final void Function(int dayIndex) onToggleDay;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TileTopRow(habit: habit, onRemove: onRemove),
          const SizedBox(height: 14),
          _WeekdaySelectorRow(
            completedIndices: habit.completedDayIndices,
            onToggleDay: onToggleDay,
          ),
        ],
      ),
    );
  }
}

class _TileTopRow extends StatelessWidget {
  const _TileTopRow({
    required this.habit,
    required this.onRemove,
  });

  final SportHabit habit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(habit.title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(
                'Hedef: Haftada ${habit.targetDaysPerWeek} gün (${habit.completedThisWeekCount}/${habit.targetDaysPerWeek})',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (habit.currentStreak > 0)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.neonLime.withAlpha(30),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '🔥 ${habit.currentStreak}',
                  style: const TextStyle(
                    color: AppColors.neonLime,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: AppColors.textMuted, size: 20),
              onPressed: onRemove,
            ),
          ],
        ),
      ],
    );
  }
}

class _WeekdaySelectorRow extends StatelessWidget {
  const _WeekdaySelectorRow({
    required this.completedIndices,
    required this.onToggleDay,
  });

  final Set<int> completedIndices;
  final void Function(int) onToggleDay;

  static const List<String> _dayLabels = [
    'Pzt',
    'Sal',
    'Çar',
    'Per',
    'Cum',
    'Cmt',
    'Paz'
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final isCompleted = completedIndices.contains(index);
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => onToggleDay(index),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.neonLime.withAlpha(40)
                  : AppColors.surfaceVariant,
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted ? AppColors.neonLime : AppColors.border,
                width: isCompleted ? 1.5 : 1,
              ),
            ),
            child: Center(
              child: Text(
                _dayLabels[index],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                      isCompleted ? FontWeight.bold : FontWeight.normal,
                  color: isCompleted
                      ? AppColors.neonLime
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
