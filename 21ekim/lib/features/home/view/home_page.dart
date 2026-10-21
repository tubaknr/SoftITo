import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/fg_buttons.dart';
import '../../../core/widgets/flower_painter.dart';
import '../../focus/controller/focus_controller.dart';
import '../../focus/view/focus_session_page.dart';

/// Ana Sayfa (Sekme 1)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String _getStageName(FlowerStage stage, AppLocalizations loc) {
    switch (stage) {
      case FlowerStage.seed:
        return loc.stageSeed;
      case FlowerStage.sprout:
        return loc.stageSprout;
      case FlowerStage.sapling:
        return loc.stageSapling;
      case FlowerStage.leafyStem:
        return loc.stageLeafyStem;
      case FlowerStage.bud:
        return loc.stageBud;
      case FlowerStage.blooming:
        return loc.stageBlooming;
      case FlowerStage.mature:
        return loc.stageMature;
      case FlowerStage.wilted:
        return loc.stageWilted;
      case FlowerStage.dead:
        return loc.stageDead;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final isDark = context.isDark;

    return ValueListenableBuilder<List<dynamic>>(
      valueListenable: FocusController.instance,
      builder: (context, _, __) {
        final stage = FocusController.instance.currentFlowerStage;
        final totalSeconds = FocusController.instance.totalFocusSeconds;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Canlı Çiçek Vitrini
              Center(
                child: FlowerView(
                  stage: stage,
                  size: 240,
                ),
              ),
              const SizedBox(height: 16),

              // Evre Rozeti
              _FlowerStageBadge(
                stageName: _getStageName(stage, loc),
                isWilted: stage == FlowerStage.wilted || stage == FlowerStage.dead,
                isDark: isDark,
              ),
              const SizedBox(height: 12),

              // Toplam Odak Süresi Kartı
              _TotalFocusCard(
                totalSeconds: totalSeconds,
                loc: loc,
                isDark: isDark,
              ),
              const SizedBox(height: 32),

              // Nefes Alan Dairesel Odaklanma Butonu
              PulsingFocusButton(
                label: loc.startFocus,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const FocusSessionPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 100), // Alt menü için boşluk
            ],
          ),
        );
      },
    );
  }
}

class _FlowerStageBadge extends StatelessWidget {
  final String stageName;
  final bool isWilted;
  final bool isDark;

  const _FlowerStageBadge({
    required this.stageName,
    required this.isWilted,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: isWilted
            ? AppColors.coralRedError.withValues(alpha: 0.15)
            : (isDark
                ? AppColors.darkCardSurface
                : Colors.white.withValues(alpha: 0.8)),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isWilted
              ? AppColors.coralRedError
              : AppColors.dustyRoseAccent.withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      child: Text(
        stageName,
        style: AppTypography.heading2(isDark: isDark).copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: isWilted
              ? AppColors.coralRedError
              : (isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal),
        ),
      ),
    );
  }
}

class _TotalFocusCard extends StatelessWidget {
  final int totalSeconds;
  final AppLocalizations loc;
  final bool isDark;

  const _TotalFocusCard({
    required this.totalSeconds,
    required this.loc,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = FocusController.formatNaturalDuration(
      totalSeconds,
      dayLabel: loc.daysUnit,
      hourLabel: loc.hoursUnit,
      minLabel: loc.minutesUnit,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardSurface.withValues(alpha: 0.6)
            : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.access_time_filled_rounded,
            color: AppColors.dustyRoseAccent,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            '${loc.totalFocusLabel}: $formattedTime',
            style: AppTypography.mottoText(isDark: isDark).copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
