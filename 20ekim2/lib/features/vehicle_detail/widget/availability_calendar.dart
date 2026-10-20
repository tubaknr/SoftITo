import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';

class AvailabilityCalendar extends StatefulWidget {
  const AvailabilityCalendar({
    required this.bookedRanges,
    required this.onRangeSelected,
    this.initialRange,
    super.key,
  });

  final List<DateTimeRange> bookedRanges;
  final ValueChanged<DateTimeRange?> onRangeSelected;
  final DateTimeRange? initialRange;

  @override
  State<AvailabilityCalendar> createState() => _AvailabilityCalendarState();
}

class _AvailabilityCalendarState extends State<AvailabilityCalendar> {
  late DateTime _currentMonth;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
    _rangeStart = widget.initialRange?.start;
    _rangeEnd = widget.initialRange?.end;
  }

  bool _isBooked(DateTime day) {
    for (final DateTimeRange range in widget.bookedRanges) {
      final DateTime s = DateTime(range.start.year, range.start.month, range.start.day);
      final DateTime e = DateTime(range.end.year, range.end.month, range.end.day);
      if ((day.isAfter(s) || day.isAtSameMomentAs(s)) &&
          (day.isBefore(e) || day.isAtSameMomentAs(e))) {
        return true;
      }
    }
    return false;
  }

  bool _isPast(DateTime day) {
    final DateTime today = DateTime.now();
    final DateTime todayZero = DateTime(today.year, today.month, today.day);
    return day.isBefore(todayZero);
  }

  void _onDayTapped(DateTime day) {
    if (_isPast(day) || _isBooked(day)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.bookedDateWarning),
          backgroundColor: context.appColors.danger,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
        _rangeStart = day;
        _rangeEnd = null;
        widget.onRangeSelected(null);
      } else {
        // İkinci tıklama: Bitiş tarihi
        if (day.isBefore(_rangeStart!)) {
          _rangeStart = day;
          _rangeEnd = null;
          widget.onRangeSelected(null);
        } else if (day.isAtSameMomentAs(_rangeStart!)) {
          // Aynı güne tıklandı, 1 günlük kiralama
          _rangeEnd = day.add(const Duration(days: 1));
          _validateAndNotify();
        } else {
          _rangeEnd = day;
          _validateAndNotify();
        }
      }
    });
  }

  void _validateAndNotify() {
    if (_rangeStart != null && _rangeEnd != null) {
      // Seçilen aralık içinde dolu gün var mı kontrol et
      DateTime test = _rangeStart!;
      while (test.isBefore(_rangeEnd!) || test.isAtSameMomentAs(_rangeEnd!)) {
        if (_isBooked(test)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.bookedDateWarning),
              backgroundColor: context.appColors.danger,
            ),
          );
          _rangeEnd = null;
          widget.onRangeSelected(null);
          return;
        }
        test = test.add(const Duration(days: 1));
      }
      widget.onRangeSelected(DateTimeRange(start: _rangeStart!, end: _rangeEnd!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final int daysInMonth = DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
    final int firstWeekday = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday; // 1 = Pazartesi

    final String monthYearText =
        '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: <Widget>[
            // Ay Başlığı ve İleri/Geri Butonları
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  monthYearText,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded),
                      onPressed: () {
                        setState(() {
                          _currentMonth = DateTime(
                            _currentMonth.year,
                            _currentMonth.month - 1,
                          );
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      onPressed: () {
                        setState(() {
                          _currentMonth = DateTime(
                            _currentMonth.year,
                            _currentMonth.month + 1,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            // Hafta Günleri Başlığı (Pzt, Sal, Çar, Per, Cum, Cmt, Paz)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const <String>['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz']
                  .map((String d) => Expanded(
                        child: Center(
                          child: Text(
                            d,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.sm),
            // Günler Izgarası
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              itemCount: 42, // 6 hafta * 7 gün
              itemBuilder: (BuildContext ctx, int index) {
                final int dayOffset = index - (firstWeekday - 1);
                if (dayOffset < 0 || dayOffset >= daysInMonth) {
                  return const SizedBox.shrink();
                }

                final DateTime cellDate = DateTime(
                  _currentMonth.year,
                  _currentMonth.month,
                  dayOffset + 1,
                );

                final bool isPast = _isPast(cellDate);
                final bool isBooked = _isBooked(cellDate);
                final bool isStart = _rangeStart != null &&
                    DateUtils.isSameDay(_rangeStart!, cellDate);
                final bool isEnd = _rangeEnd != null &&
                    DateUtils.isSameDay(_rangeEnd!, cellDate);
                final bool isInRange = _rangeStart != null &&
                    _rangeEnd != null &&
                    cellDate.isAfter(_rangeStart!) &&
                    cellDate.isBefore(_rangeEnd!);

                Color? cellBg;
                Color textColor = context.colorScheme.onSurface;
                BorderRadius? borderRadius = BorderRadius.circular(AppRadius.sm);

                if (isBooked) {
                  cellBg = context.appColors.calendarBooked;
                  textColor = context.appColors.danger;
                } else if (isStart || isEnd) {
                  cellBg = context.colorScheme.primary;
                  textColor = Colors.white;
                  borderRadius = BorderRadius.circular(20);
                } else if (isInRange) {
                  cellBg = context.colorScheme.primary.withAlpha(45);
                  textColor = context.colorScheme.primary;
                  borderRadius = BorderRadius.zero;
                } else if (isPast) {
                  textColor = context.colorScheme.onSurfaceVariant.withAlpha(100);
                }

                return InkWell(
                  onTap: () => _onDayTapped(cellDate),
                  borderRadius: borderRadius,
                  child: Container(
                    decoration: BoxDecoration(
                      color: cellBg,
                      borderRadius: borderRadius,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${dayOffset + 1}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: (isStart || isEnd || isBooked)
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: textColor,
                              decoration: isBooked ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          if (isBooked)
                            Icon(
                              Icons.lock_rounded,
                              size: 10,
                              color: context.appColors.danger,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.sm),
            // Açıklama Göstergesi (Legend)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _LegendItem(
                  color: context.appColors.calendarBooked,
                  label: context.l10n.calendarLegendBooked,
                  icon: Icons.close_rounded,
                ),
                _LegendItem(
                  color: context.appColors.calendarAvailable,
                  label: context.l10n.calendarLegendAvailable,
                  icon: Icons.check_rounded,
                ),
                _LegendItem(
                  color: context.colorScheme.primary,
                  label: context.l10n.calendarLegendSelected,
                  icon: Icons.circle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const List<String> months = <String>[
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return months[month - 1];
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.icon,
  });

  final Color color;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Icon(icon, size: 10, color: Colors.black54),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
