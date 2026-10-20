import '../models/program_model.dart';

class MockProgramData {
  const MockProgramData._();

  static final List<ProgramModel> programlar = [
    // 1. Hibe Programları
    const ProgramModel(
      id: 'p1',
      ad: 'TÜBİTAK 1512 — Girişimcilik Destek Programı (BİGG)',
      kurum: 'TÜBİTAK',
      kategori: ProgramKategorisi.hibeProgramlari,
      destekTutari: '900.000 ₺ (Geri Ödemesiz Hibe)',
      uygunlukSartlari: 'Örgün öğrenim lisans son sınıf veya mezun, şirket kurmamış girişimciler.',
      sonBasvuruTarihi: '30 Kasım 2026',
      kalanGun: 41,
      durum: ProgramDurumu.acik,
      basvuruAdimlari: [
        'Uygulayıcı kuruluş belirleme ve ön başvuru',
        'İş planı hazırlığı ve mentorluk süreci',
        'TÜBİTAK paneline sunum ve şirket kuruluşu',
      ],
    ),
    const ProgramModel(
      id: 'p2',
      ad: 'TTGV İklim ve Döngüsel Ekonomi Hibe Desteği',
      kurum: 'Türkiye Teknoloji Geliştirme Vakfı',
      kategori: ProgramKategorisi.hibeProgramlari,
      destekTutari: '1.500.000 ₺ Hibe',
      uygunlukSartlari: 'Karbon salınımı azaltan ya da atık geri dönüşümü sağlayan Ar-Ge odaklı projeler.',
      sonBasvuruTarihi: '15 Aralık 2026',
      kalanGun: 56,
      durum: ProgramDurumu.acik,
      basvuruAdimlari: [
        'Çevresel etki raporu hazırlığı',
        'Proje bütçe tabloları teslimi',
        'Teknik değerlendirme jürisi',
      ],
    ),

    // 2. Devlet Destekleri
    const ProgramModel(
      id: 'p3',
      ad: 'KOSGEB İleri Girişimci Destek Programı',
      kurum: 'KOSGEB',
      kategori: ProgramKategorisi.devletDestekleri,
      destekTutari: '375.000 ₺ Kuruluş & Makine Teçhizat',
      uygunlukSartlari: 'KOSGEB İleri Girişimcilik Eğitimi almış, son 1 yıl içinde kurulan yenilikçi KOBİler.',
      sonBasvuruTarihi: 'Sürekli Açık (Yıl Boyu)',
      kalanGun: 70,
      durum: ProgramDurumu.acik,
      basvuruAdimlari: [
        'e-Devlet üzerinden KOSGEB kayıt ve beyanname',
        'Kurul onayına sunulacak makine-yazılım listesi',
        'Hibe avans ve fatura hak ediş talebi',
      ],
    ),
    const ProgramModel(
      id: 'p4',
      ad: 'Ticaret Bakanlığı E-Turquality (Bilişimin Yıldızları)',
      kurum: 'T.C. Ticaret Bakanlığı',
      kategori: ProgramKategorisi.devletDestekleri,
      destekTutari: '%70 Oranında Yurtdışı Pazarlama Desteği',
      uygunlukSartlari: 'Yazılımını küresel pazara ihraç eden tescilli teknoloji şirketleri.',
      sonBasvuruTarihi: '28 Şubat 2027',
      kalanGun: 130,
      durum: ProgramDurumu.yakinda,
      basvuruAdimlari: [
        'Bakanlık DYS (Destek Yönetim Sistemi) kaydı',
        'İhracat kapasite raporu sunumu',
        'Ön onay ve küresel reklam giderleri beyanı',
      ],
    ),

    // 3. Yurtdışı Destekleri
    const ProgramModel(
      id: 'p5',
      ad: 'Horizon Europe EIC Accelerator',
      kurum: 'Avrupa İnovasyon Konseyi (EIC)',
      kategori: ProgramKategorisi.yurtdisiDestekleri,
      destekTutari: '2.5 Milyon € Hibe + 15 Milyon € Özkaynak',
      uygunlukSartlari: 'Derin teknoloji (DeepTech) üreten ve ölçeklenme potansiyeli olan KOBİler.',
      sonBasvuruTarihi: '18 Ekim 2026',
      kalanGun: 0,
      durum: ProgramDurumu.kapandi,
      basvuruAdimlari: [
        'Kısa video ve 3 dakikalık pitch deck yükleme',
        'Tam iş planı ve finansal projeksiyon teslimi',
        'Brüksel jüri mülakatı',
      ],
    ),
    const ProgramModel(
      id: 'p6',
      ad: 'Erasmus for Young Entrepreneurs',
      kurum: 'Avrupa Birliği Komisyonu',
      kategori: ProgramKategorisi.yurtdisiDestekleri,
      destekTutari: 'Aylık 1.100 € Yaşam ve Seyahat Hibesi',
      uygunlukSartlari: 'Avrupa\'da deneyimli bir girişimcinin yanında 1-6 ay tecrübe edinmek isteyen yeni kurucular.',
      sonBasvuruTarihi: '10 Ocak 2027',
      kalanGun: 82,
      durum: ProgramDurumu.acik,
      basvuruAdimlari: [
        'İngilizce CV ve girişim motivasyon mektubu',
        'Avrupalı ev sahibi girişimci eşleşmesi',
        'Vize ve hibe sözleşmesi protokolü',
      ],
    ),

    // 4. Özel Sektör Destekleri
    const ProgramModel(
      id: 'p7',
      ad: 'İTÜ Çekirdek Big Bang Girişimcilik Çağrısı',
      kurum: 'İTÜ ARI Teknokent',
      kategori: ProgramKategorisi.ozelSektorDestekleri,
      destekTutari: 'Toplam 150 Milyon ₺ Ödül ve Yatırım Havuzu',
      uygunlukSartlari: 'Prototipi veya çalışan ürünü olan teknoloji girişimleri.',
      sonBasvuruTarihi: '05 Kasım 2026',
      kalanGun: 16,
      durum: ProgramDurumu.acik,
      basvuruAdimlari: [
        'Online başvuru formu ve demo videosu',
        'Ön kuluçka eğitimleri ve çeyrek final sunumu',
        'Big Bang sahnesi ve yatırımcı ödül töreni',
      ],
    ),
    const ProgramModel(
      id: 'p8',
      ad: 'Türk Telekom Ventures Hızlandırma (PİLOT)',
      kurum: 'Türk Telekom',
      kategori: ProgramKategorisi.ozelSektorDestekleri,
      destekTutari: '100.000 \$ Nakit Hibe + TT ile İş Birliği',
      uygunlukSartlari: 'Telekom, siber güvenlik, bulut, AI alanlarında ölçeklenen girişimler.',
      sonBasvuruTarihi: '25 Kasım 2026',
      kalanGun: 36,
      durum: ProgramDurumu.acik,
      basvuruAdimlari: [
        'Çevrimiçi başvuru ve teknoloji değerlendirmesi',
        'POC (Kavram Kanıtlama) çalışma planı',
        'Yatırım komitesi kararı',
      ],
    ),

    // 5. Kuluçka ve Hızlandırma Merkezleri
    const ProgramModel(
      id: 'p9',
      ad: 'Bilkent Cyberpark Ön Kuluçka Merkezi',
      kurum: 'Bilkent Cyberpark',
      kategori: ProgramKategorisi.kuluckaMerkezleri,
      destekTutari: 'Ücretsiz Ofis, Laboratuvar & Vergi Muafiyeti',
      uygunlukSartlari: 'Teknokent mevzuatına uygun Ar-Ge ve yazılım geliştiricileri.',
      sonBasvuruTarihi: 'Sürekli Kabul',
      kalanGun: 90,
      durum: ProgramDurumu.acik,
      basvuruAdimlari: [
        'Teknokent portalı üzerinden proje önerisi',
        'Akademik hakem heyeti incelemesi',
        'Sözleşme imzalama ve ofis tahsisi',
      ],
    ),
    const ProgramModel(
      id: 'p10',
      ad: 'ODTÜ TEKNOKENT ATOM (Oyun Geliştirme)',
      kurum: 'ODTÜ TEKNOKENT',
      kategori: ProgramKategorisi.kuluckaMerkezleri,
      destekTutari: 'Donanım Desteği, Mentorluk ve Yayıncı Ağı',
      uygunlukSartlari: 'Mobil veya PC platformunda oyun geliştiren bağımsız ekipler.',
      sonBasvuruTarihi: '12 Aralık 2026',
      kalanGun: 53,
      durum: ProgramDurumu.acik,
      basvuruAdimlari: [
        'Oyun demosu ve oynanış videosu paylaşımı',
        'Mülakat ve teknik değerlendirme',
        'ATOM ekibine kabul ve çalışma alanı tahsisi',
      ],
    ),
  ];
}
