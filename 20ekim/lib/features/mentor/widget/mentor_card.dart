import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/status_chip.dart';
import '../models/mentor_model.dart';

class MentorCard extends StatelessWidget {
  const MentorCard({
    super.key,
    required this.mentor,
    required this.onEslesmeIste,
  });

  final MentorModel mentor;
  final VoidCallback onEslesmeIste;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.md,
        border: Border.all(color: colors.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with availability ring
              _MentorAvatar(
                name: mentor.ad,
                isAvailable: mentor.musait,
              ),
              const SizedBox(width: AppSpacing.md),
              // Name, title, and rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mentor.ad,
                      style: textTheme.titleLarge?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      mentor.unvan,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: 16, color: colors.dawn),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          mentor.puan.toStringAsFixed(1),
                          style: textTheme.labelMedium?.copyWith(
                            color: colors.dawn,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            ' (${mentor.degerlendirmeSayisi}) • ${mentor.deneyimYili} yıl deneyim',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Chips
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: mentor.uzmanliklar.map((u) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceHigh,
                  borderRadius: AppRadius.pill,
                  border: Border.all(color: colors.outline, width: 1),
                ),
                child: Text(
                  u,
                  style: textTheme.labelMedium?.copyWith(
                    color: colors.textPrimary,
                    fontSize: 11,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Match Action Button / Status
          _MatchActionSection(
            mentor: mentor,
            onEslesmeIste: onEslesmeIste,
          ),
        ],
      ),
    );
  }
}

class _MentorAvatar extends StatelessWidget {
  const _MentorAvatar({
    required this.name,
    required this.isAvailable,
  });

  final String name;
  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final initials = name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join();

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isAvailable ? colors.success : colors.outline,
          width: 2.5,
        ),
      ),
      padding: const EdgeInsets.all(2.5),
      child: CircleAvatar(
        backgroundColor: colors.surfaceHigh,
        child: Text(
          initials,
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _MatchActionSection extends StatelessWidget {
  const _MatchActionSection({
    required this.mentor,
    required this.onEslesmeIste,
  });

  final MentorModel mentor;
  final VoidCallback onEslesmeIste;

  @override
  Widget build(BuildContext context) {
    switch (mentor.eslesmeDurumu) {
      case EslesmeDurumu.yok:
        return PrimaryDawnButton(
          label: 'Eşleşme İste',
          icon: Icons.person_add_rounded,
          onPressed: mentor.musait ? onEslesmeIste : null,
        );
      case EslesmeDurumu.beklemede:
        return const Center(
          child: StatusChip(
            type: StatusType.beklemede,
            customLabel: 'Eşleşme Talebi Beklemede',
          ),
        );
      case EslesmeDurumu.eslesti:
        return const Center(
          child: StatusChip(
            type: StatusType.eslesti,
            customLabel: 'Eşleşme Sağlandı',
          ),
        );
      case EslesmeDurumu.gorusmePlanlandi:
        return const Center(
          child: StatusChip(
            type: StatusType.gorusmePlanlandi,
            customLabel: 'Görüşme Planlandı',
          ),
        );
    }
  }
}
