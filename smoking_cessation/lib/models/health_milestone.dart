// ========================================
// DOSYA: health_milestone.dart
// NE İŞE YARAR: Sağlık kazanımları listesi
// ve veri modelini tanımlar.
// NASIL ÇALIŞIR: Sabit kilometre taşları
// süre ve açıklama verilerini saklar.
// SOLID: OCP - Yeni kilometre taşları bu
// listeye eklenir, ekran kodu değişmez.
// ========================================

// SRP: Tek bir sağlık kazanımı bilgisini tutar.
class HealthMilestone {
  final String id;
  final String title;
  final String description;
  final Duration startDuration;
  final Duration endDuration;

  const HealthMilestone({
    required this.id,
    required this.title,
    required this.description,
    required this.startDuration,
    required this.endDuration,
  });

  // OCP: Yeni kazanımlar buraya eklenebilir.
  static const List<HealthMilestone> defaultMilestones = [
    HealthMilestone(
      id: '20_min',
      title: '20 Dakika',
      description: 'Nabız ve tansiyon normale yaklaşır',
      startDuration: Duration(minutes: 20),
      endDuration: Duration(minutes: 20),
    ),
    HealthMilestone(
      id: '12_hours',
      title: '12 Saat',
      description: 'Kandaki karbonmonoksit seviyesi düşer',
      startDuration: Duration(hours: 12),
      endDuration: Duration(hours: 12),
    ),
    HealthMilestone(
      id: '2_weeks_3_months',
      title: '2 Hafta – 3 Ay',
      description: 'Dolaşım ve akciğer fonksiyonu iyileşir',
      startDuration: Duration(days: 14),
      endDuration: Duration(days: 90),
    ),
    HealthMilestone(
      id: '1_9_months',
      title: '1 – 9 Ay',
      description: 'Öksürük ve nefes darlığı azalır',
      startDuration: Duration(days: 30),
      endDuration: Duration(days: 270),
    ),
    HealthMilestone(
      id: '1_year',
      title: '1 Yıl',
      description: 'Koroner kalp hastalığı riski yarıya iner',
      startDuration: Duration(days: 365),
      endDuration: Duration(days: 365),
    ),
  ];
}
