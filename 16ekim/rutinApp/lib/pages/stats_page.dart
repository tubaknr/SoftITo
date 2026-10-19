import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../state/habit_store.dart';
import '../utils/date_utils.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key, required this.store});

  final HabitStore store;

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int _rangeDays = 7;

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    final habits = store.habits;

    if (habits.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.insights_rounded, size: 52, color: Colors.black26),
              SizedBox(height: 12),
              Text(
                'İstatistikler için önce alışkanlık ekle.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.checklist_rounded,
                label: 'Alışkanlık',
                value: '${habits.length}',
                color: const Color(0xFF2563EB),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.calendar_view_week_rounded,
                label: 'Bu hafta',
                value: '%${(store.weekCompletion * 100).round()}',
                color: const Color(0xFF16A34A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.local_fire_department_rounded,
                label: 'En iyi seri',
                value: '${store.bestStreakOverall} gün',
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.task_alt_rounded,
                label: 'Toplam yapılan',
                value: '${store.totalCompletions}',
                color: const Color(0xFF9333EA),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _WeekBars(values: store.lastDaysCompletion(7)),
        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Alışkanlık bazında',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 7, label: Text('7 gün')),
                ButtonSegment(value: 30, label: Text('30 gün')),
              ],
              selected: {_rangeDays},
              showSelectedIcon: false,
              onSelectionChanged: (s) => setState(() => _rangeDays = s.first),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final habit in habits) _HabitStatCard(store: store, habit: habit, rangeDays: _rangeDays),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color.alphaBlend(color.withAlpha(30), Colors.white),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

/// Son 7 günün tamamlama oranlarını çubuklarla gösterir (grafik paketi kullanılmadı).
class _WeekBars extends StatelessWidget {
  const _WeekBars({required this.values});

  final List<double> values; // en eski gün başta, bugün sonda

  static const _chartHeight = 110.0;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final soft = Color.alphaBlend(primary.withAlpha(110), Colors.white);
    final t = today();
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Son 7 gün', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < values.length; i++)
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${(values[i] * 100).round()}%',
                        style: const TextStyle(fontSize: 10, color: Colors.black54),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: _chartHeight,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            width: 22,
                            height: values[i] * _chartHeight < 6 ? 6 : values[i] * _chartHeight,
                            decoration: BoxDecoration(
                              color: i == values.length - 1 ? primary : soft,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        weekdayShort(addDays(t, -(values.length - 1 - i))),
                        style: const TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HabitStatCard extends StatelessWidget {
  const _HabitStatCard({required this.store, required this.habit, required this.rangeDays});

  final HabitStore store;
  final Habit habit;
  final int rangeDays;

  @override
  Widget build(BuildContext context) {
    final rate = store.rate(habit, rangeDays);
    final tint = Color.alphaBlend(habit.color.withAlpha(32), Colors.white);
    final week = store.doneThisWeek(habit);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: tint,
                child: Icon(habit.icon, color: habit.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  habit.name,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
              Text(
                '%${(rate * 100).round()}',
                style: TextStyle(fontWeight: FontWeight.bold, color: habit.color, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: rate,
              minHeight: 8,
              color: habit.color,
              backgroundColor: tint,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MiniInfo(
                icon: Icons.local_fire_department_rounded,
                text: 'Seri ${store.currentStreak(habit)}',
              ),
              _MiniInfo(
                icon: Icons.emoji_events_rounded,
                text: 'En iyi ${store.bestStreak(habit)}',
              ),
              _MiniInfo(
                icon: Icons.flag_rounded,
                text: 'Hafta $week/${habit.weeklyGoal}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  const _MiniInfo({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.black45),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      );
}
