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


1. Expanded & Flexible

1.1. Expanded: Kalan boş alanın TAMAMINI kaplamaya zorlar.

1.2. Flexible: Kalan boş alanı paylaştırır (flex:1, flex:2)

1.3. Flex: Yanyana 2 expanded varsa birine flex 2, diğerine flex 1 verir; bu sayede ekran boyutuna göre otomatik olarak ayarlar.




2. Stack ve Positioned

2.1. ne yapar: Widgetları z ekseninde üst üste bindirir.

2.2. Positioned: Yalnızca bir Stack içinde çalışır.

2.3. top: 10, right: 10 vererek bir resmin sağ üst köşesine bildirim rozeti eklemenizi sağlar. 




3. ListView.builder

3.1. Klasik ListView(children: [...],) içindeki örnek vermek gerekirse 10.000 elemanın tamamını daha sayfa açılmadan belleğe yükler ve doğal olarak telefon donar. 

3.2. ListView.builder: Geri dönüşümlü görünüm alanı mantığını kullanır. Ekranda sadece o an eğer 5 kart gösterilecek ise sadece 5 kartı RAM belleğe yükler. Kullanıcı aşağı kaydırdıkça yukarıda kalanlar bellekten düşürülüp altta kalanlar belleğe taze olarak yeni olarak üretilir.
- Instagram 4 tane reels i indirir, hepsini ekrara gömmez, kalanını kaydırdıkça indirir. 

VirtualDOM uyg tamamı. bu sadece liste için bir döngü içincdedir. VirtualDOm tüm uyg alır. 


-------
(SIDENOTE: 
Optimizasyon
Sadece olduğun sayfadaki sadece ihtiyaç duyduğun belirli sayıdaki veriyi çekersin.)
------


shrinkWrap: true
Bir ListView başka bir dikey kaydırıcının (singleChildScrollView) içine konursa Vertical Viewport hatası verir.

shrinkWrap true verilerek bu çözülebilir ancak: ListView'un sonsuz kayma (sonsuz scroll) özelliğini kaybeder. Binlerce gönderin varsa olamz. 
**Sadece 3-5 elemanınız varsa bunu kullanmalısınız. Ve sayfa sabitse.**

devamlı döngü içindeyse SONSUZ. Instagramda reels kaydırma. Sürekli döngü içinde.
Döngü yoksa, sayılı ise SONLU. Facebook'da mesajlaşma. Mesajı yazdıkça aşağı doğru kayar. Ama yine de sınırı vardır. 




Inkwell ve GestureDetector

1. GestureDetector: Tıklama çift tıklama sürükleme olaylarını yakalar ama GÖRSEL HİÇBİR TEPKİ VERMEZ. Donanımdan alınan bilgidir. Kaç parmakla nasıl tıklanmış vs. yakalar. 

2. Inkwell: Tıklandığı an parmağın altından dışa doğru yayılan bir su dalgası efekti verir.

Önemli Kural: Inkwell'in arkasında mutlaka bir material widget olmak zorundadır. Aksi taktirde su dalgası arkadaki tuvali göremediği için hiçbir şekilde görünmez. 




Form Mimarisi

GlobalKey<FormState>

Widget içindeki Form düğümüne doğrudan dışarıdan müdahale ediyoruz. Bu yüzden widgetın en üstüne koyduğumuz globalKey değişkeni sayesinde formun Validate (geçerli) durumunu ve içindeki değerleri (Değişkenleri) dışarıdan okuyoruz.

_formKey.currentState?.validate() çağrıldığında o formun altındaki tüm TextFormField validator bloklarını sırayla çalıştırır.

validator: (String? value)
fonksiyonda bir hata bulursa geriye String olarak hata metni döndürür.
Bu metin otomatik kırmızı renkte ve inputun altında belirir. 
Eğer veri geçerliyse null döner. Flutter için bu alanda hata yok demektir, null gelmesi.

(
    SIDENOTE:
    1. GlobalKey<FormState> Nedir?
Uzaktan Kumanda Gibidir: Formun en üstüne koyduğumuz bu özel anahtar (_formKey), formun içindeki tüm bilgilere ve durumlara dışarıdan ulaşmamızı sağlar.

Normalde widget'lar kendi içlerindedir ve dışarıdan erişmek zordur; bu anahtar sayesinde formun durumunu (geçerli mi, değil mi?) tek komutla öğrenebiliriz.

2. _formKey.currentState?.validate() Ne Yapar?
Kontrol Et Tuşudur: Bu komutu çalıştırdığınızda, formun içindeki bütün TextFormField (metin kutusu) elemanlarının validator kuralları sırayla ve arka arkaya çalıştırılır.

Yani "Kullanıcı her şeyi doğru doldurmuş mu?" sorusunun sorulduğu andır.

3. validator (Doğrulama) Mantığı Nasıl Çalışır?
Her input kutucuğunun kendi kural kontrolcüsü (validator) vardır. Buraya girilen metin value olarak gelir ve şu mantıkla çalışır:

Eğer bir hata varsa: Fonksiyon geriye bir hata mesajı (String) döndürür. Flutter bu mesajı alır ve inputun altında otomatik olarak kırmızı renkte gösterir.

Eğer her şey yolundaysa: Fonksiyon null döndürür. Flutter için null demek, "Bu alanda hiçbir hata yok, veriler geçerli" anlamına gelir.
)



------
Animasyon Motoru

AnimatedContainer: genişlik, yükseklik, padding, margin, border, renk ve gölge oynatır.

AnimatedOpacity: Görünürlüğü 0.0 ila 1.0 arasında yumuşakça soldurur.

AnimatedScale: Widget merkezinden dışarıya doğru büyütüp küçültür.

AnimatedAlign: Widget kutunun içinde sağdan sola yukarıdan aşağıya karşı konumunu değiştirir.

Curves

1. Curves.linear: Sabit hız (robotik hareketler)
2. Curves.easeInout: Yavaş başlar ortada hızlanır yavaşça durur
3. Curves.bounceOut: Hedefe çarptığında top gibi 2 3 kez yaylanarak seker.
4. Curves.elasticOut: Lastik gibi ileri geri titreyerek yerine oturur.



1. GoRouter Nedir?
context.go('/profil'): Route Yönlendirmesidir. Rota tablosunda hiyerarşiyi takip eder sayfayı temizleyebilir. 

context.push('/profil/5'): Stack yönlendirmedir. Kullanıcı nereden gelirse gelsin mevcut sayfanın tepesine yeni bri katman ekler ve dönüş sayfası için bir geri ok butonu ekler.

context.pop() sayfanın en üstteki yığınını kapatır. 

state.pathParameters["id"]: Gorouter içinde tanımladığımız /:id yapılarına eerişmek için kullanılır.

/profil?user=berat
state.uri.queryParameters["user"]: Opsiyonel filtreleme ya da arama zamanlarında kullanılır.


Genel Yönlendirme Sistemidir: Flutter için modern ve URL tabanlı yönlendirme kütüphanesidir. Sayfalar arası geçişleri, parametre taşımayı ve yönlendirmeleri (redirect) tek bir merkezden yönetmenizi sağlar.

Yani uygulamanın bütün yönlendirme motorudur.

2. ShellRoute Nedir?
değişmez. tğm sayfalarda sabit çalışıyorsa shell. geri kalanların hepsi go. 
GoRouter'ın İçinde Bir Özelliktir: GoRouter'ın alt dalıdır. Amacı, sabit bir ana layout (şablon) oluşturmaktır.

En yaygın kullanım yeri Alt Navigasyon Çubuğu (BottomNavigationBar) veya yan menülerdir.

ShellRoute sayesinde kullanıcı alttaki menüden sekmeler arasında gezinirken, ana çerçeve (menü çubuğu) sabit kalır, sadece ortasındaki içerik alanı değişir.

Özetle Farkı:
GoRouter: Uygulamanın tüm sayfalar arası geçişlerini yöneten ana sistemdir.

ShellRoute: GoRouter içinde kullanılan ve "Arka plandaki menü/çerçeve sabit kalsın, sadece içindeki sayfa değişsin" dediğimiz durumlarda kullanılan özel bir rota türüdür.


Cihaz İçi Yerel Depolama Mimarileri

sharedPreferences:
küçük kullanıcı ayarları
düşük güvenilirlik.
Okuma yazma hızları: Okuma hızı orta / yazma hızı yavaş

FlutterSecureStorage:
Şifre Token vb. Saklama
en yüksek güvence
Okuma yazma hızları: Okuma hızı çok yavaş / yazma hızı çok yavaş

Hive/Isar:
Yüksek performanslı nesne depolama
Orta(isteğe bağlı şifreleme açılabilir.)


