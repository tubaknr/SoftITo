import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../state/habit_store.dart';
import '../widgets/habit_form_sheet.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key, required this.store});

  final HabitStore store;

  void _delete(BuildContext context, Habit habit) {
    store.deleteHabit(habit.id);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('"${habit.name}" silindi'),
          action: SnackBarAction(label: 'Geri al', onPressed: store.undoDelete),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final habits = store.habits;
    if (habits.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.playlist_add_rounded, size: 52, color: Colors.black26),
              SizedBox(height: 12),
              Text(
                'Henüz alışkanlık yok.\nAşağıdaki "Yeni alışkanlık" düğmesiyle başla.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
      children: [
        Text(
          '${habits.length} alışkanlık',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        const Text(
          'Düzenlemek için dokun, silmek için sola kaydır.',
          style: TextStyle(color: Colors.black45, fontSize: 12),
        ),
        const SizedBox(height: 12),
        for (final habit in habits)
          Padding(
            key: ValueKey('pad-${habit.id}'),
            padding: const EdgeInsets.only(bottom: 10),
            child: Dismissible(
              key: ValueKey(habit.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 22),
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.delete_rounded, color: Colors.white),
              ),
              onDismissed: (_) => _delete(context, habit),
              child: _HabitRow(
                habit: habit,
                streak: store.currentStreak(habit),
                onEdit: () => showHabitFormSheet(context, store, habit: habit),
                onDelete: () => _delete(context, habit),
              ),
            ),
          ),
      ],
    );
  }
}

class _HabitRow extends StatelessWidget {
  const _HabitRow({
    required this.habit,
    required this.streak,
    required this.onEdit,
    required this.onDelete,
  });

  final Habit habit;
  final int streak;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final tint = Color.alphaBlend(habit.color.withAlpha(32), Colors.white);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: tint,
                child: Icon(habit.icon, color: habit.color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Haftada ${habit.weeklyGoal} gün • $streak gün seri',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Seçenekler',
                onSelected: (value) => value == 'edit' ? onEdit() : onDelete(),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('Düzenle')),
                  PopupMenuItem(value: 'delete', child: Text('Sil')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
