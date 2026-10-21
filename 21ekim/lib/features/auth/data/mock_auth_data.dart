import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

/// SharedPreferences tabanlı yerel Mock Kimlik Doğrulama Servisi.
class MockAuthRepository implements AuthRepository {
  static const List<String> availableCountries = [
    'Türkiye',
    'Amerika Birleşik Devletleri',
    'Almanya',
    'Fransa',
    'İngiltere',
    'Japonya',
    'Kanada',
    'Hollanda',
    'İtalya',
    'İspanya',
    'Brezilya',
    'Avustralya',
    'Güney Kore',
    'İsveç',
    'Norveç',
  ];

  @override
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppConstants.prefKeyUser);
    if (userJson == null || userJson.isEmpty) {
      return null;
    }
    try {
      final map = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required int age,
    required String country,
  }) async {
    final user = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      age: age,
      country: country,
      isPrivate: false,
      registeredAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    );
    await _saveUser(user);
    return user;
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final current = await getCurrentUser();
    if (current != null && current.email.toLowerCase() == email.toLowerCase()) {
      final updated = current.copyWith(lastActiveAt: DateTime.now());
      await _saveUser(updated);
      return updated;
    }

    // İlk defa veya demo girişinde varsayılan kullanıcı oluştur
    final nameFromEmail = email.split('@').first;
    final user = UserModel(
      id: 'user_login_${DateTime.now().millisecondsSinceEpoch}',
      name: nameFromEmail.isNotEmpty
          ? '${nameFromEmail[0].toUpperCase()}${nameFromEmail.substring(1)}'
          : 'Doğa Dostu',
      email: email,
      age: 26,
      country: 'Türkiye',
      isPrivate: false,
      registeredAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    );
    await _saveUser(user);
    return user;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    // Gerçek Google OAuth entegrasyonu hazır olana kadar soyut servis mock kullanıcı döner
    final user = UserModel(
      id: 'google_user_demo',
      name: 'Ece Güneş',
      email: 'ece.gunes@gmail.com',
      age: 28,
      country: 'Türkiye',
      isPrivate: false,
      photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
      registeredAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    );
    await _saveUser(user);
    return user;
  }

  @override
  Future<bool> sendResetCode(String email) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return true;
  }

  @override
  Future<UserModel> updateProfile(UserModel user) async {
    await _saveUser(user);
    return user;
  }

  @override
  Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefKeyUser);
    await prefs.remove(AppConstants.prefKeySessions);
    await prefs.remove(AppConstants.prefKeyLastActive);
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefKeyUser);
  }

  Future<void> _saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(user.toJson());
    await prefs.setString(AppConstants.prefKeyUser, jsonStr);
    await prefs.setString(
      AppConstants.prefKeyLastActive,
      user.lastActiveAt.toIso8601String(),
    );
  }
}
