import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';
import '../data/auth_repository.dart';
import '../models/user_profile.dart';

/// Pure Dart controller for Authentication & Profile Session
class AuthController {
  AuthController({required this.repository});

  final AuthRepository repository;

  final ValueNotifier<UserProfile?> currentUser = ValueNotifier<UserProfile?>(null);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  Future<void> init() async {
    isLoading.value = true;
    try {
      final user = await repository.getCurrentUser();
      currentUser.value = user;
    } finally {
      isLoading.value = false;
    }
  }

  // --- Form Validation Methods ---
  static bool isValidName(String name) {
    return name.trim().isNotEmpty;
  }

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$',
    );
    return emailRegex.hasMatch(email.trim());
  }

  static bool isValidPassword(String password) {
    return password.length >= AppConstants.minPasswordLength;
  }

  static bool doPasswordsMatch(String p1, String p2) {
    return p1 == p2;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      final user = await repository.signUp(
        name: name,
        email: email,
        password: password,
      );
      currentUser.value = user;
      return true;
    } catch (_) {
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
    try {
      final user = await repository.signIn(
        email: email,
        password: password,
      );
      currentUser.value = user;
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> loginWithGoogle() async {
    isLoading.value = true;
    try {
      final user = await repository.signInWithGoogle();
      currentUser.value = user;
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    if (!isValidEmail(email)) return false;
    isLoading.value = true;
    try {
      return await repository.sendResetCode(email);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await repository.signOut();
    currentUser.value = null;
  }

  void dispose() {
    currentUser.dispose();
    isLoading.dispose();
  }
}
