import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/fg_buttons.dart';
import '../../../core/widgets/fg_text_field.dart';
import '../../../core/widgets/fg_top_bar.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../controller/auth_controller.dart';

/// Şifremi Unuttum Sayfası
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  String? _emailError;
  bool _codeSent = false;
  bool _isSending = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendCode() async {
    final error = AuthController.validateEmail(_emailController.text);
    setState(() {
      _emailError = error;
    });
    if (error != null) return;

    setState(() {
      _isSending = true;
    });

    final success =
        await AuthController.instance.sendResetCode(_emailController.text.trim());

    if (!mounted) return;

    setState(() {
      _isSending = false;
      _codeSent = success;
    });
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // "Çiçeğini kurtarmamız için emailini girebilirsin."
              Text(
                loc.forgotPasswordTitle,
                style: AppTypography.heading1Light(isDark: isDark).copyWith(
                  fontSize: 24,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),

              // E-posta Girdisi
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
              const SizedBox(height: 28),

              // "Kod Gönder" Butonu
              PrimaryPillButton(
                text: loc.sendCodeButton,
                isLoading: _isSending,
                onPressed: _handleSendCode,
              ),
              const SizedBox(height: 20),

              // "Kod gönderildi" Bilgilendirmesi
              if (_codeSent)
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.softSuccessGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.softSuccessGreen,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.softSuccessGreen,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          loc.codeSentMessage,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textCharcoal,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
