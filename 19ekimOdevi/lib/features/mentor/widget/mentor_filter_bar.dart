import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';

class MentorFilterBar extends StatelessWidget {
  final List<String> sektorler;
  final String? seciliSektor;
  final ValueChanged<String?> onSektorSelected;
  final ValueChanged<String> onSearchChanged;

  const MentorFilterBar({
    super.key,
    required this.sektorler,
    required this.seciliSektor,
    required this.onSektorSelected,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchField(context),
        const SizedBox(height: 8),
        _buildChips(context),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Mentor, uzmanlık veya sektör ara...',
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildChips(BuildContext context) {
    final colors = context.spaceColors;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          FilterChip(
            label: const Text(AppStrings.tumu),
            selected: seciliSektor == null,
            onSelected: (_) => onSektorSelected(null),
          ),
          const SizedBox(width: 8),
          ...sektorler.map(
            (sektor) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(sektor),
                selected: seciliSektor == sektor,
                selectedColor: colors.rocketFlame.withValues(alpha: 0.2),
                onSelected: (_) => onSektorSelected(sektor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
