// ========================================
// DOSYA: timer_display.dart
// NE İŞE YARAR: Çift halkalı gösterge ile
// dumansız geçen süreyi ve telemetriyi sunar.
// NASIL ÇALIŞIR: CustomPainter ve tabular
// kutularla canlı dairesel kronometre çizer.
// SOLID: SRP - Sadece sayaç kartı görünümü.
// ========================================

import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// SRP: Çift halkalı canlı sayaç bileşeni.
class TimerDisplay extends StatelessWidget {
  final Duration elapsed;

  const TimerDisplay({super.key, required this.elapsed});

  // Kademeli hedefe göre dış halka doluluk oranı.
  double _calculateOuterProgress() {
    final sec = elapsed.inSeconds;
    if (sec <= 0) return 0.0;
    const targetsInSec = [
      86400, // 1 gün
      3 * 86400, // 3 gün
      7 * 86400, // 7 gün
      14 * 86400, // 14 gün
      30 * 86400, // 30 gün
      90 * 86400, // 90 gün
      180 * 86400, // 180 gün
      365 * 86400, // 1 yıl
    ];
    for (final target in targetsInSec) {
      if (sec < target) {
        return (sec / target).clamp(0.02, 1.0);
      }
    }
    return 1.0;
  }

  // Günlük döngüye göre iç halka doluluk oranı.
  double _calculateInnerProgress() {
    final sec = elapsed.inSeconds;
    if (sec <= 0) return 0.0;
    if (sec < 86400) {
      final hourSec = sec % 3600;
      return (hourSec / 3600.0).clamp(0.02, 1.0);
    }
    final daySec = sec % 86400;
    return (daySec / 86400.0).clamp(0.02, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.outline),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2610B981),
            blurRadius: 32,
            spreadRadius: -8,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildBadge(),
          const SizedBox(height: 16),
          _buildDial(),
          const SizedBox(height: 16),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0x1A10B981),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x3310B981)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primary,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary,
                  blurRadius: 6,
                ),
              ],
            ),
            child: SizedBox(width: 7, height: 7),
          ),
          SizedBox(width: 8),
          Text(
            'SİGARASIZ TEMİZ HAYAT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDial() {
    return SizedBox(
      width: 230,
      height: 230,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(230, 230),
            painter: _DualRingPainter(
              outerProgress: _calculateOuterProgress(),
              innerProgress: _calculateInnerProgress(),
            ),
          ),
          _buildCenterContent(),
        ],
      ),
    );
  }

  Widget _buildCenterContent() {
    final days = elapsed.inDays;
    final hours = (elapsed.inHours % 24).toString().padLeft(2, '0');
    final minutes = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '$days',
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: AppTheme.onSurface,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            const Text(
              ' G ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
            Text(
              hours,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: AppTheme.onSurface,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            const Text(
              ' S',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildChip('$minutes Dk', isSec: false),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                ':',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildChip('$seconds Sn', isSec: true),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(String text, {required bool isSec}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSec ? const Color(0x6610B981) : AppTheme.outline,
        ),
        boxShadow: isSec
            ? const [
                BoxShadow(
                  color: Color(0x2610B981),
                  blurRadius: 6,
                ),
              ]
            : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isSec ? AppTheme.primaryBright : AppTheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.only(top: 14),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0x14FFFFFF))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(
                Icons.air_rounded,
                size: 18,
                color: AppTheme.secondaryCyan,
              ),
              SizedBox(width: 6),
              Text(
                'Karbonmonoksit: ',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              Text(
                '%0 Normalize',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryCyan,
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Icon(
                Icons.check_circle_outline_rounded,
                size: 16,
                color: AppTheme.primary,
              ),
              SizedBox(width: 4),
              Text(
                'Stabil',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Çift neon halkayı çizen CustomPainter.
class _DualRingPainter extends CustomPainter {
  final double outerProgress;
  final double innerProgress;

  const _DualRingPainter({
    required this.outerProgress,
    required this.innerProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const outerR = 94.0;
    const innerR = 76.0;

    // Arka plan dış halka izi.
    final bgPaintOuter = Paint()
      ..color = const Color(0x14FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    canvas.drawCircle(center, outerR, bgPaintOuter);

    // Arka plan iç halka izi.
    final bgPaintInner = Paint()
      ..color = const Color(0x0EFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawCircle(center, innerR, bgPaintInner);

    // Dış neon yeşil ilerleme yayı.
    if (outerProgress > 0) {
      final outerArcPaint = Paint()
        ..color = const Color(0xFF4EDEA3)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 10;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerR),
        -pi / 2,
        2 * pi * outerProgress,
        false,
        outerArcPaint,
      );
    }

    // İç camgöbeği ilerleme yayı.
    if (innerProgress > 0) {
      final innerArcPaint = Paint()
        ..color = const Color(0xFF4CD7F6)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 6;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerR),
        -pi / 2,
        2 * pi * innerProgress,
        false,
        innerArcPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DualRingPainter oldDelegate) {
    return oldDelegate.outerProgress != outerProgress ||
        oldDelegate.innerProgress != innerProgress;
  }
}
