// dart:io -> File sınıfı için gerekli.
// Telefondaki dosyayı temsil eder.
import 'dart:io';

// Firebase Storage paketi.
// Dosyaları Firebase'in bulutuna yükler.
import 'package:firebase_storage/firebase_storage.dart';

// debugPrint için gerekli.
// Konsola mesaj yazdırır.
import 'package:flutter/foundation.dart';

// Dosya yükleme işini tek yerde toplar.
// Ekranlar Firebase'i bilmez, bunu çağırır.
class StorageService{

  // Storage'ın tekil (singleton) nesnesi.
  // Uygulamada tek bir tane vardır.
  // final: bir kez atanır, değişmez.
  // _ ile başlar: sadece bu dosyada kullanılır.
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Dosyayı yükler, yükleme görevini döndürür.
  // Future: iş hemen bitmez, sonra tamamlanır.
  // TaskSnapshot: yüklemenin son durumu.
  Future<TaskSnapshot> uploadFile({
    // Yüklenecek dosya (telefondaki fotoğraf).
    required File file,
    // Buluttaki klasör. Örn: 'profil_resimleri'
    required String path,
    // Buluttaki dosya adı. Örn: 'tuba.jpg'
    required String fileName,
  }) {
    // Dosyanın bulutta duracağı adresi hazırlar.
    // Sonuç örneği: 'profil_resimleri/tuba.jpg'
    // ref(): bulutta bir konumu işaret eder.
    // child(): o konumun altına yol ekler.
    final Reference ref = _storage.ref().child('$path/$fileName');

    // Dosyaya eklenen ek bilgiler (metadata).
    final metadata = SettableMetadata(
      // Dosya türü: JPEG resim.
      // Tarayıcı ve konsol resim olduğunu anlar.
      contentType: 'image/jpeg',
      // Kendi istediğimiz etiketler (anahtar: değer).
      // Not: 'uplader' yazım hatası, 'uploader' olmalı.
      customMetadata: {'uploader': 'Tuba'}
    );

    // Yüklemeyi BAŞLATIR.
    // putFile: dosyayı ve ek bilgiyi buluta gönderir.
    // UploadTask: devam eden yükleme görevi.
    final UploadTask task = ref.putFile(file, metadata);

    // Yükleme sırasında gelen güncellemeleri dinler.
    // snapshotEvents: her ilerlemede yeni bilgi verir.
    // listen: her bilgi geldiğinde içindeki kodu çalıştırır.
    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      // İlerleme oranı: 0.0 ile 1.0 arası.
      // bytesTransferred: şu ana kadar giden bayt.
      // totalBytes: dosyanın toplam bayt sayısı.
      // Örn: 500 / 1000 = 0.5 (yüzde 50)
      final double progress = snapshot.bytesTransferred/snapshot.totalBytes;

      // Konsola yüzdeyi yazar. Örn: 'Uploading: %50.0'
      // progress*100: oranı yüzdeye çevirir.
      // toStringAsFixed(1): virgülden sonra 1 hane.
      debugPrint('Uploading: %${(progress*100).toStringAsFixed(1)}');
    });

    // Görevi geri verir.
    // Çağıran yer 'await' ile bitmesini bekleyebilir.
    // Bittiğinde indirme linkini de alabilir.
    return task;
  }

}