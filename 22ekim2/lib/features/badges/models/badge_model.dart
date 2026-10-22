/// Immutable badge award model
class BadgeModel {
  const BadgeModel({
    required this.id,
    required this.level,
    required this.title,
    required this.earnedAt,
    this.habitId,
    this.description = '',
  });

  final String id;
  final int level; // e.g. 21 (Silver), 42 (Gold), 66 (Diamond), 84 (Master) or micro-step: 5, 10, 15...
  final String title;
  final DateTime earnedAt;
  final String? habitId;
  final String description;

  BadgeModel copyWith({
    String? id,
    int? level,
    String? title,
    DateTime? earnedAt,
    String? habitId,
    String? description,
  }) {
    return BadgeModel(
      id: id ?? this.id,
      level: level ?? this.level,
      title: title ?? this.title,
      earnedAt: earnedAt ?? this.earnedAt,
      habitId: habitId ?? this.habitId,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'title': title,
      'earnedAt': earnedAt.toIso8601String(),
      'habitId': habitId,
      'description': description,
    };
  }

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] as String,
      level: json['level'] as int,
      title: json['title'] as String,
      earnedAt: DateTime.parse(json['earnedAt'] as String),
      habitId: json['habitId'] as String?,
      description: (json['description'] as String?) ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BadgeModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          level == other.level &&
          title == other.title &&
          habitId == other.habitId;

  @override
  int get hashCode => Object.hash(id, level, title, habitId);
}
