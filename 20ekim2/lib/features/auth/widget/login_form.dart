import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/controllers/session_controller.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/validators/app_validators.dart';
import '../data/mock_auth_data.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    required this.role,
    required this.sessionController,
    required this.onSuccess,
    super.key,
  });

  final UserRole role;
  final SessionController sessionController;
  final VoidCallback onSuccess;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Kayıt formu alanları
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();

  bool _isLoginMode = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _rememberMe = true;
  bool _termsAccepted = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Testleri ve demoyu kolaylaştırmak için varsayılan mock e-posta ve şifre
    if (widget.role == UserRole.owner) {
      _emailController.text = 'mehmet@kiralago.com';
      _passwordController.text = 'Password123';
    } else {
      _emailController.text = 'ahmet@kiralago.com';
      _passwordController.text = 'Password123';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
    _occupationController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    if (!_isLoginMode && !_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.valTermsRequired),
          backgroundColor: context.colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Kısa gecikme simülasyonu
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    if (_isLoginMode) {
      final MockAccount? account = MockAuthData.authenticate(
        email: _emailController.text,
        password: _passwordController.text,
        expectedRole: widget.role,
      );

      setState(() => _isLoading = false);

      if (account != null) {
        await widget.sessionController.login(
          role: widget.role,
          userId: account.id,
          displayName: account.displayName,
          email: account.email,
          rememberMe: _rememberMe,
        );
        widget.onSuccess();
      } else {
        showDialog<void>(
          context: context,
          builder: (BuildContext ctx) => AlertDialog(
            title: const Text('Giriş Başarısız'),
            content: const Text(
              'Girdiğiniz e-posta veya şifre hatalı ya da seçtiğiniz kullanıcı rolüyle eşleşmiyor.\n\nÖrnek Kiracı: ahmet@kiralago.com / Password123\nÖrnek Araç Sahibi: mehmet@kiralago.com / Password123',
            ),
            actions: <Widget>[
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(context.l10n.dialogClose),
              ),
            ],
          ),
        );
      }
    } else {
      // Kayıt simülasyonu
      setState(() => _isLoading = false);
      final String displayName =
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim().substring(0, 1).toUpperCase()}.';

      await widget.sessionController.login(
        role: widget.role,
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        displayName: displayName,
        email: _emailController.text.trim(),
        rememberMe: true,
      );
      widget.onSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (!_isLoginMode) ...<Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: context.l10n.firstNameLabel,
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                      ),
                      validator: AppValidators.onlyLetters(context.l10n),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: context.l10n.lastNameLabel,
                      ),
                      validator: AppValidators.onlyLetters(context.l10n),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: context.l10n.phoneLabel,
                  hintText: context.l10n.phoneHint,
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
                validator: AppValidators.phone(context.l10n),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: context.l10n.ageLabel,
                        prefixIcon: const Icon(Icons.cake_outlined),
                      ),
                      validator: AppValidators.age(context.l10n),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: _occupationController,
                      decoration: InputDecoration(
                        labelText: context.l10n.occupationLabel,
                        prefixIcon: const Icon(Icons.work_outline_rounded),
                      ),
                      validator: AppValidators.required(context.l10n),
                    ),
                  ),
                ],
              ),
              if (widget.role == UserRole.owner) ...<Widget>[
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          labelText: context.l10n.cityLabel,
                          prefixIcon: const Icon(Icons.location_city_outlined),
                        ),
                        validator: AppValidators.required(context.l10n),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _districtController,
                        decoration: InputDecoration(
                          labelText: context.l10n.districtLabel,
                        ),
                        validator: AppValidators.required(context.l10n),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.md),
            ],
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const <String>[AutofillHints.email],
              decoration: InputDecoration(
                labelText: context.l10n.emailLabel,
                hintText: context.l10n.emailHint,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              validator: AppValidators.email(context.l10n),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              autofillHints: const <String>[AutofillHints.password],
              decoration: InputDecoration(
                labelText: context.l10n.passwordLabel,
                hintText: context.l10n.passwordHint,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              validator: AppValidators.password(context.l10n),
            ),
            if (!_isLoginMode) ...<Widget>[
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: context.l10n.confirmPasswordLabel,
                  prefixIcon: const Icon(Icons.lock_reset_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    ),
                  ),
                ),
                validator: AppValidators.confirmPassword(
                  () => _passwordController.text,
                  context.l10n,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              CheckboxListTile(
                value: _termsAccepted,
                onChanged: (bool? val) => setState(() => _termsAccepted = val ?? false),
                title: Text(
                  context.l10n.termsAgreement,
                  style: context.textTheme.bodySmall,
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ] else ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (bool? val) => setState(() => _rememberMe = val ?? true),
                  ),
                  Text(
                    context.l10n.rememberMe,
                    style: context.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: _isLoading ? null : _handleSubmit,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      _isLoginMode
                          ? context.l10n.loginButton
                          : context.l10n.registerButton,
                    ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _isLoginMode ? context.l10n.noAccount : context.l10n.hasAccount,
                  style: context.textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: () => setState(() => _isLoginMode = !_isLoginMode),
                  child: Text(
                    _isLoginMode
                        ? context.l10n.registerHere
                        : context.l10n.loginHere,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
