class ActivityTrackerModel {
  final String id;
  final String title;
  final int value;
  final bool isCompleted;
  final DateTime lastUpdated;

  const ActivityTrackerModel({
    required this.id,
    required this.title,
    required this.value,
    required this.isCompleted,
    required this.lastUpdated,
  });

  ActivityTrackerModel copyWith({
    String? id,
    String? title,
    int? value,
    bool? isCompleted,
    DateTime? lastUpdated,
  }) {
    return ActivityTrackerModel(
      id: id ?? this.id,
      title: title ?? this.title,
      value: value ?? this.value,
      isCompleted: isCompleted ?? this.isCompleted,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  factory ActivityTrackerModel.fromJson(Map<String, dynamic> json) {
    return ActivityTrackerModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      value: (json['value'] as num?)?.toInt() ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'isCompleted': isCompleted,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
