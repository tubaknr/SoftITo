// dart:io -> File sınıfı buradan gelir (cihazdaki dosyayı temsil eder).
import 'dart:io';

// Firebase Storage: fotoğraf, video gibi dosyaları buluta yükleyip saklamayı sağlar.
import 'package:firebase_storage/firebase_storage.dart';
// image_picker: kullanıcının galerisinden veya kamerasından fotoğraf seçmeyi sağlar.
import 'package:image_picker/image_picker.dart';

// ---------------------------------------------------------------
// StorageServisi
// ---------------------------------------------------------------
// Dosya işlerini (seçme, yükleme, link alma, silme) tek sınıfta toplar.
// Ekranlar Firebase'i doğrudan bilmez, sadece bu servisi çağırır.
class StorageServisi {
  // Firebase Storage'ın tekil (singleton) örneği: buluttaki depoyla konuşan nesne.
  // Yükleme, silme ve dosya yolu (referans) oluşturma işlemleri bununla yapılır.
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Galeri/kamera penceresini açan nesne.
  final ImagePicker _picker = ImagePicker();

  // ---------------------------------------------------------------
  // 1) GÖRSEL SEÇME
  // ---------------------------------------------------------------
  // kameradan: true -> kamera açılır, false -> galeri açılır.
  // Dönen değer: seçilen fotoğraf (File) veya kullanıcı vazgeçtiyse null.
  Future<File?> gorselSec({bool kameradan = false}) async {
    // Seçim penceresini açar ve kullanıcının seçmesini BEKLER (await).
    final XFile? xFile = await _picker.pickImage(
      // Kaynak: parametreden gelen değere göre kamera veya galeri.
      source: kameradan ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 80, // Kaliteyi %80'e düşürür -> dosya küçülür, yükleme hızlanır, depolama tasarrufu olur.
      maxWidth:
          1200, // Genişliği en fazla 1200 piksel yapar -> yine boyutu küçültür.
    );

    // Kullanıcı geri tuşuna basıp seçimden vazgeçtiyse xFile null gelir; işlem burada biter.
    if (xFile == null) return null;

    // image_picker'ın verdiği XFile'ı, Firebase'in yükleyebildiği File tipine çevirir.
    // xFile.path: fotoğrafın telefondaki geçici konumudur.
    return File(xFile.path);
  }

  // ---------------------------------------------------------------
  // 2) YÜKLEME
  // ---------------------------------------------------------------
  // DİKKAT: Bu fonksiyon async DEĞİL ve UploadTask döndürür (Future değil).
  // Neden? Yükleme zaman alır. Fonksiyon bitmesini beklese:
  //   - Kullanıcı "yüzde kaç yüklendi?" göremezdi,
  //   - Yüklemeyi durdurup iptal edemezdi.
  // UploadTask, yüklemenin "kargo takip numarası" gibidir: yükleme arkaplanda
  // sürerken ekran bu nesneden ilerlemeyi (progress bar) izler ve bitişi bekler.
  //
  // Parametreler ekrandan gelir:
  //   dosya    -> gorselSec()'ten dönen File
  //   dosyaAdi -> buluttaki dosya adı (örn. "profil_123.png")
  //   klasor   -> buluttaki klasör (varsayılan: "yuklemeler")
  UploadTask yuklemeBaslat({
    required File dosya,
    required String dosyaAdi,
    String klasor = 'yuklemeler',
  }) {
    // Dosyanın bulutta kaydedileceği adres (referans): "klasor/dosyaAdi".
    // Bu adres Storage içindeki yol gibidir.
    final Reference ref = _storage.ref().child('$klasor/$dosyaAdi');

    // Metadata: dosya hakkında ek bilgi.
    final metadata = SettableMetadata(
      // Dosya türü. Tarayıcı/uygulama dosyayı buna göre doğru açar.
      contentType: 'image/png',
      // Kendi eklediğimiz bilgiler (örn. dosyayı kim yükledi). Bulutta dosyayla birlikte saklanır.
      customMetadata: {'ekleyen': 'Ali Ay'},
    );

    // putFile: yüklemeyi BAŞLATIR ve beklemeden hemen UploadTask döndürür.
    // Yükleme arkaplanda devam eder; UploadTask ile izlenir.
    return ref.putFile(dosya, metadata);
  }

  // ---------------------------------------------------------------
  // 3) İNDİRME LİNKİ ALMA
  // ---------------------------------------------------------------
  // Yüklenen dosyanın internetten erişilebilen adresini (URL) verir.
  // 'ref' parametresi yükleme tamamlandıktan sonra gelir (örn. snapshot.ref).
  // Bu URL genellikle Firestore'a kaydedilir, ekranda Image.network ile gösterilir.
  Future<String> urlGetir(Reference ref) async {
    return await ref.getDownloadURL();
  }

  // ---------------------------------------------------------------
  // 4) SİLME
  // ---------------------------------------------------------------
  // dosyaYolu: bulutta dosyanın yolu (örn. "yuklemeler/profil_123.png").
  Future<void> dosyaSil(String dosyaYolu) async {
    // Yoldan dosyanın referansını bulur.
    final Reference ref = _storage.ref().child(dosyaYolu);
    // Dosyayı buluttan kalıcı olarak siler (geri alınamaz).
    await ref.delete();
  }
}
