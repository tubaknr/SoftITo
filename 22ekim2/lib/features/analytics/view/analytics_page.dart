import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../habits/controller/habits_controller.dart';
import '../../habits/models/habit.dart';
import '../../reflection/models/mood_entry.dart';
import '../controller/analytics_controller.dart';
import '../widget/completion_rate_painter.dart';
import '../widget/continuity_chart_painter.dart';
import '../widget/mood_distribution_painter.dart';

/// Analytics & Progress screen adhering to `SKILL.md` Section 3.5 & `style.md` Section 5.7
class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key, required this.controller});

  final HabitsController controller;

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final AnalyticsEngine _engine = const AnalyticsEngine();
  AnalyticsTimeRange _selectedRange = AnalyticsTimeRange.thirtyDays;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.controller.habits, widget.controller.completions]),
      builder: (context, _) {
        final habits = widget.controller.habits.value;
        final completions = widget.controller.completions.value;
        final today = widget.controller.dateTimeService.today();

        final overallRate = _engine.calculateOverallContinuity(
          habits: habits,
          completions: completions,
          referenceDate: today,
          days: _selectedRange.days,
        );

        final timelinePoints = _engine.calculateContinuityTimeline(
          habits: habits,
          completions: completions,
          referenceDate: today,
          days: _selectedRange == AnalyticsTimeRange.sevenDays ? 7 : 14,
        );

        final moodDist = _engine.calculateMoodDistribution(completions);

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(context),
              const SizedBox(height: 12),
              _buildRangeFilterPills(context),
              const SizedBox(height: 20),
              _buildOverallGaugeCard(context, overallRate),
              const SizedBox(height: 20),
              _buildTimelineCard(context, timelinePoints),
              const SizedBox(height: 20),
              _buildHabitsBreakdownCard(context, habits, completions, today),
              const SizedBox(height: 20),
              _buildMoodDistributionCard(context, moodDist),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      context.loc.analyticsTitle,
      style: context.typography.headlineLarge?.copyWith(
        fontWeight: FontWeight.w800,
        color: context.colors.textMain,
      ),
    );
  }

  Widget _buildRangeFilterPills(BuildContext context) {
    final colors = context.colors;
    final items = [
      (AnalyticsTimeRange.sevenDays, context.loc.range7Days),
      (AnalyticsTimeRange.thirtyDays, context.loc.range30Days),
      (AnalyticsTimeRange.ninetyDays, context.loc.range90Days),
      (AnalyticsTimeRange.all, context.loc.rangeAll),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((it) {
          final isSelected = _selectedRange == it.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(it.$2),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedRange = it.$1),
              selectedColor: colors.primary,
              backgroundColor: colors.bgCard,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : colors.textMain,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12,
                decoration: TextDecoration.none,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: isSelected ? colors.primary : colors.borderLight),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOverallGaugeCard(BuildContext context, double rate) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.borderLight.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            context.loc.overallContinuity,
            style: context.typography.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.textMain,
            ),
          ),
          const SizedBox(height: 16),
          _buildGaugeWidget(context, rate, colors),
          const SizedBox(height: 16),
          _buildGaugeEncouragementBanner(context, colors),
        ],
      ),
    );
  }

  Widget _buildGaugeWidget(BuildContext context, double rate, dynamic colors) {
    return SizedBox(
      width: 140,
      height: 140,
      child: CustomPaint(
        painter: CompletionRatePainter(
          percentage: rate,
          primaryColor: colors.primary,
          trackColor: colors.bgCardSubtle,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.loc.isTr
                    ? '%${rate.toStringAsFixed(0)}'
                    : '${rate.toStringAsFixed(0)}%',
                style: context.typography.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colors.textMain,
                  fontSize: 28,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up_rounded, size: 11, color: Color(0xFF006947)),
                    SizedBox(width: 2),
                    Text(
                      '+8.4%',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF006947),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGaugeEncouragementBanner(BuildContext context, dynamic colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: colors.bgCardSubtle,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text('🐧', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 11.5, color: colors.textMuted),
                children: [
                  TextSpan(
                    text: context.loc.greatConsistency,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                    ),
                  ),
                  TextSpan(text: context.loc.consistencySub),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(BuildContext context, List<double> points) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.continuityChartTitle,
            style: context.typography.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.textMain,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 90,
            child: CustomPaint(
              painter: ContinuityChartPainter(
                values: points,
                barGradient: colors.btnPrimaryGradient,
                gridColor: colors.borderLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitsBreakdownCard(
    BuildContext context,
    List<Habit> habits,
    dynamic completions,
    DateTime today,
  ) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.habitPerformance,
            style: context.typography.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.textMain,
            ),
          ),
          const SizedBox(height: 14),
          if (habits.isEmpty)
            Text(
              context.loc.noAnalyticsData,
              style: context.typography.bodySmall?.copyWith(color: colors.textMuted),
            )
          else
            ...habits.map((h) {
              final rate = _engine.calculateHabitRate(
                habit: h,
                completions: completions,
                referenceDate: today,
                days: _selectedRange.days,
              );
              final habitColor = AppColors.getHabitColor(h.colorIndex);
              final emoji = _detectHabitEmoji(h.title);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: habitColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(emoji, style: const TextStyle(fontSize: 14)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              h.displayTitle(context.loc.isTr),
                              style: context.typography.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          context.loc.isTr
                              ? '%${rate.toStringAsFixed(0)}'
                              : '${rate.toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: colors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colors.bgCardSubtle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: LayoutBuilder(
                        builder: (ctx, constraints) {
                          final w = constraints.maxWidth * (rate / 100.0).clamp(0.0, 1.0);
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: w,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF93C5FD),
                                    colors.primary,
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
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

  String _detectHabitEmoji(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('su') || lower.contains('water')) return '💧';
    if (lower.contains('kitap') || lower.contains('oku') || lower.contains('book')) return '📖';
    if (lower.contains('yürü') || lower.contains('koş') || lower.contains('spor') || lower.contains('walk')) return '🏃';
    if (lower.contains('meditasyon') || lower.contains('yoga')) return '🧘';
    if (lower.contains('yaz') || lower.contains('günlük')) return '✍️';
    if (lower.contains('kod') || lower.contains('yazılım')) return '💻';
    return '🌱';
  }

  Widget _buildMoodDistributionCard(BuildContext context, Map<Mood, int> dist) {
    final colors = context.colors;
    final total = dist.values.fold(0, (s, c) => s + c);

    final moodColors = {
      Mood.awesome: const Color(0xFF10B981),
      Mood.happy: const Color(0xFF3B82F6),
      Mood.calm: const Color(0xFF06B6D4),
      Mood.tired: const Color(0xFFF59E0B),
      Mood.challenging: const Color(0xFFEF4444),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.moodDistributionTitle,
            style: context.typography.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.textMain,
            ),
          ),
          const SizedBox(height: 14),
          if (total == 0)
            Text(
              context.loc.noAnalyticsData,
              style: context.typography.bodySmall?.copyWith(color: colors.textMuted),
            )
          else ...[
            SizedBox(
              width: double.infinity,
              height: 14,
              child: CustomPaint(
                painter: MoodDistributionPainter(
                  distribution: dist,
                  moodColors: moodColors,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: Mood.values.map((m) {
                final count = dist[m] ?? 0;
                return Column(
                  children: [
                    Text(m.emoji, style: const TextStyle(fontSize: 20)),
                    Text(
                      '$count',
                      style: context.typography.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
