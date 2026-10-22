enum CalendarFilter {
  weekly,     // 7 days
  twoWeeks,   // 14 days
  monthly,    // Current month view
  twoMonths,  // ~60 days
  threeMonths // ~90 days
}

/// Pure Dart calendar calculation helper
class CalendarEngine {
  const CalendarEngine();

  /// Computes start and end date bounds for selected filter
  DateTimeRange calculateDateRange({
    required CalendarFilter filter,
    required DateTime referenceDate,
  }) {
    final base = DateTime(referenceDate.year, referenceDate.month, referenceDate.day);

    switch (filter) {
      case CalendarFilter.weekly:
        // Current week starting on Monday
        final weekday = base.weekday;
        final start = base.subtract(Duration(days: weekday - 1));
        final end = start.add(const Duration(days: 6));
        return DateTimeRange(start: start, end: end);

      case CalendarFilter.twoWeeks:
        final weekday = base.weekday;
        final start = base.subtract(Duration(days: weekday - 1));
        final end = start.add(const Duration(days: 13));
        return DateTimeRange(start: start, end: end);

      case CalendarFilter.monthly:
        final firstDayOfMonth = DateTime(base.year, base.month, 1);
        final lastDayOfMonth = DateTime(base.year, base.month + 1, 0);
        // Expand to fill complete weeks (Monday to Sunday)
        final startOffset = firstDayOfMonth.weekday - 1;
        final start = firstDayOfMonth.subtract(Duration(days: startOffset));
        final endOffset = 7 - lastDayOfMonth.weekday;
        final end = lastDayOfMonth.add(Duration(days: endOffset));
        return DateTimeRange(start: start, end: end);

      case CalendarFilter.twoMonths:
        final start = DateTime(base.year, base.month, 1);
        final end = DateTime(base.year, base.month + 2, 0);
        return DateTimeRange(start: start, end: end);

      case CalendarFilter.threeMonths:
        final start = DateTime(base.year, base.month, 1);
        final end = DateTime(base.year, base.month + 3, 0);
        return DateTimeRange(start: start, end: end);
    }
  }

  /// Generates the list of days within the specified range
  List<DateTime> generateDays(DateTimeRange range) {
    final days = <DateTime>[];
    DateTime cursor = range.start;
    while (!cursor.isAfter(range.end)) {
      days.add(cursor);
      cursor = cursor.add(const Duration(days: 1));
    }
    return days;
  }
}

class DateTimeRange {
  const DateTimeRange({required this.start, required this.end});
  final DateTime start;
  final DateTime end;
}
