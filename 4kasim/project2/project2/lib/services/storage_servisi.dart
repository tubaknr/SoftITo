import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageServisi {
  // KİLİT NOKTA: Firebase Storage servisinin örneğini (instance) alarak bulut depolama işlemlerini başlatır.
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // KİLİT NOKTA: Cihazın galerisinden veya kamerasından görsel seçmek için ImagePicker nesnesi oluşturur.
  final ImagePicker _picker = ImagePicker();

  Future<File?> gorselSec({bool kameradan = false}) async {
    // KİLİT NOKTA: Asenkron (await) olarak cihazdan görsel seçme pencerisini açar.
    final XFile? xFile = await _picker.pickImage(
      // Parametreden gelen değere göre kaynağın kamera mı yoksa galeri mi olacağını seçer.
      source: kameradan ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 80, // Görselin kalitesini %80'e düşürerek boyutunu küçültür (sunucuda yer kazandırır).
      maxWidth: 1200, // Görselin genişliğini en fazla 1200 piksel yapar.
    );

    // Kullanıcı fotoğraf seçmekten vazgeçerse veya geri tuşuna basarsa işlem sonlandırılır.
    if (xFile == null) return null;

    // Seçilen geçici resmi, uygulamanın kullanabileceği bir File nesnesine dönüştürüp geri döndürür.
    return File(xFile.path);
  }

  // UploadTask: Firebase'e yükleme işleminin durumunu (yüklenen yüzdeyi vb.) takip etmeyi sağlayan bir nesne döndürür.
  UploadTask yuklemeBaslat({
    required File dosya,
    required String dosyaAdi,
    String klasor = 'yuklemeler',
  }) {
    // Firebase Storage içinde dosyanın kaydedileceği konumu (yolu) belirler (klasor/dosyaAdi).
    final Reference ref = _storage.ref().child('$klasor/$dosyaAdi');

    // Dosyanın türünü (örneğin image/png) ve ek bilgileri (kim yükledi vb.) Firebase'e kaydetmek için kullanılır.
    final metadata = SettableMetadata(
      contentType: 'image/png',
      // KİLİT NOKTA: Dosyaya özel meta veriler ekleyerek yükleyen kişi veya ek bilgileri bulut üzerinde saklar.
      customMetadata: {'ekleyen': 'Ali Ay'},
    );

    // Dosyayı ve ek bilgileri Firebase Storage'a yükleme sürecini başlatır ve UploadTask döndürür.
    // KİLİT NOKTA: putFile metodu dosyayı buluta gönderirken, geri kalan süreci dinleyebilmemiz için UploadTask (akış/görev) nesnesi döner.
    return ref.putFile(dosya, metadata);
  }

  // Firebase'e yüklenen dosyanın internet üzerinden (tarayıcıdan veya uygulamadan) erişilebilmesi için
  // gereken paylaşılabilir URL adresini (bağlantısını) getirir.
  // Bu link genellikle veritabanında (Firestore vb.) saklanır.
  Future<String> urlGetir(Reference ref) async {
    // KİLİT NOKTA: Storage üzerindeki dosya referansından güvenli indirme linkini (Download URL) asenkron olarak çeker.
    return await ref.getDownloadURL();
  }

  Future<void> dosyaSil(String dosyaYolu) async {
    // Silinecek dosyanın konumunu bulur.
    final Reference ref = _storage.ref().child(dosyaYolu);
    // KİLİT NOKTA: Belirtilen yoldaki dosyayı Firebase Storage sunucusundan kalıcı olarak siler.
    await ref.delete();
  }
}
