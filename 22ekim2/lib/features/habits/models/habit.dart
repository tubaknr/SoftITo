/// Immutable habit definition model
class Habit {
  const Habit({
    required this.id,
    required this.title,
    this.description = '',
    required this.repeatDays,
    this.reminderTime,
    this.colorIndex = 0,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final List<int> repeatDays; // 1 = Monday, ..., 7 = Sunday
  final String? reminderTime; // e.g. "08:30"
  final int colorIndex;
  final DateTime createdAt;

  bool isScheduledForWeekday(int weekday) {
    return repeatDays.contains(weekday);
  }

  bool get isEveryday => repeatDays.length == 7;

  Habit copyWith({
    String? id,
    String? title,
    String? description,
    List<int>? repeatDays,
    String? reminderTime,
    int? colorIndex,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      repeatDays: repeatDays ?? List<int>.from(this.repeatDays),
      reminderTime: reminderTime ?? this.reminderTime,
      colorIndex: colorIndex ?? this.colorIndex,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'repeatDays': repeatDays,
      'reminderTime': reminderTime,
      'colorIndex': colorIndex,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      title: json['title'] as String,
      description: (json['description'] as String?) ?? '',
      repeatDays: (json['repeatDays'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      reminderTime: json['reminderTime'] as String?,
      colorIndex: (json['colorIndex'] as int?) ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Habit &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          colorIndex == other.colorIndex &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(id, title, description, colorIndex, createdAt);
}
