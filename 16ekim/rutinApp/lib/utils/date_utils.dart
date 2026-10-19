const _weekdaysShort = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
const _weekdaysFull = [
  'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar',
];
const _months = [
  'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
  'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
];

/// Saat bilgisini atar, sadece günü bırakır (00:00).
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime today() => dateOnly(DateTime.now());

/// Ay sonlarını ve yaz saati geçişlerini doğru yöneten gün ekleme.
DateTime addDays(DateTime d, int days) => DateTime(d.year, d.month, d.day + days);

bool sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Bir günü "2026-10-16" biçiminde anahtara çevirir (tamamlanan günler bu anahtarla saklanır).
String dateKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

DateTime parseKey(String key) {
  final parts = key.split('-');
  return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
}

String weekdayShort(DateTime d) => _weekdaysShort[d.weekday - 1];
String weekdayFull(DateTime d) => _weekdaysFull[d.weekday - 1];

/// "16 Ekim Cuma"
String formatLongDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${weekdayFull(d)}';

/// Haftanın başlangıcı (Pazartesi).
DateTime startOfWeek(DateTime d) => addDays(dateOnly(d), -(d.weekday - 1));

String greeting() {
  final hour = DateTime.now().hour;
  if (hour < 6) return 'İyi geceler';
  if (hour < 12) return 'Günaydın';
  if (hour < 18) return 'İyi günler';
  return 'İyi akşamlar';
}
