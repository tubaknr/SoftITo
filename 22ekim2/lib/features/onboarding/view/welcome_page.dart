import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/locale_controller.dart';
import '../../../core/services/url_opener/url_opener.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../../core/widgets/penguin_mascot_painter.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/view/login_page.dart';
import '../../auth/view/register_page.dart';
import '../../shell/view/shell_page.dart';

/// Pixel-perfect Welcome & Onboarding Landing Page matching user specifications
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, required this.authController});

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      useHeroGradient: false,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  24,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTopBar(context),
                const SizedBox(height: 10),
                _buildHeroSection(context),
                const SizedBox(height: 16),
                _buildActionButtons(context),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- 1. TOP BAR ---
  Widget _buildTopBar(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Language Toggle Pill (TR / EN)
        ValueListenableBuilder<Locale>(
          valueListenable: LocaleController.instance,
          builder: (context, locale, _) {
            final isTr = locale.languageCode == 'tr';
            return Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: colors.bgCard.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3A8A).withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLangChip(context, 'TR', isTr),
                  _buildLangChip(context, 'EN', !isTr),
                ],
              ),
            );
          },
        ),

        // Right: "Minik Adım" Heart Badge & Light/Dark Theme Switcher
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
              decoration: BoxDecoration(
                color: colors.bgCard.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3A8A).withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.favorite_rounded,
                    size: 14,
                    color: Color(0xFFFDA4AF),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    context.loc.tinyStepBadge,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colors.textMain,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LoginPage(authController: authController),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: colors.bgCard.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E3A8A).withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.login_rounded,
                  color: colors.primary,
                  size: 17,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ValueListenableBuilder<ThemeMode>(
              valueListenable: ThemeController.instance,
              builder: (context, mode, _) {
                final isDark = mode == ThemeMode.dark;
                return InkWell(
                  onTap: () => ThemeController.instance.toggleTheme(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: colors.bgCard.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.borderLight),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E3A8A).withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      color: isDark ? colors.accentSun : colors.textMuted,
                      size: 17,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLangChip(BuildContext context, String text, bool active) {
    final colors = context.colors;
    return GestureDetector(
      onTap: () {
        if (!active) {
          LocaleController.instance.toggleLocale();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
        decoration: BoxDecoration(
          color: active ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: active ? FontWeight.w800 : FontWeight.w600,
            color: active ? Colors.white : colors.textMuted,
          ),
        ),
      ),
    );
  }

  // --- 2. HERO SECTION ---
  Widget _buildHeroSection(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        // Mascot with Platform & Floating Badges
        SizedBox(
          width: 240,
          height: 195,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ambient glow aura
              Positioned(
                bottom: 10,
                child: Container(
                  width: 150,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.24),
                        blurRadius: 32,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),

              // Polar Platform
              Positioned(
                bottom: 8,
                child: Container(
                  width: 140,
                  height: 20,
                  decoration: BoxDecoration(
                    color: colors.bgCard.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: colors.borderLight),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E3A8A).withValues(alpha: 0.08),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                ),
              ),

              // Penguin Mascot
              const PenguinMascotWidget(
                pose: PenguinPose.celebrating,
                size: 168,
              ),

              // Micro Badge 1 (Top Left: Sparkle / Star)
              Positioned(
                top: 10,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: colors.bgCard,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.borderLight),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E3A8A).withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    size: 16,
                    color: Color(0xFFFDE047),
                  ),
                ),
              ),

              // Micro Badge 2 (Top Right: 1% Sprout check)
              Positioned(
                top: 16,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: colors.bgCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colors.borderLight),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E3A8A).withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 13,
                        color: Color(0xFF10B981),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        context.loc.isTr ? '%1' : '1%',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF006947),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Brand Title Hierarchy: "SMALL TICK" larger, but smaller than "Big Grow"
        Text(
          'SMALL TICK',
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.2,
            color: colors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Big Grow',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.6,
            color: colors.textMain,
          ),
        ),

        const SizedBox(height: 10),

        // Motto Pill Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFD8E2FF).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFADC6FF).withValues(alpha: 0.8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.eco_rounded, size: 15, color: colors.primary),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  context.loc.brandMotto,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF001A42),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            context.loc.welcomeSubtitle,
            textAlign: TextAlign.center,
            style: context.typography.bodySmall?.copyWith(
              fontSize: 12.5,
              color: colors.textMuted,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }

  // --- 3. CALL TO ACTION BUTTONS & LEGAL ---
  Widget _buildActionButtons(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        // Primary Gradient Action: "Hemen Başla" (clean, NO underline)
        SizedBox(
          width: double.infinity,
          height: 50,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E40AF), Color(0xFF3B82F6), Color(0xFF60A5FA)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RegisterPage(authController: authController),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.loc.getStarted,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 19, color: Colors.white),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Google OAuth: purely circular button, only Google logo, NO text
        _buildGoogleCircleButton(context),

        const SizedBox(height: 14),

        // Legal / Privacy Disclaimer with clickable links opening the browser
        _buildLegalDisclaimer(context),
      ],
    );
  }

  Widget _buildGoogleCircleButton(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: () async {
        final success = await authController.loginWithGoogle();
        if (!context.mounted) return;
        if (success) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => ShellPage(authController: authController),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.bgCard,
          border: Border.all(color: colors.borderLight),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E3A8A).withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CustomPaint(
              painter: _GoogleLogoPainter(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegalDisclaimer(BuildContext context) {
    final colors = context.colors;
    final isTr = context.loc.isTr;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontSize: 11,
            color: colors.textMuted,
            height: 1.4,
          ),
          children: [
            TextSpan(
              text: isTr ? 'Devam ederek ' : 'By continuing, you agree to our ',
            ),
            TextSpan(
              text: context.loc.termsOfService,
              style: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  UrlOpener.open('terms.html');
                },
            ),
            TextSpan(
              text: isTr ? ' ve ' : ' and ',
            ),
            TextSpan(
              text: context.loc.privacyPolicy,
              style: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  UrlOpener.open('privacy.html');
                },
            ),
            TextSpan(
              text: isTr ? '\'nı kabul etmiş olursunuz.' : '.',
            ),
          ],
        ),
      ),
    );
  }
}

/// Painter for the official 4-color Google G icon
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;

    // Blue section
    paint.color = const Color(0xFF4285F4);
    final bluePath = Path()
      ..moveTo(w * 0.94, h * 0.51)
      ..lineTo(w * 0.5, h * 0.51)
      ..lineTo(w * 0.5, h * 0.69)
      ..lineTo(w * 0.75, h * 0.69)
      ..arcToPoint(Offset(w * 0.65, h * 0.81), radius: Radius.circular(w * 0.4))
      ..lineTo(w * 0.8, h * 0.92)
      ..arcToPoint(Offset(w * 0.94, h * 0.51), radius: Radius.circular(w * 0.5));
    canvas.drawPath(bluePath, paint);

    // Green section
    paint.color = const Color(0xFF34A853);
    final greenPath = Path()
      ..moveTo(w * 0.5, h * 0.96)
      ..arcToPoint(Offset(w * 0.8, h * 0.92), radius: Radius.circular(w * 0.5))
      ..lineTo(w * 0.65, h * 0.81)
      ..arcToPoint(Offset(w * 0.24, h * 0.72), radius: Radius.circular(w * 0.38))
      ..lineTo(w * 0.09, h * 0.84)
      ..arcToPoint(Offset(w * 0.5, h * 0.96), radius: Radius.circular(w * 0.5));
    canvas.drawPath(greenPath, paint);

    // Yellow section
    paint.color = const Color(0xFFFBBC05);
    final yellowPath = Path()
      ..moveTo(w * 0.09, h * 0.84)
      ..lineTo(w * 0.24, h * 0.72)
      ..arcToPoint(Offset(w * 0.24, h * 0.28), radius: Radius.circular(w * 0.38))
      ..lineTo(w * 0.09, h * 0.16)
      ..arcToPoint(Offset(w * 0.09, h * 0.84), radius: Radius.circular(w * 0.5));
    canvas.drawPath(yellowPath, paint);

    // Red section
    paint.color = const Color(0xFFEA4335);
    final redPath = Path()
      ..moveTo(w * 0.5, h * 0.04)
      ..arcToPoint(Offset(w * 0.09, h * 0.16), radius: Radius.circular(w * 0.5))
      ..lineTo(w * 0.24, h * 0.28)
      ..arcToPoint(Offset(w * 0.68, h * 0.19), radius: Radius.circular(w * 0.38))
      ..lineTo(w * 0.82, h * 0.06)
      ..arcToPoint(Offset(w * 0.5, h * 0.04), radius: Radius.circular(w * 0.5));
    canvas.drawPath(redPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
