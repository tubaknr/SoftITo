import '../models/focus_session_model.dart';

/// Odaklanma kayıtları için soyut Repository arayüzü.
abstract class FocusRepository {
  Future<List<FocusSessionModel>> getSessions();
  Future<void> saveSession(FocusSessionModel session);
  Future<void> clearAllSessions();
  Future<DateTime?> getLastActiveTime();
  Future<void> updateLastActiveTime(DateTime time);
}
