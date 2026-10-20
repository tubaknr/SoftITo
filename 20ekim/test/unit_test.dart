import 'package:flutter_test/flutter_test.dart';
import 'package:yorunge/features/analiz/controller/analiz_controller.dart';
import 'package:yorunge/features/fikir_durumu/controller/fikir_durumu_controller.dart';
import 'package:yorunge/features/mentor/controller/mentor_controller.dart';
import 'package:yorunge/features/mentor/models/mentor_model.dart';
import 'package:yorunge/features/programlar/controller/program_controller.dart';
import 'package:yorunge/features/programlar/models/program_model.dart';
import 'package:yorunge/features/topluluk/controller/topluluk_controller.dart';
import 'package:yorunge/features/yatirimci/controller/yatirimci_controller.dart';
import 'package:yorunge/features/yatirimci/models/yatirimci_model.dart';

void main() {
  group('MentorController Testleri', () {
    late MentorController controller;

    setUp(() {
      controller = MentorController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıçta mentor listesi dolu olmalıdır', () {
      expect(controller.tumMentorlar.value.isNotEmpty, true);
      expect(controller.filtreliMentorlar.value.isNotEmpty, true);
    });

    test('Sektör filtresi doğru çalışmalıdır', () {
      controller.sektorSec('FinTech');
      expect(controller.seciliSektor.value, 'FinTech');
      for (final m in controller.filtreliMentorlar.value) {
        expect(m.sektor, 'FinTech');
      }
    });

    test('Eşleşme isteği durumu "beklemede" yapmalıdır', () {
      final ilkMentor = controller.tumMentorlar.value.first;
      controller.eslesmeIste(ilkMentor.id);
      final guncelMentor = controller.tumMentorlar.value.firstWhere((m) => m.id == ilkMentor.id);
      expect(guncelMentor.eslesmeDurumu, EslesmeDurumu.beklemede);
    });
  });

  group('YatirimciController Testleri', () {
    late YatirimciController controller;

    setUp(() {
      controller = YatirimciController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Kategori değişimi listeyi doğru filtrelemelidir', () {
      controller.kategoriSec(YatirimciKategorisi.melekYatirimcilar);
      expect(controller.seciliKategori.value, YatirimciKategorisi.melekYatirimcilar);
      for (final y in controller.filtreliYatirimcilar.value) {
        expect(y.kategori, YatirimciKategorisi.melekYatirimcilar);
      }
    });

    test('İletişim isteği durumu güncellemelidir', () {
      final ilk = controller.filtreliYatirimcilar.value.first;
      controller.iletisimKur(ilk.id);
      final guncel = controller.tumYatirimcilar.value.firstWhere((y) => y.id == ilk.id);
      expect(guncel.iletisimKuruldu, true);
    });
  });

  group('ProgramController Testleri', () {
    late ProgramController controller;

    setUp(() {
      controller = ProgramController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Kategori seçimi doğru listeyi döndürmelidir', () {
      controller.kategoriSec(ProgramKategorisi.devletDestekleri);
      for (final p in controller.filtreliProgramlar.value) {
        expect(p.kategori, ProgramKategorisi.devletDestekleri);
      }
    });

    test('Takvime ekleme durumu toggle olmalıdır', () {
      final ilk = controller.filtreliProgramlar.value.first;
      expect(ilk.takvimeEklendi, false);
      controller.takvimeEkle(ilk.id);
      final guncel = controller.tumProgramlar.value.firstWhere((p) => p.id == ilk.id);
      expect(guncel.takvimeEklendi, true);
    });
  });

  group('ToplulukController Yetki ve Güvenlik Testleri', () {
    late ToplulukController controller;

    setUp(() {
      controller = ToplulukController(initialOnayli: false);
    });

    tearDown(() {
      controller.dispose();
    });

    test('Onaysız kullanıcı paylaşım yapamaz (Controller kuralı)', () {
      final ok = controller.gonderiPaylas('Test gönderisi');
      expect(ok, false);
      expect(controller.hataMesaji.value, isNotNull);
    });

    test('Onaysız kullanıcı beğeni yapamaz', () {
      final ok = controller.begen('g1');
      expect(ok, false);
      expect(controller.hataMesaji.value, isNotNull);
    });

    test('Onaylı kullanıcı paylaşım yapabilir ve liste güncellenir', () {
      controller.kullaniciOnayDurumunuAyarla(true);
      final ok = controller.gonderiPaylas('Yörünge harika bir platform!');
      expect(ok, true);
      expect(controller.gonderiler.value.first.metin, 'Yörünge harika bir platform!');
    });
  });

  group('FikirDurumuController Hukuki Süreç Testleri', () {
    late FikirDurumuController controller;

    setUp(() {
      controller = FikirDurumuController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Hukuki adımlarda sonraki aşamaya ilerleme çalışmalıdır', () {
      final baslangicIndex = controller.seciliFikir.value.hukukiAdimIndex;
      controller.sonrakiHukukiAdimaIlerle();
      expect(controller.seciliFikir.value.hukukiAdimIndex, baslangicIndex + 1);
    });
  });

  group('AnalizController Stepper Testleri', () {
    late AnalizController controller;

    setUp(() {
      controller = AnalizController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Adım navigasyonu sınırları aşmamalıdır', () {
      expect(controller.currentStep.value, 0);
      controller.previousStep();
      expect(controller.currentStep.value, 0);

      controller.goToStep(5);
      expect(controller.currentStep.value, 5);

      controller.nextStep();
      expect(controller.currentStep.value, 6);
    });
  });
}
