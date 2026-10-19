import 'package:flutter/material.dart';
import '../state/habit_store.dart';
import '../utils/date_utils.dart';
import '../widgets/habit_check_tile.dart';
import '../widgets/progress_ring.dart';
import '../widgets/week_strip.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key, required this.store, required this.onAddHabit});

  final HabitStore store;
  final VoidCallback onAddHabit;

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  DateTime _selected = today();

  void _toggle(String habitId) {
    final error = widget.store.toggle(habitId, _selected);
    if (error != null) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    final habits = store.activeOn(_selected);
    final total = habits.length;
    final done = habits.where((h) => h.isDoneOn(_selected)).length;
    final value = total == 0 ? 0.0 : done / total;
    final isToday = sameDay(_selected, today());

    final String message;
    if (total == 0) {
      message = 'Bu gün için alışkanlık yok';
    } else if (done == total) {
      message = 'Harika! Hepsi tamam 🎉';
    } else if (done == 0) {
      message = 'Hadi başlayalım!';
    } else {
      message = '${total - done} alışkanlık kaldı';
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        Text(
          isToday ? greeting() : weekdayFull(_selected),
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(formatLongDate(_selected), style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Row(
            children: [
              ProgressRing(
                value: value,
                size: 92,
                child: Text(
                  '$done/$total',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '%${(value * 100).round()} tamamlandı',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        WeekStrip(
          store: store,
          selected: _selected,
          onSelect: (day) => setState(() => _selected = day),
        ),
        if (!isToday)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => setState(() => _selected = today()),
              icon: const Icon(Icons.undo_rounded),
              label: const Text('Bugüne dön'),
            ),
          ),
        const SizedBox(height: 12),
        if (total == 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                const Icon(Icons.checklist_rounded, size: 48, color: Colors.black26),
                const SizedBox(height: 10),
                Text(
                  store.habits.isEmpty
                      ? 'Henüz alışkanlık eklemedin'
                      : 'Bu tarihte takip edilen alışkanlık yok',
                  style: const TextStyle(color: Colors.black54),
                ),
                if (store.habits.isEmpty) ...[
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: widget.onAddHabit,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('İlk alışkanlığını ekle'),
                  ),
                ],
              ],
            ),
          )
        else
          for (final habit in habits)
            HabitCheckTile(
              habit: habit,
              done: habit.isDoneOn(_selected),
              streak: store.currentStreak(habit),
              onTap: () => _toggle(habit.id),
            ),
      ],
    );
  }
}
