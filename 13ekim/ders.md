- Flutter en çok hanig sektörlerde kullanılır:
* e ticarette, sağlıkta React Native genelde baskındır. 
* oyun sektörü %99a yakın şekilde Flutter kullanılır 120fps farkından dolayı. Ama her sektörde Flutter kullanılabilir, [2026]. 

Flutter 3 ağaç mimarisi: 
1. Widget Ağaçları
2. Element Ağaçları
3.


1. Widget Ağaçları: 
    1. İskelet
    2. Immutables (değişmezler)

    * Widget -> hafif -> kolay -> ucuz maliyetli. 
    * saniyede 60-120 kez yaratılığ yeniden çöğpe atılır ve yeniden oluşturulur. 60-120 arasında. hz fps buradan gelir. 
    * Widget lar ekranda çizim yapmaz!
    * Sadece şablon sunar! 
    * yeni bir şey geldiğinde esikis çöpe atılır, yenien oluşturulur. her yenilikte her seferinde kendini yeniler. önceki silinir. güncellenmez. silinir. 
    * bir oyundaki her bir fps, 120 kere saniyede 1 güncellenmesidir ekranın. 
    * her widget ın bir keyi olmak zorundadır. 


2. Element Ağaçları
    * Yönetici bölümüdür.
    * Yaşayan iskeletin omurgasıdır. 
    * Mutable dır. Durumu ve referanslı hafızada canlı tutar, değişi.r
    * Widget ile renderObject arasındaki koordinatördür. Organizasyonu sunar. 
    * element kendini günceller. güncelleme yapar. canlı yapar. Elementler slinmez, widget lar silinir. Element güncellenir, widget yeniden üretilir. 
    * butonun içindeki yazı elementtir. yazı güncellenir. buton widgettır. buton değişincee çöpe atılır yenisi oluşturulur, element içine gömülür ekrana getirilir. 
    * widget yenilense bile element yenilenmemiş olabilir. 
    * içini günceller. 

// canUpdate
// standart kural static olarak başlar. 
static bool canUpdate(Widget oldWidget, Widget newWidget){
    return oldWidget.runtimeType = newWidget.runtimeType && oldWidget.key==newWidget.key;
}


State yaşam Döngüsü
* StatefulWidget => 
    * immutable olarak değişmez. her rebuild'de yneiden oluşturulur.

* State Nesneleri 
    * mutable. durumu saklar. rebuild sırasında çöpe atılmaz. element tarafında devam eder. 

Eğer 2 sınıf birleşik olsaydı her rebuild esnasında kullanıcı girdileri, sayaçlar, kontrollerlar, vb. sıfırlanırdı.








