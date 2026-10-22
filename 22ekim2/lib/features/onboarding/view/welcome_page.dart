import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/locale_controller.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/brand_title_widget.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../../core/widgets/penguin_mascot_painter.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/view/login_page.dart';
import '../../auth/view/register_page.dart';
import '../../shell/view/shell_page.dart';

/// Welcome / Landing page (Sayfa 1)
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, required this.authController});

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      useHeroGradient: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            _WelcomeHeader(),
            const Spacer(),
            const PenguinMascotWidget(
              pose: PenguinPose.climbing,
              size: 210,
            ),
            const SizedBox(height: 24),
            _WelcomeMottoText(),
            const Spacer(),
            _WelcomeActionButtons(authController: authController),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const BrandTitleWidget(subSize: 11, mainSize: 22),
        Row(
          children: [
            _LanguageToggleButton(),
            const SizedBox(width: 8),
            _ThemeToggleButton(),
          ],
        ),
      ],
    );
  }
}

class _LanguageToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LocaleController.instance,
      builder: (context, locale, _) {
        final isTr = locale.languageCode == 'tr';
        return TextButton(
          onPressed: () => LocaleController.instance.toggleLocale(),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            backgroundColor: context.colors.bgCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.colors.borderLight),
            ),
          ),
          child: Text(
            isTr ? 'TR 🇹🇷' : 'EN 🇬🇧',
            style: context.typography.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colors.textMain,
            ),
          ),
        );
      },
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        return IconButton(
          onPressed: () => ThemeController.instance.toggleTheme(),
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: isDark ? context.colors.accentSun : context.colors.textMuted,
            size: 22,
          ),
        );
      },
    );
  }
}

class _WelcomeMottoText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.loc.welcomeTitle,
          textAlign: TextAlign.center,
          style: context.typography.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: context.colors.textMain,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '"${context.loc.brandMotto}"',
          textAlign: TextAlign.center,
          style: context.typography.bodyLarge?.copyWith(
            color: context.colors.textMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class _WelcomeActionButtons extends StatelessWidget {
  const _WelcomeActionButtons({required this.authController});

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryGradientButton(
          label: context.loc.registerAction,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RegisterPage(authController: authController),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        GoogleOAuthButton(
          onPressed: () async {
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
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.loc.alreadyHaveAccount,
              style: context.typography.bodyMedium?.copyWith(
                color: context.colors.textMuted,
              ),
            ),
            const SizedBox(width: 8),
            UnderlineLinkButton(
              label: context.loc.loginAction,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LoginPage(authController: authController),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
