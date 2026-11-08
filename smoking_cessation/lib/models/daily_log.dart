// ========================================
// DOSYA: daily_log.dart
// NE İŞE YARAR: Günlük sigara içmeme kaydını
// ve tarih formatlayıcısını tanımlar.
// NASIL ÇALIŞIR: Gün, durum, kriz seviyesi ve
// not bilgilerini JSON uyumlu saklar.
// SOLID: SRP - Sadece günlük kayıt verisi
// ve tarih anahtarı yardımcısını barındırır.
// ========================================

// SRP: Tek bir güne ait kayıt verisini tutar.
class DailyLog {
  final String date;
  final bool smokeFree;
  final int? cravingLevel;
  final String? note;

  const DailyLog({
    required this.date,
    required this.smokeFree,
    this.cravingLevel,
    this.note,
  });

  // Kayıt modelini JSON haritasına çevirir.
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'smokeFree': smokeFree,
      'cravingLevel': cravingLevel,
      'note': note,
    };
  }

  // JSON haritasından güvenle model kurar.
  factory DailyLog.fromJson(Map<String, dynamic> json) {
    final rawLevel = (json['cravingLevel'] as num?)?.toInt();
    final clampedLevel = rawLevel?.clamp(1, 5);

    final rawNote = json['note'] as String?;
    final isLong = (rawNote?.length ?? 0) > 200;
    final truncatedNote =
        isLong ? rawNote!.substring(0, 200) : rawNote;

    return DailyLog(
      date: json['date'] as String? ?? '',
      smokeFree: json['smokeFree'] as bool? ?? true,
      cravingLevel: clampedLevel,
      note: truncatedNote,
    );
  }

  // Günlük kaydı klonlayarak günceller.
  DailyLog copyWith({
    String? date,
    bool? smokeFree,
    int? cravingLevel,
    String? note,
  }) {
    return DailyLog(
      date: date ?? this.date,
      smokeFree: smokeFree ?? this.smokeFree,
      cravingLevel: cravingLevel ?? this.cravingLevel,
      note: note ?? this.note,
    );
  }
}

// SRP: Tarih anahtarı ve formatlama yardımcısı.
class DateKey {
  DateKey._();

  // DateTime nesnesini yyyy-MM-dd yapar.
  static String format(DateTime dt) {
    final year = dt.year.toString().padLeft(4, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  // yyyy-MM-dd metnini DateTime nesnesine çevirir.
  static DateTime parse(String dateStr) {
    final parts = dateStr.split('-');
    if (parts.length != 3) return DateTime.now();
    final y = int.tryParse(parts[0]) ?? 2026;
    final m = int.tryParse(parts[1]) ?? 1;
    final d = int.tryParse(parts[2]) ?? 1;
    return DateTime(y, m, d);
  }

  // Verilen tarihin bugün olup olmadığını denetler.
  static bool isToday(String dateStr) {
    return dateStr == format(DateTime.now());
  }

  // Tarihin gelecekte olup olmadığını denetler.
  static bool isFuture(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(dt.year, dt.month, dt.day);
    return target.isAfter(today);
  }
}
