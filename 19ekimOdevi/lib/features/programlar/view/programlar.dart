import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/section_header.dart';
import '../controller/programlar_controller.dart';
import '../models/program_model.dart';
import '../widget/program_card.dart';

class ProgramlarView extends StatefulWidget {
  final ProgramlarController? controller;

  const ProgramlarView({super.key, this.controller});

  @override
  State<ProgramlarView> createState() => _ProgramlarViewState();
}

class _ProgramlarViewState extends State<ProgramlarView> {
  late final ProgramlarController _controller;
  late final bool _internalController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _internalController = false;
    } else {
      _controller = ProgramlarController();
      _internalController = true;
    }
  }

  @override
  void dispose() {
    if (_internalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _showProgramDetail(BuildContext context, ProgramModel program) {
    final colors = context.spaceColors;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.isDark ? colors.nightBlue : colors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  program.ad,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  program.kurum,
                  style: TextStyle(
                    color: colors.nebulaCyan,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Divider(height: 24),
                Text(
                  'Başvuru Adımları',
                  style: TextStyle(
                    color: colors.rocketFlame,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...program.basvuruAdimlari.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: colors.rocketFlame.withValues(
                            alpha: 0.2,
                          ),
                          child: Text(
                            '${entry.key + 1}',
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.rocketFlame,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              fontSize: 13,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Kapat'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Destek ve Programlar')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildCategoryTabs()),
          SliverToBoxAdapter(child: _buildSearchAndFilter()),
          SliverToBoxAdapter(
            child: ValueListenableBuilder<ProgramKategori>(
              valueListenable: _controller.seciliKategori,
              builder: (context, kat, _) {
                return SectionHeader(
                  title: kat.baslik,
                  subtitle: 'Girişimciler için açık çağrılar ve hibeler',
                );
              },
            ),
          ),
          _buildProgramList(),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return ValueListenableBuilder<ProgramKategori>(
      valueListenable: _controller.seciliKategori,
      builder: (context, secili, _) {
        final colors = context.spaceColors;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: ProgramKategori.values.map((kat) {
              final isSelected = kat == secili;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(kat.baslik),
                  selected: isSelected,
                  selectedColor: colors.rocketFlame,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : colors.textPrimary,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (_) => _controller.kategoriSec(kat),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          TextField(
            onChanged: _controller.aramaYap,
            decoration: InputDecoration(
              hintText: 'Program veya kurum ara...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildStatusFilterChips(),
        ],
      ),
    );
  }

  Widget _buildStatusFilterChips() {
    final colors = context.spaceColors;
    return ValueListenableBuilder<ProgramDurum?>(
      valueListenable: _controller.seciliDurum,
      builder: (context, secili, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChip(
                label: const Text(AppStrings.tumu),
                selected: secili == null,
                onSelected: (_) => _controller.durumSec(null),
              ),
              const SizedBox(width: 6),
              ...ProgramDurum.values.map(
                (durum) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(durum.baslik),
                    selected: secili == durum,
                    selectedColor: colors.ascensionLime.withValues(alpha: 0.2),
                    onSelected: (_) => _controller.durumSec(durum),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgramList() {
    return ValueListenableBuilder<List<ProgramModel>>(
      valueListenable: _controller.gorunenProgramlar,
      builder: (context, liste, _) {
        if (liste.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('Kriterlere uygun program bulunamadı.')),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final program = liste[index];
            return ProgramCard(
              program: program,
              onTakvimToggle: () => _controller.takvimeEkle(program.id),
              onDetay: () => _showProgramDetail(context, program),
            );
          }, childCount: liste.length),
        );
      },
    );
  }
}
