import '../modals/kategori.dart';
import '../modals/urun.dart';
import 'i_urun_servisi.dart';


class MockUrunServisi implements IUrunServisi{
    final List<Urun> _urunDeposu = const[
        Urun(
            id: 1,
            baslik: "Macbook M5 Pro Laptop",
            aciklama: "Harika bir M5 Pro İşlemcili Macbook Pro",
            fiyat: 179999.99,
            resimUrl: "https://picsum.photos/400/400",
            kategori: Kategori.elektronik,
            stokAdedi: 5,
        ),
        Urun(
            id: 2,
            baslik: "Apple IPhone Pro 18 Pro Max",
            aciklama: "Harika bir M5 Pro İşlemcili Macbook Pro",
            fiyat: 149999.99,
            resimUrl: "https://picsum.photos/400/400",
            kategori: Kategori.elektronik,
            stokAdedi: 15,
        ),
        Urun(
            id: 3,
            baslik: "Erkek L Gömlek",
            aciklama: "Harika bir M5 Pro İşlemcili Macbook Pro",
            fiyat: 499.99,
            resimUrl: "https://picsum.photos/400/400",
            kategori: Kategori.giyim,
            stokAdedi: 45,
        ),
        Urun(
            id: 4,
            baslik: "Kadın çantası",
            aciklama: "Harika bir M5 Pro İşlemcili Macbook Pro",
            fiyat: 450.99,
            resimUrl: "https://picsum.photos/400/400",
            kategori: Kategori.evYasam,
            stokAdedi: 88,
        ),
        Urun(
            id: 5,
            baslik: "Oje Seti",
            aciklama: "Harika bir M5 Pro İşlemcili Macbook Pro",
            fiyat: 399.99,
            resimUrl: "https://picsum.photos/400/400",
            kategori: Kategori.kozmetik,
            stokAdedi: 120,
        ),
        Urun(
            id: 6,
            baslik: "Cam Rende",
            aciklama: "Harika bir M5 Pro İşlemcili Macbook Pro",
            fiyat: 49.99,
            resimUrl: "https://picsum.photos/400/400",
            kategori: Kategori.oto,
            stokAdedi: 150,
        ),
        Urun(
            id: 7,
            baslik: "Çekiç",
            aciklama: "Harika bir çekiç",
            fiyat: 79.99,
            resimUrl: "https://picsum.photos/400/400",
            kategori: Kategori.oto,
            stokAdedi: 2,
        ),
        Urun(
            id: 8,
            baslik: "Çaydanlık",
            aciklama: "Harika bir M5 Pro İşlemcili Macbook Pro",
            fiyat: 1199.99,
            resimUrl: "https://picsum.photos/400/400",
            kategori: Kategori.evYasam,
            stokAdedi: 88,
        ),
        Urun(   
            id: 9,
            baslik: "Apple IPhone 17 Pro Max",
            aciklama: "Harika bir M5 Pro İşlemcili Macbook Pro",
            fiyat: 99999.99,
            resimUrl: "https://picsum.photos/400/400",
            kategori: Kategori.elektronik,
            stokAdedi: 15,
        ),
    ];

    @override
    Future<List<Urun>> tumUrunleriGetir() async{
        await Future.delayed(const Duration(milliseconds: 1500));
        return List.from(_urunDeposu);
    }

    @override
    Future <List<Urun>> kategoriyeGoreGetir(Kategori kategori) async {
        await Future.delayed(const Duration(milliseconds: 400));

        if (kategori == Kategori.hepsi){
            return List.from(_urunDeposu);
        }

        return _urunDeposu.where((urun) => urun.kategori == kategori).toList();
    }

    @override
    Future <List<Urun>> adaGoreAra(String aramaMetni) async{
        await Future.delayed(const Duration(milliseconds: 200));

        if (aramaMetni.trim().isEmpty){
            return List.from(_urunDeposu);
        }

        return _urunDeposu.where((urun) {
            final baslikKucuk = urun.baslik.toLowerCase();
            final aramaMetniKucuk = aramaMetni.toLowerCase();
            return baslikKucuk.contains(aramaMetniKucuk);
        }).toList();
    }
}




