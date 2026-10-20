import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../controller/yatirimci_controller.dart';
import '../data/mock_yatirimci_data.dart';
import '../models/yatirimci_model.dart';
import '../widget/yatirimci_card.dart';

class YatirimciView extends StatefulWidget {
  const YatirimciView({
    super.key,
    required this.controller,
  });

  final YatirimciController controller;

  @override
  State<YatirimciView> createState() => _YatirimciViewState();
}

class _YatirimciViewState extends State<YatirimciView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yatırımcılar & Fonlar'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Segmented Bar
                  _CategorySelector(controller: widget.controller),

                  const SizedBox(height: AppSpacing.lg),

                  // Search Field
                  TextField(
                    controller: _searchController,
                    onChanged: widget.controller.aramaDegisti,
                    decoration: InputDecoration(
                      hintText: 'Yatırımcı, portföy veya sektör ara...',
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

                  const SizedBox(height: AppSpacing.md),

                  // Stage Filter Chips
                  _StageChips(controller: widget.controller),
                ],
              ),
            ),
          ),

          // Yatirimci Cards List
          ValueListenableBuilder<List<YatirimciModel>>(
            valueListenable: widget.controller.filtreliYatirimcilar,
            builder: (context, yatirimcilar, _) {
              if (yatirimcilar.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Center(
                      child: Text(
                        'Kriterlere uygun yatırımcı bulunamadı.',
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
                      final item = yatirimcilar[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                        child: YatirimciCard(
                          yatirimci: item,
                          onIletisimeGec: () => widget.controller.iletisimKur(item.id),
                        ),
                      );
                    },
                    childCount: yatirimcilar.length,
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

  final YatirimciController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<YatirimciKategorisi>(
      valueListenable: controller.seciliKategori,
      builder: (context, secili, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _TabChip(
                label: 'Şirketler (CVC)',
                isSelected: secili == YatirimciKategorisi.sirketler,
                onTap: () => controller.kategoriSec(YatirimciKategorisi.sirketler),
              ),
              const SizedBox(width: AppSpacing.sm),
              _TabChip(
                label: 'Holdingler',
                isSelected: secili == YatirimciKategorisi.holdingler,
                onTap: () => controller.kategoriSec(YatirimciKategorisi.holdingler),
              ),
              const SizedBox(width: AppSpacing.sm),
              _TabChip(
                label: 'Melek Yatırımcılar',
                isSelected: secili == YatirimciKategorisi.melekYatirimcilar,
                onTap: () => controller.kategoriSec(YatirimciKategorisi.melekYatirimcilar),
              ),
              const SizedBox(width: AppSpacing.sm),
              _TabChip(
                label: 'Girişim Sermayesi (VC)',
                isSelected: secili == YatirimciKategorisi.girisimSermayesiFonlari,
                onTap: () => controller.kategoriSec(YatirimciKategorisi.girisimSermayesiFonlari),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
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

class _StageChips extends StatelessWidget {
  const _StageChips({required this.controller});

  final YatirimciController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return ValueListenableBuilder<String>(
      valueListenable: controller.seciliAsama,
      builder: (context, secili, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: MockYatirimciData.asamalar.map((asama) {
              final isSelected = asama == secili;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: FilterChip(
                  label: Text(asama),
                  selected: isSelected,
                  onSelected: (_) => controller.asamaSec(asama),
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
