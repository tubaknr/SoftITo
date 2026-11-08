// ========================================
// DOSYA: storage_service.dart
// NE İŞE YARAR: Veriyi cihazda yerel anahtar-
// değer olarak saklar ve okur.
// NASIL ÇALIŞIR: SharedPreferences paketini
// soyutlayarak string saklar.
// SOLID: ISP & DIP - Küçük soyut arayüz,
// somut implementasyonlardan ayrılmıştır.
// ========================================

import 'package:shared_preferences/shared_preferences.dart';

// ISP & DIP: Saklama için küçük soyut arayüz.
abstract class StorageService {
  Future<String?> readString(String key);
  Future<bool> writeString(String key, String value);
  Future<bool> remove(String key);
  Future<bool> clear();
}

// LSP: SharedPreferences somut gerçeklemesi.
class SharedPrefsStorageService implements StorageService {
  final SharedPreferences _prefs;

  SharedPrefsStorageService(this._prefs);

  @override
  Future<String?> readString(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<bool> writeString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  @override
  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  @override
  Future<bool> clear() async {
    return _prefs.clear();
  }
}

// LSP: Testler ve çevrimdışı hafıza deposu.
class InMemoryStorageService implements StorageService {
  final Map<String, String> _data = {};

  @override
  Future<String?> readString(String key) async {
    return _data[key];
  }

  @override
  Future<bool> writeString(String key, String value) async {
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
