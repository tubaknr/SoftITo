// ============================================================
// DOSYA 2: Row / Column Layout ve "overflow" hatası
// ============================================================
// [KİLİT - FLUTTER LAYOUT ALTIN KURALI]
//   "Constraints go down, sizes go up, parent sets position."
//   1) Üst widget, alt widget'a KISITLAMA (min/max boyut) verir.
//   2) Alt widget bu kısıtlar içinde kendi boyutunu seçer.
//   3) Üst widget alt widget'ın konumunu belirler.
//
// Row'un yatay eksende bounded olmayan (sınırsız) alan vermesi
// Text gibi flex olmayan çocuklar için geçerlidir. Text sığmazsa
// taşar ve sarı-siyah "A RenderFlex overflowed" şeridi çıkar.
// Çözüm: Expanded / Flexible (çocuğa KALAN alanı sınırlı verir).
// ============================================================

import 'package:flutter/material.dart';

// [MİMARİ] Ekran içinde state tutulmadığı için StatelessWidget.
class HataliveDogruRow extends StatelessWidget {
  // const constructor: widget değişmeyecekse rebuild maliyeti düşer.
  const HataliveDogruRow({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold: Material sayfa iskeleti (appBar + body vb.).
    return Scaffold(
      // Üst başlık çubuğu.
      appBar: AppBar(title: const Text("Row ve Layout")),
      // Body'yi her kenardan 16 px boşlukla sarar.
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // [DÜZELTME] Orijinalde Column kapanıp "Container"
        // Column'un DIŞINDA kalmıştı (Padding'e 2. child verilmişti).
        // Container artık Column'un children listesinin içinde.
        //
        // Column: çocukları DİKEY (alt alta) dizer.
        // Main axis = dikey, Cross axis = yatay.
        child: Column(
          // crossAxisAlignment: Column için YATAY hizalamadır.
          // center: ortalar. start: sola, end: sağa yaslar.
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Başlık: hatalı yapıyı anlatır.
            const Text(
              "Hatalı yapı: A overflowed by *** pixels (sarı siyah şerit)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            // Dikey boşluk. Değer mantıksal piksel (dp) cinsindendir,
            // yüzde değildir. Yüzde için MediaQuery / FractionallySizedBox.
            const SizedBox(height: 8),

            // Row'u görünür kılmak için arka plan rengi veren kutu.
            Container(
              color: Colors.amber.shade100,
              // Row: çocukları YATAY (yan yana) dizer.
              // [KİLİT] Row, Text gibi flex olmayan çocuklara yatayda
              // kısıt koymaz; içerik uzunsa ekran dışına TAŞAR.
              // Çözüm: Text'i Expanded veya Flexible ile sarmak.
              child: Row(
                children: [
                  // Uyarı ikonu.
                  const Icon(Icons.warning, color: Colors.red),
                  // İkon ile metin arası yatay boşluk.
                  const SizedBox(width: 8),
                  // Bu metin sarılmadığı için HATALI yapıdır.
                  // Dar ekranda bu metin bile taşabilir!
                  const Text('Kısa Metin (hata vermez ama uzarsa Render patlar)'),
                ],
              ),
            ),
            // İki örnek arasında büyük boşluk.
            const SizedBox(height: 32),

            // Başlık: doğru yapıyı anlatır.
            const Text(
              'Doğru Yapı: Flexible ve Expanded ile sınırlandırılmıştır.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            // Doğru yapının örneği olan kart benzeri kutu.
            Container(
              // İç boşluk: içerik kenarlara yapışmaz.
              padding: const EdgeInsets.all(12),
              // decoration kullanılırsa "color" buraya yazılmalıdır
              // (Container'da hem color hem decoration verilemez).
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                children: [
                  // Yuvarlak ikon alanı.
                  const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  // [KİLİT] Expanded: Row'daki KALAN yatay alanı doldurur
                  // ve çocuğuna SINIRLI genişlik verir. Metin artık
                  // taşmaz, sığmazsa alt satıra geçer.
                  // Flexible farkı: çocuk küçükse küçük kalabilir
                  // (loose fit). Expanded = Flexible(fit: tight).
                  Expanded(
                    // Birbirinin altına iki metin için iç Column.
                    child: Column(
                      // Metinleri sola yaslar (start = yatay başlangıç).
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Liste sabit olduğu için const kullanılabilir.
                      children: const [
                        Text(
                          'SoftITo 4. Dönem Mobil Standardı',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Bu metin ne kadar uzun olursa olsun telefonun ekranının '
                          'genişliğinde alt satıra geçer ve asla sarı siyah '
                          'taşma hatası üretmez.',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // [DÜZELTME] Orijinalde return satırında ";" ve parantezler
    // eksikti/fazlaydı. Yapı yukarıdaki gibi kapatıldı.
  }
}