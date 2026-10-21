import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/fg_top_bar.dart';
import '../../../core/widgets/flower_painter.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../focus/controller/focus_controller.dart';
import '../../profile/widget/profile_stats_card.dart';
import '../../stats/controller/stats_controller.dart';
import '../../stats/widget/monthly_chart_painter.dart';
import '../../stats/widget/weekly_chart_painter.dart';
import '../controller/community_controller.dart';
import '../models/community_user_model.dart';

/// Toplulukta Bir Kişiye Tıklanınca Açılan Salt Okunur Profil Sayfası
class PublicProfilePage extends StatelessWidget {
  final CommunityUserModel user;

  const PublicProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final isDark = context.isDark;

    final worldRank = CommunityController.instance.getUserWorldRank(user);
    final countryRank = CommunityController.instance.getUserCountryRank(user);

    final weeklyItems = StatsController.computeUserWeeklyItems(
      user,
      localeCode: loc.isTr ? 'tr' : 'en',
    );
    final monthlyItems = StatsController.computeUserMonthlyWeeks(user);

    return GradientScaffold(
      appBar: FGTopBar(
        showBackButton: true,
        userName: user.name,
        userFlowerStage: user.flowerStage,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // 1. Kullanıcı Başlık ve Avatar Alanı
              _UserHeaderSection(user: user, isDark: isDark, loc: loc),
              const SizedBox(height: 16),

              // 2. Sıralama Rozetleri (Dünya ve Ülke Sıralaması)
              _RankBadgesRow(
                worldRank: worldRank,
                countryRank: countryRank,
                country: user.country,
                loc: loc,
                isDark: isDark,
              ),
              const SizedBox(height: 16),

              // 3. Toplam Odaklanma Süresi Vurgu Kartı
              _TotalDurationCard(
                totalSeconds: user.totalFocusSeconds,
                loc: loc,
              ),
              const SizedBox(height: 20),

              // 4. Kişinin Çiçeğinin Son Durumu
              Center(
                child: FlowerView(
                  stage: user.flowerStage,
                  size: 210,
                ),
              ),
              const SizedBox(height: 24),

              // 5. Haftalık Analiz Grafiği ve Tablosu
              _UserWeeklySection(
                weeklyItems: weeklyItems,
                loc: loc,
                isDark: isDark,
              ),
              const SizedBox(height: 20),

              // 6. Aylık Trend Grafiği ve Tablosu
              _UserMonthlySection(
                monthlyItems: monthlyItems,
                loc: loc,
                isDark: isDark,
              ),
              const SizedBox(height: 20),

              // 7. Günlük, Haftalık, Yıllık Özet İstatistik Tablosu
              ProfileStatsCard(
                dailySeconds: user.dailySeconds,
                weeklySeconds: user.weeklySeconds,
                yearlySeconds: user.yearlySeconds,
                isDark: isDark,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserHeaderSection extends StatelessWidget {
  final CommunityUserModel user;
  final bool isDark;
  final AppLocalizations loc;

  const _UserHeaderSection({
    required this.user,
    required this.isDark,
    required this.loc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 86,
          height: 86,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? AppColors.darkCardSurface
                : Colors.white.withValues(alpha: 0.9),
            border: Border.all(
              color: AppColors.dustyRoseAccent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: CustomPaint(
            painter: FlowerPainter(
              stage: user.flowerStage,
              animationProgress: 0.5,
              isDark: isDark,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${user.name}, ${user.age}',
          textAlign: TextAlign.center,
          style: AppTypography.heading1Bold(isDark: isDark).copyWith(
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${user.country} • 🔥 ${user.streakDays} ${loc.streakLabel}',
          style: AppTypography.mottoText(isDark: isDark).copyWith(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _RankBadgesRow extends StatelessWidget {
  final int worldRank;
  final int countryRank;
  final String country;
  final AppLocalizations loc;
  final bool isDark;

  const _RankBadgesRow({
    required this.worldRank,
    required this.countryRank,
    required this.country,
    required this.loc,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _BadgeItem(
            icon: Icons.public_rounded,
            title: loc.worldRankTitle,
            value: loc.worldRankText(worldRank),
            isDark: isDark,
            highlightColor: const Color(0xFFFFD54F),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _BadgeItem(
            icon: Icons.flag_rounded,
            title: loc.countryRankTitle,
            value: loc.countryRankText(country, countryRank),
            isDark: isDark,
            highlightColor: AppColors.dustyRoseAccent,
          ),
        ),
      ],
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isDark;
  final Color highlightColor;

  const _BadgeItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.isDark,
    required this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardSurface.withValues(alpha: 0.85)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: highlightColor.withValues(alpha: 0.5),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: highlightColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalDurationCard extends StatelessWidget {
  final int totalSeconds;
  final AppLocalizations loc;

  const _TotalDurationCard({
    required this.totalSeconds,
    required this.loc,
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryButtonGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30E8A598),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            loc.allTimeFocus,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 19,
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

class _UserWeeklySection extends StatelessWidget {
  final List<DailyStatItem> weeklyItems;
  final AppLocalizations loc;
  final bool isDark;

  const _UserWeeklySection({
    required this.weeklyItems,
    required this.loc,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardSurface.withValues(alpha: 0.85)
            : Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(22),
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
            style: AppTypography.heading2(isDark: isDark).copyWith(fontSize: 17),
          ),
          const SizedBox(height: 14),
          // Haftalık Çubuk Grafik
          SizedBox(
            height: 150,
            width: double.infinity,
            child: CustomPaint(
              painter: WeeklyChartPainter(
                items: weeklyItems,
                isDark: isDark,
              ),
            ),
          ),
          const SizedBox(height: 14),
          // 7 Gün Döküm Tablosu
          ...weeklyItems.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item.dayName} (${item.dateStr})',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                    ),
                  ),
                  Text(
                    '${item.minutes} ${loc.minutesUnit}',
                    style: TextStyle(
                      fontSize: 12,
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

class _UserMonthlySection extends StatelessWidget {
  final List<WeeklySummaryItem> monthlyItems;
  final AppLocalizations loc;
  final bool isDark;

  const _UserMonthlySection({
    required this.monthlyItems,
    required this.loc,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardSurface.withValues(alpha: 0.85)
            : Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(22),
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
            style: AppTypography.heading2(isDark: isDark).copyWith(fontSize: 17),
          ),
          const SizedBox(height: 14),
          // Aylık Trend Çizgi Grafiği
          SizedBox(
            height: 150,
            width: double.infinity,
            child: CustomPaint(
              painter: MonthlyChartPainter(
                items: monthlyItems,
                isDark: isDark,
              ),
            ),
          ),
          const SizedBox(height: 14),
          // 4 Hafta Döküm Tablosu
          ...monthlyItems.map((w) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    w.weekLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                    ),
                  ),
                  Text(
                    '${w.totalMinutes} ${loc.minutesUnit}',
                    style: TextStyle(
                      fontSize: 12,
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
