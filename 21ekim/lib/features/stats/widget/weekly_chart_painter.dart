import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/stats_controller.dart';

/// Son 7 günün odaklanma sürelerini çizen CustomPainter çubuk grafiği.
class WeeklyChartPainter extends CustomPainter {
  final List<DailyStatItem> items;
  final bool isDark;

  WeeklyChartPainter({required this.items, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;

    final maxMinutes = items.map((e) => e.minutes).fold(1, math.max);
    final effectiveMax = math.max(maxMinutes, 60); // En az 60 dk tavan

    final barWidth = size.width / (items.length * 2);
    final chartHeight = size.height - 30; // Alt etiketler için pay

    // Arka plan yatay kılavuz çizgileri
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)
      ..strokeWidth = 1;

    for (int step = 1; step <= 3; step++) {
      final y = chartHeight - (chartHeight * (step / 3));
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final barPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final x = (i * 2 + 0.6) * barWidth;
      final barH = (item.minutes / effectiveMax) * chartHeight;
      final y = chartHeight - barH;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth * 0.85, barH),
        const Radius.circular(8),
      );

      // Çubuk gradyanı
      barPaint.shader = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          AppColors.sproutSage,
          AppColors.dustyRoseAccent,
        ],
      ).createShader(rect.outerRect);

      canvas.drawRRect(rect, barPaint);

      // Gün Etiketi
      final textPainter = TextPainter(
        text: TextSpan(
          text: item.dayName,
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
        Offset(x + (barWidth * 0.42) - (textPainter.width / 2), chartHeight + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant WeeklyChartPainter oldDelegate) {
    return oldDelegate.items != items || oldDelegate.isDark != isDark;
  }
}
