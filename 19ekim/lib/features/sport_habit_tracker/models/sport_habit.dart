class SportHabit {
  const SportHabit({
    required this.id,
    required this.title,
    required this.targetDaysPerWeek,
    required this.completedDayIndices,
    this.currentStreak = 0,
  });

  final String id;
  final String title;
  final int targetDaysPerWeek;
  final Set<int> completedDayIndices; // 0: Pzt, 1: Sal, ..., 6: Paz
  final int currentStreak;

  int get completedThisWeekCount => completedDayIndices.length;

  bool get isWeeklyTargetReached =>
      completedThisWeekCount >= targetDaysPerWeek;

  double get weeklyProgressRatio {
    if (targetDaysPerWeek <= 0) return 0.0;
    final ratio = completedThisWeekCount / targetDaysPerWeek;
    return ratio > 1.0 ? 1.0 : ratio;
  }

  SportHabit copyWith({
    String? id,
    String? title,
    int? targetDaysPerWeek,
    Set<int>? completedDayIndices,
    int? currentStreak,
  }) {
    return SportHabit(
      id: id ?? this.id,
      title: title ?? this.title,
      targetDaysPerWeek: targetDaysPerWeek ?? this.targetDaysPerWeek,
      completedDayIndices: completedDayIndices ?? this.completedDayIndices,
      currentStreak: currentStreak ?? this.currentStreak,
    );
  }
}
