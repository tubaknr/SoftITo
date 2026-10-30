import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modals/urun.dart';
import '../modals/kategori.dart';
import 'i_urun_servisi.dart'    ;

class ApiUrunServisi implements IUrunServisi{
    static const String _baseUrl = 'https://fakeStoreapi.com/products';

    @override
    Future<List<Urun>> tumUrunleriGetir() async{
        final uri = Uri.parse(_baseUrl);

        try{
            final yanit = await http.get(uri).timeout(
                const Duration(seconds: 10),
                onTimeout: () => throw Exception("Ağ isteği zaman aşımına uğradı (Timeout)."),
            );
            //print("yanit: ${yanit.body}");
            //print("statusCode: ${yanit.statusCode}");

            if (yanit.statusCode == 200){
                final List<dynamic> hamListe = jsonDecode(utf8.decode(yanit.bodyBytes));
                //print("hamListe: ${hamListe}");
                final listeler = hamListe.map((tekilJson) => Urun.fromJson(tekilJson as Map<String,dynamic>)).toList();
                //print("listeler: $listeler");
                return listeler;
            } else {
                throw Exception('Sunucu hatası oluştu! Durum Kodu: ${yanit.statusCode}');
            } 

        } catch(hata){
            throw Exception("Internet bağlantısı kurulamadı $hata");
        }
    }

    // kategoriyeGoreGetir
    @override
    Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori) async {
        if (kategori == Kategori.hepsi){
            return tumUrunleriGetir();
        }
        String kategoriYolu;
        switch(kategori){
            case Kategori.elektronik:
                kategoriYolu = 'elektronik';
                break;
            case Kategori.giyim:
                kategoriYolu = "giyim";
                break;
            case Kategori.ayakkabi:
                kategoriYolu = 'jewelery';
                break;
            default:
            return tumUrunleriGetir();
        }

        final uri = Uri.parse('$_baseUrl/category/$kategoriYolu');
        final yanit = await http.get(uri);

        if (yanit.statusCode == 200){
            final List<dynamic> hamListe = jsonDecode(utf8.decode(yanit.bodyBytes));
            return hamListe.map((j) => Urun.fromJson(j as Map<String,dynamic>)).toList();
        } else {
            throw Exception('Kategori filtreleme hatası oluştu! Durum Kodu: ${yanit.statusCode}');
        }
    }

    // adaGoreAra
    @override
    Future <List<Urun>> adaGoreAra(String aramaMetni) async{
        final tumUrunler = await tumUrunleriGetir();
        if (aramaMetni.trim().isEmpty) return tumUrunler;

        return tumUrunler.where((urun) {
            return urun.baslik.toLowerCase().contains(aramaMetni.toLowerCase()) 
                || urun.aciklama.toLowerCase().contains(aramaMetni.toLowerCase());
        }).toList();

    }
}



