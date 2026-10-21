import 'package:flutter_test/flutter_test.dart';
import 'package:focus_and_grow/features/focus/models/focus_session_model.dart';
import 'package:focus_and_grow/features/stats/controller/stats_controller.dart';

void main() {
  group('İstatistik Hesaplama Testleri', () {
    final refDate = DateTime(2026, 10, 21, 14, 0);

    test('Son 7 gün dökümü doğru gün sayısı ve dakikaları hesaplar', () {
      final sessions = [
        FocusSessionModel(
          id: '1',
          startTime: refDate,
          durationSeconds: 1800, // 30 dk
          dayString: '2026-10-21',
        ),
        FocusSessionModel(
          id: '2',
          startTime: refDate.subtract(const Duration(days: 1)),
          durationSeconds: 3600, // 60 dk
          dayString: '2026-10-20',
        ),
      ];

      final dailyList = StatsController.computeLast7Days(
        sessions,
        localeCode: 'tr',
        referenceDate: refDate,
      );

      expect(dailyList.length, equals(7));
      expect(dailyList.last.minutes, equals(30)); // 21 Ekim
      expect(dailyList[dailyList.length - 2].minutes, equals(60)); // 20 Ekim
    });

    test('Aylık 4 haftalık döküm doğru hesaplanır', () {
      final sessions = [
        FocusSessionModel(
          id: '1',
          startTime: refDate.subtract(const Duration(days: 3)),
          durationSeconds: 3600, // 60 dk (4. Hafta)
          dayString: '2026-10-18',
        ),
      ];

      final weeks = StatsController.computeMonthlyWeeks(
        sessions,
        referenceDate: refDate,
      );

      expect(weeks.length, equals(4));
      expect(weeks.last.totalMinutes, equals(60));
    });
  });
}
