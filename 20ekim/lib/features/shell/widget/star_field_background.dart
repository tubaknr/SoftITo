import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/extensions/context_extensions.dart';

class StarFieldBackground extends StatefulWidget {
  const StarFieldBackground({
    super.key,
    required this.child,
    this.showHorizonGlow = true,
  });

  final Widget child;
  final bool showHorizonGlow;

  @override
  State<StarFieldBackground> createState() => _StarFieldBackgroundState();
}

class _StarPoint {
  _StarPoint({
    required this.x,
    required this.y,
    required this.radius,
    required this.cycleDuration,
    required this.initialPhase,
  });

  final double x;
  final double y;
  final double radius;
  final double cycleDuration;
  final double initialPhase;
}

class _StarFieldBackgroundState extends State<StarFieldBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _twinkleController;
  late final List<_StarPoint> _stars;

  @override
  void initState() {
    super.initState();
    final random = math.Random(42);
    _stars = List.generate(50, (_) {
      return _StarPoint(
        x: random.nextDouble(),
        y: random.nextDouble(),
        radius: 1.0 + random.nextDouble() * 2.0,
        cycleDuration: 4.0 + random.nextDouble() * 4.0,
        initialPhase: random.nextDouble() * 2 * math.pi,
      );
    });

    _twinkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _twinkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Night gradient background
        Container(
          decoration: BoxDecoration(
            gradient: colors.nightGradient,
          ),
        ),

        // Custom Painted Twinkling Stars
        if (reduceMotion)
          CustomPaint(
            painter: _StaticStarPainter(
              stars: _stars,
              starColor: colors.textPrimary,
            ),
          )
        else
          AnimatedBuilder(
            animation: _twinkleController,
            builder: (context, _) {
              return CustomPaint(
                painter: _TwinklingStarPainter(
                  stars: _stars,
                  animationValue: _twinkleController.value,
                  starColor: colors.textPrimary,
                ),
              );
            },
          ),

        // Dawn Horizon Glow
        if (widget.showHorizonGlow)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 180,
            child: IgnorePointer(
              child: AnimatedOpacity(
                duration: AppDurations.hero,
                curve: Curves.easeOutCubic,
                opacity: 0.28,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        colors.dawn,
                        colors.dawnEnd.withValues(alpha: 0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

        // Foreground Child
        widget.child,
      ],
    );
  }
}

class _TwinklingStarPainter extends CustomPainter {
  _TwinklingStarPainter({
    required this.stars,
    required this.animationValue,
    required this.starColor,
  });

  final List<_StarPoint> stars;
  final double animationValue;
  final Color starColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final timeSeconds = animationValue * 6.0;

    for (final star in stars) {
      final phase = star.initialPhase + (2 * math.pi * timeSeconds / star.cycleDuration);
      final alphaFactor = 0.25 + 0.75 * ((math.sin(phase) + 1.0) / 2.0);
      paint.color = starColor.withValues(alpha: alphaFactor * 0.85);

      final offset = Offset(star.x * size.width, star.y * size.height);
      canvas.drawCircle(offset, star.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_TwinklingStarPainter oldDelegate) => true;
}

class _StaticStarPainter extends CustomPainter {
  _StaticStarPainter({
    required this.stars,
    required this.starColor,
  });

  final List<_StarPoint> stars;
  final Color starColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final star in stars) {
      paint.color = starColor.withValues(alpha: 0.6);
      final offset = Offset(star.x * size.width, star.y * size.height);
      canvas.drawCircle(offset, star.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_StaticStarPainter oldDelegate) => false;
}
