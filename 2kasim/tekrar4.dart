import 'dart:convert';
import 'package:http/http.dart';

//veri model sınıfını tanımlar
class UrunModel{
    final int id; // ürünün benzersiz kimlik numarasını tutan id. immutable. 
    final String baslik; // ürünün başlığı
    final double fiyat; // ürünün fiyatı. ondalıklı. 
    final String resimUrl; //bağlantı adresini tutan immutable .
    final String kategori; //kategoriyi tutan immutable.
    
    const UrunModel({ // class ın const (sabit) constructor 'ı. performrans opt sağlar.
        required this.id, // class oluşturulurken verilemsi zorunlu alanal buraad requred'dır.  
        required this.baslik,
        required this.fiyat,
        required this.resimUrl,
        required this.kategori,
    });

// dışarıdan gelen json. map türündedir. json'ı UrunModel nesnesine dönüştürür. 
    factory UrunModel.fromJson(Map<String, dynamic> json){
        return UrunModel( // dönüştürülen verilerle yeni bir UrunModel örneği döner
            id: json['id'] as int? ?? 0, // json ın çindeki id alanını tamsayıya çevirir. null ile 0 atar. 
            baslik: json['title'] as String? ?? 'İsimsiz Ürün', // json daki title alanını string olarak alır null ilse isimsiz ürün atar.
            fiyat: (json['price'] as num?)?.toDouble() ?? 0.0, // jsn daki price alanını double a çevirir null ise 0 yapar.
            resimUrl: json['image'] as String? ?? 'https://via.placeholder.com/150', // jsondan image ı alır, null ise buradaki linki verir.
            kategori: json['category'] as String? ?? 'Genel', // json daki category yi alır null ise genel verir.
        );
    }
}

// ürün servislerinin uyması gerekn kurlları belirleyen sözleşme. abstract class. interface.
abstract class IUrunServisi{
    Future<List<UrunModel>> urunleriGetir(); 
}

// api ürün servisi. IUrunServisi interface inden impelemnt eder.
class CanliApiUrunServisi implements IUrunServisi{
  // istek atılacak olan apinin ana adresini sabit olarak tanımlar.
    static const String _baseUrl = "https://fakestoreapi.com/products";

    @override // interface'deki metodun override edildiğini belirtir.
    Future<List<UrunModel>> urunleriGetir() async { // asenkron veri çekişi. future. lite dönecek. veriler urunmodel tipinde olacak. 
        try{ // async old. için try catch. 
            final yanit = await http.get(Uri.parse(_baseUrl)).timeout( // url'e http get isteği gönderir. 
                const Duration(seconds: 10), // zaman aşımı süresi belirler
                onTimeout: (){ // 10 saniye içinde yanıt alamazsa çalışacak fonk:
                    throw Exception('Ağ zaman aşımına uğradı.'); // burası.
                },
            );
            if (yanit.statusCode == 200){ // yanıt 200 dönerse
            // gelen json yanitin body sini alır, decode eder, dynamic list e çevirir.
                final List<dynamic> hamListe = jsonDecode(yanit.body) as List<dynamic>;
                // listedeki her ürünü urunmodel e çevirir. hepsini yeni bir listede toplar. 
                return hamListe.map((eleman) => UrunModel.fromJson(eleman as Map<String, dynamic>)).toList();
            }
            else{ // 200 dışında hata dönerse 
            // hata fırlatır. 
                throw Exception(' Sunucu Hatası ${yanit.statusCode}');
            }

        } catch(e){ // try bloğunda hata yakalandığında çalışır
            print("Ağ hatası: $e"); // hatayı basar. 
            rethrow; // yakalanan hatayı üst katmana tekrar fırlatır. 
        }
    }
}