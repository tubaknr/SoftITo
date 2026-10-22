import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../habits/controller/habits_controller.dart';
import '../../habits/models/habit.dart';
import '../controller/calendar_controller.dart';

/// Native Calendar screen with range filters and habit color indicators
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, required this.controller});

  final HabitsController controller;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarEngine _engine = const CalendarEngine();
  CalendarFilter _selectedFilter = CalendarFilter.monthly;
  late DateTime _referenceDate;

  @override
  void initState() {
    super.initState();
    _referenceDate = widget.controller.dateTimeService.today();
  }

  void _changeMonth(int delta) {
    setState(() {
      _referenceDate = DateTime(
        _referenceDate.year,
        _referenceDate.month + delta,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CalendarHeader(
          controller: widget.controller,
          referenceDate: _referenceDate,
          selectedFilter: _selectedFilter,
          onFilterChanged: (f) => setState(() => _selectedFilter = f),
          onPrevMonth: () => _changeMonth(-1),
          onNextMonth: () => _changeMonth(1),
        ),
        const SizedBox(height: 6),
        _WeekdayHeaderRow(),
        const SizedBox(height: 6),
        Expanded(
          child: _CalendarGrid(
            controller: widget.controller,
            engine: _engine,
            filter: _selectedFilter,
            referenceDate: _referenceDate,
          ),
        ),
      ],
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.controller,
    required this.referenceDate,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  final HabitsController controller;
  final DateTime referenceDate;
  final CalendarFilter selectedFilter;
  final ValueChanged<CalendarFilter> onFilterChanged;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterPills(context),
          const SizedBox(height: 8),
          _buildMonthNavBar(context),
        ],
      ),
    );
  }

  Widget _buildFilterPills(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterChip(context, CalendarFilter.weekly, context.loc.filterWeekly),
          _filterChip(context, CalendarFilter.twoWeeks, context.loc.filterTwoWeeks),
          _filterChip(context, CalendarFilter.monthly, context.loc.filterMonthly),
          _filterChip(context, CalendarFilter.twoMonths, context.loc.filterTwoMonths),
          _filterChip(context, CalendarFilter.threeMonths, context.loc.filterThreeMonths),
        ],
      ),
    );
  }

  Widget _filterChip(BuildContext context, CalendarFilter filter, String label) {
    final isSelected = selectedFilter == filter;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => onFilterChanged(filter),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? colors.primary : colors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? colors.primary : colors.borderLight,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.28),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF34D399),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : colors.textMain,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthNavBar(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context).languageCode;
    final monthTitle = DateFormat('MMMM yyyy', locale).format(referenceDate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderLight.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFD8E2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.calendar_month_rounded,
                  size: 18,
                  color: colors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    monthTitle,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: colors.textMain,
                    ),
                  ),
                  Text(
                    context.loc.monthlyTracking,
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.chevron_left_rounded, size: 22),
                onPressed: onPrevMonth,
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.chevron_right_rounded, size: 22),
                onPressed: onNextMonth,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeekdayHeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final days = [
      context.loc.dayMon,
      context.loc.dayTue,
      context.loc.dayWed,
      context.loc.dayThu,
      context.loc.dayFri,
      context.loc.daySat,
      context.loc.daySun,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((d) {
          return SizedBox(
            width: 36,
            child: Center(
              child: Text(
                d,
                style: context.typography.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: context.colors.textMuted,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.controller,
    required this.engine,
    required this.filter,
    required this.referenceDate,
  });

  final HabitsController controller;
  final CalendarEngine engine;
  final CalendarFilter filter;
  final DateTime referenceDate;

  double get _childAspectRatio {
    switch (filter) {
      case CalendarFilter.weekly:
        return 0.42;
      case CalendarFilter.twoWeeks:
        return 0.45;
      case CalendarFilter.monthly:
      case CalendarFilter.twoMonths:
      case CalendarFilter.threeMonths:
        return 0.48;
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = controller.dateTimeService.today();
    final range = engine.calculateDateRange(filter: filter, referenceDate: referenceDate);
    final days = engine.generateDays(range);

    return AnimatedBuilder(
      animation: Listenable.merge([controller.habits, controller.completions]),
      builder: (context, _) {
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 100),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: _childAspectRatio,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemCount: days.length,
          itemBuilder: (context, index) {
            final day = days[index];
            final isToday = day.year == today.year && day.month == today.month && day.day == today.day;
            final isFuture = day.isAfter(today);
            final scheduled = controller.habitsForDate(day);

            return _DayCell(
              day: day,
              isToday: isToday,
              isFuture: isFuture,
              scheduledHabits: scheduled,
              controller: controller,
              onTap: () => _onDayTapped(context, day, isFuture, scheduled),
            );
          },
        );
      },
    );
  }

  void _onDayTapped(
    BuildContext context,
    DateTime day,
    bool isFuture,
    List<Habit> scheduled,
  ) {
    if (isFuture) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.loc.cannotCompleteFuture),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }
    _showDayDetailsSheet(context, day, scheduled);
  }

  void _showDayDetailsSheet(BuildContext context, DateTime day, List<Habit> scheduled) {
    final dateStr = DateFormat('d MMMM yyyy').format(day);

    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, context.padding.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${context.loc.dayDetails} — $dateStr',
                style: context.typography.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.colors.textMain,
                ),
              ),
              const SizedBox(height: 16),
              if (scheduled.isEmpty)
                Text(
                  context.loc.noHabitsOnThisDay,
                  style: context.typography.bodyMedium?.copyWith(
                    color: context.colors.textMuted,
                  ),
                )
              else
                ...scheduled.map((h) {
                  final isDone = controller.isCompleted(h.id, day);
                  final comp = controller.getCompletion(h.id, day);
                  final c = AppColors.getHabitColor(h.colorIndex);
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: isDone ? context.colors.success : c,
                    ),
                    title: Text(
                      h.displayTitle(context.loc.isTr),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: context.colors.textMain,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: comp?.moodEntry != null
                        ? Text('${comp!.moodEntry!.mood.emoji} "${comp.moodEntry!.note}"')
                        : null,
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isToday,
    required this.isFuture,
    required this.scheduledHabits,
    required this.controller,
    required this.onTap,
  });

  final DateTime day;
  final bool isToday;
  final bool isFuture;
  final List<Habit> scheduledHabits;
  final HabitsController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final maxPills = 2;
    final shown = scheduledHabits.take(maxPills).toList();
    final overflow = scheduledHabits.length - shown.length;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isToday
              ? colors.primary.withValues(alpha: 0.12)
              : colors.bgCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isToday
                ? colors.primary
                : colors.borderLight.withValues(alpha: 0.8),
            width: isToday ? 1.8 : 1.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                '${day.day}',
                style: context.typography.bodySmall?.copyWith(
                  fontSize: 11,
                  fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                  color: isFuture
                      ? colors.textDisabled
                      : isToday
                          ? colors.primary
                          : colors.textMain,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ...shown.map((habit) {
                    final isDone = controller.isCompleted(habit.id, day);
                    return _HabitPillItem(
                      habit: habit,
                      isDone: isDone,
                    );
                  }),
                  if (overflow > 0)
                    _OverflowPill(count: overflow),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitPillItem extends StatelessWidget {
  const _HabitPillItem({
    required this.habit,
    required this.isDone,
  });

  final Habit habit;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final habitColor = AppColors.getHabitColor(habit.colorIndex);
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
      decoration: BoxDecoration(
        color: isDone ? habitColor : habitColor.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: isDone ? habitColor : habitColor.withValues(alpha: 0.5),
          width: 0.6,
        ),
      ),
      child: Text(
        '${isDone ? "✓ " : ""}${habit.displayTitle(context.loc.isTr)}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 9.5,
          height: 1.15,
          fontWeight: FontWeight.w600,
          color: isDone ? Colors.white : (context.isDark ? colors.textMain : habitColor),
          decoration: isDone ? TextDecoration.lineThrough : null,
        ),
      ),
    );
  }
}

class _OverflowPill extends StatelessWidget {
  const _OverflowPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 0.5),
      child: Text(
        '+$count',
        style: TextStyle(
          fontSize: 8.5,
          fontWeight: FontWeight.w800,
          color: context.colors.textMuted,
        ),
      ),
    );
  }
}
