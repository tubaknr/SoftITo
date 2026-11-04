import 'dart:io';

import 'package:image_picker/image_picker.dart';

// KİLİT NOKTA: Cihazın kamerası veya galerisinden görsel seçme işlemlerini yöneten servis sınıfı.
class MediaPickerService {
  // KİLİT NOKTA: image_picker paketinin ana işlevlerini kullanabilmek için ImagePicker nesnesi oluşturur.
  final ImagePicker _imagePicker = ImagePicker();

  // KİLİT NOKTA: Telefonun galerisinden (fotoğraf arşivinden) resim seçmeyi sağlayan asenkron metot.
  Future<File?> pickImageGallery() async {
    // KİLİT NOKTA: Galeri arayüzünü açar ve kullanıcının seçtiği dosyanın bilgisini XFile formatında alır.
    final XFile? pickedFile = await _imagePicker.pickImage(
      // Kaynağın galeri olduğunu belirten parametre
      source: ImageSource.gallery,
      // Görselin kalitesini %80'e sıkıştırarak dosya boyutunu küçültür
      imageQuality: 80,
      // Galeri seçimlerinde performans ve boyut tasarrufu için maksimum genişliği 500 pikselle sınırlar
      maxWidth: 500,
      // Maksimum yüksekliği 500 pikselle sınırlar
      maxHeight: 500,
    );
    // Eğer kullanıcı galeriden resim seçmeden vazgeçerse (geri tuşuna basarsa) null döner.
    if (pickedFile == null) return null;
    // Seçilen geçici dosya yolunu, dart:io File nesnesine dönüştürerek geri döndürür.
    return File(pickedFile.path);
  }

  // KİLİT NOKTA: Telefonun kamerasını anlık olarak açıp fotoğraf çekmeyi sağlayan asenkron metot.
  Future<File?> pickImageCamera() async {
    // KİLİT NOKTA: Kamera uygulamasını başlatır ve çekilen fotoğrafın bilgisini XFile formatında alır.
    final XFile? pickedFile = await _imagePicker.pickImage(
      // Kaynağın kamera olduğunu belirten parametre
      source: ImageSource.camera,
      // Çekilen fotoğrafın kalitesini %80 oranında sıkıştırır
      imageQuality: 80,
      // Kameradan gelen yüksek çözünürlüklü fotoğrafları optimize etmek için maksimum genişliği 1200 piksel yapar
      maxWidth: 1200,
      // Maksimum yüksekliği 1200 piksel yapar
      maxHeight: 1200,
    );
    // Eğer kullanıcı fotoğraf çekmeden iptal butonuna basarsa null döner.
    if (pickedFile == null) return null;
    // Çekilen geçici fotoğraf dosyasını File nesnesine çevirerek kullanılmak üzere teslim eder.
    return File(pickedFile.path);
  }
}
