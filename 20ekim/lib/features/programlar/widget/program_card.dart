import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/status_chip.dart';
import '../models/program_model.dart';

class ProgramCard extends StatelessWidget {
  const ProgramCard({
    super.key,
    required this.program,
    required this.onTakvimeEkle,
    required this.onBasvuruBilgisi,
  });

  final ProgramModel program;
  final VoidCallback onTakvimeEkle;
  final VoidCallback onBasvuruBilgisi;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    final Color statusStripColor;
    final StatusType chipStatus;
    final String statusLabel;

    switch (program.durum) {
      case ProgramDurumu.acik:
        statusStripColor = colors.success;
        chipStatus = StatusType.acik;
        statusLabel = 'Başvuruya Açık';
        break;
      case ProgramDurumu.yakinda:
        statusStripColor = colors.warning;
        chipStatus = StatusType.yakinda;
        statusLabel = 'Yakında Başlıyor';
        break;
      case ProgramDurumu.kapandi:
        statusStripColor = colors.danger;
        chipStatus = StatusType.kapandi;
        statusLabel = 'Dönem Kapandı';
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.md,
        border: Border.all(color: colors.outline, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left 4px Status Strip (style.md Section 7.4)
            Container(
              width: 4,
              color: statusStripColor,
            ),
            // Card Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Kurum and Status Chip
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          program.kurum,
                          style: textTheme.labelMedium?.copyWith(
                            color: colors.orbit,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        StatusChip(
                          type: chipStatus,
                          customLabel: statusLabel,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    // Program Name
                    Text(
                      program.ad,
                      style: textTheme.titleLarge?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Support Amount / Scope
                    Row(
                      children: [
                        Icon(Icons.payments_rounded, size: 16, color: colors.dawn),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            program.destekTutari,
                            style: textTheme.titleMedium?.copyWith(
                              color: colors.dawn,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Eligibility criteria
                    Text(
                      program.uygunlukSartlari,
                      style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Deadline and Remaining Days
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: colors.surfaceHigh,
                        borderRadius: AppRadius.sm,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_rounded, size: 16, color: colors.textMuted),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'Son Başvuru: ${program.sonBasvuruTarihi}',
                            style: textTheme.bodySmall?.copyWith(color: colors.textPrimary),
                          ),
                          const Spacer(),
                          if (program.kalanGun > 0)
                            Text(
                              '${program.kalanGun} gün kaldı',
                              style: textTheme.labelMedium?.copyWith(
                                color: program.kalanGun <= 15 ? colors.warning : colors.success,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          else
                            Text(
                              'Süre Doldu',
                              style: textTheme.labelMedium?.copyWith(color: colors.danger),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Actions: Takvime Ekle & Başvuru Bilgisi (Secondary buttons)
                    Row(
                      children: [
                        Expanded(
                          child: SecondaryOutlineButton(
                            label: program.takvimeEklendi ? 'Takvimde' : 'Takvime Ekle',
                            icon: program.takvimeEklendi
                                ? Icons.event_available_rounded
                                : Icons.calendar_today_rounded,
                            onPressed: onTakvimeEkle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: FilledButton(
                            onPressed: onBasvuruBilgisi,
                            style: FilledButton.styleFrom(
                              backgroundColor: colors.surfaceHigh,
                              foregroundColor: colors.textPrimary,
                              side: BorderSide(color: colors.outline, width: 1),
                            ),
                            child: const Text('Başvuru Bilgisi'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
