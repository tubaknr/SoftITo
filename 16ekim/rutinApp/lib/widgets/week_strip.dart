import 'package:flutter/material.dart';

import '../state/habit_store.dart';
import '../utils/date_utils.dart';

/// Son 7 günü gösteren, gün seçtiren şerit. Tüm alışkanlıkları tamamlanan günün altında nokta çıkar.
class WeekStrip extends StatelessWidget {
  const WeekStrip({
    super.key,
    required this.store,
    required this.selected,
    required this.onSelect,
  });

  final HabitStore store;
  final DateTime selected;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final t = today();
    final days = [for (var i = 6; i >= 0; i--) addDays(t, -i)];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          for (final d in days)
            Expanded(
              child: _DayCell(
                day: d,
                isSelected: sameDay(d, selected),
                isToday: sameDay(d, t),
                allDone: store.totalOn(d) > 0 && store.doneCountOn(d) == store.totalOn(d),
                onTap: () => onSelect(d),
              ),
            ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.allDone,
    required this.onTap,
  });

  final DateTime day;
  final bool isSelected;
  final bool isToday;
  final bool allDone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          children: [
            Text(
              weekdayShort(day),
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? primary : Colors.transparent,
                border: isToday && !isSelected ? Border.all(color: primary, width: 1.5) : null,
              ),
              child: Text(
                '${day.day}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: allDone ? Colors.green.shade600 : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
