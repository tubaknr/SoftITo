import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/auth/models/user_profile.dart';
import '../../features/badges/models/badge_model.dart';
import '../../features/habits/models/habit.dart';
import '../../features/home/models/habit_completion.dart';
import '../../features/reflection/models/mood_entry.dart';

/// Helper utilities for serializing and deserializing domain models to/from Cloud Firestore
class FirestoreConverters {
  // -------------------------------------------------------------
  // USER PROFILE
  // -------------------------------------------------------------
  static Map<String, dynamic> userProfileToFirestore(UserProfile profile) {
    return {
      'id': profile.id,
      'name': profile.name,
      'email': profile.email,
      'avatarUrl': profile.avatarUrl,
      'languageCode': profile.languageCode,
      'isDarkMode': profile.isDarkMode,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static UserProfile userProfileFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};
    return UserProfile(
      id: (data['id'] as String?) ?? snapshot.id,
      name: (data['name'] as String?) ?? 'Kullanıcı',
      email: (data['email'] as String?) ?? '',
      avatarUrl: data['avatarUrl'] as String?,
      languageCode: (data['languageCode'] as String?) ?? 'tr',
      isDarkMode: (data['isDarkMode'] as bool?) ?? false,
    );
  }

  // -------------------------------------------------------------
  // HABIT
  // -------------------------------------------------------------
  static Map<String, dynamic> habitToFirestore(Habit habit) {
    return {
      'id': habit.id,
      'title': habit.title,
      'description': habit.description,
      'repeatDays': habit.repeatDays,
      'reminderTime': habit.reminderTime,
      'colorIndex': habit.colorIndex,
      'createdAt': Timestamp.fromDate(habit.createdAt),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static Habit habitFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};
    final id = (data['id'] as String?) ?? snapshot.id;
    final title = (data['title'] as String?) ?? '';
    final description = (data['description'] as String?) ?? '';
    final repeatDaysRaw = data['repeatDays'] as List<dynamic>?;
    final repeatDays = repeatDaysRaw != null
        ? repeatDaysRaw.map((e) => (e as num).toInt()).toList()
        : <int>[1, 2, 3, 4, 5, 6, 7];

    final reminderTime = data['reminderTime'] as String?;
    final colorIndex = (data['colorIndex'] as num?)?.toInt() ?? 0;

    DateTime createdAt = DateTime.now();
    if (data['createdAt'] is Timestamp) {
      createdAt = (data['createdAt'] as Timestamp).toDate();
    } else if (data['createdAt'] is String) {
      createdAt = DateTime.tryParse(data['createdAt'] as String) ?? DateTime.now();
    }

    return Habit(
      id: id,
      title: title,
      description: description,
      repeatDays: repeatDays,
      reminderTime: reminderTime,
      colorIndex: colorIndex,
      createdAt: createdAt,
    );
  }

  // -------------------------------------------------------------
  // HABIT COMPLETION
  // -------------------------------------------------------------
  static Map<String, dynamic> completionToFirestore(HabitCompletion completion) {
    return {
      'id': completion.id,
      'habitId': completion.habitId,
      'date': completion.date.toIso8601String(),
      'dateKey': _formatDayKey(completion.date),
      'completedAt': Timestamp.fromDate(completion.completedAt),
      'moodEntry': completion.moodEntry?.toJson(),
    };
  }

  static HabitCompletion completionFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};
    final id = (data['id'] as String?) ?? snapshot.id;
    final habitId = (data['habitId'] as String?) ?? '';

    DateTime date = DateTime.now();
    if (data['date'] is String) {
      date = DateTime.tryParse(data['date'] as String) ?? DateTime.now();
    } else if (data['date'] is Timestamp) {
      date = (data['date'] as Timestamp).toDate();
    }

    DateTime completedAt = DateTime.now();
    if (data['completedAt'] is Timestamp) {
      completedAt = (data['completedAt'] as Timestamp).toDate();
    } else if (data['completedAt'] is String) {
      completedAt = DateTime.tryParse(data['completedAt'] as String) ?? DateTime.now();
    }

    MoodEntry? moodEntry;
    if (data['moodEntry'] != null && data['moodEntry'] is Map) {
      try {
        moodEntry = MoodEntry.fromJson(
          Map<String, dynamic>.from(data['moodEntry'] as Map),
        );
      } catch (_) {}
    }

    return HabitCompletion(
      id: id,
      habitId: habitId,
      date: date,
      completedAt: completedAt,
      moodEntry: moodEntry,
    );
  }

  // -------------------------------------------------------------
  // BADGE MODEL
  // -------------------------------------------------------------
  static Map<String, dynamic> badgeToFirestore(BadgeModel badge) {
    return {
      'id': badge.id,
      'level': badge.level,
      'title': badge.title,
      'description': badge.description,
      'habitId': badge.habitId,
      'earnedAt': Timestamp.fromDate(badge.earnedAt),
    };
  }

  static BadgeModel badgeFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};
    final id = (data['id'] as String?) ?? snapshot.id;
    final level = (data['level'] as num?)?.toInt() ?? 0;
    final title = (data['title'] as String?) ?? '';
    final description = (data['description'] as String?) ?? '';
    final habitId = data['habitId'] as String?;

    DateTime earnedAt = DateTime.now();
    if (data['earnedAt'] is Timestamp) {
      earnedAt = (data['earnedAt'] as Timestamp).toDate();
    } else if (data['earnedAt'] is String) {
      earnedAt = DateTime.tryParse(data['earnedAt'] as String) ?? DateTime.now();
    }

    return BadgeModel(
      id: id,
      level: level,
      title: title,
      earnedAt: earnedAt,
      habitId: habitId,
      description: description,
    );
  }

  static String _formatDayKey(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }
}
