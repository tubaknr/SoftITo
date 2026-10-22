import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../controller/auth_controller.dart';

/// Password recovery page
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, required this.authController});

  final AuthController authController;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  String? _emailError;
  bool _codeSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendCode() async {
    final email = _emailController.text;
    if (!AuthController.isValidEmail(email)) {
      setState(() => _emailError = context.loc.errorEmailInvalid);
      return;
    }
    setState(() => _emailError = null);

    final success = await widget.authController.sendPasswordReset(email);
    if (!mounted) return;

    if (success) {
      setState(() => _codeSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.loc.resetCodeSent),
          backgroundColor: context.colors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: context.colors.textMain),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ForgotPasswordHeader(),
            const SizedBox(height: 28),
            AppTextField(
              label: context.loc.emailLabel,
              hintText: 'ornek@email.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: _emailError,
              prefixIcon: Icon(Icons.email_outlined, color: context.colors.textMuted),
            ),
            const SizedBox(height: 24),
            _buildSendButton(),
            if (_codeSent) _buildSuccessNotice(),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.authController.isLoading,
      builder: (context, isLoading, _) {
        return PrimaryGradientButton(
          label: context.loc.sendCodeAction,
          isLoading: isLoading,
          onPressed: _handleSendCode,
        );
      },
    );
  }

  Widget _buildSuccessNotice() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.successLight.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.success),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle_outline, color: context.colors.success),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                context.loc.resetCodeSent,
                style: context.typography.bodyMedium?.copyWith(
                  color: context.colors.textMain,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForgotPasswordHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.loc.forgotPasswordLink,
          style: context.typography.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: context.colors.textMain,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.loc.forgotPasswordInfo,
          style: context.typography.bodyLarge?.copyWith(
            color: context.colors.textMuted,
          ),
        ),
      ],
    );
  }
}
