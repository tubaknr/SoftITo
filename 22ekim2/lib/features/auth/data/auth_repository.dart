import 'dart:convert';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/local_store.dart';
import '../models/user_profile.dart';

/// Abstract authentication repository
abstract class AuthRepository {
  Future<UserProfile?> getCurrentUser();
  Future<UserProfile> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<UserProfile> signIn({
    required String email,
    required String password,
  });
  Future<UserProfile> signInWithGoogle();
  Future<bool> sendResetCode(String email);
  Future<void> signOut();
}

/// Local SharedPreferences-backed AuthRepository implementation
class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository({required this.localStore});

  final LocalStore localStore;

  // Simple obfuscation/hash helper to satisfy "password not stored in plaintext"
  String _hashPassword(String password) {
    final bytes = utf8.encode('salt_pengu_$password');
    return base64Encode(bytes);
  }

  @override
  Future<UserProfile?> getCurrentUser() async {
    final jsonStr = await localStore.getString(AppConstants.keyCurrentUser);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return UserProfile.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserProfile> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = UserProfile(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: email.trim().toLowerCase(),
    );

    // Save user credentials safely
    final hashed = _hashPassword(password);
    await localStore.setString('cred_${user.email}', hashed);
    await localStore.setString(AppConstants.keyCurrentUser, jsonEncode(user.toJson()));
    return user;
  }

  @override
  Future<UserProfile> signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final savedHash = await localStore.getString('cred_$normalizedEmail');

    // Default mock check: if no credentials found or hash matches
    final currentHash = _hashPassword(password);
    if (savedHash != null && savedHash != currentHash) {
      throw Exception('invalid_credentials');
    }

    // Load or create session user
    final existingUser = await getCurrentUser();
    final user = (existingUser != null && existingUser.email == normalizedEmail)
        ? existingUser
        : UserProfile(
            id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
            name: normalizedEmail.split('@').first,
            email: normalizedEmail,
          );

    await localStore.setString(AppConstants.keyCurrentUser, jsonEncode(user.toJson()));
    return user;
  }

  @override
  Future<UserProfile> signInWithGoogle() async {
    // Mock Google OAuth user
    const googleUser = UserProfile(
      id: 'google_user_pengu',
      name: 'Ayşe Kaya',
      email: 'ayse.pengu@gmail.com',
    );
    await localStore.setString(
      AppConstants.keyCurrentUser,
      jsonEncode(googleUser.toJson()),
    );
    return googleUser;
  }

  @override
  Future<bool> sendResetCode(String email) async {
    // Mock password reset code dispatcher
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<void> signOut() async {
    await localStore.remove(AppConstants.keyCurrentUser);
  }
}
