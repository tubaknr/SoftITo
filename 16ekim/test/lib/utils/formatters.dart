const _months = [
  'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
  'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
];

/// 1234.5 -> "1.234,50" (Türkçe sayı formatı, ek paket gerektirmez).
String formatNumber(double value, {int decimals = 2}) {
  final negative = value < 0;
  final fixed = value.abs().toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final intPart = parts[0];
  final buffer = StringBuffer();
  for (var i = 0; i < intPart.length; i++) {
    final remaining = intPart.length - i;
    buffer.write(intPart[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write('.');
  }
  final decimalPart = decimals > 0 ? ',${parts[1]}' : '';
  return '${negative ? '-' : ''}$buffer$decimalPart';
}

String formatTry(double value) => '₺ ${formatNumber(value)}';

/// "Bugün, 10:32" / "Dün, 16:48" / "14 Ekim, 12:10"
String formatDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(date.year, date.month, date.day);
  final diff = today.difference(day).inDays;
  final time =
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  if (diff == 0) return 'Bugün, $time';
  if (diff == 1) return 'Dün, $time';
  return '${date.day} ${_months[date.month - 1]}, $time';
}

/// Kullanıcının yazdığı metni sayıya çevirir. "1.500,50" ve "0.018" kabul edilir.
double? parseAmount(String? input) {
  if (input == null) return null;
  var text = input.trim().replaceAll(' ', '');
  if (text.isEmpty) return null;
  if (text.contains(',')) {
    text = text.replaceAll('.', '').replaceAll(',', '.');
  }
  return double.tryParse(text);
}

String? validateAmount(String? value) {
  final amount = parseAmount(value);
  if (amount == null) return 'Geçerli bir tutar girin.';
  if (amount <= 0) return 'Tutar sıfırdan büyük olmalı.';
  return null;
}

double roundMoney(double value) => (value * 100).round() / 100;
