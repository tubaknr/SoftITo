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

  // OCP: Geriye dönük uyumlu varsayılan liste.
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

  // OCP: 8 kademeli zengin zaman çizelgesi listesi.
  static const List<HealthMilestone> timelineMilestones = [
    HealthMilestone(
      id: '20_min',
      title: 'Nabız ve Kan Basıncı Normale Döndü',
      description:
          'Kan basıncınız ve kalp atım hızınız normal referans '
          'aralıklarına gerileyerek kalbin aşırı iş yükü hafifledi.',
      startDuration: Duration(minutes: 20),
      endDuration: Duration(minutes: 20),
    ),
    HealthMilestone(
      id: '8_hours',
      title: 'Kandaki Oksijen Seviyesi Arttı',
      description:
          'Kan dolaşımındaki serbest oksijen düzeyi yükseldi, '
          'dokular ve kas lifleri tekrar optimum beslenmeye başladı.',
      startDuration: Duration(hours: 8),
      endDuration: Duration(hours: 8),
    ),
    HealthMilestone(
      id: '24_hours',
      title: 'Karbonmonoksit Temizlendi',
      description:
          'Zehirli karbonmonoksit gazı vücuttan bütünüyle atıldı. '
          'Akciğerler mukus ve duman partiküllerini dışa atmaya başladı.',
      startDuration: Duration(hours: 24),
      endDuration: Duration(hours: 24),
    ),
    HealthMilestone(
      id: '48_hours',
      title: 'Tat ve Koku Duyuları Keskinleşti',
      description:
          'Hasar görmüş koku ve tat alma sinir uçları hızla kendini '
          'yeniledi. Yiyeceklerin doğal lezzeti geri döndü.',
      startDuration: Duration(hours: 48),
      endDuration: Duration(hours: 48),
    ),
    HealthMilestone(
      id: '72_hours',
      title: 'Bronşlar Gevşedi, Nefes Almak Kolaylaştı',
      description:
          'Bronşiyal tüpler genişleyerek solunum kapasitesi belirgin '
          'biçimde ferahladı. Enerji seviyelerinde sıçrama gerçekleşti.',
      startDuration: Duration(hours: 72),
      endDuration: Duration(hours: 72),
    ),
    HealthMilestone(
      id: '2_weeks_3_months',
      title: 'Kan Dolaşımı ve Akciğer Fonksiyonu Güçleniyor',
      description:
          'Yürüme ve kardiyo eforu belirgin şekilde kolaylaşır; silya '
          'tüycükleri yeniden büyüyerek akciğerleri korur.',
      startDuration: Duration(days: 14),
      endDuration: Duration(days: 90),
    ),
    HealthMilestone(
      id: '1_year',
      title: 'Kalp Krizi Riski Yarı Yarıya Düşüyor',
      description:
          'Koroner kalp hastalığı riski, aktif bir sigara içicisine '
          'kıyasla tam %50 oranında azalır.',
      startDuration: Duration(days: 365),
      endDuration: Duration(days: 365),
    ),
    HealthMilestone(
      id: '5_years',
      title: 'Felç Riski Sigara İçmeyen Biriyle Aynı Düzeye İner',
      description:
          'Damarlar tamamen esnekliğini geri kazanır, inme ve '
          'serebrovasküler felç olasılığı sigara içmemişlerle eşitlenir.',
      startDuration: Duration(days: 1825),
      endDuration: Duration(days: 1825),
    ),
  ];
}
