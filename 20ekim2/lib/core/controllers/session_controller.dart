import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserRole {
  guest,
  renter,
  owner,
}

@immutable
class SessionState {
  const SessionState({
    required this.isLoggedIn,
    required this.role,
    this.userId,
    this.userDisplayName,
    this.userEmail,
    this.rememberMe = false,
  });

  final bool isLoggedIn;
  final UserRole role;
  final String? userId;
  final String? userDisplayName;
  final String? userEmail;
  final bool rememberMe;

  static const SessionState guest = SessionState(
    isLoggedIn: false,
    role: UserRole.guest,
  );

  bool get isOwner => isLoggedIn && role == UserRole.owner;
  bool get isRenter => isLoggedIn && role == UserRole.renter;

  SessionState copyWith({
    bool? isLoggedIn,
    UserRole? role,
    String? userId,
    String? userDisplayName,
    String? userEmail,
    bool? rememberMe,
  }) {
    return SessionState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      role: role ?? this.role,
      userId: userId ?? this.userId,
      userDisplayName: userDisplayName ?? this.userDisplayName,
      userEmail: userEmail ?? this.userEmail,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionState &&
          runtimeType == other.runtimeType &&
          isLoggedIn == other.isLoggedIn &&
          role == other.role &&
          userId == other.userId &&
          userDisplayName == other.userDisplayName &&
          userEmail == other.userEmail &&
          rememberMe == other.rememberMe;

  @override
  int get hashCode => Object.hash(
        isLoggedIn,
        role,
        userId,
        userDisplayName,
        userEmail,
        rememberMe,
      );
}

class SessionController extends ValueNotifier<SessionState> {
  SessionController() : super(SessionState.guest) {
    _loadFromPrefs();
  }

  static const String _prefIsLoggedIn = 'kiralago_is_logged_in';
  static const String _prefRole = 'kiralago_user_role';
  static const String _prefUserId = 'kiralago_user_id';
  static const String _prefUserName = 'kiralago_user_name';
  static const String _prefUserEmail = 'kiralago_user_email';

  Future<void> _loadFromPrefs() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool isLoggedIn = prefs.getBool(_prefIsLoggedIn) ?? false;
      if (!isLoggedIn) return;

      final String? roleStr = prefs.getString(_prefRole);
      final UserRole role = roleStr == 'owner'
          ? UserRole.owner
          : (roleStr == 'renter' ? UserRole.renter : UserRole.guest);

      value = SessionState(
        isLoggedIn: true,
        role: role,
        userId: prefs.getString(_prefUserId),
        userDisplayName: prefs.getString(_prefUserName),
        userEmail: prefs.getString(_prefUserEmail),
        rememberMe: true,
      );
    } catch (_) {
      // Hata halinde guest kalır
    }
  }

  Future<void> login({
    required UserRole role,
    required String userId,
    required String displayName,
    required String email,
    bool rememberMe = true,
  }) async {
    value = SessionState(
      isLoggedIn: true,
      role: role,
      userId: userId,
      userDisplayName: displayName,
      userEmail: email,
      rememberMe: rememberMe,
    );

    if (rememberMe) {
      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_prefIsLoggedIn, true);
        await prefs.setString(_prefRole, role == UserRole.owner ? 'owner' : 'renter');
        await prefs.setString(_prefUserId, userId);
        await prefs.setString(_prefUserName, displayName);
        await prefs.setString(_prefUserEmail, email);
      } catch (_) {}
    }
  }

  Future<void> logout() async {
    value = SessionState.guest;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefIsLoggedIn);
      await prefs.remove(_prefRole);
      await prefs.remove(_prefUserId);
      await prefs.remove(_prefUserName);
      await prefs.remove(_prefUserEmail);
    } catch (_) {}
  }
}
