Const

1) ne işe yarar: İçine girilen değerleri **derleme zamanında** tek bir kere yazılarak değişmez olarak üretir.

2) Neden Kullanılır: Bir widget const olarak tanımlanırsa setState olduğunda flutter bu widget'ı yeniden üretmez CPU ve pil tasarrufu sağlar.



final

1) ne işe yarar: **çalışma zamanında** değeri bir kez atanan ve sonrasında referansı asla değiştirilmeyen değişkenler

2) const ve final farkı: const derlenirken bilinmek zorunda(const pi=3.14) 
final ise çalışma anında belirlenebilir(final saat = DateTime.now())

3) ---Model sınıflarında alanlar her zaman **final** olmalıdır.--- class model



late

1) ne işe yarar: değişen tanımlandığı anda değil, ilk kullanıldığında veya initState anında başlayacağı zaman kullanılır.

2) ne yapar: veriyi arka tarafta tutar ama ön tarafa çağırmaz.



required

1) ne işe yarar: isimlendirilmiş parametrelerde o parametrenin zorunlu olduğunu belirtmek için kullanılır.



@override

1) ne işe yarar: alt sınıfın üst sınıftan devraldığı metodu ezdiğini belirtir.

2) faydası: eğer üst metod adını yanlış yazarsanız derleyici @override sayesinde bunu anında hata olarak yakalar. (mesela build yerine yanlışlıkla builds yazdın)



null-aware operatörleri (? ?? !)

?. - place?.title --> eğer place null ise hata vermez direk null olarak döner.
?? - if null: final id = state.userId ?? 10; --> sol taraf null ise sağdaki (hardcoded olan değer) otomatik olarak atanır.
! - (null / force): final id: state.userId ! --> bu kod derleyiciye bana güven bu değer o anda kesinlikle null değil verir. eğer null gelir ise uygulama anında çöker. (ÇOK DİKKATLİ KULLANILMALI)
örn: uygulamanın adı logosu olmadan uyg ayağa kalkmasın.



spread operatörü(...)

1) ne işe yarar: bir listenin elemanlarını tek tek çıkartıp bulunduğu üst listenin içine ekler. Column ve ListView içinde dinamik kart dizini kullanmak için en temiz yöntemdir.
...listeAdi.map((p) => _buildCard(p))



initState()

1) ne zaman çalışır: Widget ağaca fiziksel olarak ilk başladığında yalnızca 1 kere çalışır.

2) ne yapar: ScrollController başlatmaları ve ilk API istekleri burada kurulur.

3) Kural: İçinde doğrudan BuildContext ile Navigator çağrılmaz çünkü widget ağaca tam oturmamıştır.



didChangeDependencies()

1) ne zaman çalışır: initState()'den hemen sonra ve widget dinlendiği bir (örn. Theme.of(context) ) değiştiğinde otomatik olark günceller.

2) ne yapar: BuildContext güvenli bir şekilde erişerek tema ve ya ekran boyutu bağımlılıkları ile ilgili ilk yüklemeler burada yapılır.



build(BuildContext context)

1) ne zaman çalışır: Sayfa ilk açıldığında, setState() çağrıldığında veya üst widget yeni bir inşa ağaç boyama geldiğinde sayesinde defalarca çalışır.

2) Kural: build() metodu tamamen saf olmalıdır. Asla içinde setState() api isteği yada controller başlatma yapılmamalıdır. Sadece UI döndürmelidir.



dispose()

1) ne zaman çalışır: widget hafızadan atılmadan hemen önce son 1 kez çalışır.

2) ne yapılır: _controller.dispose() stream dinleyicilerin iptalleri burada yapılır. 
super.dispose() un mutlaka son satırda çalıştırılması gerekir.



setState((){})

1) arka planda ne yapar: State'in bağlı olduğu StatefulElement nesnesine "ben değiştim, build et" sinyali yollar.

2) nerede kullanılır: Sayfa genelini çizdirmez. Sadece onu dinleyen küçük ValueListenableBuilder'a sinyal gönderilir.



ValueNotifier<T>

1) arka planda ne iş yapar. ChangeNotifier sınıfından türer. Belleğinde tek bir nesne referansı tutar. (T _value) 

2) Tetikleme Değer atandığında (set value(T value)), eğer yeni değer eski değere eşit değilse (_value!=newValue), kayıtlı olan fonksiyonu çağrılır. (addListener() {})



InheritedNotifier

1) ne yapar: Widget ağacında alttaki childların, aradaki onlarca widget'ı baypass ederek, üst widgetın verisine (state'ine) doğrudan erişmesini sğalayan soyut bir widgettir.




Mterial 3 Tasarım Dili Renk Algoritması ve Temalar


primary: Ana marka rengi
onPrimary: Ana rengin üzerine yazılacak yazı rengi (okunabilirlik açısından)
primaryContainer: Ana rengin yumuşak pastel arkaplan tonu
onPrimaryContainer: Ana rengin pastel arkaplan üzerine yazılacak yazı rengi

secondary: İkincil renk (düğmeler, vurgular)
onSecondary: İkincil rengin üzerine yazılacak yazı rengi
secondaryContainer: İkincil rengin yumuşak pastel arkaplan tonu
onSecondaryContainer: İkincil rengin pastel arkaplan üzerine yazılacak yazı rengi

surface: Sayfa arkaplan tuvali
onSurface: Sayfa üstündeki ana metin rengi

outlineVariant: ince sınır ve ayrım çizgilerinin rengi


ThemeMode.system
color: Colors.black.withOpacity(0.8) --> hata verir! çöker! 1-255 arsında tamsayı olarak değer ister!
- **Bu kullanım güncelde istenmiyor. deprecated.**

color: Colors.black.withValues(alpha: 186/255) // double sayı olarak girilmelidir.
- **güncel ve doğru yöntem**




Arayüz Düzen ve Liste Bileşenleri


Expanded & Flexible

Expanded: Kalan boş alanın TAMAMINI kaplamaya zorlar.

Flexible: Kalan boş alanı paylaştırır (flex:1, flex:2)

Flex: Yanyana 2 expanded varsa birine flex 2, diğerine flex 1 verir; bu sayede ekran boyutuna göre otomatik olarak ayarlar.



Stack ve Positioned

ne yapar: Widgetları z ekseninde üst üste bindirir.

positioned: Yalnızca bir Stack içinde çalışır.

top: 10, right: 10 vererek bir resmin sağ üst köşesine bildirim rozeti eklemenizi sağlar. 






