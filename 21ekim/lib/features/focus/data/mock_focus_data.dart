import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../models/focus_session_model.dart';
import 'focus_repository.dart';

/// SharedPreferences tabanlı Odaklanma Veri Deposu
class MockFocusRepository implements FocusRepository {
  @override
  Future<List<FocusSessionModel>> getSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(AppConstants.prefKeySessions);
    if (jsonStr == null || jsonStr.isEmpty) {
      // Başlangıç için kullanıcının deneyimini zenginleştiren örnek oturumlar
      final initialSessions = _createSampleInitialSessions();
      await _saveSessionsToPrefs(initialSessions);
      return initialSessions;
    }

    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list
          .map((item) => FocusSessionModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveSession(FocusSessionModel session) async {
    final current = await getSessions();
    final updated = [...current, session];
    await _saveSessionsToPrefs(updated);
    await updateLastActiveTime(DateTime.now());
  }

  @override
  Future<void> clearAllSessions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefKeySessions);
    await updateLastActiveTime(DateTime.now());
  }

  @override
  Future<DateTime?> getLastActiveTime() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(AppConstants.prefKeyLastActive);
    if (str == null) return null;
    return DateTime.tryParse(str);
  }

  @override
  Future<void> updateLastActiveTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefKeyLastActive, time.toIso8601String());
  }

  Future<void> _saveSessionsToPrefs(List<FocusSessionModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString(AppConstants.prefKeySessions, jsonStr);
  }

  List<FocusSessionModel> _createSampleInitialSessions() {
    final now = DateTime.now();
    final sampleDurationsInMinutes = [35, 50, 45, 60, 40, 55, 30]; // Son 7 gün
    final result = <FocusSessionModel>[];

    for (int i = 0; i < sampleDurationsInMinutes.length; i++) {
      final day = now.subtract(Duration(days: 6 - i));
      final durationSec = sampleDurationsInMinutes[i] * 60;
      final dayStr =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

      result.add(
        FocusSessionModel(
          id: 'initial_session_$i',
          startTime: day,
          durationSeconds: durationSec,
          dayString: dayStr,
        ),
      );
    }
    return result;
  }
}
