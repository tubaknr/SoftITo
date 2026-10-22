import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../shell/view/shell_page.dart';
import '../controller/auth_controller.dart';
import 'forgot_password_page.dart';

/// User login page
class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.authController});

  final AuthController authController;

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

  bool _validate() {
    final email = _emailController.text;
    final password = _passwordController.text;

    setState(() {
      _emailError = AuthController.isValidEmail(email)
          ? null
          : context.loc.errorEmailInvalid;
      _passwordError = password.isNotEmpty
          ? null
          : context.loc.errorPasswordLength;
      _generalError = null;
    });

    return _emailError == null && _passwordError == null;
  }

  Future<void> _handleLogin() async {
    if (!_validate()) return;

    final success = await widget.authController.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => ShellPage(authController: widget.authController),
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
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: context.colors.textMain),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LoginHeader(),
            const SizedBox(height: 28),
            _buildFields(),
            if (_generalError != null) _buildGeneralError(),
            const SizedBox(height: 12),
            _buildForgotPasswordLink(),
            const SizedBox(height: 28),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFields() {
    return Column(
      children: [
        AppTextField(
          label: context.loc.emailLabel,
          hintText: 'ornek@email.com',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          errorText: _emailError,
          prefixIcon: Icon(Icons.email_outlined, color: context.colors.textMuted),
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: context.loc.passwordLabel,
          hintText: '••••••••',
          controller: _passwordController,
          isPassword: true,
          errorText: _passwordError,
          prefixIcon: Icon(Icons.lock_outline, color: context.colors.textMuted),
        ),
      ],
    );
  }

  Widget _buildGeneralError() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        _generalError!,
        style: context.typography.bodyMedium?.copyWith(
          color: Colors.redAccent,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: UnderlineLinkButton(
        label: context.loc.forgotPasswordLink,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ForgotPasswordPage(authController: widget.authController),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.authController.isLoading,
      builder: (context, isLoading, _) {
        return PrimaryGradientButton(
          label: context.loc.loginAction,
          isLoading: isLoading,
          onPressed: _handleLogin,
        );
      },
    );
  }
}

class _LoginHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.loc.loginAction,
          style: context.typography.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: context.colors.textMain,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          context.loc.brandMotto,
          style: context.typography.bodyLarge?.copyWith(
            color: context.colors.textMuted,
          ),
        ),
      ],
    );
  }
}
