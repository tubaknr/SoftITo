import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Penguin mascot pose variants from `style.md`
enum PenguinPose {
  climbing,     // Climbing ice/wood stairs (Welcome Page)
  celebrating,  // At summit, waving & smiling in sunrise (Post-Register / Success)
  curiousEmpty, // Holding notepad/brush curiously (Empty state)
  badgeMedal,   // Wearing a cute gold medal (Profile & Badges)
}

/// CustomPainter rendering a cute, chubby penguin mascot
class PenguinMascotPainter extends CustomPainter {
  const PenguinMascotPainter({
    required this.pose,
    this.animationValue = 1.0,
  });

  final PenguinPose pose;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    // 1. Background scene elements based on pose
    if (pose == PenguinPose.climbing) {
      _drawStairs(canvas, w, h);
    } else if (pose == PenguinPose.celebrating) {
      _drawDawnSun(canvas, w, h);
    }

    // Mascot position and scale
    final mascotScale = math.min(w, h) * 0.75;
    final mascotOrigin = Offset(center.dx, center.dy + (pose == PenguinPose.climbing ? -10 : 5));

    // 2. Penguin Feet
    _drawFeet(canvas, mascotOrigin, mascotScale);

    // 3. Penguin Body (Dark chubby oval)
    final bodyPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.fill;
    final bodyRect = Rect.fromCenter(
      center: mascotOrigin,
      width: mascotScale * 0.85,
      height: mascotScale * 0.95,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, Radius.circular(mascotScale * 0.42)),
      bodyPaint,
    );

    // 4. White Belly
    final bellyPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final bellyRect = Rect.fromCenter(
      center: Offset(mascotOrigin.dx, mascotOrigin.dy + mascotScale * 0.08),
      width: mascotScale * 0.60,
      height: mascotScale * 0.72,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bellyRect, Radius.circular(mascotScale * 0.34)),
      bellyPaint,
    );

    // 5. Blushing Cheeks (Pastel Coral)
    final cheekPaint = Paint()
      ..color = AppColors.lightAccentCoral.withValues(alpha: 0.75)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(mascotOrigin.dx - mascotScale * 0.22, mascotOrigin.dy - mascotScale * 0.05),
      mascotScale * 0.07,
      cheekPaint,
    );
    canvas.drawCircle(
      Offset(mascotOrigin.dx + mascotScale * 0.22, mascotOrigin.dy - mascotScale * 0.05),
      mascotScale * 0.07,
      cheekPaint,
    );

    // 6. Eyes (Cute shiny black dots with white sparkle)
    _drawEyes(canvas, mascotOrigin, mascotScale);

    // 7. Beak (Golden Orange triangle/rounded diamond)
    _drawBeak(canvas, mascotOrigin, mascotScale);

    // 8. Wings / Flippers according to pose
    _drawFlippers(canvas, mascotOrigin, mascotScale);

    // 9. "Small Tick" Metaphor: Green tick mark on chest
    _drawSmallTickOnChest(canvas, mascotOrigin, mascotScale);

    // 10. "Big Grow" Metaphor: Fresh green sprout beside mascot
    _drawBigGrowSprout(canvas, mascotOrigin, mascotScale);

    // 11. Extra pose items (Notepad for curiousEmpty, Medal for badgeMedal)
    if (pose == PenguinPose.curiousEmpty) {
      _drawNotepad(canvas, mascotOrigin, mascotScale);
    } else if (pose == PenguinPose.badgeMedal) {
      _drawMedal(canvas, mascotOrigin, mascotScale);
    }
  }

  void _drawStairs(Canvas canvas, double w, double h) {
    final stairPaint = Paint()
      ..color = AppColors.lightPrimaryLight.withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;
    final stairBorder = Paint()
      ..color = AppColors.lightPrimary.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 4; i++) {
      final rect = Rect.fromLTWH(
        w * 0.15 + (i * w * 0.18),
        h * 0.85 - (i * h * 0.12),
        w * 0.22,
        h * 0.08,
      );
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));
      canvas.drawRRect(rrect, stairPaint);
      canvas.drawRRect(rrect, stairBorder);
    }
  }

  void _drawDawnSun(Canvas canvas, double w, double h) {
    final sunPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFDE047), Color(0x00FDE047)],
      ).createShader(Rect.fromCircle(center: Offset(w * 0.8, h * 0.25), radius: w * 0.35));
    canvas.drawCircle(Offset(w * 0.8, h * 0.25), w * 0.35, sunPaint);
  }

  void _drawFeet(Canvas canvas, Offset origin, double scale) {
    final feetPaint = Paint()
      ..color = AppColors.lightAccentOrange
      ..style = PaintingStyle.fill;

    // Left foot
    final leftFoot = Rect.fromCenter(
      center: Offset(origin.dx - scale * 0.20, origin.dy + scale * 0.45),
      width: scale * 0.22,
      height: scale * 0.10,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(leftFoot, const Radius.circular(10)), feetPaint);

    // Right foot
    final rightFoot = Rect.fromCenter(
      center: Offset(origin.dx + scale * 0.20, origin.dy + scale * 0.45),
      width: scale * 0.22,
      height: scale * 0.10,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(rightFoot, const Radius.circular(10)), feetPaint);
  }

  void _drawEyes(Canvas canvas, Offset origin, double scale) {
    final leftEyeCenter = Offset(origin.dx - scale * 0.12, origin.dy - scale * 0.14);
    final rightEyeCenter = Offset(origin.dx + scale * 0.12, origin.dy - scale * 0.14);
    final eyeRadius = scale * 0.045;

    if (pose == PenguinPose.celebrating || pose == PenguinPose.badgeMedal) {
      // Happy smiling arched eyes (^_^) per style2.md
      final arcPaint = Paint()
        ..color = const Color(0xFF0F172A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = scale * 0.03
        ..strokeCap = StrokeCap.round;

      final leftRect = Rect.fromCircle(center: leftEyeCenter, radius: eyeRadius);
      final rightRect = Rect.fromCircle(center: rightEyeCenter, radius: eyeRadius);
      canvas.drawArc(leftRect, math.pi * 1.15, math.pi * 0.7, false, arcPaint);
      canvas.drawArc(rightRect, math.pi * 1.15, math.pi * 0.7, false, arcPaint);
    } else {
      final eyePaint = Paint()..color = const Color(0xFF0F172A);
      final sparklePaint = Paint()..color = Colors.white;

      canvas.drawCircle(leftEyeCenter, eyeRadius, eyePaint);
      canvas.drawCircle(rightEyeCenter, eyeRadius, eyePaint);

      // Sparkles
      canvas.drawCircle(
        Offset(leftEyeCenter.dx - 1.5, leftEyeCenter.dy - 1.5),
        eyeRadius * 0.35,
        sparklePaint,
      );
      canvas.drawCircle(
        Offset(rightEyeCenter.dx - 1.5, rightEyeCenter.dy - 1.5),
        eyeRadius * 0.35,
        sparklePaint,
      );
    }
  }

  void _drawBeak(Canvas canvas, Offset origin, double scale) {
    final beakPaint = Paint()
      ..color = AppColors.lightAccentOrange
      ..style = PaintingStyle.fill;

    final path = Path();
    final top = origin.dy - scale * 0.09;
    path.moveTo(origin.dx - scale * 0.08, top);
    path.lineTo(origin.dx + scale * 0.08, top);
    path.lineTo(origin.dx, top + scale * 0.11);
    path.close();

    canvas.drawPath(path, beakPaint);
  }

  void _drawFlippers(Canvas canvas, Offset origin, double scale) {
    final wingPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.fill;

    if (pose == PenguinPose.celebrating) {
      // Arms raised up in celebration!
      final leftWing = Rect.fromCenter(
        center: Offset(origin.dx - scale * 0.42, origin.dy - scale * 0.15),
        width: scale * 0.16,
        height: scale * 0.36,
      );
      final rightWing = Rect.fromCenter(
        center: Offset(origin.dx + scale * 0.42, origin.dy - scale * 0.15),
        width: scale * 0.16,
        height: scale * 0.36,
      );
      canvas.drawRRect(RRect.fromRectAndRadius(leftWing, const Radius.circular(16)), wingPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(rightWing, const Radius.circular(16)), wingPaint);
    } else {
      // Normal cute flippers resting at sides
      final leftWing = Rect.fromCenter(
        center: Offset(origin.dx - scale * 0.40, origin.dy + scale * 0.10),
        width: scale * 0.14,
        height: scale * 0.34,
      );
      final rightWing = Rect.fromCenter(
        center: Offset(origin.dx + scale * 0.40, origin.dy + scale * 0.10),
        width: scale * 0.14,
        height: scale * 0.34,
      );
      canvas.drawRRect(RRect.fromRectAndRadius(leftWing, const Radius.circular(16)), wingPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(rightWing, const Radius.circular(16)), wingPaint);
    }
  }

  void _drawNotepad(Canvas canvas, Offset origin, double scale) {
    final padPaint = Paint()
      ..color = const Color(0xFFFDE047)
      ..style = PaintingStyle.fill;
    final padBorder = Paint()
      ..color = const Color(0xFFD97706)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final padRect = Rect.fromCenter(
      center: Offset(origin.dx + scale * 0.22, origin.dy + scale * 0.20),
      width: scale * 0.26,
      height: scale * 0.32,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(padRect, const Radius.circular(6)), padPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(padRect, const Radius.circular(6)), padBorder);

    // Mini lines inside notepad
    final linePaint = Paint()
      ..color = const Color(0xFFB45309)
      ..strokeWidth = 2;
    for (int i = 0; i < 3; i++) {
      final y = padRect.top + 8 + (i * 10);
      canvas.drawLine(Offset(padRect.left + 6, y), Offset(padRect.right - 6, y), linePaint);
    }
  }

  void _drawMedal(Canvas canvas, Offset origin, double scale) {
    final ribbonPaint = Paint()
      ..color = const Color(0xFFEF4444)
      ..style = PaintingStyle.fill;
    final medalPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.fill;

    final medalCenter = Offset(origin.dx, origin.dy + scale * 0.22);

    // Ribbon
    final ribbonPath = Path()
      ..moveTo(origin.dx - scale * 0.08, origin.dy + scale * 0.05)
      ..lineTo(medalCenter.dx, medalCenter.dy)
      ..lineTo(origin.dx + scale * 0.08, origin.dy + scale * 0.05)
      ..close();
    canvas.drawPath(ribbonPath, ribbonPaint);

    // Medal
    canvas.drawCircle(medalCenter, scale * 0.09, medalPaint);
  }

  void _drawSmallTickOnChest(Canvas canvas, Offset origin, double scale) {
    final tickPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 0.038
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final tickCenter = Offset(origin.dx, origin.dy + scale * 0.16);
    final tickPath = Path()
      ..moveTo(tickCenter.dx - scale * 0.07, tickCenter.dy)
      ..lineTo(tickCenter.dx - scale * 0.015, tickCenter.dy + scale * 0.05)
      ..lineTo(tickCenter.dx + scale * 0.08, tickCenter.dy - scale * 0.05);

    canvas.drawPath(tickPath, tickPaint);
  }

  void _drawBigGrowSprout(Canvas canvas, Offset origin, double scale) {
    final sproutPaint = Paint()
      ..color = const Color(0xFF34D399)
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 0.025
      ..strokeCap = StrokeCap.round;

    final leafPaint = Paint()
      ..color = const Color(0xFF34D399)
      ..style = PaintingStyle.fill;

    // Position sprout beside penguin
    final sproutBase = Offset(origin.dx + scale * 0.44, origin.dy + scale * 0.42);
    final sproutTop = Offset(sproutBase.dx, sproutBase.dy - scale * 0.18);

    // Stem
    final stemPath = Path()
      ..moveTo(sproutBase.dx, sproutBase.dy)
      ..quadraticBezierTo(
        sproutBase.dx + 4,
        sproutBase.dy - scale * 0.09,
        sproutTop.dx,
        sproutTop.dy,
      );
    canvas.drawPath(stemPath, sproutPaint);

    // Left leaf
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(sproutTop.dx - scale * 0.045, sproutTop.dy + scale * 0.035),
        width: scale * 0.09,
        height: scale * 0.045,
      ),
      leafPaint,
    );

    // Right leaf
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(sproutTop.dx + scale * 0.045, sproutTop.dy + scale * 0.015),
        width: scale * 0.09,
        height: scale * 0.045,
      ),
      leafPaint,
    );
  }

  @override
  bool shouldRepaint(covariant PenguinMascotPainter oldDelegate) {
    return oldDelegate.pose != pose || oldDelegate.animationValue != animationValue;
  }
}

/// A convenient widget that sizes and presents the Penguin Mascot
class PenguinMascotWidget extends StatelessWidget {
  const PenguinMascotWidget({
    super.key,
    required this.pose,
    this.size = 180,
  });

  final PenguinPose pose;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: PenguinMascotPainter(pose: pose),
      ),
    );
  }
}
