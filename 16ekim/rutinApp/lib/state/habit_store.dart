import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/habit.dart';
import '../utils/date_utils.dart';

/// Uygulamanın tüm durumu ve iş kuralları burada.
/// Hata döndürebilen metotlar `String?` verir: null = başarılı, metin = hata mesajı.
class HabitStore extends ChangeNotifier {
  HabitStore() {
    _seed();
  }

  static const maxHabits = 20;

  final List<Habit> _habits = [];
  int _nextId = 1;
  Habit? _lastDeleted;
  int _lastDeletedIndex = 0;

  List<Habit> get habits => List.unmodifiable(_habits);

  String _newId() => 'h${_nextId++}';

  /// Uygulama boş görünmesin diye geçmişi olan örnek alışkanlıklar.
  void _seed() {
    final t = today();
    Set<String> history(int days, bool Function(int i) rule) {
      final set = <String>{};
      for (var i = 0; i < days; i++) {
        if (rule(i)) set.add(dateKey(addDays(t, -i)));
      }
      return set;
    }

    _habits.addAll([
      Habit(
        id: _newId(),
        name: 'Su iç (2 litre)',
        iconIndex: 0,
        colorIndex: 1,
        weeklyGoal: 7,
        createdAt: addDays(t, -44),
        completed: history(45, (i) => i != 0 && i % 6 != 3),
      ),
      Habit(
        id: _newId(),
        name: '20 sayfa kitap oku',
        iconIndex: 2,
        colorIndex: 3,
        weeklyGoal: 5,
        createdAt: addDays(t, -44),
        completed: history(45, (i) => i % 3 != 1),
      ),
      Habit(
        id: _newId(),
        name: '30 dk yürüyüş',
        iconIndex: 1,
        colorIndex: 2,
        weeklyGoal: 4,
        createdAt: addDays(t, -44),
        completed: history(45, (i) => i % 2 == 1),
      ),
      Habit(
        id: _newId(),
        name: 'Meditasyon',
        iconIndex: 3,
        colorIndex: 5,
        weeklyGoal: 3,
        createdAt: addDays(t, -9),
        completed: history(10, (i) => i != 0 && i % 4 != 2),
      ),
    ]);
  }

  // ---------------------------------------------------------------- Yönetim
  String? _validate({required String name, required int weeklyGoal, String? ignoreId}) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'Bir isim girin.';
    if (trimmed.length > 30) return 'İsim en fazla 30 karakter olabilir.';
    if (weeklyGoal < 1 || weeklyGoal > 7) return 'Haftalık hedef 1 ile 7 arasında olmalı.';
    final exists = _habits.any(
      (h) => h.id != ignoreId && h.name.toLowerCase() == trimmed.toLowerCase(),
    );
    if (exists) return 'Bu isimde bir alışkanlık zaten var.';
    return null;
  }

// ADD HABIT 
  String? addHabit({
    required String name,
    required int iconIndex,
    required int colorIndex,
    required int weeklyGoal,
  }) {
    // VALIDATION 
    if (_habits.length >= maxHabits) return 'En fazla $maxHabits alışkanlık eklenebilir.';
    final error = _validate(name: name, weeklyGoal: weeklyGoal);
    if (error != null) return error;

    _habits.add(Habit(
      id: _newId(),
      name: name.trim(),
      iconIndex: iconIndex,
      colorIndex: colorIndex,
      weeklyGoal: weeklyGoal,
      createdAt: today(),
      completed: <String>{},
    ));
    notifyListeners();
    return null;
  }

// UPDATE HABIT 
  String? updateHabit(
    String id, {
    required String name,
    required int iconIndex,
    required int colorIndex,
    required int weeklyGoal,
  }) {
    // FIND HABIT 
    final index = _habits.indexWhere((h) => h.id == id);
    if (index == -1) return 'Alışkanlık bulunamadı.';
    // VALIDATE
    final error = _validate(name: name, weeklyGoal: weeklyGoal, ignoreId: id);
    if (error != null) return error;
    //UPDATE WITH COPYWITH 
    _habits[index] = _habits[index].copyWith(
      name: name.trim(),
      iconIndex: iconIndex,
      colorIndex: colorIndex,
      weeklyGoal: weeklyGoal,
    );
    notifyListeners();
    return null;
  }

// DELETE HABIT 
  /// Alışkanlığı siler; son silineni "geri al" için hatırlar.
  bool deleteHabit(String id) {
    // FIND HABIT 
    final index = _habits.indexWhere((h) => h.id == id);
    if (index == -1) return false;
    // DELETE 
    _lastDeleted = _habits.removeAt(index);
    _lastDeletedIndex = index;
    notifyListeners();
    return true;
  }

// UNDO DELETE 
  bool undoDelete() {
    final habit = _lastDeleted;
    if (habit == null) return false;
    final index = min(_lastDeletedIndex, _habits.length);
    _habits.insert(index, habit);
    _lastDeleted = null;
    notifyListeners();
    return true;
  }

  /// Bir günün işaretini tersine çevirir (yapıldı <-> yapılmadı).
  String? toggle(String id, DateTime date) {
    // FİND DAY
    final day = dateOnly(date);
    // EDGE CASE
    if (day.isAfter(today())) return 'Gelecekteki günler işaretlenemez.';
    // FIND HABIT 
    final index = _habits.indexWhere((h) => h.id == id);
    if (index == -1) return 'Alışkanlık bulunamadı.';
    final habit = _habits[index];
    // EDGE CASE 
    if (!habit.existsOn(day)) return 'Bu alışkanlık o gün henüz yoktu.';
    final key = dateKey(day);
    // UPDATE 
    final updated = Set<String>.of(habit.completed);
    if (!updated.add(key)) updated.remove(key);
    
    _habits[index] = habit.copyWith(completed: updated);
    notifyListeners();
    return null;
  }

  // ------------------------------------------------------------ Günlük sorgular
  List<Habit> activeOn(DateTime day) => _habits.where((h) => h.existsOn(day)).toList();

  int totalOn(DateTime day) => activeOn(day).length;

  int doneCountOn(DateTime day) =>
      _habits.where((h) => h.existsOn(day) && h.isDoneOn(day)).length;

  double completionOn(DateTime day) {
    final total = totalOn(day);
    return total == 0 ? 0 : doneCountOn(day) / total;
  }

  /// Son [n] günün tamamlama oranları (en eski gün başta).
  List<double> lastDaysCompletion(int n) =>
      [for (var i = n - 1; i >= 0; i--) completionOn(addDays(today(), -i))];

  // ------------------------------------------------------------- Seri ve oranlar
  /// Bugüne (veya bugün yapılmadıysa dünden geriye) kesintisiz kaç gün yapıldı?
  int currentStreak(Habit habit) {
    var day = today();
    if (!habit.isDoneOn(day)) day = addDays(day, -1);
    var count = 0;
    while (habit.isDoneOn(day)) {
      count++;
      day = addDays(day, -1);
    }
    return count;
  }

  /// Şimdiye kadarki en uzun kesintisiz seri.
  int bestStreak(Habit habit) {
    if (habit.completed.isEmpty) return 0;
    final days = habit.completed.map(parseKey).toList()..sort();
    var best = 1;
    var run = 1;
    for (var i = 1; i < days.length; i++) {
      if (sameDay(addDays(days[i - 1], 1), days[i])) {
        run++;
      } else {
        run = 1;
      }
      if (run > best) best = run;
    }
    return best;
  }

  /// Son [days] gün içindeki tamamlama oranı (alışkanlık yokken geçen günler sayılmaz).
  double rate(Habit habit, int days) {
    var counted = 0;
    var done = 0;
    for (var i = 0; i < days; i++) {
      final day = addDays(today(), -i);
      if (!habit.existsOn(day)) continue;
      counted++;
      if (habit.isDoneOn(day)) done++;
    }
    return counted == 0 ? 0 : done / counted;
  }

  /// Bu hafta (Pazartesi'den bugüne) kaç gün yapıldı?
  int doneThisWeek(Habit habit) {
    var count = 0;
    for (var d = startOfWeek(today()); !d.isAfter(today()); d = addDays(d, 1)) {
      if (habit.isDoneOn(d)) count++;
    }
    return count;
  }

  /// Bu haftaki genel tamamlama oranı (tüm alışkanlıklar birlikte).
  double get weekCompletion {
    var done = 0;
    var total = 0;
    for (var d = startOfWeek(today()); !d.isAfter(today()); d = addDays(d, 1)) {
      done += doneCountOn(d);
      total += totalOn(d);
    }
    return total == 0 ? 0 : done / total;
  }

  int get bestStreakOverall => _habits.fold(0, (m, h) => max(m, bestStreak(h)));

  int get totalCompletions => _habits.fold(0, (sum, h) => sum + h.completed.length);
}
