import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';

/// Primary gradient action button defined in `style.md`
class PrimaryGradientButton extends StatelessWidget {
  const PrimaryGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = 54,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: onPressed != null ? colors.btnPrimaryGradient : null,
        color: onPressed == null ? colors.textDisabled.withValues(alpha: 0.3) : null,
        borderRadius: BorderRadius.circular(16),
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          icon!,
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.typography.titleMedium?.copyWith(
                              color: colors.textOnPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Google OAuth button styled per `style.md` Section 5.1
class GoogleOAuthButton extends StatelessWidget {
  const GoogleOAuthButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderLight, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Google__G__logo.svg.webp',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const _GoogleIconPainterWidget(size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                context.loc.googleContinue,
                style: context.typography.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textMain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Text link button without underline
class UnderlineLinkButton extends StatelessWidget {
  const UnderlineLinkButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
  });

  final String label;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        label,
        style: context.typography.labelLarge?.copyWith(
          color: color ?? context.colors.textLink,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _GoogleIconPainterWidget extends StatelessWidget {
  const _GoogleIconPainterWidget({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleIconPainter(),
      ),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Segment colors of Google G
    final redPaint = Paint()..color = const Color(0xFFEA4335)..style = PaintingStyle.fill;
    final bluePaint = Paint()..color = const Color(0xFF4285F4)..style = PaintingStyle.fill;
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05)..style = PaintingStyle.fill;
    final greenPaint = Paint()..color = const Color(0xFF34A853)..style = PaintingStyle.fill;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Simplified Google color arcs
    canvas.drawArc(rect, -0.8, 1.6, true, bluePaint);
    canvas.drawArc(rect, 0.8, 1.4, true, greenPaint);
    canvas.drawArc(rect, 2.2, 1.2, true, yellowPaint);
    canvas.drawArc(rect, 3.4, 1.4, true, redPaint);

    // Inner cutout
    final innerPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.58, innerPaint);

    // Horizontal bar
    final barPaint = Paint()..color = const Color(0xFF4285F4)..style = PaintingStyle.fill;
    final barRect = Rect.fromLTWH(
      center.dx - 1,
      center.dy - radius * 0.22,
      radius * 0.95,
      radius * 0.44,
    );
    canvas.drawRect(barRect, barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
