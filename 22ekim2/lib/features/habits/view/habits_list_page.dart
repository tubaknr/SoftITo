import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../controller/habits_controller.dart';
import '../models/habit.dart';
import '../widget/habit_form_sheet.dart';

/// Screen listing all defined habits with Edit & Delete actions
class HabitsListPage extends StatelessWidget {
  const HabitsListPage({super.key, required this.controller});

  final HabitsController controller;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: Text(
          context.loc.allHabits,
          style: context.typography.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colors.textMain,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: context.colors.textMain),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: context.colors.primary, size: 28),
            onPressed: () {
              HabitFormSheet.show(
                context,
                onSave: (newHabit) => controller.saveHabit(newHabit),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<List<Habit>>(
        valueListenable: controller.habits,
        builder: (context, habitList, _) {
          if (habitList.isEmpty) {
            return Center(
              child: Text(
                context.loc.emptyHabitsTitle,
                style: context.typography.bodyLarge?.copyWith(
                  color: context.colors.textMuted,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            itemCount: habitList.length,
            itemBuilder: (context, index) {
              final habit = habitList[index];
              return _HabitListItem(
                habit: habit,
                onEdit: () {
                  HabitFormSheet.show(
                    context,
                    existingHabit: habit,
                    onSave: (updated) => controller.saveHabit(updated),
                  );
                },
                onDelete: () => _confirmDelete(context, habit),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Habit habit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          context.loc.deleteAction,
          style: context.typography.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        content: Text(
          context.loc.confirmDeleteHabit,
          style: context.typography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(context.loc.cancelAction),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              context.loc.deleteAction,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await controller.deleteHabit(habit.id);
    }
  }
}

class _HabitListItem extends StatelessWidget {
  const _HabitListItem({
    required this.habit,
    required this.onEdit,
    required this.onDelete,
  });

  final Habit habit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final habitColor = AppColors.getHabitColor(habit.colorIndex);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(color: habitColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.title,
                  style: context.typography.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.textMain,
                  ),
                ),
                if (habit.description.isNotEmpty)
                  Text(
                    habit.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typography.bodySmall?.copyWith(
                      color: colors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit_outlined, color: colors.primary, size: 20),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
