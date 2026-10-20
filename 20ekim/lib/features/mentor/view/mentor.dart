import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/section_header.dart';
import '../../analiz/view/analiz_view.dart';
import '../../fikir_durumu/controller/fikir_durumu_controller.dart';
import '../../fikir_durumu/models/fikir_model.dart';
import '../../fikir_durumu/view/fikir_durumu_view.dart';
import '../../shell/widget/idea_status_badge.dart';
import '../controller/mentor_controller.dart';
import '../data/mock_mentor_data.dart';
import '../models/mentor_model.dart';
import '../widget/mentor_card.dart';

class MentorView extends StatefulWidget {
  const MentorView({
    super.key,
    required this.mentorController,
    required this.fikirController,
  });

  final MentorController mentorController;
  final FikirDurumuController fikirController;

  @override
  State<MentorView> createState() => _MentorViewState();
}

class _MentorViewState extends State<MentorView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFikirDurumu() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FikirDurumuView(controller: widget.fikirController),
      ),
    );
  }

  void _openAnalizFormu() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AnalizView(
          onAnalizGonderildi: (gonderilenFikir) {
            widget.fikirController.seciliFikriAyarla(gonderilenFikir);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: colors.dawnGradient,
              ),
              child: Icon(Icons.rocket_launch_rounded, size: 18, color: colors.onDawn),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Yörünge',
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          // Theme Switcher
          IconButton(
            icon: Icon(
              context.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: colors.textPrimary,
            ),
            tooltip: context.isDark ? 'Gündüz Teması' : 'Gece Teması',
            onPressed: () => ThemeController.instance.toggleTheme(),
          ),
          // Idea Status Badge (akılda kalan özel rozet)
          ValueListenableBuilder<GirisimFikri>(
            valueListenable: widget.fikirController.seciliFikir,
            builder: (context, fikir, _) {
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.md),
                child: IdeaStatusBadge(
                  statusText: fikir.asama == BasvuruAsamasi.onaylandi ? 'Onaylandı' : 'İnceleniyor',
                  progress: fikir.ilerlemeYuzdesi,
                  onTap: _openFikirDurumu,
                ),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Business plan banner / CTA
                  _AnalizCtaBanner(onAnalizBaslat: _openAnalizFormu),

                  const SizedBox(height: AppSpacing.xxl),

                  // Search Field
                  TextField(
                    controller: _searchController,
                    onChanged: widget.mentorController.aramaDegisti,
                    decoration: InputDecoration(
                      hintText: 'Mentor, uzmanlık veya sektör ara...',
                      prefixIcon: Icon(Icons.search_rounded, color: colors.textMuted),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () {
                                _searchController.clear();
                                widget.mentorController.aramaDegisti('');
                              },
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Sector Filter Chips
                  _SectorChips(controller: widget.mentorController),

                  const SizedBox(height: AppSpacing.xl),

                  // Recommended Mentors
                  const SectionHeader(
                    title: 'Önerilen Mentorlar',
                    subtitle: 'Girişiminizin aşamasına ve sektörüne özel eşleşmeler',
                  ),
                ],
              ),
            ),
          ),

          // Recommended Mentors Horizontal List
          SliverToBoxAdapter(
            child: _RecommendedMentorsList(
              controller: widget.mentorController,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xxl,
                AppSpacing.xl,
                AppSpacing.sm,
              ),
              child: const SectionHeader(
                title: 'Tüm Mentorlar',
                subtitle: 'Görüşme talebi gönderebileceğiniz doğrulanmış mentorlar',
              ),
            ),
          ),

          // Mentors List
          ValueListenableBuilder<List<MentorModel>>(
            valueListenable: widget.mentorController.filtreliMentorlar,
            builder: (context, mentorlar, _) {
              if (mentorlar.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Center(
                      child: Text(
                        'Arama kriterlerine uygun mentor bulunamadı.',
                        style: textTheme.bodyMedium?.copyWith(color: colors.textMuted),
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final mentor = mentorlar[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                        child: MentorCard(
                          mentor: mentor,
                          onEslesmeIste: () => widget.mentorController.eslesmeIste(mentor.id),
                        ),
                      );
                    },
                    childCount: mentorlar.length,
                  ),
                ),
              );
            },
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.giant),
          ),
        ],
      ),
    );
  }
}

class _AnalizCtaBanner extends StatelessWidget {
  const _AnalizCtaBanner({required this.onAnalizBaslat});

  final VoidCallback onAnalizBaslat;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: colors.dawn.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.dawn.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.assignment_turned_in_rounded, color: colors.dawn, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'İş Planını Değerlendir',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '8 adımlı analizi tamamla, onaylanırsa ücretsiz avukat & gelir desteği kazan!',
                  style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          FilledButton(
            onPressed: onAnalizBaslat,
            style: FilledButton.styleFrom(
              minimumSize: const Size(80, 40),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            ),
            child: const Text('Başlat'),
          ),
        ],
      ),
    );
  }
}

class _SectorChips extends StatelessWidget {
  const _SectorChips({required this.controller});

  final MentorController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return ValueListenableBuilder<String>(
      valueListenable: controller.seciliSektor,
      builder: (context, secili, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: MockMentorData.sektorler.map((sektor) {
              final isSelected = sektor == secili;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: FilterChip(
                  label: Text(sektor),
                  selected: isSelected,
                  onSelected: (_) => controller.sektorSec(sektor),
                  backgroundColor: colors.surface,
                  selectedColor: colors.surfaceHigh,
                  checkmarkColor: colors.dawn,
                  labelStyle: textTheme.labelMedium?.copyWith(
                    color: isSelected ? colors.dawn : colors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  side: BorderSide(
                    color: isSelected ? colors.dawn : colors.outline,
                    width: 1,
                  ),
                  shape: const RoundedRectangleBorder(borderRadius: AppRadius.pill),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _RecommendedMentorsList extends StatelessWidget {
  const _RecommendedMentorsList({required this.controller});

  final MentorController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<MentorModel>>(
      valueListenable: controller.tumMentorlar,
      builder: (context, mentorlar, _) {
        final onerilenler = mentorlar.where((m) => m.onerilenMi).toList();

        return SizedBox(
          height: 330,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            scrollDirection: Axis.horizontal,
            itemCount: onerilenler.length,
            separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final mentor = onerilenler[index];
              return SizedBox(
                width: 320,
                child: MentorCard(
                  mentor: mentor,
                  onEslesmeIste: () => controller.eslesmeIste(mentor.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
