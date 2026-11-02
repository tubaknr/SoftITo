import 'package:flutter/material.dart';

class SepetKontrolu{
    static final SepetKontrolu ornek = SepetKontrolu._dahili();
    SepetKontrolu._dahili();

    // default ürün sayısı = 0
    final ValueNotifier<int> urunSayisi = ValueNotifier<int>(0);

    //ürün arttırma metodu
    void sepeteEkle(){
        urunSayisi.value++;
    }

    //ürün sıfırlama metodu
    void sepetSifirla(){
        urunSayisi.value = 0;
    }
}