import 'package:flutter/material.dart';
import '../../reflection/models/mood_entry.dart';

/// Renders horizontal proportional segments for emotion distribution
class MoodDistributionPainter extends CustomPainter {
  const MoodDistributionPainter({
    required this.distribution,
    required this.moodColors,
  });

  final Map<Mood, int> distribution;
  final Map<Mood, Color> moodColors;

  @override
  void paint(Canvas canvas, Size size) {
    final total = distribution.values.fold(0, (sum, count) => sum + count);
    if (total == 0) return;

    final h = size.height;
    double currentX = 0.0;

    // Draw stacked rounded bar
    final trackRect = Rect.fromLTWH(0, 0, size.width, h);
    canvas.save();
    canvas.clipRRect(RRect.fromRectAndRadius(trackRect, Radius.circular(h / 2)));

    for (final mood in Mood.values) {
      final count = distribution[mood] ?? 0;
      if (count > 0) {
        final segmentWidth = (count / total) * size.width;
        final paint = Paint()
          ..color = moodColors[mood] ?? Colors.blueAccent
          ..style = PaintingStyle.fill;

        canvas.drawRect(Rect.fromLTWH(currentX, 0, segmentWidth, h), paint);
        currentX += segmentWidth;
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant MoodDistributionPainter oldDelegate) {
    return oldDelegate.distribution != distribution;
  }
}
