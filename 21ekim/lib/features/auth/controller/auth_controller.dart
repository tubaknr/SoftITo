import 'package:flutter/foundation.dart';
import '../data/auth_repository.dart';
import '../data/mock_auth_data.dart';
import '../models/user_model.dart';

/// Kimlik doğrulama form doğrulama sonuç modeli
class RegisterValidationResult {
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? ageError;
  final String? countryError;

  const RegisterValidationResult({
    this.nameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.ageError,
    this.countryError,
  });

  bool get isValid =>
      nameError == null &&
      emailError == null &&
      passwordError == null &&
      confirmPasswordError == null &&
      ageError == null &&
      countryError == null;
}

/// Saf Dart ve Foundation tabanlı AuthController.
class AuthController extends ValueNotifier<UserModel?> {
  final AuthRepository _repository;

  AuthController({AuthRepository? repository})
      : _repository = repository ?? MockAuthRepository(),
        super(null);

  static final AuthController instance = AuthController();

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  Future<void> init() async {
    final user = await _repository.getCurrentUser();
    value = user;
  }

  // --- Doğrulama Kuralları (Saf Dart & Birim Test Edilebilir) ---

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Lütfen şifrenizi giriniz.';
    }
    if (password.length < 8) {
      return 'Şifre en az 8 karakter olmalıdır.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'En az 1 büyük harf içermelidir.';
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'En az 1 küçük harf içermelidir.';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'En az 1 sembol içermelidir.';
    }
    return null;
  }

  static String? validateConfirmPassword(
      String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Lütfen şifre doğrulamasını giriniz.';
    }
    if (password != confirmPassword) {
      return 'Şifreler eşleşmiyor.';
    }
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Lütfen email adresinizi giriniz.';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email.trim())) {
      return 'Geçerli bir email adresi giriniz.';
    }
    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Lütfen adınızı veya takma adınızı giriniz.';
    }
    if (name.trim().length < 2) {
      return 'İsim en az 2 karakter olmalıdır.';
    }
    return null;
  }

  static String? validateAge(String? ageStr) {
    if (ageStr == null || ageStr.trim().isEmpty) {
      return 'Lütfen yaşınızı giriniz.';
    }
    final parsed = int.tryParse(ageStr.trim());
    if (parsed == null || parsed <= 0 || parsed > 120) {
      return 'Lütfen geçerli bir yaş giriniz.';
    }
    return null;
  }

  static String? validateCountry(String? country) {
    if (country == null || country.trim().isEmpty) {
      return 'Lütfen bir ülke seçiniz.';
    }
    return null;
  }

  RegisterValidationResult validateRegisterForm({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String age,
    required String country,
  }) {
    return RegisterValidationResult(
      nameError: validateName(name),
      emailError: validateEmail(email),
      passwordError: validatePassword(password),
      confirmPasswordError: validateConfirmPassword(password, confirmPassword),
      ageError: validateAge(age),
      countryError: validateCountry(country),
    );
  }

  // --- Eylemler ---

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required int age,
    required String country,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final user = await _repository.register(
        name: name,
        email: email,
        password: password,
        age: age,
        country: country,
      );
      value = user;
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final user = await _repository.login(email: email, password: password);
      value = user;
      return true;
    } catch (e) {
      errorMessage.value = 'E-posta veya şifre hatalı.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signInWithGoogle() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final user = await _repository.signInWithGoogle();
      value = user;
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> sendResetCode(String email) async {
    return await _repository.sendResetCode(email);
  }

  Future<void> updateProfile({
    String? name,
    int? age,
    String? country,
    bool? isPrivate,
    String? photoUrl,
  }) async {
    if (value == null) return;
    final updated = value!.copyWith(
      name: name,
      age: age,
      country: country,
      isPrivate: isPrivate,
      photoUrl: photoUrl,
    );
    await _repository.updateProfile(updated);
    value = updated;
  }

  Future<void> togglePrivacy(bool isPrivate) async {
    await updateProfile(isPrivate: isPrivate);
  }

  Future<void> deleteAccount() async {
    await _repository.deleteAccount();
    value = null;
  }

  Future<void> logout() async {
    await _repository.logout();
    value = null;
  }
}
