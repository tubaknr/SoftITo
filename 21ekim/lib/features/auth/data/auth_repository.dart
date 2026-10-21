import '../models/user_model.dart';

/// Kimlik doğrulama ve kullanıcı oturumu için soyut Repository arayüzü.
abstract class AuthRepository {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required int age,
    required String country,
  });
  Future<UserModel> login({
    required String email,
    required String password,
  });
  Future<UserModel> signInWithGoogle();
  Future<bool> sendResetCode(String email);
  Future<UserModel> updateProfile(UserModel user);
  Future<void> deleteAccount();
  Future<void> logout();
}
