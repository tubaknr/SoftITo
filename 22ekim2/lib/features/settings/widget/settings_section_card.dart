import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';

/// Card container grouping related settings under a section header
class SettingsSectionCard extends StatelessWidget {
  const SettingsSectionCard({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, bottom: 6),
          child: Text(
            title,
            style: context.typography.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.textMuted,
              letterSpacing: 0.4,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: colors.bgCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.borderLight),
            boxShadow: [
              BoxShadow(
                color: context.isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : const Color(0xFF1E3A8A).withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: _buildSeparatedChildren(colors),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSeparatedChildren(dynamic colors) {
    final result = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(
          Divider(
            height: 1,
            thickness: 0.8,
            color: colors.borderLight.withValues(alpha: 0.6),
          ),
        );
      }
    }
    return result;
  }
}
