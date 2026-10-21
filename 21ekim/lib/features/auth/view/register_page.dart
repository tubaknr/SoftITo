import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/fg_buttons.dart';
import '../../../core/widgets/fg_text_field.dart';
import '../../../core/widgets/fg_top_bar.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../controller/auth_controller.dart';
import '../data/mock_auth_data.dart';
import 'welcome_transition_page.dart';

/// Kayıt Ol Sayfası
class RegisterPage extends StatefulWidget {
  final VoidCallback onRegisterSuccess;

  const RegisterPage({
    super.key,
    required this.onRegisterSuccess,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedCountry = 'Türkiye';

  RegisterValidationResult _validation = const RegisterValidationResult();
  bool _submittedOnce = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _validate() {
    setState(() {
      _validation = AuthController.instance.validateRegisterForm(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        age: _ageController.text,
        country: _selectedCountry,
      );
    });
  }

  Future<void> _handleRegister() async {
    _submittedOnce = true;
    _validate();
    if (!_validation.isValid) return;

    final success = await AuthController.instance.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      age: int.parse(_ageController.text.trim()),
      country: _selectedCountry,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => WelcomeTransitionPage(
            userName: _nameController.text.trim(),
            onProceed: widget.onRegisterSuccess,
          ),
        ),
      );
    }
  }

  void _openCountryPicker() {
    final isDark = context.isDark;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark ? AppColors.darkCardSurface : const Color(0xFFFFFDF8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  context.loc.selectCountry,
                  style: AppTypography.heading2(isDark: isDark),
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: MockAuthRepository.availableCountries.length,
                  itemBuilder: (context, index) {
                    final country = MockAuthRepository.availableCountries[index];
                    final isSelected = country == _selectedCountry;

                    return ListTile(
                      title: Text(
                        country,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? AppColors.dustyRoseAccent
                              : (isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textCharcoal),
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.dustyRoseAccent,
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedCountry = country;
                          if (_submittedOnce) _validate();
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık
              Text(
                loc.registerTitle,
                style: AppTypography.heading1Light(isDark: isDark),
              ),
              const SizedBox(height: 20),

              // 1. İsim
              FGTextField(
                controller: _nameController,
                label: loc.nameLabel,
                placeholder: 'Mahmut Yılmaz',
                errorText: _validation.nameError,
                onChanged: (_) {
                  if (_submittedOnce) _validate();
                },
              ),
              const SizedBox(height: 14),

              // 2. E-posta
              FGTextField(
                controller: _emailController,
                label: loc.emailLabel,
                placeholder: 'ornek@email.com',
                keyboardType: TextInputType.emailAddress,
                errorText: _validation.emailError,
                onChanged: (_) {
                  if (_submittedOnce) _validate();
                },
              ),
              const SizedBox(height: 14),

              // 3. Şifre
              FGTextField(
                controller: _passwordController,
                label: loc.passwordLabel,
                placeholder: '••••••••',
                obscureText: true,
                errorText: _validation.passwordError,
                onChanged: (_) {
                  if (_submittedOnce) _validate();
                },
              ),
              const SizedBox(height: 14),

              // 4. Şifre Doğrulama
              FGTextField(
                controller: _confirmPasswordController,
                label: loc.confirmPasswordLabel,
                placeholder: '••••••••',
                obscureText: true,
                errorText: _validation.confirmPasswordError,
                onChanged: (_) {
                  if (_submittedOnce) _validate();
                },
              ),
              const SizedBox(height: 14),

              // 5. Yaş
              FGTextField(
                controller: _ageController,
                label: loc.ageLabel,
                placeholder: '25',
                keyboardType: TextInputType.number,
                errorText: _validation.ageError,
                onChanged: (_) {
                  if (_submittedOnce) _validate();
                },
              ),
              const SizedBox(height: 14),

              // 6. Ülke Seçici
              FGTextField(
                label: loc.countryLabel,
                readOnly: true,
                placeholder: _selectedCountry,
                controller: TextEditingController(text: _selectedCountry),
                suffixIcon: const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: AppColors.dustyRoseAccent,
                  size: 28,
                ),
                onTap: _openCountryPicker,
              ),
              const SizedBox(height: 28),

              // 7. Kaydol Butonu
              ValueListenableBuilder<bool>(
                valueListenable: AuthController.instance.isLoading,
                builder: (context, isLoading, _) {
                  return PrimaryPillButton(
                    text: loc.signUpButton,
                    isLoading: isLoading,
                    onPressed: _handleRegister,
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
