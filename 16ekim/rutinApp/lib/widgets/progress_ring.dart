import 'package:flutter/material.dart';

/// Ortasında içerik gösteren, değeri animasyonla değişen daire ilerleme göstergesi.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.value,
    required this.size,
    required this.child,
  });

  final double value; // 0.0 - 1.0
  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: value),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              builder: (context, animated, _) => CircularProgressIndicator(
                value: animated,
                strokeWidth: 10,
                color: primary,
                backgroundColor: const Color(0xFFFFE4D1),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
