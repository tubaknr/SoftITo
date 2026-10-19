import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_item.dart';

class WorkoutList extends StatelessWidget {
  const WorkoutList({
    super.key,
    required this.workouts,
    required this.onRemove,
  });

  final List<WorkoutItem> workouts;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return const _EmptyWorkoutPlaceholder();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: workouts.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = workouts[index];
        return _WorkoutTile(item: item, onRemove: () => onRemove(item.id));
      },
    );
  }
}

class _EmptyWorkoutPlaceholder extends StatelessWidget {
  const _EmptyWorkoutPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          'Bugün henüz antrenman kaydedilmedi.',
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _WorkoutTile extends StatelessWidget {
  const _WorkoutTile({
    required this.item,
    required this.onRemove,
  });

  final WorkoutItem item;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.fitness_center,
              color: AppColors.neonLime,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  '${item.durationMinutes} dakika • ${item.caloriesBurned} kcal',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.textMuted),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
