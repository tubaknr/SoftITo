import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/workout_controller.dart';
import '../widget/add_workout_dialog.dart';
import '../widget/workout_list.dart';
import '../widget/workout_summary_card.dart';

class WorkoutView extends StatelessWidget {
  const WorkoutView({
    super.key,
    required this.controller,
  });

  final WorkoutController controller;

  Future<void> _openAddWorkoutDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const AddWorkoutDialog(),
    );

    if (result != null) {
      controller.addWorkout(
        title: result['title'] as String,
        durationMinutes: result['duration'] as int,
        caloriesBurned: result['calories'] as int,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WorkoutSummaryCard(
                caloriesBurned: controller.totalCaloriesBurned,
                calorieGoal: controller.dailyCalorieGoal,
                totalMinutes: controller.totalDurationMinutes,
                progress: controller.calorieProgressRatio,
              ),
              const SizedBox(height: 16),
              _AddWorkoutActionButton(
                onTap: () => _openAddWorkoutDialog(context),
              ),
              const SizedBox(height: 24),
              const _WorkoutHeader(title: 'Bugünkü Egzersizler'),
              const SizedBox(height: 12),
              WorkoutList(
                workouts: controller.workouts,
                onRemove: controller.removeWorkout,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddWorkoutActionButton extends StatelessWidget {
  const _AddWorkoutActionButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surfaceVariant,
          foregroundColor: AppColors.neonLime,
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        icon: const Icon(Icons.add_circle_outline, size: 20),
        label: const Text(
          'Yeni Egzersiz Ekle',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _WorkoutHeader extends StatelessWidget {
  const _WorkoutHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(title, style: theme.textTheme.titleMedium);
  }
}
