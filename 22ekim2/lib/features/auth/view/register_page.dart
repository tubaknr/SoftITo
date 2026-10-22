import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../onboarding/view/welcome_after_register_page.dart';
import '../controller/auth_controller.dart';

/// User registration form page
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.authController});

  final AuthController authController;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _generalError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    setState(() {
      _nameError = AuthController.isValidName(name)
          ? null
          : context.loc.errorNameRequired;
      _emailError = AuthController.isValidEmail(email)
          ? null
          : context.loc.errorEmailInvalid;
      _passwordError = AuthController.isValidPassword(password)
          ? null
          : context.loc.errorPasswordLength;
      _confirmPasswordError = AuthController.doPasswordsMatch(password, confirm)
          ? null
          : context.loc.errorPasswordMismatch;
      _generalError = null;
    });

    return _nameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null;
  }

  Future<void> _handleRegister() async {
    if (!_validateForm()) return;

    final success = await widget.authController.register(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => WelcomeAfterRegisterPage(
            authController: widget.authController,
          ),
        ),
      );
    } else {
      setState(() {
        _generalError = 'Kayıt işlemi başarısız oldu. E-posta kullanımda olabilir veya şifre çok zayıf.';
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
            _RegisterHeader(),
            const SizedBox(height: 24),
            _buildFormFields(),
            if (_generalError != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                ),
                child: Text(
                  _generalError!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                ),
              ),
            ],
            const SizedBox(height: 28),
            _buildSubmitButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        AppTextField(
          label: context.loc.nameLabel,
          hintText: 'Ayşe Kaya',
          controller: _nameController,
          errorText: _nameError,
          prefixIcon: Icon(Icons.person_outline, color: context.colors.textMuted),
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
        AppTextField(
          label: context.loc.confirmPasswordLabel,
          hintText: '••••••••',
          controller: _confirmPasswordController,
          isPassword: true,
          errorText: _confirmPasswordError,
          prefixIcon: Icon(Icons.lock_reset_outlined, color: context.colors.textMuted),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.authController.isLoading,
      builder: (context, isLoading, _) {
        return PrimaryGradientButton(
          label: context.loc.registerAction,
          isLoading: isLoading,
          onPressed: _handleRegister,
        );
      },
    );
  }
}

class _RegisterHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.loc.registerAction,
          style: context.typography.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: context.colors.textMain,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          context.loc.registerEncouragement,
          style: context.typography.bodyLarge?.copyWith(
            color: context.colors.textMuted,
          ),
        ),
      ],
    );
  }
}
