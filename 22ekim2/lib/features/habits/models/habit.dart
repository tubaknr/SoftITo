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

  String displayTitle([bool isTr = true]) {
    if (isTr) {
      switch (id) {
        case 'h_water':
          return 'Günlük 2 Litre Su İç 💧';
        case 'h_book':
          return '20 Sayfa Kitap Oku 📖';
        case 'h_walk':
          return '30 Dakika Yürüyüş & Temiz Hava 🏃';
        case 'h_meditation':
          return 'Sabah Meditasyonu & Nefes 🧘';
        case 'h_code':
          return 'Temiz Kod Pratiği 💻';
      }
      return title;
    } else {
      switch (id) {
        case 'h_water':
          return 'Drink 2L Water Daily 💧';
        case 'h_book':
          return 'Read 20 Pages 📖';
        case 'h_walk':
          return '30 Min Walk & Fresh Air 🏃';
        case 'h_meditation':
          return 'Morning Meditation & Breathing 🧘';
        case 'h_code':
          return 'Clean Code Practice 💻';
      }
      final lower = title.toLowerCase();
      if (lower.contains('su iç') || lower.contains('2 litre')) return 'Drink 2L Water Daily 💧';
      if (lower.contains('kitap') || lower.contains('sayfa')) return 'Read 20 Pages 📖';
      if (lower.contains('yürüyüş') || lower.contains('temiz hava')) return '30 Min Walk & Fresh Air 🏃';
      if (lower.contains('meditasyon') || lower.contains('nefes')) return 'Morning Meditation & Breathing 🧘';
      if (lower.contains('kod pratiği') || lower.contains('temiz kod')) return 'Clean Code Practice 💻';
      return title;
    }
  }

  String displayDescription([bool isTr = true]) {
    if (isTr) {
      switch (id) {
        case 'h_water':
          return 'Vücudunu canlı ve enerjik tutmak için düzenli su tüket.';
        case 'h_book':
          return 'Yeni ufuklar keşfetmek için sakin bir okuma seansı.';
        case 'h_walk':
          return 'Zihnini boşalt, penguen gibi adımlarını sıklaştır.';
        case 'h_meditation':
          return 'Dingin bir gün başlangıcı için 10 dakika nefes egzersizi.';
        case 'h_code':
          return 'Mimariye sadık kalarak bir modülü gözden geçir ve geliştir.';
      }
      return description;
    } else {
      switch (id) {
        case 'h_water':
          return 'Stay hydrated and energetic with regular water intake.';
        case 'h_book':
          return 'A calm reading session to discover new horizons.';
        case 'h_walk':
          return 'Clear your mind, take quick steps like a penguin.';
        case 'h_meditation':
          return 'A 10-minute breathing exercise for a serene start to the day.';
        case 'h_code':
          return 'Review and improve a module sticking to clean architecture.';
      }
      return description;
    }
  }

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
