import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/stats_controller.dart';

/// 4 haftalık trend çizgi ve dolgu grafiği (CustomPainter).
class MonthlyChartPainter extends CustomPainter {
  final List<WeeklySummaryItem> items;
  final bool isDark;

  MonthlyChartPainter({required this.items, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;

    final maxMinutes = items.map((e) => e.totalMinutes).fold(1, math.max);
    final effectiveMax = math.max(maxMinutes, 120);

    final chartHeight = size.height - 30;
    final stepX = size.width / (items.length - 1);

    // Grid lines
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)
      ..strokeWidth = 1;

    for (int step = 1; step <= 3; step++) {
      final y = chartHeight - (chartHeight * (step / 3));
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final points = <Offset>[];
    for (int i = 0; i < items.length; i++) {
      final x = i * stepX;
      final y = chartHeight - ((items[i].totalMinutes / effectiveMax) * chartHeight);
      points.add(Offset(x, y));
    }

    // Yumuşak Eğri Yolu
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX = (p0.dx + p1.dx) / 2;
      path.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    // Dolgu Gradyanı
    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, chartHeight)
      ..lineTo(points.first.dx, chartHeight)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.dustyRoseAccent.withValues(alpha: 0.35),
          AppColors.sproutSage.withValues(alpha: 0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, chartHeight))
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    // Çizgi
    final linePaint = Paint()
      ..color = AppColors.dustyRoseAccent
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);

    // Noktalar ve etiketler
    final pointPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final pointBorder = Paint()
      ..color = AppColors.dustyRoseAccent
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 5, pointPaint);
      canvas.drawCircle(points[i], 5, pointBorder);

      final textPainter = TextPainter(
        text: TextSpan(
          text: items[i].weekLabel,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(points[i].dx - (textPainter.width / 2), chartHeight + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant MonthlyChartPainter oldDelegate) {
    return oldDelegate.items != items || oldDelegate.isDark != isDark;
  }
}
