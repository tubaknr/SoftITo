import 'package:shared_preferences/shared_preferences.dart';

/// Abstract storage interface to abstract away SharedPreferences
abstract class LocalStore {
  Future<String?> getString(String key);
  Future<bool> setString(String key, String value);
  Future<bool> remove(String key);
  Future<bool> clear();
}

/// Production implementation backed by SharedPreferences
class SharedPreferencesLocalStore implements LocalStore {
  const SharedPreferencesLocalStore();

  @override
  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Future<bool> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  @override
  Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  @override
  Future<bool> clear() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}

/// In-memory implementation for deterministic unit & widget tests
class MockLocalStore implements LocalStore {
  final Map<String, String> _data = {};

  @override
  Future<String?> getString(String key) async => _data[key];

  @override
  Future<bool> setString(String key, String value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    _data.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    _data.clear();
    return true;
  }
}
