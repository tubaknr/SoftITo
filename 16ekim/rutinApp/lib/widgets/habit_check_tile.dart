import 'package:flutter/material.dart';

import '../models/habit.dart';

/// "Bugün" sayfasındaki işaretlenebilir alışkanlık kartı.
class HabitCheckTile extends StatelessWidget {
  const HabitCheckTile({
    super.key,
    required this.habit,
    required this.done,
    required this.streak,
    required this.onTap,
  });

  final Habit habit;
  final bool done;
  final int streak;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tint = Color.alphaBlend(habit.color.withAlpha(32), Colors.white);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: done ? tint : Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
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
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: done ? Colors.black45 : Colors.black87,
                          decoration: done ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department_rounded,
                            size: 16,
                            color: streak > 0 ? Colors.deepOrange : Colors.black26,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            streak > 0 ? '$streak gün seri' : 'Henüz seri yok',
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done ? habit.color : Colors.transparent,
                    border: Border.all(color: done ? habit.color : Colors.black26, width: 2),
                  ),
                  child: done
                      ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
