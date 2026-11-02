import 'package:flutter/material.dart';

class HataliveDogruRow extends StatelessWidget{
    const HataliveDogruRow({super.key});

    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(
                title: const Text("Row ve Layout")
            ),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                // Column: Çocuk (children) widget'larını DİKEY eksende (alt alta) sıralar.
                child: Column( // dikey eksen
                // crossAxisAlignment: Column için YATAY eksendeki hizalamayı belirler.
                // 'CrossAxisAlignment.center' elemanları yatayda tam ortaya hizalar.
                // (Eğer 'start' olsaydı sola, 'end' olsaydı sağa yaslanırlardı).
                    crossAxisAlignment: CrossAxisAlignment.center, //EN üstten başladı.
                    children: [
                        const Text(
                            "Hatalı yapı: A overflowed by *** pixels (sarı siyah şerit)",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        const SizedBox(height: 8), // px girlmexse % oalrak alınır. style içindeki pixeller yazılabilir. 

                        // container içinde otomatik yatay sonsuz çalışır. uzun ayzı verirlise dışarı taşar ve sarı siyaah çizgili hata verilir.
                        Container(
                            color:Colors.amber.shade100,
                            // Row: Çocuk (children) widget'larını YATAY eksende (yan yana) sıralar.
                            // DİKKAT (Kritik Nokta): 
                            // Row, çocuklarına yatayda "sonsuz" genişlik tanımaya çalışır. 
                            // Eğer içine sığmayacak kadar uzun bir metin verilirse ekranın dışına taşar 
                            // ve ünlenen "A overflowed by X pixels" (sarı-siyah çizgili hata) görünür.
                            // Çözüm için metnin etrafına Flexible veya Expanded sarmalamak gerekir.
                            child:Row(
                                children: [
                                    const Icon(Icons.warning, color:Colors.red),
                                    const SizedBox(width:8),
                                    const Text('Kısa Metin (hata vermez ama uzarsa REnder Patlar)'),
                                ],
                            ),
                        ),
                        const SizedBox(height: 32),
                        const Text('Doğru Yapı: Flexible ce Expanded ile sınırlandırılmıştır.',

                        style: TextStyle(fontWeight: FontWeight.bold, color:Colors.green),
                        ),
                    ],
                ),
                Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color:Colors.green),
                    ),
                    child: Row(
                        children: [
                            const CircleAvatar(
                                backgroundColor: Colors.green,
                                child: Icon(Icons.check, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                        Text('SoftITo 4. Dönem Mobil Standardı',
                                        style:TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 4),
                                        Text('Bu metin ne kadar uzun olursa olsun telefonun ekranının genişliğinde alt satıra geçer ve asla sarı siyah taşma hatası üretmez.',
                                        style: TextStyle(color: Colors.black87),
                                        
                                        ),
                                    ],
                                ),
                            )
                        ]
                    )
                )
            )
        )
    }
}






