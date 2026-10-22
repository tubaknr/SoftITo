import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/penguin_mascot_painter.dart';

/// Bento-style Hero Motivational Banner matching Stitch 3._anasayfa_ve_al_kanl_k_takibi
class HeroMotivationalBanner extends StatelessWidget {
  const HeroMotivationalBanner({
    super.key,
    required this.completedCount,
    required this.totalCount,
    required this.activeStreak,
  });

  final int completedCount;
  final int totalCount;
  final int activeStreak;

  double get progressRatio =>
      totalCount > 0 ? (completedCount / totalCount).clamp(0.0, 1.0) : 0.0;

  int get percentage => (progressRatio * 100).round();

  int get remainingCount => (totalCount - completedCount).clamp(0, totalCount);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: colors.borderLight.withValues(alpha: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopRow(context),
          const SizedBox(height: 16),
          _buildProgressMeter(context),
        ],
      ),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    final colors = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMotivationPill(context, colors),
              const SizedBox(height: 6),
              Text(
                context.loc.todayGreatDay,
                style: context.typography.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: colors.textMain,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                context.loc.todaySubQuote,
                style: context.typography.bodySmall?.copyWith(
                  color: colors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _buildMascotBadge(colors),
      ],
    );
  }

  Widget _buildMotivationPill(BuildContext context, dynamic colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
      decoration: BoxDecoration(
        color: const Color(0xFFD1FAE5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.spa_rounded, size: 13, color: Color(0xFF006947)),
          const SizedBox(width: 4),
          Text(
            context.loc.dailyMotivation,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF006947),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMascotBadge(dynamic colors) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 54,
          height: 54,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF93C5FD), Color(0xFFD8E2FF)],
            ),
          ),
          child: const PenguinMascotWidget(
            pose: PenguinPose.celebrating,
            size: 46,
          ),
        ),
        const Positioned(
          top: -3,
          right: -3,
          child: Text('🌱', style: TextStyle(fontSize: 13)),
        ),
      ],
    );
  }

  Widget _buildProgressMeter(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colors.borderLight.withValues(alpha: 0.6),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.task_alt_rounded,
                    size: 16,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    context.loc.dailyProgress,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: colors.textMain,
                    ),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  text: '$completedCount/$totalCount ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: colors.primary,
                  ),
                  children: [
                    TextSpan(
                      text: context.loc.isTr
                          ? '(%$percentage)'
                          : '($percentage%)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildProgressBarTrack(colors),
          const SizedBox(height: 8),
          _buildProgressFooter(context, colors),
        ],
      ),
    );
  }

  Widget _buildProgressBarTrack(dynamic colors) {
    return Container(
      width: double.infinity,
      height: 10,
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        color: colors.bgCardSubtle,
        borderRadius: BorderRadius.circular(10),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barWidth = constraints.maxWidth * progressRatio;
          return Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              width: barWidth,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  colors: [
                    AppColors.lightPrimary,
                    Color(0xFF2170E4),
                    Color(0xFF34D399),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressFooter(BuildContext context, dynamic colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          remainingCount > 0
              ? context.loc.habitsRemaining(remainingCount)
              : context.loc.allStepsCompletedToday,
          style: TextStyle(
            fontSize: 11,
            color: colors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (activeStreak > 0)
          Text(
            context.loc.activeStreakDays(activeStreak),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFFFB923C),
            ),
          ),
      ],
    );
  }
}
