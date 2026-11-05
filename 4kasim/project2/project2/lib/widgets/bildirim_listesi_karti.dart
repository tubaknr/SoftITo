import 'package:flutter/material.dart';

import '../models/bildirim_modeli.dart';

// kart : statelesswidget.
// liste, token, switch : dışarıdan parametre olarak gelir. 
// switch e basınca onAboneDegisti fonksiyonunu çağırır, asıl işi ekran yapar. 
// bu desen: statei yukarı taşımak. LIFTING STATE UP. 
class BildirimListesiKarti extends StatelessWidget {
  // Dışarıdan gelen bildirimlerin listesini tutan değişken
  final List<BildirimModeli> bildirimler;

  // Cihazın Firebase Cloud Messaging (FCM) token bilgisini tutan nullable string
  final String? token;

  // Kullanıcının konuya abone olup olmadığını belirten boolean değer
  final bool konuyaAboneMi; // SWITCH AÇIK MI KAPALI MI 

  // Abonelik durumu değiştiğinde tetiklenecek fonksiyon (Callback)
  final ValueChanged<bool> onAboneDegisti; // SWITCH DEĞİŞİNCE ÇAĞRILACAK FONKSİYON 

  // Widget'ın kurucu metodu (Constructor), dışarıdan zorunlu parametreleri alır
  const BildirimListesiKarti({
    super.key,
    required this.bildirimler,
    required this.token,
    required this.konuyaAboneMi,
    required this.onAboneDegisti,
  });

  @override
  Widget build(BuildContext context) {
    // 1. En Dış Katman: Kart tasarımı oluşturan Card widget'ı
    return Card(
      // Kartın gölgesini sıfırlar, düz bir çerçeve görünümü sağlar
      elevation: 0,
      // Kartın köşe kavislerini ve gri ince kenarlık çizgisini ayarlar
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // yuvarlak köşe 
        side: BorderSide(color: Colors.grey.shade300), // gri çerçeve 
      ),
      // Kartın içindeki yazılara ve ikonlara her yönden boşluk bırakır (Tek çocuk alır)
      child: Padding(
        padding: const EdgeInsets.all(16),
        // İçerideki elemanları yukarıdan aşağıya alt alta sırayla dizen Column (Tek çocuk alır)
        child: Column(
          // İçindeki elemanları yatay eksende uçtan uca (genişliğe göre) yayar
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // Column içine birden fazla eleman koyabilmemizi sağlayan çoklu liste yapısı
          children: [
            // İkonu, başlığı ve switch'i yan yana koyan Row widget'ı (1. Çoklu eleman)
            Row(
              // Row içinde yan yana duracak elemanların listesi
              children: [
                // Bildirim zili simgesini gösteren Icon widget'ı
                const Icon(
                  Icons.notifications_active_outlined,
                  color: Color(0xFF006C4A),
                ),
                // İkon ile yazı arasına yatayda 8 birim boşluk koyar
                const SizedBox(width: 8),
                // Yazının, satırda kalan boş alanın tamamını kaplamasını sağlayan Expanded (Taşmayı önler)
                const Expanded( // TEXTİN DIŞINDA EXPANDED!!!!!!!!!!!!!!!!!!!!! TAŞMA HATASI OLMAZ
                  // Ekranda görünecek başlık metni
                  child: Text(
                    'FCM Bildirim Merkezi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      // Not: 0xFF0F172A veya düzgün bir renk kodu olmalı, 0xFFF172A eksik haneliydi, 6 haneye tamamlandı:
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                // Abonelik durumunu açıp kapatmaya yarayan Switch düğmesi
                Switch(
                  value: konuyaAboneMi,
                  activeColor: const Color(0xFF006C4A),
                  onChanged: onAboneDegisti, // LIFTING STATE UP
                ),
              ], // ROW BİTTİ 
            ),
            // Abonelik durumuna göre dinamik metin gösteren Text widget'ı (2. Çoklu eleman)
            Text(
              konuyaAboneMi ? 'Tüm sınıf yayını aktif' : 'Yayın kapalı',
              style: TextStyle(
                fontSize: 12,
                color: konuyaAboneMi
                    ? const Color(0xFF006C4A)
                    : Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Elemanlar üst üste binmesin diye dikeyde 12 birim boşluk bırakır (3. Çoklu eleman)
            const SizedBox(height: 12),
            // Token bilgisini koyu renkli şık bir kutu içinde gösteren Container (4. Çoklu eleman)
            Container(
              // Kutunun içindeki yazılara etrafından 10 birim iç boşluk verir
              padding: const EdgeInsets.all(10),
              // Kutunun arka plan rengini ve köşe yuvarlamasını ayarlar
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(8),
              ),
              // Container içine alt alta eleman dizmek için Column kullanılır (Tek çocuk alır)
              child: Column(
                // İçerisindeki yazıları sola yaslar
                crossAxisAlignment: CrossAxisAlignment.start,
                // Column'un alt alta sıralayacağı elemanlar listesi
                children: [
                  // Sabit açıklama metni
                  const Text(
                    "Cihazın FCM Tokeni",
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  // Metinler arası dikey 2 birimlik minik boşluk
                  const SizedBox(height: 2),
                  // Kullanıcının üzerine basıp kopyalayabileceği token metin alanı
                  SelectableText(
                    token ?? 'token alınıyor',
                    style: const TextStyle(
                      color: Color(0xFF388888),
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            // Sonraki elemanla araya dikeyde 14 birim boşluk bırakır
            const SizedBox(height: 14),
            // Gelen bildirimlerin adedini dinamik gösteren başlık yazısı
            Text(
              'Gelen Bildirimler (${bildirimler.length}):',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            // Başlık ile liste arasına dikeyde 8 birim boşluk bırakır
            const SizedBox(height: 8),
            // Bildirim listesinin dolu veya boş olmasına bakan Ternary (Koşul) yapısı
            bildirimler.isEmpty
                // Eğer liste boşsa ekranda ortalanmış "Henüz gelen bildirim yok" kutusu gösterilir
                ? Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    child: Text(
                      'Henüz gelen bildirim yok',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  )
                // Eğer liste doluysa verileri liste halinde ekrana basan ListView.separated
                // LITVIEW, COLUMN İÇİNDE SONSUZ YÜKSEKLİK HATASI VERMESİN VE SAYFANIN KAYDIRMASI İLE ÇAKIŞMASIN DİYE SHRINKWRAP:TRUE + NEVERSCROLLABLESCROLLPHYSICS
                : ListView.separated(
                    // Sütun içinde sonsuz yükseklik hatasını engellemek için gerekli küçülme ayarı
                    // 
                    shrinkWrap: true,
                    // Kartın kendi kaydırma özelliğini kapatıp ana sayfa kaydırmasına uyumlu hale getirir
                    physics: const NeverScrollableScrollPhysics(),
                    // Listede toplam kaç adet eleman döneceğini belirleyen sayaç
                    itemCount: bildirimler.length,
                    // Her bir liste elemanının arasına ince bir çizgi (Divider) çizen fonksiyon
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    // Listenin içindeki her bir veriyi tek tek alıp görsel birer satıra dönüştüren fonksiyon
                    itemBuilder: (context, index) {
                      // O anki sıradaki bildirim nesnesini değişkene aktarır
                      final b = bildirimler[index];
                      // Bildirimi görsel bir satır elemanı olarak ekrana çizer
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFE0F2F1),
                          child: const Icon(
                            Icons.mark_email_unread_outlined,
                            color: Color(0xFF006C4A),
                            size: 20,
                          ),
                        ),
                        title: Text(
                          b.baslik,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(b.icerik),
                        trailing: Text(
                          '${b.tarih.hour.toString().padLeft(2, '0')}:${b.tarih.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
