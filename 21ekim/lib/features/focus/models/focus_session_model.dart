/// Odaklanma oturumu veri modeli (Immutable).
class FocusSessionModel {
  final String id;
  final DateTime startTime;
  final int durationSeconds;
  final String dayString; // YYYY-MM-DD

  const FocusSessionModel({
    required this.id,
    required this.startTime,
    required this.durationSeconds,
    required this.dayString,
  });

  FocusSessionModel copyWith({
    String? id,
    DateTime? startTime,
    int? durationSeconds,
    String? dayString,
  }) {
    return FocusSessionModel(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      dayString: dayString ?? this.dayString,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'durationSeconds': durationSeconds,
      'dayString': dayString,
    };
  }

  factory FocusSessionModel.fromJson(Map<String, dynamic> json) {
    return FocusSessionModel(
      id: json['id'] as String? ?? '',
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'] as String)
          : DateTime.now(),
      durationSeconds: json['durationSeconds'] as int? ?? 0,
      dayString: json['dayString'] as String? ?? '',
    );
  }
}
