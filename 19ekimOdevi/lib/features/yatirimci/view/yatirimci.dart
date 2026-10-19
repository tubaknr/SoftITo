import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/section_header.dart';
import '../controller/yatirimci_controller.dart';
import '../models/yatirimci_model.dart';
import '../widget/yatirimci_card.dart';

class YatirimciView extends StatefulWidget {
  final YatirimciController? controller;

  const YatirimciView({super.key, this.controller});

  @override
  State<YatirimciView> createState() => _YatirimciViewState();
}

class _YatirimciViewState extends State<YatirimciView> {
  late final YatirimciController _controller;
  late final bool _internalController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _internalController = false;
    } else {
      _controller = YatirimciController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yatırımcı Ağı')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildCategoryTabs()),
          SliverToBoxAdapter(child: _buildSearchAndStageFilter()),
          SliverToBoxAdapter(
            child: ValueListenableBuilder<YatirimciKategori>(
              valueListenable: _controller.seciliKategori,
              builder: (context, kat, _) {
                return SectionHeader(
                  title: kat.baslik,
                  subtitle: 'Girişiminize uygun sermaye ve stratejik ortaklar',
                );
              },
            ),
          ),
          _buildYatirimciList(),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return ValueListenableBuilder<YatirimciKategori>(
      valueListenable: _controller.seciliKategori,
      builder: (context, secili, _) {
        final colors = context.spaceColors;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: YatirimciKategori.values.map((kat) {
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

  Widget _buildSearchAndStageFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          TextField(
            onChanged: _controller.aramaYap,
            decoration: InputDecoration(
              hintText: 'Yatırımcı, sektör veya portföy ara...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildStageFilterChips(),
        ],
      ),
    );
  }

  Widget _buildStageFilterChips() {
    final colors = context.spaceColors;
    return ValueListenableBuilder<String?>(
      valueListenable: _controller.seciliAsama,
      builder: (context, secili, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChip(
                label: const Text(AppStrings.tumu),
                selected: secili == null,
                onSelected: (_) => _controller.asamaSec(null),
              ),
              const SizedBox(width: 6),
              ..._controller.asamalar.map(
                (asama) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(asama),
                    selected: secili == asama,
                    selectedColor: colors.nebulaCyan.withValues(alpha: 0.2),
                    onSelected: (_) => _controller.asamaSec(asama),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildYatirimciList() {
    return ValueListenableBuilder<List<YatirimciModel>>(
      valueListenable: _controller.gorunenYatirimcilar,
      builder: (context, liste, _) {
        if (liste.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text('Kriterlere uygun yatırımcı bulunamadı.'),
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final y = liste[index];
            return YatirimciCard(
              yatirimci: y,
              onIletisim: () => _controller.iletisimTalebiGonder(y.id),
            );
          }, childCount: liste.length),
        );
      },
    );
  }
}
