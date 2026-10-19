class WorkoutItem {
  const WorkoutItem({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.completedAt,
  });

  final String id;
  final String title;
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime completedAt;
}
