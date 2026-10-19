import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/sport_habit_controller.dart';
import '../widget/add_habit_dialog.dart';
import '../widget/habit_item_tile.dart';
import '../widget/habit_summary_card.dart';

class SportHabitTrackerView extends StatelessWidget {
  const SportHabitTrackerView({
    super.key,
    required this.controller,
  });

  final SportHabitController controller;

  Future<void> _openAddHabitDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const AddHabitDialog(),
    );

    if (result != null) {
      controller.addHabit(
        title: result['title'] as String,
        targetDaysPerWeek: result['targetDays'] as int,
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
              HabitSummaryCard(
                completedCount: controller.totalWeeklyCompleted,
                targetCount: controller.totalWeeklyTarget,
                consistencyRatio: controller.overallConsistencyRatio,
                highestStreak: controller.highestStreak,
              ),
              const SizedBox(height: 16),
              _AddHabitActionButton(
                onTap: () => _openAddHabitDialog(context),
              ),
              const SizedBox(height: 24),
              const _HabitHeader(title: 'Spor Alışkanlıkları & Seriler'),
              const SizedBox(height: 12),
              _HabitListView(controller: controller),
            ],
          ),
        );
      },
    );
  }
}

class _AddHabitActionButton extends StatelessWidget {
  const _AddHabitActionButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surfaceVariant,
          foregroundColor: AppColors.neonCyan,
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        icon: const Icon(Icons.add_task, size: 20),
        label: const Text(
          'Yeni Spor Alışkanlığı Ekle',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _HabitHeader extends StatelessWidget {
  const _HabitHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(title, style: theme.textTheme.titleMedium);
  }
}

class _HabitListView extends StatelessWidget {
  const _HabitListView({required this.controller});

  final SportHabitController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.habits.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'Henüz spor alışkanlığı eklenmedi.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.habits.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final habit = controller.habits[index];
        return HabitItemTile(
          habit: habit,
          onToggleDay: (dayIndex) =>
              controller.toggleDayCompletion(habit.id, dayIndex),
          onRemove: () => controller.removeHabit(habit.id),
        );
      },
    );
  }
}
