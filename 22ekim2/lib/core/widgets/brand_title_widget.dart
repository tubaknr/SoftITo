import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';

/// Two-line typographic brand title specified in `style2.md` Section 1.1
class BrandTitleWidget extends StatelessWidget {
  const BrandTitleWidget({
    super.key,
    this.subSize = 13,
    this.mainSize = 22,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final double subSize;
  final double mainSize;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'SMALL TICK',
          style: TextStyle(
            fontSize: subSize,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.4,
            color: isDark ? colors.primaryLight : colors.primary,
          ),
        ),
        Text(
          'Big Grow',
          style: TextStyle(
            fontSize: mainSize,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.6,
            height: 1.05,
            color: isDark ? Colors.white : colors.primaryDark,
          ),
        ),
      ],
    );
  }
}
