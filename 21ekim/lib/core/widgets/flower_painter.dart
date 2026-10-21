import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

/// Focus & Grow canlı çiçek illüstrasyonu (CustomPainter tabanlı).
/// Harici görsel gerektirmeden tohumdan olgun çiçeğe kadar tüm evreleri çizer.
class FlowerPainter extends CustomPainter {
  final FlowerStage stage;
  final double animationProgress;
  final bool isDark;

  const FlowerPainter({
    required this.stage,
    this.animationProgress = 0.0,
    this.isDark = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final centerBottom = Offset(w / 2, h * 0.92);

    // Hafif rüzgar salınımı (sway) açısı
    final swayAngle = math.sin(animationProgress * 2 * math.pi) * 0.04;

    canvas.save();
    canvas.translate(centerBottom.dx, centerBottom.dy);
    canvas.rotate(swayAngle);

    // Toprak ve zemin çizgisi
    _drawSoil(canvas, size);

    switch (stage) {
      case FlowerStage.seed:
        _drawSeed(canvas);
        break;
      case FlowerStage.sprout:
        _drawSprout(canvas);
        break;
      case FlowerStage.sapling:
        _drawSapling(canvas);
        break;
      case FlowerStage.leafyStem:
        _drawLeafyStem(canvas);
        break;
      case FlowerStage.bud:
        _drawBud(canvas);
        break;
      case FlowerStage.blooming:
        _drawBlooming(canvas, isMature: false);
        break;
      case FlowerStage.mature:
        _drawBlooming(canvas, isMature: true);
        break;
      case FlowerStage.wilted:
        _drawWilted(canvas);
        break;
      case FlowerStage.dead:
        _drawDead(canvas);
        break;
    }

    canvas.restore();
  }

  void _drawSoil(Canvas canvas, Size size) {
    final soilPaint = Paint()
      ..color = (isDark ? const Color(0xFF38433C) : const Color(0xFFC0CEBF))
          .withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(-size.width * 0.35, 0)
      ..quadraticBezierTo(0, -6, size.width * 0.35, 0)
      ..quadraticBezierTo(0, 6, -size.width * 0.35, 0);

    canvas.drawPath(path, soilPaint);
  }

  void _drawSeed(Canvas canvas) {
    final seedPaint = Paint()
      ..color = isDark ? const Color(0xFF9E8468) : const Color(0xFF8B6C4F)
      ..style = PaintingStyle.fill;

    // Tohum gövdesi
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, -5), width: 14, height: 18),
      seedPaint,
    );

    // Minik filiz ucu
    final tinySprout = Paint()
      ..color = AppColors.sproutSage
      ..style = PaintingStyle.fill;

    final sproutPath = Path()
      ..moveTo(0, -12)
      ..quadraticBezierTo(3, -18, 6, -20)
      ..quadraticBezierTo(3, -15, 0, -12);
    canvas.drawPath(sproutPath, tinySprout);
  }

  void _drawSprout(Canvas canvas) {
    final stemPaint = Paint()
      ..color = AppColors.sproutSage
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final leafPaint = Paint()
      ..color = AppColors.sproutSage
      ..style = PaintingStyle.fill;

    // Gövde
    canvas.drawLine(Offset.zero, const Offset(0, -42), stemPaint);

    // Sol yaprak
    final leftLeaf = Path()
      ..moveTo(0, -32)
      ..quadraticBezierTo(-16, -42, -22, -36)
      ..quadraticBezierTo(-14, -26, 0, -32);
    canvas.drawPath(leftLeaf, leafPaint);

    // Sağ yaprak
    final rightLeaf = Path()
      ..moveTo(0, -36)
      ..quadraticBezierTo(16, -46, 22, -40)
      ..quadraticBezierTo(14, -30, 0, -36);
    canvas.drawPath(rightLeaf, leafPaint);
  }

  void _drawSapling(Canvas canvas) {
    final stemPaint = Paint()
      ..color = const Color(0xFF9FC49E)
      ..strokeWidth = 4.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final leafPaint = Paint()
      ..color = const Color(0xFFB5DAB4)
      ..style = PaintingStyle.fill;

    // Uzayan gövde
    final stemPath = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(2, -40, -1, -85);
    canvas.drawPath(stemPath, stemPaint);

    // Alt yapraklar
    _drawSingleLeaf(canvas, const Offset(0, -35), -1, 26, leafPaint);
    _drawSingleLeaf(canvas, const Offset(0, -45), 1, 28, leafPaint);

    // Üst taze yapraklar
    _drawSingleLeaf(canvas, const Offset(0, -70), -1, 22, leafPaint);
    _drawSingleLeaf(canvas, const Offset(0, -78), 1, 24, leafPaint);
  }

  void _drawLeafyStem(Canvas canvas) {
    final stemPaint = Paint()
      ..color = const Color(0xFF88B887)
      ..strokeWidth = 5.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final leafPaint = Paint()
      ..color = const Color(0xFFAFD6AE)
      ..style = PaintingStyle.fill;

    // Kıvrımlı sağlam gövde
    final stemPath = Path()
      ..moveTo(0, 0)
      ..cubicTo(-4, -45, 6, -95, 0, -135);
    canvas.drawPath(stemPath, stemPaint);

    // 6 Adet Yaprak
    _drawSingleLeaf(canvas, const Offset(-1, -35), -1, 32, leafPaint);
    _drawSingleLeaf(canvas, const Offset(2, -50), 1, 34, leafPaint);
    _drawSingleLeaf(canvas, const Offset(3, -75), -1, 30, leafPaint);
    _drawSingleLeaf(canvas, const Offset(1, -95), 1, 32, leafPaint);
    _drawSingleLeaf(canvas, const Offset(-1, -115), -1, 24, leafPaint);
    _drawSingleLeaf(canvas, const Offset(0, -125), 1, 24, leafPaint);
  }

  void _drawBud(Canvas canvas) {
    _drawLeafyStem(canvas);

    // Tomurcuk çanağı
    final sepalPaint = Paint()
      ..color = const Color(0xFF7FA77E)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, -137), width: 18, height: 12),
      sepalPaint,
    );

    // Renklenen kapalı tomurcuk taç yaprakları (Sarı & Pembe pastel)
    final budPaint = Paint()
      ..color = AppColors.blushPetal
      ..style = PaintingStyle.fill;

    final budPath = Path()
      ..moveTo(-10, -138)
      ..quadraticBezierTo(-14, -165, 0, -172)
      ..quadraticBezierTo(14, -165, 10, -138)
      ..close();
    canvas.drawPath(budPath, budPaint);

    final highlightPaint = Paint()
      ..color = AppColors.sunlightYellow
      ..style = PaintingStyle.fill;
    final highlight = Path()
      ..moveTo(-4, -140)
      ..quadraticBezierTo(-2, -162, 0, -168)
      ..quadraticBezierTo(2, -162, 4, -140)
      ..close();
    canvas.drawPath(highlight, highlightPaint);
  }

  void _drawBlooming(Canvas canvas, {required bool isMature}) {
    _drawLeafyStem(canvas);

    const flowerCenter = Offset(0, -140);
    final petalCount = isMature ? 10 : 7;
    final petalLength = isMature ? 38.0 : 30.0;
    final petalWidth = isMature ? 22.0 : 18.0;

    // Dış Taç Yapraklar
    for (int i = 0; i < petalCount; i++) {
      final angle = (i * 2 * math.pi) / petalCount;
      canvas.save();
      canvas.translate(flowerCenter.dx, flowerCenter.dy);
      canvas.rotate(angle);

      final petalPaint = Paint()
        ..color = (i % 2 == 0 ? AppColors.blushPetal : AppColors.dustyRoseAccent)
            .withValues(alpha: 0.92)
        ..style = PaintingStyle.fill;

      final petalPath = Path()
        ..moveTo(0, 0)
        ..cubicTo(-petalWidth / 2, -petalLength * 0.45, -petalWidth / 2,
            -petalLength, 0, -petalLength)
        ..cubicTo(petalWidth / 2, -petalLength, petalWidth / 2,
            -petalLength * 0.45, 0, 0);
      canvas.drawPath(petalPath, petalPaint);

      // İç pastel ışıma çizgisi
      final innerLine = Paint()
        ..color = AppColors.sunlightYellow.withValues(alpha: 0.7)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
          const Offset(0, -4), Offset(0, -petalLength * 0.75), innerLine);

      canvas.restore();
    }

    // Çiçek Göbeği
    final centerPaint = Paint()
      ..color = AppColors.sunlightYellow
      ..style = PaintingStyle.fill;
    canvas.drawCircle(flowerCenter, isMature ? 14 : 11, centerPaint);

    final centerCore = Paint()
      ..color = const Color(0xFFE89A5F)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(flowerCenter, isMature ? 7 : 5, centerCore);
  }

  void _drawWilted(Canvas canvas) {
    // 7 gün girilmedi: solgun, başı öne bükük
    final wiltedStem = Paint()
      ..color = const Color(0xFF8E998B)
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final stemPath = Path()
      ..moveTo(0, 0)
      ..cubicTo(4, -40, -10, -90, -32, -118);
    canvas.drawPath(stemPath, wiltedStem);

    // Solgun yapraklar (aşağı sarkık)
    final wiltedLeaf = Paint()
      ..color = const Color(0xFFA5ACA3).withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    _drawDroopingLeaf(canvas, const Offset(1, -38), 1, 28, wiltedLeaf);
    _drawDroopingLeaf(canvas, const Offset(-4, -68), -1, 26, wiltedLeaf);

    // Başı bükük solgun taç yapraklar
    const flowerCenter = Offset(-32, -118);
    for (int i = 0; i < 6; i++) {
      final angle = (i * 2 * math.pi) / 6 + 0.3;
      canvas.save();
      canvas.translate(flowerCenter.dx, flowerCenter.dy);
      canvas.rotate(angle);

      final petalPaint = Paint()
        ..color = const Color(0xFFC7B1B6).withValues(alpha: 0.75)
        ..style = PaintingStyle.fill;

      final petalPath = Path()
        ..moveTo(0, 0)
        ..cubicTo(-8, -12, -8, -24, 0, -24)
        ..cubicTo(8, -24, 8, -12, 0, 0);
      canvas.drawPath(petalPath, petalPaint);
      canvas.restore();
    }
  }

  void _drawDead(Canvas canvas) {
    // 30 gün girilmedi: kurumuş yapraklar, sıfırlanmış tohum aşaması
    final deadStem = Paint()
      ..color = const Color(0xFF70675E)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Kuru dal
    canvas.drawLine(Offset.zero, const Offset(-6, -30), deadStem);
    canvas.drawLine(const Offset(-6, -30), const Offset(4, -48), deadStem);

    // Dökülmüş kuru yapraklar
    final dryLeaf = Paint()
      ..color = const Color(0xFF7A6B5F)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(-20, -2), width: 14, height: 6),
      dryLeaf,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(18, -3), width: 12, height: 5),
      dryLeaf,
    );
  }

  void _drawSingleLeaf(
    Canvas canvas,
    Offset origin,
    double direction,
    double length,
    Paint paint,
  ) {
    final leaf = Path()
      ..moveTo(origin.dx, origin.dy)
      ..quadraticBezierTo(
        origin.dx + (direction * length * 0.7),
        origin.dy - (length * 0.6),
        origin.dx + (direction * length),
        origin.dy - (length * 0.35),
      )
      ..quadraticBezierTo(
        origin.dx + (direction * length * 0.65),
        origin.dy + (length * 0.05),
        origin.dx,
        origin.dy,
      );
    canvas.drawPath(leaf, paint);
  }

  void _drawDroopingLeaf(
    Canvas canvas,
    Offset origin,
    double direction,
    double length,
    Paint paint,
  ) {
    final leaf = Path()
      ..moveTo(origin.dx, origin.dy)
      ..quadraticBezierTo(
        origin.dx + (direction * length * 0.8),
        origin.dy + (length * 0.1),
        origin.dx + (direction * length),
        origin.dy + (length * 0.4),
      )
      ..quadraticBezierTo(
        origin.dx + (direction * length * 0.4),
        origin.dy + (length * 0.5),
        origin.dx,
        origin.dy,
      );
    canvas.drawPath(leaf, paint);
  }

  @override
  bool shouldRepaint(covariant FlowerPainter oldDelegate) {
    return oldDelegate.stage != stage ||
        oldDelegate.animationProgress != animationProgress ||
        oldDelegate.isDark != isDark;
  }
}

/// Canlı Çiçek Animasyonlu Widget Bileşeni
class FlowerView extends StatefulWidget {
  final FlowerStage stage;
  final double size;

  const FlowerView({
    super.key,
    required this.stage,
    this.size = 200,
  });

  @override
  State<FlowerView> createState() => _FlowerViewState();
}

class _FlowerViewState extends State<FlowerView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: FlowerPainter(
            stage: widget.stage,
            animationProgress: _controller.value,
            isDark: isDark,
          ),
        );
      },
    );
  }
}
