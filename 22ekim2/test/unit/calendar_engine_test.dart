import 'package:flutter_test/flutter_test.dart';
import 'package:penguhabit/features/calendar/controller/calendar_controller.dart';

void main() {
  group('CalendarEngine Unit Tests', () {
    const engine = CalendarEngine();
    final today = DateTime(2026, 10, 22); // Thursday

    test('Weekly filter: produces 7 days starting on Monday', () {
      final range = engine.calculateDateRange(
        filter: CalendarFilter.weekly,
        referenceDate: today,
      );
      final days = engine.generateDays(range);

      expect(days.length, equals(7));
      expect(range.start.weekday, equals(DateTime.monday));
      expect(range.end.weekday, equals(DateTime.sunday));
    });

    test('Two weeks filter: produces 14 days starting on Monday', () {
      final range = engine.calculateDateRange(
        filter: CalendarFilter.twoWeeks,
        referenceDate: today,
      );
      final days = engine.generateDays(range);

      expect(days.length, equals(14));
      expect(range.start.weekday, equals(DateTime.monday));
    });

    test('Monthly filter: expands to fill full grid weeks (multiple of 7)', () {
      final range = engine.calculateDateRange(
        filter: CalendarFilter.monthly,
        referenceDate: today,
      );
      final days = engine.generateDays(range);

      expect(days.length % 7, equals(0));
      expect(range.start.weekday, equals(DateTime.monday));
      expect(range.end.weekday, equals(DateTime.sunday));
    });
  });
}
