import '../models/fikir_model.dart';

class MockFikirDurumuData {
  const MockFikirDurumuData._();

  static List<HukukiAdim> createStandardHukukiAdimlar(int tamamlananAdimSayisi) {
    const tumAdimlar = [
      (
        'Ücretsiz Avukat Ataması',
        'Yörünge platformu tarafından girişim için bilişim ve şirketler hukuku uzmanı avukat tayin edilir.',
      ),
      (
        'Şirket Tipi Seçimi',
        'Girişimin sermaye yapısı ve yatırım stratejisine göre Anonim (A.Ş.) veya Limited Şirket yapısı belirlenir.',
      ),
      (
        'MERSİS & Ticaret Sicil Tescili',
        'Ana sözleşme MERSİS sistemi üzerinden onaylanır, noter işlemleri ve Ticaret Sicili tescili tamamlanır.',
      ),
      (
        'Vergi Dairesi Kaydı & Vergi Levhası',
        'İlgili vergi dairesine başvuru, e-tebligat ve e-fatura kayıtları yapılarak resmi vergi levhası tanzim edilir.',
      ),
      (
        'TÜRKPATENT Marka Tescili',
        'Girişimin ticari unvanı ve logosu Türk Patent ve Marka Kurumu nezdinde koruma altına alınır.',
      ),
      (
        'Pay Sahipleri Sözleşmesi (SHA)',
        'Kurucu ortaklar arası vesting, hisse devir kısıtlamaları ve hakları düzenleyen sözleşme akdedilir.',
      ),
    ];

    return List.generate(tumAdimlar.length, (index) {
      final step = tumAdimlar[index];
      final sira = index + 1;
      final tamamlandi = sira <= tamamlananAdimSayisi;
      final aktif = sira == tamamlananAdimSayisi + 1;

      return HukukiAdim(
        sira: sira,
        baslik: step.$1,
        aciklama: step.$2,
        tamamlandi: tamamlandi,
        aktif: aktif,
        tamamlanmaTarihi: tamamlandi ? '2026-0$sira-15' : null,
      );
    });
  }

  static const AtananAvukat ornekAvukat1 = AtananAvukat(
    adSoyad: 'Av. Elif Karadağ',
    baro: 'İstanbul Barosu',
    sicilNo: '54219',
    uzmanlik: 'Bilişim ve Girişim Sermayesi Hukuku',
    telefon: '+90 (212) 555 01 23',
    eposta: 'elif.karadag@yorunge-hukuk.org',
  );

  static const AtananAvukat ornekAvukat2 = AtananAvukat(
    adSoyad: 'Av. Canberk Yılmaz',
    baro: 'Ankara Barosu',
    sicilNo: '38192',
    uzmanlik: 'Şirketler Hukuku & Fikri Mülkiyet',
    telefon: '+90 (312) 555 01 88',
    eposta: 'canberk.yilmaz@yorunge-hukuk.org',
  );

  static final List<GirisimFikri> kabulEdilenFikirler = [
    GirisimFikri(
      id: 'fikir_1',
      ad: 'BiyoTarım Akıllı Sensör',
      sektor: 'Tarım Teknolojileri (AgriTech)',
      ozet: 'Toprak nemi ve besin değerlerini yapay zeka ile analiz eden IoT tarım izleme ağı.',
      asama: BasvuruAsamasi.onaylandi,
      ekipSayisi: 4,
      ilerlemeYuzdesi: 0.85,
      hukukiAdimIndex: 5,
      hukukiAdimlar: createStandardHukukiAdimlar(5),
      avukat: ornekAvukat1,
      gelirDestek: const GelirDestekDurumu(
        aylikTaahhutTutari: 45000,
        odenenAySayisi: 5,
        toplamAySayisi: 6,
        kalanGun: 12,
        aktif: true,
        sonOdemeTarihi: '01.10.2026',
      ),
    ),
    GirisimFikri(
      id: 'fikir_2',
      ad: 'LojistikRotam',
      sektor: 'Lojistik & Tedarik Zinciri',
      ozet: 'Şehir içi teslimatlarda karbon salınımını %35 azaltan dinamik rota optimizasyon motoru.',
      asama: BasvuruAsamasi.onaylandi,
      ekipSayisi: 3,
      ilerlemeYuzdesi: 0.65,
      hukukiAdimIndex: 4,
      hukukiAdimlar: createStandardHukukiAdimlar(4),
      avukat: ornekAvukat2,
      gelirDestek: const GelirDestekDurumu(
        aylikTaahhutTutari: 40000,
        odenenAySayisi: 4,
        toplamAySayisi: 6,
        kalanGun: 18,
        aktif: true,
        sonOdemeTarihi: '05.10.2026',
      ),
    ),
    GirisimFikri(
      id: 'fikir_3',
      ad: 'MediLens AI',
      sektor: 'Sağlık Teknolojileri (HealthTech)',
      ozet: 'Radyolojik görüntüleri 3 saniyede tarayarak erken teşhis desteği veren klinik karar destek aracı.',
      asama: BasvuruAsamasi.onaylandi,
      ekipSayisi: 5,
      ilerlemeYuzdesi: 0.50,
      hukukiAdimIndex: 3,
      hukukiAdimlar: createStandardHukukiAdimlar(3),
      avukat: ornekAvukat1,
      gelirDestek: const GelirDestekDurumu(
        aylikTaahhutTutari: 60000,
        odenenAySayisi: 3,
        toplamAySayisi: 12,
        kalanGun: 20,
        aktif: true,
        sonOdemeTarihi: '10.10.2026',
      ),
    ),
    GirisimFikri(
      id: 'fikir_4',
      ad: 'GeriDönüşüm Otomatı',
      sektor: 'Temiz Enerji & Çevre (CleanTech)',
      ozet: 'Kullanıcıları mikro-ödüllerle teşvik eden yapay zeka destekli akıllı atık ayrıştırma kutuları.',
      asama: BasvuruAsamasi.onaylandi,
      ekipSayisi: 3,
      ilerlemeYuzdesi: 0.35,
      hukukiAdimIndex: 2,
      hukukiAdimlar: createStandardHukukiAdimlar(2),
      avukat: ornekAvukat2,
      gelirDestek: const GelirDestekDurumu(
        aylikTaahhutTutari: 35000,
        odenenAySayisi: 2,
        toplamAySayisi: 6,
        kalanGun: 8,
        aktif: true,
        sonOdemeTarihi: '02.10.2026',
      ),
    ),
    GirisimFikri(
      id: 'fikir_5',
      ad: 'FinLens Kobi',
      sektor: 'Finansal Teknolojiler (FinTech)',
      ozet: 'Mikro işletmeler için açık bankacılık entegrasyonlu anlık nakit akışı tahmin yazılımı.',
      asama: BasvuruAsamasi.onaylandi,
      ekipSayisi: 2,
      ilerlemeYuzdesi: 0.20,
      hukukiAdimIndex: 1,
      hukukiAdimlar: createStandardHukukiAdimlar(1),
      avukat: ornekAvukat1,
      gelirDestek: const GelirDestekDurumu(
        aylikTaahhutTutari: 30000,
        odenenAySayisi: 1,
        toplamAySayisi: 6,
        kalanGun: 25,
        aktif: true,
        sonOdemeTarihi: '28.09.2026',
      ),
    ),
    GirisimFikri(
      id: 'fikir_6',
      ad: 'EduCraft AR',
      sektor: 'Eğitim Teknolojileri (EdTech)',
      ozet: 'Fen bilimleri ve mühendislik derslerini zenginleştirilmiş gerçeklikle etkileşimli kılan müfredat platformu.',
      asama: BasvuruAsamasi.onaylandi,
      ekipSayisi: 4,
      ilerlemeYuzdesi: 1.0,
      hukukiAdimIndex: 6,
      hukukiAdimlar: createStandardHukukiAdimlar(6),
      avukat: ornekAvukat2,
      gelirDestek: const GelirDestekDurumu(
        aylikTaahhutTutari: 50000,
        odenenAySayisi: 6,
        toplamAySayisi: 6,
        kalanGun: 0,
        aktif: false,
        sonOdemeTarihi: '15.09.2026',
      ),
    ),
  ];

  static GirisimFikri defaultKullaniciFikri = GirisimFikri(
    id: 'kullanici_fikri',
    ad: 'Yörünge Girişimi',
    sektor: 'Yazılım & Bilişim',
    ozet: 'Platforma kabul edilen girişiminiz için hukuki süreç ve gelir desteği aktif olarak işletilmektedir.',
    asama: BasvuruAsamasi.onaylandi,
    ekipSayisi: 3,
    ilerlemeYuzdesi: 0.70,
    hukukiAdimIndex: 4,
    hukukiAdimlar: createStandardHukukiAdimlar(4),
    avukat: ornekAvukat1,
    gelirDestek: const GelirDestekDurumu(
      aylikTaahhutTutari: 50000,
      odenenAySayisi: 4,
      toplamAySayisi: 6,
      kalanGun: 14,
      aktif: true,
      sonOdemeTarihi: '01.10.2026',
    ),
  );
}
