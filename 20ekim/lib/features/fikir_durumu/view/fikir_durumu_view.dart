import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/status_chip.dart';
import '../controller/fikir_durumu_controller.dart';
import '../models/fikir_model.dart';
import '../widget/avukat_karti.dart';
import '../widget/gelir_destek_karti.dart';
import '../widget/hukuki_surec_timeline.dart';
import '../widget/ornek_fikirler_secici.dart';

class FikirDurumuView extends StatefulWidget {
  const FikirDurumuView({
    super.key,
    required this.controller,
  });

  final FikirDurumuController controller;

  @override
  State<FikirDurumuView> createState() => _FikirDurumuViewState();
}

class _FikirDurumuViewState extends State<FikirDurumuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fikir & Hukuki Süreç Durumu'),
      ),
      body: ValueListenableBuilder<GirisimFikri>(
        valueListenable: widget.controller.seciliFikir,
        builder: (context, fikir, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
            children: [
              // Top Hero Card
              _FikirOzetKarti(
                fikir: fikir,
                onIlerle: widget.controller.sonrakiHukukiAdimaIlerle,
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Sample Ideas Selector
              const SectionHeader(
                title: 'Örnek Girişimler',
                subtitle: 'Platform tarafından onaylanmış 6 farklı sektör girişimi',
              ),
              const SizedBox(height: AppSpacing.xs),
              ValueListenableBuilder<List<GirisimFikri>>(
                valueListenable: widget.controller.ornekFikirler,
                builder: (context, ornekler, _) {
                  return OrnekFikirlerSecici(
                    fikirler: ornekler,
                    seciliFikirId: fikir.id,
                    onFikirSecildi: widget.controller.seciliFikriAyarla,
                  );
                },
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Revenue Guarantee Card
              if (fikir.gelirDestek != null) ...[
                const SectionHeader(
                  title: 'Platform Gelir Güvencesi',
                  subtitle: 'T.C. kanunlarına uygun şirketleşme taahhüdü',
                ),
                const SizedBox(height: AppSpacing.xs),
                GelirDestekKarti(destek: fikir.gelirDestek!),
                const SizedBox(height: AppSpacing.xxl),
              ],

              // Lawyer Card
              if (fikir.avukat != null) ...[
                const SectionHeader(
                  title: 'Atanan Ücretsiz Avukat',
                  subtitle: 'Şirket kuruluşu ve marka tescili için hukuk rehberiniz',
                ),
                const SizedBox(height: AppSpacing.xs),
                AvukatKarti(avukat: fikir.avukat!),
                const SizedBox(height: AppSpacing.xxl),
              ],

              // Legal Process Timeline
              const SectionHeader(
                title: 'Hukuki Süreç Yol Haritası',
                subtitle: 'T.C. Ticaret ve Vergi Mevzuatına göre resmi adımlar',
              ),
              const SizedBox(height: AppSpacing.md),
              HukukiSurecTimeline(adimlar: fikir.hukukiAdimlar),

              const SizedBox(height: AppSpacing.giant),
            ],
          );
        },
      ),
    );
  }
}

class _FikirOzetKarti extends StatelessWidget {
  const _FikirOzetKarti({
    required this.fikir,
    required this.onIlerle,
  });

  final GirisimFikri fikir;
  final VoidCallback onIlerle;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: colors.dawn.withValues(alpha: 0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: colors.dawn.withValues(alpha: 0.08),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fikir.sektor,
                      style: textTheme.labelMedium?.copyWith(color: colors.orbit),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      fikir.ad,
                      style: textTheme.headlineSmall?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip(
                type: StatusType.onaylandi,
                customLabel: 'Onaylandı',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            fikir.ozet,
            style: textTheme.bodyMedium?.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(Icons.groups_rounded, size: 16, color: colors.textMuted),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Ekip: ${fikir.ekipSayisi} kişi',
                style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
              ),
              const Spacer(),
              Icon(Icons.verified_rounded, size: 16, color: colors.success),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Hukuki Adım ${fikir.hukukiAdimIndex}/6',
                style: textTheme.bodySmall?.copyWith(color: colors.success),
              ),
            ],
          ),
          if (fikir.hukukiAdimIndex < 6) ...[
            const SizedBox(height: AppSpacing.lg),
            PrimaryDawnButton(
              label: 'Sonraki Hukuki Aşamaya İlerle (${fikir.hukukiAdimIndex + 1}/6)',
              icon: Icons.fast_forward_rounded,
              onPressed: onIlerle,
            ),
          ],
        ],
      ),
    );
  }
}
