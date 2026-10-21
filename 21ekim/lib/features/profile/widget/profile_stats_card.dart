import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_typography.dart';
import '../../focus/controller/focus_controller.dart';

/// Kişi profili ve kullanıcının kendi profilinde ortak kullanılan istatistikler bileşeni.
class ProfileStatsCard extends StatelessWidget {
  final int dailySeconds;
  final int weeklySeconds;
  final int yearlySeconds;
  final bool isDark;

  const ProfileStatsCard({
    super.key,
    required this.dailySeconds,
    required this.weeklySeconds,
    required this.yearlySeconds,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
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
          _StatRow(
            label: loc.dailyStats,
            durationText: FocusController.formatNaturalDuration(
              dailySeconds,
              dayLabel: loc.daysUnit,
              hourLabel: loc.hoursUnit,
              minLabel: loc.minutesUnit,
            ),
            isDark: isDark,
          ),
          const Divider(height: 18),
          _StatRow(
            label: loc.weeklyStats,
            durationText: FocusController.formatNaturalDuration(
              weeklySeconds,
              dayLabel: loc.daysUnit,
              hourLabel: loc.hoursUnit,
              minLabel: loc.minutesUnit,
            ),
            isDark: isDark,
          ),
          const Divider(height: 18),
          _StatRow(
            label: loc.yearlyStats,
            durationText: FocusController.formatNaturalDuration(
              yearlySeconds,
              dayLabel: loc.daysUnit,
              hourLabel: loc.hoursUnit,
              minLabel: loc.minutesUnit,
            ),
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String durationText;
  final bool isDark;

  const _StatRow({
    required this.label,
    required this.durationText,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.heading2(isDark: isDark).copyWith(fontSize: 15),
        ),
        Text(
          durationText,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
          ),
        ),
      ],
    );
  }
}
