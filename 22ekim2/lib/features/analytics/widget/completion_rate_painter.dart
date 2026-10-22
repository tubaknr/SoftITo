import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Circular progress bar painter with pastel gradient for overall continuity rate
class CompletionRatePainter extends CustomPainter {
  const CompletionRatePainter({
    required this.percentage,
    required this.primaryColor,
    required this.trackColor,
  });

  final double percentage; // 0.0 to 100.0
  final Color primaryColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 24) / 2;
    const strokeWidth = 14.0;

    // Background track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    if (percentage > 0) {
      final sweepAngle = (percentage / 100.0) * 2 * math.pi;
      final progressPaint = Paint()
        ..shader = SweepGradient(
          startAngle: -math.pi / 2,
          endAngle: 3 * math.pi / 2,
          colors: [
            primaryColor,
            const Color(0xFF10B981),
            primaryColor,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CompletionRatePainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.primaryColor != primaryColor;
  }
}
