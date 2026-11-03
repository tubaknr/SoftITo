import 'package:cloud_firestore/cloud_firestore.dart';

class OgrenciModel{
    final String id; // çok fazla veri tutabilmek için String.  
    final String adSoyad;
    final String projeAdi;
    final int notu;
    final DateTime kayitTarihi;

    const OgrenciModel({
        required this.id,
        required this.adSoyad,
        required this.projeAdi,
        required this.notu,
        required this.kayitTarihi,
    });

// snapshot: db nin o anlık bir yedeğini almak. 
    factory OgrenciModel.fromJson(DocumentSnapshot doc){
        final veri = doc.data() as Map<String, dynamic>? ?? {};

        final OgrenciModel(
            id: doc.id, // id yi ssitem otomatikman bir sonraki id olarak veriyor
            adSoyad: veri['adSoyad'] as String? ?? "İsimsiz Öğrenci",
            projeAdi: veri['projeAdi'] as String? ?? "Henüz bir projesi yok.",
            notu: (veri['notu'] as num?)?.toInt() ?? 0,
            kayitTarihi: (veri['kayitTarihi'] as Timestamp?)?.toDate() ?? DateTime.now(),
            // db timestamp kulalnır.
            // dart datatime kullanır. bu yüzden dartın anlayacağı dile çevirmek gerekir. 
        );       
    }
}


// ------------------ ÖĞRENCİ EKLE ---------------------------------
class FirestoreOgrenciServisi{
    final CollectionReference _ogrencilerKoleksiyonu = FirebaseFirestore.instance.collection('ogrenciler');

    Future<void> ogrenciEkle({
        required String adSoyad,
        required String projeAdi,
        required int notu, 
    }) async {
        try{
            await _ogrencilerKoleksiyonu.add({ // ADD 
                'adSoyad': adSoyad,
                'projeAdi': projeAdi,
                'notu': notu,
                'kayitTarihi': FieldValue.serverTimestamp(),
            });
            print("Öğrenci başarıyla kaydedildi.");
        } catch (e) {
            print("Öğrenci ekleme başarısız: $e");
            // hatayı yakaladıktan sonra haatyı sürekli bellekte tutmasın diye rethrow. belleği şişirmemesi için temizler.
            rethrow; 
        }
    }

// PUT. HEM KAYDET HEM GÜNCELLE. 
// -----------ÖĞRENCİYİ TCKNO İLE KAYDET ------------------------
    Future<void> ogrenciIdIleKaydet({ // VOİD BU FONK U MUHAKKAK BİTİRİR. SADEC KARŞI TARAF HİÇBİ YNAIT VERMEZSE O ZAMAN BİTİREMEZ YANIT BEKLER.
        required String tcNo, // ASYNC bşaldıktan sonra bir kopukluk kesiklik olursa, 
        required String adSoyad, // eğer o fonk içinde onu sonlandıracak (void vb) kod yoksa sonsuza akdar arka planda log basar. 
        // RAM üzerinde çok yük oluşur. saniyede milyon kere yapar bun ve o yolu tıkar. 
    }) async { // Sütekli orayı çalıştırmaya çalışır. Ama bir yandan diğer fonksiyonları vs de çalıştırı.
    //  async olduğu için birni başaltıp cevap beklerken diğer fonk ları da çalıştırabilir. 
        required String projeAdi,
        // tcNo göndermek --> ID göndermek. 
        await _ogrencilerKoleksiyonu.doc(tcNo).set({ // SET --> GÜNCELLE + KAYDET.  
            'adSoyad': adSoyad,
            'projeAdi': projeAdi,
            'guncellemeTarihi': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true)); // merge: true --> önceki değişiklikleri koru, sadece yeni verdiklerimi güncelle. 
    }

// -----------TÜM ÖĞRENCİLERİ GETİR ----------------------------
    Future<List<OgrenciModel>> tumOgrencileriGetir() async {
        try{
            // notu en yüksek olanları getirsin.
            final QuerySnapshot snapshot = await _ogrencilerKoleksiyonu.orderBy('notu', ascending: true).get();

            return snapshot.docs.map((doc) => OgrenciModel.fromFireStore(doc)).toList();
        } catch(e) {
            print("Veri çekme hatası: $e");
            return []; // hata vermesin boş array dönsün. hem de dönecek olan verinin array olduğunu göstermiş olduk. 
        }
    }

// -----------NOT GÜNCELLE ------------------------------
    Future<void> ogrenciNotuGuncelle(String documanId, int yeniNot) async {
        await _ogrencilerKoleksiyonu.doc(documanId).update({
            'notu': yeniNot,
            'sonDuzenleme': FieldValue.serverTimestamp(),
        });
    }

// ----------OGRENCİ SİL ---------------------------------
    Future<void> ogrenciSil(String documanId) async {
        await _ogrencilerKoleksiyonu.doc(documanId).delete();
        print("$documanId referanslı veri tamamen silindi.");
    }

}
