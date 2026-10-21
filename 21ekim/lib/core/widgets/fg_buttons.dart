import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_typography.dart';

/// Focus & Grow birincil pastel gül gradyanlı Pill CTA butonu.
class PrimaryPillButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryPillButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        gradient: AppColors.primaryButtonGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x35E8A598),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: isLoading ? null : onPressed,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    text,
                    style: AppTypography.buttonText,
                  ),
          ),
        ),
      ),
    );
  }
}

/// Dairesel nefes alan nabız animasyonlu Odaklanma Butonu ("Odaklanmaya Başla").
class PulsingFocusButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;

  const PulsingFocusButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  State<PulsingFocusButton> createState() => _PulsingFocusButtonState();
}

class _PulsingFocusButtonState extends State<PulsingFocusButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + (_pulseController.value * 0.06);
        final glowAlpha = 0.2 + (_pulseController.value * 0.25);

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 124,
            height: 124,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.pulsingButtonGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.dustyRoseAccent.withValues(alpha: glowAlpha),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: widget.onPressed,
                child: Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.spa_rounded,
                          color: AppColors.textCharcoal,
                          size: 30,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.label,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: AppTypography.heading2().copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                            color: AppColors.textCharcoal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Odak Durdurma Butonu ("Durdur").
class StopButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const StopButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.stopButtonRed,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40DF828A),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onPressed,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.stop_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: AppTypography.buttonText.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Dairesel Google OAuth Butonu
class GoogleOAuthButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleOAuthButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? AppColors.darkCardSurface
            : Colors.white.withValues(alpha: 0.9),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : AppColors.dustyRoseAccent.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Center(
            child: CustomPaint(
              size: const Size(24, 24),
              painter: _GoogleLogoPainter(),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final redPaint = Paint()..color = const Color(0xFFEA4335);
    final bluePaint = Paint()..color = const Color(0xFF4285F4);
    final greenPaint = Paint()..color = const Color(0xFF34A853);
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05);

    // Kırmızı üst yay
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.75,
      math.pi * 0.5,
      true,
      redPaint,
    );
    // Mavi sağ yay & çubuk
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.25,
      math.pi * 0.5,
      true,
      bluePaint,
    );
    // Yeşil alt yay
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.25,
      math.pi * 0.5,
      true,
      greenPaint,
    );
    // Sarı sol yay
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75,
      math.pi * 0.5,
      true,
      yellowPaint,
    );

    // Beyaz merkez delik
    final holePaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.55, holePaint);

    // Mavi sağ yatay çubuk
    final barPaint = Paint()..color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTRB(center.dx, center.dy - radius * 0.25, center.dx + radius,
          center.dy + radius * 0.25),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
