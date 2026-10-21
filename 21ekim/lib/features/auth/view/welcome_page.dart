import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/fg_buttons.dart';
import '../../../core/widgets/fg_top_bar.dart';
import '../../../core/widgets/flower_painter.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../shell/controller/shell_controller.dart';
import '../../shell/view/shell_view.dart';
import '../controller/auth_controller.dart';
import 'login_page.dart';
import 'register_page.dart';

/// Giriş / Karşılama Sayfası (Landing)
class WelcomePage extends StatelessWidget {
  final VoidCallback onLoginSuccess;

  const WelcomePage({
    super.key,
    required this.onLoginSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final isDark = context.isDark;

    return GradientScaffold(
      appBar: const FGTopBar(isAuthFlow: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Canlı Çiçek İllüstrasyonu (CustomPainter)
              const Center(
                child: FlowerView(
                  stage: FlowerStage.blooming,
                  size: 220,
                ),
              ),
              const SizedBox(height: 20),

              // Uygulama Adı
              Text(
                loc.appName,
                textAlign: TextAlign.center,
                style: AppTypography.heroDisplay(isDark: isDark),
              ),
              const SizedBox(height: 10),

              // Motto
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  loc.motto,
                  textAlign: TextAlign.center,
                  style: AppTypography.mottoText(isDark: isDark),
                ),
              ),
              const SizedBox(height: 40),

              // Register Pill Butonu
              PrimaryPillButton(
                text: loc.registerCta,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RegisterPage(
                        onRegisterSuccess: onLoginSuccess,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Giriş Yap Altı Çizili Bağlantısı
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LoginPage(
                        onLoginSuccess: onLoginSuccess,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    loc.alreadyHaveAccount,
                    textAlign: TextAlign.center,
                    style: AppTypography.underlineLink(isDark: isDark),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Dairesel Google OAuth Butonu
              Center(
                child: GoogleOAuthButton(
                  onPressed: () async {
                    final success =
                        await AuthController.instance.signInWithGoogle();
                    if (success && context.mounted) {
                      onLoginSuccess();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => ShellView(
                            onLogoutOrDelete: () {
                              ShellController.instance.resetToHome();
                            },
                          ),
                        ),
                        (route) => false,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
