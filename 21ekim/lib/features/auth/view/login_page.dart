import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/fg_buttons.dart';
import '../../../core/widgets/fg_text_field.dart';
import '../../../core/widgets/fg_top_bar.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../shell/controller/shell_controller.dart';
import '../../shell/view/shell_view.dart';
import '../controller/auth_controller.dart';
import 'forgot_password_page.dart';

/// Giriş Yap Sayfası
class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginPage({
    super.key,
    required this.onLoginSuccess,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _generalError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _emailError = AuthController.validateEmail(_emailController.text);
      _passwordError = _passwordController.text.isEmpty
          ? context.loc.errorRequiredField
          : null;
      _generalError = null;
    });

    if (_emailError != null || _passwordError != null) return;

    final success = await AuthController.instance.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      widget.onLoginSuccess();
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
    } else {
      setState(() {
        _generalError = context.loc.errorInvalidCredentials;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final isDark = context.isDark;

    return GradientScaffold(
      appBar: const FGTopBar(
        isAuthFlow: true,
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // "Doğanın tadını çıkarmaya"
              Text(
                loc.loginNatureGreeting,
                style: AppTypography.heading1Light(isDark: isDark),
              ),
              const SizedBox(height: 4),
              // "Hoşgeldin"
              Text(
                loc.welcomeGreeting,
                style: AppTypography.heading1Bold(isDark: isDark).copyWith(
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 32),

              if (_generalError != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    _generalError!,
                    style: AppTypography.errorCaption,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // E-posta
              FGTextField(
                controller: _emailController,
                label: loc.emailLabel,
                placeholder: 'ornek@email.com',
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
                onChanged: (_) {
                  if (_emailError != null) {
                    setState(() => _emailError = null);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Şifre
              FGTextField(
                controller: _passwordController,
                label: loc.passwordLabel,
                placeholder: '••••••••',
                obscureText: true,
                errorText: _passwordError,
                onChanged: (_) {
                  if (_passwordError != null) {
                    setState(() => _passwordError = null);
                  }
                },
              ),
              const SizedBox(height: 10),

              // "Şifremi unuttum"
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordPage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      loc.forgotPasswordLink,
                      style: AppTypography.underlineLink(isDark: isDark),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Giriş Yap Butonu
              ValueListenableBuilder<bool>(
                valueListenable: AuthController.instance.isLoading,
                builder: (context, isLoading, _) {
                  return PrimaryPillButton(
                    text: loc.loginButton,
                    isLoading: isLoading,
                    onPressed: _handleLogin,
                  );
                },
              ),
              const SizedBox(height: 24),

              // Alternatif Google ile Giriş
              Center(
                child: GoogleOAuthButton(
                  onPressed: () async {
                    final success =
                        await AuthController.instance.signInWithGoogle();
                    if (success && context.mounted) {
                      widget.onLoginSuccess();
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
