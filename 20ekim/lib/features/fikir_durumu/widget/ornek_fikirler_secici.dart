import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/fikir_model.dart';

class OrnekFikirlerSecici extends StatelessWidget {
  const OrnekFikirlerSecici({
    super.key,
    required this.fikirler,
    required this.seciliFikirId,
    required this.onFikirSecildi,
  });

  final List<GirisimFikri> fikirler;
  final String seciliFikirId;
  final ValueChanged<GirisimFikri> onFikirSecildi;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: fikirler.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final fikir = fikirler[index];
          final isSelected = fikir.id == seciliFikirId;

          return InkWell(
            onTap: () => onFikirSecildi(fikir),
            borderRadius: AppRadius.md,
            child: Container(
              width: 170,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isSelected ? colors.surfaceHigh : colors.surface,
                borderRadius: AppRadius.md,
                border: Border.all(
                  color: isSelected ? colors.dawn : colors.outline,
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    fikir.ad,
                    style: textTheme.labelLarge?.copyWith(
                      color: isSelected ? colors.dawn : colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    fikir.sektor,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textMuted,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(Icons.gavel_rounded, size: 12, color: colors.orbit),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Adım ${fikir.hukukiAdimIndex}/6',
                        style: textTheme.labelMedium?.copyWith(
                          fontSize: 10,
                          color: colors.orbit,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
