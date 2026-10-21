import '../../community/models/community_user_model.dart';
import '../../focus/models/focus_session_model.dart';

class DailyStatItem {
  final String dayName;
  final String dateStr;
  final int minutes;

  const DailyStatItem({
    required this.dayName,
    required this.dateStr,
    required this.minutes,
  });
}

class WeeklySummaryItem {
  final String weekLabel;
  final int totalMinutes;

  const WeeklySummaryItem({
    required this.weekLabel,
    required this.totalMinutes,
  });
}

/// İstatistik türetme ve analiz sınıfı (Saf Dart & Birim Test Edilebilir).
class StatsController {
  StatsController._();

  static List<DailyStatItem> computeLast7Days(
    List<FocusSessionModel> sessions, {
    String localeCode = 'tr',
    DateTime? referenceDate,
  }) {
    final now = referenceDate ?? DateTime.now();
    final result = <DailyStatItem>[];
    const trDays = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    const enDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayNames = localeCode == 'tr' ? trDays : enDays;

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final dateStr =
          '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';

      final matchingMinutes = sessions
          .where((s) => s.dayString == dateKey)
          .fold<int>(0, (sum, s) => sum + (s.durationSeconds ~/ 60));

      final dayName = dayNames[(date.weekday - 1) % 7];

      result.add(
        DailyStatItem(
          dayName: dayName,
          dateStr: dateStr,
          minutes: matchingMinutes,
        ),
      );
    }

    return result;
  }

  static List<WeeklySummaryItem> computeMonthlyWeeks(
    List<FocusSessionModel> sessions, {
    DateTime? referenceDate,
  }) {
    final now = referenceDate ?? DateTime.now();
    final result = <WeeklySummaryItem>[];

    for (int w = 3; w >= 0; w--) {
      final start = now.subtract(Duration(days: (w + 1) * 7));
      final end = now.subtract(Duration(days: w * 7));

      final matchingMinutes = sessions
          .where((s) => s.startTime.isAfter(start) && s.startTime.isBefore(end))
          .fold<int>(0, (sum, s) => sum + (s.durationSeconds ~/ 60));

      result.add(
        WeeklySummaryItem(
          weekLabel: '${4 - w}. Hafta',
          totalMinutes: matchingMinutes,
        ),
      );
    }

    return result;
  }

  /// Topluluk kullanıcısı için 7 günlük gerçekçi dağılım hesaplar.
  static List<DailyStatItem> computeUserWeeklyItems(
    CommunityUserModel user, {
    String localeCode = 'tr',
    DateTime? referenceDate,
  }) {
    final now = referenceDate ?? DateTime.now();
    const trDays = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    const enDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayNames = localeCode == 'tr' ? trDays : enDays;

    final avgDailyMinutes = (user.weeklySeconds ~/ 7) ~/ 60;
    const multipliers = [0.85, 1.15, 0.9, 1.25, 0.95, 1.2, 0.7];

    final result = <DailyStatItem>[];
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr =
          '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
      final dayName = dayNames[(date.weekday - 1) % 7];
      final minutes = (avgDailyMinutes * multipliers[6 - i]).round();

      result.add(
        DailyStatItem(
          dayName: dayName,
          dateStr: dateStr,
          minutes: minutes.clamp(5, 720),
        ),
      );
    }
    return result;
  }

  /// Topluluk kullanıcısı için 4 haftalık gerçekçi trend hesaplar.
  static List<WeeklySummaryItem> computeUserMonthlyWeeks(
    CommunityUserModel user,
  ) {
    final avgWeekMinutes = (user.yearlySeconds ~/ 52) ~/ 60;
    const multipliers = [0.85, 1.05, 0.95, 1.15];

    final result = <WeeklySummaryItem>[];
    for (int w = 0; w < 4; w++) {
      final totalMinutes = (avgWeekMinutes * multipliers[w]).round();
      result.add(
        WeeklySummaryItem(
          weekLabel: '${w + 1}. Hafta',
          totalMinutes: totalMinutes.clamp(20, 3000),
        ),
      );
    }
    return result;
  }
}
