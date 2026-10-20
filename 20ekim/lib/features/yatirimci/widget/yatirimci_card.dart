import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/status_chip.dart';
import '../data/mock_yatirimci_data.dart';
import '../models/yatirimci_model.dart';

class YatirimciCard extends StatelessWidget {
  const YatirimciCard({
    super.key,
    required this.yatirimci,
    required this.onIletisimeGec,
  });

  final YatirimciModel yatirimci;
  final VoidCallback onIletisimeGec;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;
    final currency = NumberFormat.compactCurrency(locale: 'tr_TR', symbol: '₺');

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
          // Header: Name & Stage Chip
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      yatirimci.ad,
                      style: textTheme.titleLarge?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      yatirimci.sektorler.join(' • '),
                      style: textTheme.bodySmall?.copyWith(color: colors.orbit),
                    ),
                  ],
                ),
              ),
              Container(
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
                  yatirimci.asama,
                  style: textTheme.labelMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Ticket Size Range Bar (style.md Section 7.4)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bilet Büyüklüğü:',
                    style: textTheme.labelMedium?.copyWith(color: colors.textMuted),
                  ),
                  Text(
                    '${currency.format(yatirimci.minBilet)} – ${currency.format(yatirimci.maxBilet)}',
                    style: textTheme.labelLarge?.copyWith(
                      color: colors.dawn,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              _TicketRangeBar(
                minBilet: yatirimci.minBilet,
                maxBilet: yatirimci.maxBilet,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Portfolio Samples
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Portföy: ',
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.textMuted,
                ),
              ),
              Expanded(
                child: Text(
                  yatirimci.portfoy.join(', '),
                  style: textTheme.bodySmall?.copyWith(color: colors.textPrimary),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // Contact details
          Row(
            children: [
              Icon(Icons.email_outlined, size: 14, color: colors.textMuted),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  yatirimci.eposta,
                  style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.phone_outlined, size: 14, color: colors.textMuted),
              const SizedBox(width: AppSpacing.xs),
              Text(
                yatirimci.telefon,
                style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Action button
          if (yatirimci.iletisimKuruldu)
            const Center(
              child: StatusChip(
                type: StatusType.eslesti,
                customLabel: 'İletişim Talebi İletildi',
              ),
            )
          else
            PrimaryDawnButton(
              label: 'İletişime Geç',
              icon: Icons.send_rounded,
              onPressed: onIletisimeGec,
            ),
        ],
      ),
    );
  }
}

class _TicketRangeBar extends StatelessWidget {
  const _TicketRangeBar({
    required this.minBilet,
    required this.maxBilet,
  });

  final double minBilet;
  final double maxBilet;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    const totalMin = MockYatirimciData.globalMinBilet;
    const totalMax = MockYatirimciData.globalMaxBilet;

    final startRatio = ((minBilet - totalMin) / (totalMax - totalMin)).clamp(0.0, 1.0);
    final endRatio = ((maxBilet - totalMin) / (totalMax - totalMin)).clamp(0.0, 1.0);

    return Container(
      height: 8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surfaceHigh,
        borderRadius: AppRadius.pill,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final leftOffset = totalWidth * startRatio;
          final barWidth = (totalWidth * (endRatio - startRatio)).clamp(12.0, totalWidth);

          return Stack(
            children: [
              Positioned(
                left: leftOffset,
                width: barWidth,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.dawn,
                    borderRadius: AppRadius.pill,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
