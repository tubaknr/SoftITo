/// Emotion / Mood enumeration with emoji and integer scores
enum Mood {
  awesome(emoji: '🤩', score: 5, key: 'awesome'),
  happy(emoji: '😊', score: 4, key: 'happy'),
  calm(emoji: '😌', score: 3, key: 'calm'),
  tired(emoji: '🥱', score: 2, key: 'tired'),
  challenging(emoji: '🤯', score: 1, key: 'challenging');

  const Mood({
    required this.emoji,
    required this.score,
    required this.key,
  });

  final String emoji;
  final int score;
  final String key;

  static Mood fromString(String key) {
    return Mood.values.firstWhere(
      (m) => m.key == key,
      orElse: () => Mood.happy,
    );
  }
}

/// Immutable reflection and awareness note entry
class MoodEntry {
  const MoodEntry({
    required this.mood,
    required this.note,
    required this.recordedAt,
  });

  final Mood mood;
  final String note;
  final DateTime recordedAt;

  MoodEntry copyWith({
    Mood? mood,
    String? note,
    DateTime? recordedAt,
  }) {
    return MoodEntry(
      mood: mood ?? this.mood,
      note: note ?? this.note,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mood': mood.key,
      'note': note,
      'recordedAt': recordedAt.toIso8601String(),
    };
  }

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      mood: Mood.fromString(json['mood'] as String),
      note: (json['note'] as String?) ?? '',
      recordedAt: DateTime.parse(json['recordedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodEntry &&
          runtimeType == other.runtimeType &&
          mood == other.mood &&
          note == other.note &&
          recordedAt == other.recordedAt;

  @override
  int get hashCode => Object.hash(mood, note, recordedAt);
}
