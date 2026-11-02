import 'package:flutter/material.dart';
import '../sepetKontrolu.dart';

class VitrinEkrani extends StatelessWidget{
        const VitrinEkrani({super.key});

        @override
        Widget build(BuildContext context){
            return Scaffold(
                appBar: AppBar(
                    title: const Text('Canlı Vitrin (ValueNotifier)'),
                ),
                body: Center(
                    child: ElevatedButton.icon(
                        onPressed: (){
                            SepetKontrolu.ornek.sepeteEkle();
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Sepete ürün ekle (+1)'),
                    ),
                ),
            );
        }
    }
