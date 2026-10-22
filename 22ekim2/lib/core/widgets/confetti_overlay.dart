import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Micro confetti and glitter celebration burst
class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({
    super.key,
    required this.child,
    required this.triggerCount,
  });

  final Widget child;
  final int triggerCount;

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant ConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.triggerCount > oldWidget.triggerCount) {
      _spawnParticles();
      _controller.forward(from: 0.0);
    }
  }

  void _spawnParticles() {
    _particles.clear();
    const colors = [
      Color(0xFF3B82F6),
      Color(0xFFFDE047),
      Color(0xFF10B981),
      Color(0xFFFB923C),
      Color(0xFFFDA4AF),
      Color(0xFF818CF8),
    ];
    for (int i = 0; i < 35; i++) {
      _particles.add(
        _Particle(
          color: colors[i % colors.length],
          angle: _random.nextDouble() * 2 * math.pi,
          speed: 60 + _random.nextDouble() * 120,
          size: 6 + _random.nextDouble() * 6,
          rotation: _random.nextDouble() * 2 * math.pi,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_controller.isAnimating)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _ConfettiPainter(
                  progress: _controller.value,
                  particles: _particles,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Particle {
  _Particle({
    required this.color,
    required this.angle,
    required this.speed,
    required this.size,
    required this.rotation,
  });

  final Color color;
  final double angle;
  final double speed;
  final double size;
  final double rotation;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({
    required this.progress,
    required this.particles,
  });

  final double progress;
  final List<_Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.4);
    final opacity = (1.0 - progress).clamp(0.0, 1.0);

    for (final p in particles) {
      final distance = p.speed * progress;
      final x = center.dx + math.cos(p.angle) * distance;
      final y = center.dy + math.sin(p.angle) * distance + (progress * progress * 80);

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotation + (progress * 4));
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
