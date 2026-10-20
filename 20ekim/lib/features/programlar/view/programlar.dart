import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../controller/program_controller.dart';
import '../models/program_model.dart';
import '../widget/program_card.dart';

class ProgramlarView extends StatefulWidget {
  const ProgramlarView({
    super.key,
    required this.controller,
  });

  final ProgramController controller;

  @override
  State<ProgramlarView> createState() => _ProgramlarViewState();
}

class _ProgramlarViewState extends State<ProgramlarView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showBasvuruDetaySheet(ProgramModel program) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                program.ad,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Sağlayıcı: ${program.kurum} • Destek: ${program.destekTutari}',
                style: textTheme.bodyMedium?.copyWith(color: colors.dawn),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Başvuru Adımları',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...List.generate(program.basvuruAdimlari.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: colors.dawn.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: textTheme.labelMedium?.copyWith(
                              color: colors.dawn,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          program.basvuruAdimlari[index],
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Anladım, Kapat'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Destek Programları & Hibeler'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 5 Category Tabs
                  _CategorySelector(controller: widget.controller),

                  const SizedBox(height: AppSpacing.lg),

                  // Search Field
                  TextField(
                    controller: _searchController,
                    onChanged: widget.controller.aramaDegisti,
                    decoration: InputDecoration(
                      hintText: 'Program adı, kurum veya şart ara...',
                      prefixIcon: Icon(Icons.search_rounded, color: colors.textMuted),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () {
                                _searchController.clear();
                                widget.controller.aramaDegisti('');
                              },
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Programs List
          ValueListenableBuilder<List<ProgramModel>>(
            valueListenable: widget.controller.filtreliProgramlar,
            builder: (context, programlar, _) {
              if (programlar.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Center(
                      child: Text(
                        'Bu kategoride açık program bulunamadı.',
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
                      final item = programlar[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                        child: ProgramCard(
                          program: item,
                          onTakvimeEkle: () => widget.controller.takvimeEkle(item.id),
                          onBasvuruBilgisi: () => _showBasvuruDetaySheet(item),
                        ),
                      );
                    },
                    childCount: programlar.length,
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

class _CategorySelector extends StatelessWidget {
  const _CategorySelector({required this.controller});

  final ProgramController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ProgramKategorisi>(
      valueListenable: controller.seciliKategori,
      builder: (context, secili, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _TabItem(
                label: 'Hibe Programları',
                isSelected: secili == ProgramKategorisi.hibeProgramlari,
                onTap: () => controller.kategoriSec(ProgramKategorisi.hibeProgramlari),
              ),
              const SizedBox(width: AppSpacing.sm),
              _TabItem(
                label: 'Devlet Destekleri',
                isSelected: secili == ProgramKategorisi.devletDestekleri,
                onTap: () => controller.kategoriSec(ProgramKategorisi.devletDestekleri),
              ),
              const SizedBox(width: AppSpacing.sm),
              _TabItem(
                label: 'Yurtdışı Destekleri',
                isSelected: secili == ProgramKategorisi.yurtdisiDestekleri,
                onTap: () => controller.kategoriSec(ProgramKategorisi.yurtdisiDestekleri),
              ),
              const SizedBox(width: AppSpacing.sm),
              _TabItem(
                label: 'Özel Sektör Destekleri',
                isSelected: secili == ProgramKategorisi.ozelSektorDestekleri,
                onTap: () => controller.kategoriSec(ProgramKategorisi.ozelSektorDestekleri),
              ),
              const SizedBox(width: AppSpacing.sm),
              _TabItem(
                label: 'Kuluçka & Hızlandırma',
                isSelected: secili == ProgramKategorisi.kuluckaMerkezleri,
                onTap: () => controller.kategoriSec(ProgramKategorisi.kuluckaMerkezleri),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.pill,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colors.surfaceHigh : colors.surface,
          borderRadius: AppRadius.pill,
          border: Border.all(
            color: isSelected ? colors.dawn : colors.outline,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: isSelected ? colors.dawn : colors.textPrimary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
