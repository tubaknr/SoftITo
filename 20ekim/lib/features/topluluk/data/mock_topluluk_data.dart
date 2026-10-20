import '../models/topluluk_model.dart';

class MockToplulukData {
  const MockToplulukData._();

  static final List<GonderiModel> gonderiler = [
    GonderiModel(
      id: 'g1',
      yazarAd: 'Berke Güven',
      girisimAd: 'BiyoTarım Akıllı Sensör',
      metin: 'Yörünge sayesinde şirket kuruluşumuzu ve TÜRKPATENT tescilimizi dün tamamladık! Ücretsiz atanan avukatımız Elif Hanım tüm süreci 1 haftada toparladı. Şimdi ilk pilot seralarımızı kuruyoruz 🚀',
      zaman: '2 saat önce',
      begeniSayisi: 24,
      begenildiMi: false,
      yanitlar: const [
        YanitModel(
          id: 'y1_1',
          yazarAd: 'Dr. Selin Aktaş',
          girisimAd: 'Mentor',
          metin: 'Tebrikler Berke! Sensör kalibrasyon verilerini haftaya menti görüşmemizde inceleyelim.',
          zaman: '1 saat önce',
        ),
      ],
    ),
    GonderiModel(
      id: 'g2',
      yazarAd: 'Aslıhan Demir',
      girisimAd: 'LojistikRotam',
      metin: 'Gelir destek taahhüdünün 4. ayı hesabımıza geçti. Bu nakit güvencesi olmasa yazılımcı ekibini tam zamanlı istihdam etmemiz imkansızdı. Girişimcilikte odaklanabilmek her şey.',
      zaman: '5 saat önce',
      begeniSayisi: 42,
      begenildiMi: true,
      yanitlar: const [
        YanitModel(
          id: 'y2_1',
          yazarAd: 'Murat Erdem',
          girisimAd: 'Mentor',
          metin: 'Erken aşamada runway\'i korumak kritik. Harika bir ivme yakaladınız.',
          zaman: '4 saat önce',
        ),
      ],
    ),
    GonderiModel(
      id: 'g3',
      yazarAd: 'Kaan Öztürk',
      girisimAd: 'MediLens AI',
      metin: 'TÜBİTAK 1512 BİGG panelinden az önce çıktık. Jüri karar destek algoritmamızı çok beğendi. Sonuçları sabırsızlıkla bekliyoruz!',
      zaman: '1 gün önce',
      begeniSayisi: 31,
      begenildiMi: false,
      yanitlar: const [],
    ),
    GonderiModel(
      id: 'g4',
      yazarAd: 'Gizem Vural',
      girisimAd: 'EduCraft AR',
      metin: 'T.C. Ticaret Sicil Gazetesi ilanımız bugün yayınlandı. Anonim şirketimiz resmen kuruldu. Yörünge platformu ailesine teşekkürler.',
      zaman: '2 gün önce',
      begeniSayisi: 55,
      begenildiMi: false,
      yanitlar: const [
        YanitModel(
          id: 'y4_1',
          yazarAd: 'Av. Canberk Yılmaz',
          girisimAd: 'Yörünge Hukuk',
          metin: 'Hayırlı olsun Gizem Hanım, SHA protokolünüzü de sisteme yükledik.',
          zaman: '2 gün önce',
        ),
      ],
    ),
  ];
}
