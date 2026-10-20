import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/status_chip.dart';
import '../models/fikir_model.dart';

class GelirDestekKarti extends StatelessWidget {
  const GelirDestekKarti({
    super.key,
    required this.destek,
  });

  final GelirDestekDurumu destek;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;
    final currencyFormatter = NumberFormat.currency(locale: 'tr_TR', symbol: '₺', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: colors.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Gelir Destek Taahhüdü',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const Spacer(),
              StatusChip(
                type: destek.aktif ? StatusType.acik : StatusType.onaylandi,
                customLabel: destek.aktif ? 'Aktif Taahhüt' : 'Tamamlandı',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                currencyFormatter.format(destek.aylikTaahhutTutari),
                style: textTheme.headlineMedium?.copyWith(
                  color: colors.dawn,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '/ aylık güvence',
                style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Progress bar
          ClipRRect(
            borderRadius: AppRadius.pill,
            child: LinearProgressIndicator(
              value: destek.ilerlemeYuzdesi,
              minHeight: 8,
              backgroundColor: colors.surfaceHigh,
              valueColor: AlwaysStoppedAnimation<Color>(colors.dawn),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tamamlanan: ${destek.odenenAySayisi} / ${destek.toplamAySayisi} Ay',
                style: textTheme.bodySmall?.copyWith(color: colors.textPrimary),
              ),
              Text(
                destek.kalanGun > 0
                    ? 'Sonraki ödemeye ${destek.kalanGun} gün'
                    : 'Tüm ödemeler aktarıldı',
                style: textTheme.bodySmall?.copyWith(color: colors.orbit),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Son işlem tarihi: ${destek.sonOdemeTarihi}',
            style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}
