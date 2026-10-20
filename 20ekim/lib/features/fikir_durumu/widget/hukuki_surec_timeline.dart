import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/fikir_model.dart';

class HukukiSurecTimeline extends StatelessWidget {
  const HukukiSurecTimeline({
    super.key,
    required this.adimlar,
  });

  final List<HukukiAdim> adimlar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(adimlar.length, (index) {
        final adim = adimlar[index];
        final isLast = index == adimlar.length - 1;
        return _TimelineTile(adim: adim, isLast: isLast);
      }),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    required this.adim,
    required this.isLast,
  });

  final HukukiAdim adim;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    final Color indicatorColor;
    final IconData indicatorIcon;

    if (adim.tamamlandi) {
      indicatorColor = colors.success;
      indicatorIcon = Icons.check_circle_rounded;
    } else if (adim.aktif) {
      indicatorColor = colors.dawn;
      indicatorIcon = Icons.radio_button_checked_rounded;
    } else {
      indicatorColor = colors.outline;
      indicatorIcon = Icons.radio_button_unchecked_rounded;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicator & vertical line
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: indicatorColor.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                  border: Border.all(color: indicatorColor, width: 1.5),
                ),
                child: Icon(indicatorIcon, size: 16, color: indicatorColor),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: adim.tamamlandi ? colors.success : colors.outline,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: adim.aktif ? colors.surfaceHigh : colors.surface,
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: adim.aktif ? colors.dawn : colors.outline,
                    width: adim.aktif ? 1.5 : 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Adım ${adim.sira}',
                          style: textTheme.labelMedium?.copyWith(
                            color: adim.aktif ? colors.dawn : colors.textMuted,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        if (adim.tamamlanmaTarihi != null)
                          Text(
                            adim.tamamlanmaTarihi!,
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.textMuted,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      adim.baslik,
                      style: textTheme.titleMedium?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      adim.aciklama,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
