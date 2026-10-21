import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_typography.dart';
import '../../focus/controller/focus_controller.dart';
import '../controller/stats_controller.dart';
import '../widget/monthly_chart_painter.dart';
import '../widget/weekly_chart_painter.dart';

/// İstatistikler Sayfası (Sekme 2)
class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final isDark = context.isDark;

    return ValueListenableBuilder<List<dynamic>>(
      valueListenable: FocusController.instance,
      builder: (context, sessions, _) {
        final typedSessions = FocusController.instance.value;
        final todaySeconds = FocusController.instance.todayFocusSeconds;
        final totalSeconds = FocusController.instance.totalFocusSeconds;

        final weeklyItems = StatsController.computeLast7Days(
          typedSessions,
          localeCode: loc.isTr ? 'tr' : 'en',
        );
        final monthlyItems = StatsController.computeMonthlyWeeks(typedSessions);

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Vitrin Kartı: Bugünkü Odaklanma Süresi
              _TodayFocusCard(
                todaySeconds: todaySeconds,
                loc: loc,
                isDark: isDark,
              ),
              const SizedBox(height: 24),

              // 2. Haftalık Analiz Bölümü
              _WeeklySection(
                weeklyItems: weeklyItems,
                loc: loc,
                isDark: isDark,
              ),
              const SizedBox(height: 24),

              // 3. Aylık Analiz Bölümü
              _MonthlySection(
                monthlyItems: monthlyItems,
                loc: loc,
                isDark: isDark,
              ),
              const SizedBox(height: 24),

              // 4. En Nihai Toplam Süre Kartı
              _AllTimeTotalCard(
                totalSeconds: totalSeconds,
                loc: loc,
                isDark: isDark,
              ),
              const SizedBox(height: 100), // Alt bar payı
            ],
          ),
        );
      },
    );
  }
}

class _TodayFocusCard extends StatelessWidget {
  final int todaySeconds;
  final AppLocalizations loc;
  final bool isDark;

  const _TodayFocusCard({
    required this.todaySeconds,
    required this.loc,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardSurface.withValues(alpha: 0.85)
            : Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.8),
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          Text(
            loc.todayFocusTime,
            style: AppTypography.mottoText(isDark: isDark).copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            FocusController.formatDigitalTime(todaySeconds),
            style: AppTypography.timerDisplay(isDark: isDark).copyWith(
              fontSize: 48,
              color: AppColors.dustyRoseAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklySection extends StatelessWidget {
  final List<DailyStatItem> weeklyItems;
  final AppLocalizations loc;
  final bool isDark;

  const _WeeklySection({
    required this.weeklyItems,
    required this.loc,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardSurface.withValues(alpha: 0.85)
            : Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.8),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.weeklyAnalysis,
            style: AppTypography.heading2(isDark: isDark).copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),
          // Haftalık Çubuk Grafik
          SizedBox(
            height: 160,
            width: double.infinity,
            child: CustomPaint(
              painter: WeeklyChartPainter(
                items: weeklyItems,
                isDark: isDark,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Son 7 Gün Tablosu
          ...weeklyItems.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item.dayName} (${item.dateStr})',
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                    ),
                  ),
                  Text(
                    '${item.minutes} ${loc.minutesUnit}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textCharcoal,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _MonthlySection extends StatelessWidget {
  final List<WeeklySummaryItem> monthlyItems;
  final AppLocalizations loc;
  final bool isDark;

  const _MonthlySection({
    required this.monthlyItems,
    required this.loc,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardSurface.withValues(alpha: 0.85)
            : Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.8),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.monthlyAnalysis,
            style: AppTypography.heading2(isDark: isDark).copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),
          // Aylık Trend Çizgi Grafiği
          SizedBox(
            height: 160,
            width: double.infinity,
            child: CustomPaint(
              painter: MonthlyChartPainter(
                items: monthlyItems,
                isDark: isDark,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Haftalık Döküm Tablosu
          ...monthlyItems.map((w) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    w.weekLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                    ),
                  ),
                  Text(
                    '${w.totalMinutes} ${loc.minutesUnit}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textCharcoal,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AllTimeTotalCard extends StatelessWidget {
  final int totalSeconds;
  final AppLocalizations loc;
  final bool isDark;

  const _AllTimeTotalCard({
    required this.totalSeconds,
    required this.loc,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final text = FocusController.formatNaturalDuration(
      totalSeconds,
      dayLabel: loc.daysUnit,
      hourLabel: loc.hoursUnit,
      minLabel: loc.minutesUnit,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryButtonGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30E8A598),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            loc.allTimeFocus,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
