// ========================================
// DOSYA: user_profile.dart
// NE İŞE YARAR: Kullanıcı profili ve genel
// uygulama ayar modellerini tanımlar.
// NASIL ÇALIŞIR: JSON serileştirme ve
// doğrulama metotlarıyla veri tutar.
// SOLID: SRP - Sadece profil ve ayar
// verilerini temsil etme görevi vardır.
// ========================================

// SRP: Kullanıcı profil verisini tutar.
class UserProfile {
  final DateTime quitDateTime;
  final int cigarettesPerDay;
  final double packPrice;
  final int cigarettesPerPack;

  const UserProfile({
    required this.quitDateTime,
    required this.cigarettesPerDay,
    required this.packPrice,
    required this.cigarettesPerPack,
  });

  // Profil verilerinin geçerliliğini denetler.
  bool get isValid {
    final now = DateTime.now();
    final dateValid = !quitDateTime.isAfter(now);
    final countValid =
        cigarettesPerDay >= 1 && cigarettesPerDay <= 100;
    final priceValid = packPrice > 0 && packPrice <= 10000;
    final packValid =
        cigarettesPerPack >= 1 && cigarettesPerPack <= 50;
    return dateValid && countValid && priceValid && packValid;
  }

  // Modeli JSON haritasına dönüştürür.
  Map<String, dynamic> toJson() {
    return {
      'quitDateTime': quitDateTime.toIso8601String(),
      'cigarettesPerDay': cigarettesPerDay,
      'packPrice': packPrice,
      'cigarettesPerPack': cigarettesPerPack,
    };
  }

  // JSON haritasından güvenli nesne üretir.
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final rawDate = json['quitDateTime']?.toString();
    final parsedDate = rawDate != null
        ? DateTime.tryParse(rawDate) ?? DateTime.now()
        : DateTime.now();

    final count = (json['cigarettesPerDay'] as num?)?.toInt() ?? 20;
    final price = (json['packPrice'] as num?)?.toDouble() ?? 100.0;
    final perPack =
        (json['cigarettesPerPack'] as num?)?.toInt() ?? 20;

    return UserProfile(
      quitDateTime: parsedDate,
      cigarettesPerDay: count.clamp(1, 100),
      packPrice: price > 0 ? price.clamp(1.0, 10000.0) : 100.0,
      cigarettesPerPack: perPack.clamp(1, 50),
    );
  }

  // Klonlama ve alan güncelleme metodu.
  UserProfile copyWith({
    DateTime? quitDateTime,
    int? cigarettesPerDay,
    double? packPrice,
    int? cigarettesPerPack,
  }) {
    return UserProfile(
      quitDateTime: quitDateTime ?? this.quitDateTime,
      cigarettesPerDay: cigarettesPerDay ?? this.cigarettesPerDay,
      packPrice: packPrice ?? this.packPrice,
      cigarettesPerPack:
          cigarettesPerPack ?? this.cigarettesPerPack,
    );
  }
}

// SRP: Uygulama ayarları verisini tutar.
class AppSettings {
  final bool notificationsEnabled;
  final int reminderHour;
  final int reminderMinute;

  const AppSettings({
    this.notificationsEnabled = true,
    this.reminderHour = 9,
    this.reminderMinute = 0,
  });

  // Ayarları JSON formatına çevirir.
  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'reminderHour': reminderHour,
      'reminderMinute': reminderMinute,
    };
  }

  // JSON verisinden ayarları güvenle okur.
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    final enabled = json['notificationsEnabled'] as bool? ?? true;
    final hour = (json['reminderHour'] as num?)?.toInt() ?? 9;
    final minute = (json['reminderMinute'] as num?)?.toInt() ?? 0;

    return AppSettings(
      notificationsEnabled: enabled,
      reminderHour: hour.clamp(0, 23),
      reminderMinute: minute.clamp(0, 59),
    );
  }

  // Ayar değerlerini kopyalayarak günceller.
  AppSettings copyWith({
    bool? notificationsEnabled,
    int? reminderHour,
    int? reminderMinute,
  }) {
    return AppSettings(
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
    );
  }
}
