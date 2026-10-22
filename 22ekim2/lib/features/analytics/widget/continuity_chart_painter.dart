import 'package:flutter/material.dart';

/// CustomPainter rendering smooth gradient bars for continuity timeline
class ContinuityChartPainter extends CustomPainter {
  const ContinuityChartPainter({
    required this.values,
    required this.barGradient,
    required this.gridColor,
  });

  final List<double> values; // Values from 0.0 to 1.0
  final LinearGradient barGradient;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final w = size.width;
    final h = size.height;
    final count = values.length;
    final slotWidth = w / count;
    final barWidth = (slotWidth * 0.45).clamp(8.0, 28.0);

    // Draw baseline
    final baseLinePaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(0, h), Offset(w, h), baseLinePaint);

    for (int i = 0; i < count; i++) {
      final val = values[i].clamp(0.0, 1.0);
      final barHeight = val * (h - 8);
      final x = (i * slotWidth) + (slotWidth / 2);
      final top = h - barHeight;

      if (barHeight > 0) {
        final rect = Rect.fromLTWH(x - (barWidth / 2), top, barWidth, barHeight);
        final barPaint = Paint()
          ..shader = barGradient.createShader(rect)
          ..style = PaintingStyle.fill;

        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(8)),
          barPaint,
        );
      } else {
        // Dot for zero
        final zeroPaint = Paint()..color = gridColor;
        canvas.drawCircle(Offset(x, h - 3), 3, zeroPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant ContinuityChartPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}
