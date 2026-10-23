import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/firebase/firestore_converters.dart';
import '../../../core/services/date_time_service.dart';
import '../../../core/services/local_store.dart';
import '../../badges/models/badge_model.dart';
import '../../home/models/habit_completion.dart';
import '../../reflection/models/mood_entry.dart';
import '../models/habit.dart';
import 'habits_repository.dart';
import 'mock_habits_data.dart';

/// Cloud Firestore-backed HabitsRepository with subcollections and offline caching
class FirestoreHabitsRepository implements HabitsRepository {
  FirestoreHabitsRepository({
    required this.userId,
    required this.firestore,
    required this.localStore,
    required this.dateTimeService,
  });

  final String userId;
  final FirebaseFirestore firestore;
  final LocalStore localStore;
  final DateTimeService dateTimeService;

  // Collection references scoped per user
  CollectionReference<Map<String, dynamic>> get _habitsCol =>
      firestore.collection('users').doc(userId).collection('habits');

  CollectionReference<Map<String, dynamic>> get _completionsCol =>
      firestore.collection('users').doc(userId).collection('completions');

  CollectionReference<Map<String, dynamic>> get _badgesCol =>
      firestore.collection('users').doc(userId).collection('badges');

  String get _localHabitsKey => '${AppConstants.keyHabits}_$userId';
  String get _localCompletionsKey => '${AppConstants.keyCompletions}_$userId';
  String get _localBadgesKey => '${AppConstants.keyBadges}_$userId';

  // -------------------------------------------------------------
  // REAL-TIME STREAMS
  // -------------------------------------------------------------
  Stream<List<Habit>> watchHabits() {
    return _habitsCol.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => FirestoreConverters.habitFromFirestore(doc))
          .toList();
    });
  }

  Stream<List<HabitCompletion>> watchCompletions() {
    return _completionsCol.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => FirestoreConverters.completionFromFirestore(doc))
          .toList();
    });
  }

  Stream<List<BadgeModel>> watchBadges() {
    return _badgesCol.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => FirestoreConverters.badgeFromFirestore(doc))
          .toList();
    });
  }

  // -------------------------------------------------------------
  // HABITS CRUD
  // -------------------------------------------------------------
  @override
  Future<List<Habit>> getHabits() async {
    try {
      final snapshot = await _habitsCol.get();
      if (snapshot.docs.isNotEmpty) {
        final habits = snapshot.docs
            .map((doc) => FirestoreConverters.habitFromFirestore(doc))
            .toList();
        await _cacheHabits(habits);
        return habits;
      }

      // If remote collection is empty, check local cache or seed with defaults
      final cached = await _getCachedHabits();
      if (cached.isNotEmpty) {
        // Sync cached habits to Firestore in background
        _batchSaveHabits(cached);
        return cached;
      }

      // Initial Seed
      final initial = MockHabitsData.initialHabits;
      await _batchSaveHabits(initial);
      await _cacheHabits(initial);
      return initial;
    } catch (e) {
      debugPrint('Firestore getHabits error: $e. Using local cache.');
      final cached = await _getCachedHabits();
      return cached.isNotEmpty ? cached : MockHabitsData.initialHabits;
    }
  }

  @override
  Future<void> saveHabit(Habit habit) async {
    // 1. Update local cache immediately
    final habits = await _getCachedHabits();
    final index = habits.indexWhere((h) => h.id == habit.id);
    if (index >= 0) {
      habits[index] = habit;
    } else {
      habits.add(habit);
    }
    await _cacheHabits(habits);

    // 2. Persist to Firestore
    try {
      await _habitsCol.doc(habit.id).set(
            FirestoreConverters.habitToFirestore(habit),
            SetOptions(merge: true),
          );
    } catch (e) {
      debugPrint('Firestore saveHabit error: $e');
    }
  }

  @override
  Future<void> deleteHabit(String id) async {
    // 1. Update local cache immediately
    final habits = await _getCachedHabits();
    habits.removeWhere((h) => h.id == id);
    await _cacheHabits(habits);

    final completions = await _getCachedCompletions();
    completions.removeWhere((c) => c.habitId == id);
    await _cacheCompletions(completions);

    // 2. Delete from Firestore
    try {
      await _habitsCol.doc(id).delete();

      // Delete associated completions in Firestore
      final compQuery = await _completionsCol.where('habitId', isEqualTo: id).get();
      final batch = firestore.batch();
      for (final doc in compQuery.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Firestore deleteHabit error: $e');
    }
  }

  // -------------------------------------------------------------
  // COMPLETIONS & REFLECTIONS
  // -------------------------------------------------------------
  @override
  Future<List<HabitCompletion>> getCompletions() async {
    try {
      final snapshot = await _completionsCol.get();
      if (snapshot.docs.isNotEmpty) {
        final completions = snapshot.docs
            .map((doc) => FirestoreConverters.completionFromFirestore(doc))
            .toList();
        await _cacheCompletions(completions);
        return completions;
      }

      final cached = await _getCachedCompletions();
      if (cached.isNotEmpty) {
        _batchSaveCompletions(cached);
        return cached;
      }

      // Initial Seed
      final initial = MockHabitsData.initialCompletions(dateTimeService.today());
      await _batchSaveCompletions(initial);
      await _cacheCompletions(initial);
      return initial;
    } catch (e) {
      debugPrint('Firestore getCompletions error: $e. Using local cache.');
      final cached = await _getCachedCompletions();
      return cached.isNotEmpty
          ? cached
          : MockHabitsData.initialCompletions(dateTimeService.today());
    }
  }

  @override
  Future<HabitCompletion?> toggleCompletion(
    String habitId,
    DateTime date, {
    MoodEntry? moodEntry,
  }) async {
    final completions = await getCompletions();
    final normalized = DateTime(date.year, date.month, date.day);
    final dayKey = '${normalized.year}-${normalized.month.toString().padLeft(2, '0')}-${normalized.day.toString().padLeft(2, '0')}';
    final docId = 'cmp_${habitId}_$dayKey';

    final index = completions.indexWhere((c) =>
        c.habitId == habitId &&
        c.date.year == normalized.year &&
        c.date.month == normalized.month &&
        c.date.day == normalized.day);

    if (index >= 0) {
      // Untoggle: remove
      completions.removeAt(index);
      await _cacheCompletions(completions);

      try {
        await _completionsCol.doc(docId).delete();
      } catch (e) {
        debugPrint('Firestore untoggleCompletion error: $e');
      }
      return null;
    } else {
      // Toggle: create
      final completion = HabitCompletion(
        id: docId,
        habitId: habitId,
        date: normalized,
        completedAt: dateTimeService.now(),
        moodEntry: moodEntry,
      );
      completions.add(completion);
      await _cacheCompletions(completions);

      try {
        await _completionsCol.doc(docId).set(
              FirestoreConverters.completionToFirestore(completion),
              SetOptions(merge: true),
            );
      } catch (e) {
        debugPrint('Firestore toggleCompletion error: $e');
      }
      return completion;
    }
  }

  @override
  Future<void> saveReflection(
    String habitId,
    DateTime date,
    MoodEntry entry,
  ) async {
    final completions = await getCompletions();
    final normalized = DateTime(date.year, date.month, date.day);
    final dayKey = '${normalized.year}-${normalized.month.toString().padLeft(2, '0')}-${normalized.day.toString().padLeft(2, '0')}';
    final docId = 'cmp_${habitId}_$dayKey';

    final index = completions.indexWhere((c) =>
        c.habitId == habitId &&
        c.date.year == normalized.year &&
        c.date.month == normalized.month &&
        c.date.day == normalized.day);

    if (index >= 0) {
      completions[index] = completions[index].copyWith(moodEntry: entry);
    } else {
      completions.add(HabitCompletion(
        id: docId,
        habitId: habitId,
        date: normalized,
        completedAt: dateTimeService.now(),
        moodEntry: entry,
      ));
    }
    await _cacheCompletions(completions);

    try {
      await _completionsCol.doc(docId).set({
        'moodEntry': entry.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Firestore saveReflection error: $e');
    }
  }

  // -------------------------------------------------------------
  // BADGES
  // -------------------------------------------------------------
  @override
  Future<List<BadgeModel>> getBadges() async {
    try {
      final snapshot = await _badgesCol.get();
      if (snapshot.docs.isNotEmpty) {
        final badges = snapshot.docs
            .map((doc) => FirestoreConverters.badgeFromFirestore(doc))
            .toList();
        await _cacheBadges(badges);
        return badges;
      }

      final cached = await _getCachedBadges();
      return cached;
    } catch (e) {
      debugPrint('Firestore getBadges error: $e. Using local cache.');
      return _getCachedBadges();
    }
  }

  @override
  Future<void> saveBadge(BadgeModel badge) async {
    final badges = await _getCachedBadges();
    final index = badges.indexWhere((b) => b.id == badge.id);
    if (index >= 0) {
      badges[index] = badge;
    } else {
      badges.add(badge);
    }
    await _cacheBadges(badges);

    try {
      await _badgesCol.doc(badge.id).set(
            FirestoreConverters.badgeToFirestore(badge),
            SetOptions(merge: true),
          );
    } catch (e) {
      debugPrint('Firestore saveBadge error: $e');
    }
  }

  // -------------------------------------------------------------
  // CACHING & BATCH HELPERS
  // -------------------------------------------------------------
  Future<List<Habit>> _getCachedHabits() async {
    final raw = await localStore.getString(_localHabitsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => Habit.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _cacheHabits(List<Habit> habits) async {
    await localStore.setString(
      _localHabitsKey,
      jsonEncode(habits.map((h) => h.toJson()).toList()),
    );
  }

  Future<void> _batchSaveHabits(List<Habit> habits) async {
    try {
      final batch = firestore.batch();
      for (final h in habits) {
        final docRef = _habitsCol.doc(h.id);
        batch.set(docRef, FirestoreConverters.habitToFirestore(h), SetOptions(merge: true));
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Firestore _batchSaveHabits error: $e');
    }
  }

  Future<List<HabitCompletion>> _getCachedCompletions() async {
    final raw = await localStore.getString(_localCompletionsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => HabitCompletion.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _cacheCompletions(List<HabitCompletion> completions) async {
    await localStore.setString(
      _localCompletionsKey,
      jsonEncode(completions.map((c) => c.toJson()).toList()),
    );
  }

  Future<void> _batchSaveCompletions(List<HabitCompletion> completions) async {
    try {
      final batch = firestore.batch();
      for (final c in completions) {
        final docRef = _completionsCol.doc(c.id);
        batch.set(docRef, FirestoreConverters.completionToFirestore(c), SetOptions(merge: true));
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Firestore _batchSaveCompletions error: $e');
    }
  }

  Future<List<BadgeModel>> _getCachedBadges() async {
    final raw = await localStore.getString(_localBadgesKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => BadgeModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _cacheBadges(List<BadgeModel> badges) async {
    await localStore.setString(
      _localBadgesKey,
      jsonEncode(badges.map((b) => b.toJson()).toList()),
    );
  }
}
