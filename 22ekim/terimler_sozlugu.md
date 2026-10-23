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



------
### Cuma öğleden sonra Sümeyye dersi

## Sözleşmeler, SOLID Prensipleri & OOP Mimarisi

### 1.1. `interface` (arayüz/sözleşme)
**Sözlük anlamı:** iki bağımsız sistemin veya sınıfın birbiriyle nasıl konuşacağını belirleyen, içi boş metot imzalarından oluşan kurallar bütünü.

- İtalyanŞef sınıfı bu arayüzü implements ederse (bu sözleşmeyi imzalarsa), o iki yemeği kendi tarifine göre sıfırdan yapmak zorundadır. İtalyan şef minestrone çorbası yapar, TürkAşçı sınıfı mercimek çorbası yapar. Sistem (restoran müdürü), ikisinin de "çorba" yapabildiğini bilir ve gerisine karışmaz. Gevşek bağlılık (loose coupling) budur.

**Neden kullanılır:** Bir sınıfa göbekten bağımlı kalmamak (örneğin gerçek şarj istasyonu cihazı olmadan sahte/mock şarj seviyesiyle testi çalıştırabilmek) için.

```dart
abstract interface class StationContract({
    Future<void> startCharging(String socketId);
    Stream<double> watchLivePower();
})
```

### 1.2. `implements` ve `extends` vs `with`
#### 1.2.1. `implements` (Arayüz Sözleşmesi)
**sözlük anlamı:** bir sınıfın, bir şablonun belirlediği kuralları kabul edip **içini sıfırdan kendisinin doldurması** zorunluluğudur. 

**Neden kullanılır:** farklı sınıflara ortak bir standart/sözleşme dayatmak, çoklu arayüz desteği sağlamak ve kodda bağımlılıkları azaltmak için.

```dart
// İş ilanı (Sözleşme)
abstract class AscilikSozlesmesi {
  void yemekYap();
  void mutfagiTemizle();
}

// Sözleşmeyi imzalayan sınıf
class ItalyanSef implements AscilikSozlesmesi {
  @override
  void yemekYap() {
    print("Makarna yapılıyor...");
  }

  @override
  void mutfagiTemizle() {
    print("Mutfak İtalyan standartlarında temizleniyor...");
  }
}
```

#### 1.2.2. `extends` (kalıtım/miras)

**sözlük anlamı:** bir sınıfın, başka bir sınıfın özelliklerini ve metotlarını doğrudan devralması.

- Garson sınıfı oluştururken, bu metotları tekrar tekrar yazmamak için Çalışan sınıfını extends edersin (miras alırsın). Garson, ebeveyninin yeteneklerini doğrudan cebinde bulur. Kod tekrarı (DRY - Don't Repeat Yourself) engellenmiş olur.

**Neden kullanılır:** kod tekrarını önlemek (DRY), mantıksal bir sınıf hiyerarşisi oluşturmak için.

```dart
// Ebeveyn sınıf
class Calisan {
  String isim;
  Calisan(this.isim);

  void molaVer() {
    print("$isim mola yapıyor. Çay içiliyor.");
  }
}

// Çocuk sınıf ebeveynin tüm yeteneklerini miras alır
class Garson extends Calisan {
  Garson(String isim) : super(isim);
  
  void siparisAl() {
    print("$isim siparişleri alıyor.");
  }
}

// Kullanımı:
// var garson = Garson("Ali");
// garson.molaVer(); // Ebeveynden gelen metot doğrudan kullanılabilir.

```


#### 1.2.3. `with` (mixin/yetenek aşılama)

**Neden kullanılır:** sınıf hiyerarşisini bozmadan, bağımsız bir sınıfa hazır kod blokları (metotlar ve değişkenler) enjekte etme mekanizmasıdır. 

- Kalıtım (extends) ağacını bozmadan, akraba olmayan sınıflara hazır yetenek (davranış) paketleri eklemektir.
- Diyelim ki restoranda bazılarının "İlk Yardım" sertifikası var. Bu kişi bir Aşçı da olabilir, Kasiyer de olabilir. Sadece İlk Yardım için yeni bir "Ebeveyn Sınıf" oluşturmak mantıksızdır.
Bunun yerine IlkYardim adında bir mixin yazarsın. class Kasiyer extends Çalışan with IlkYardim dediğin an, kasiyere kalp masajı yapma yeteneğini enjekte etmiş olursun. Sınıfın kimliği (Kasiyer) değişmez, sadece çantasına yeni bir alet eklenmiş olur.

**Neden kullanılır:** Akraba olmayan sınıflara ortak yetenekler kazandırmak, çoklu kaltıım kimliğini önlemek ve modülerliği arttırmak için. 

```dart
// Hazır yetenek paketi (Mixin)
mixin IlkYardim {
  void kalpMasajiYap() {
    print("Kalp masajı yapılıyor! 1-2-3-4...");
  }
}

// Ana sınıf
class Kasiyer extends Calisan with IlkYardim {
  Kasiyer(String isim) : super(isim);

  void hesapAl() {
    print("$isim hesabı alıyor.");
  }
}

// Kullanımı:
// var kasiyer = Kasiyer("Ayşe");
// kasiyer.hesapAl(); // Kendi metodu
// kasiyer.molaVer(); // Calisan'dan extends ile geldi
// kasiyer.kalpMasajiYap(); // IlkYardim mixin'inden with ile geldi
```

| Özellik | extends | implements | with |
|---|---|---|---|
| **Temel felsefe** | ben senin çocuğunum, genlerini alıyorum. | seninle sözleşme imzaladım, maddeleri ben yapacağım. | ben ana sınıfıma ek bir uzmanlık yeteneği takıyorum. |
| **gövdesi dolu metot gelir mi** | evet, üst sınıfın metotlarını doğrudan kullanır. | hayır! üst sınıfın içi dolu olsa bile hepsi silinir, sıfırdan yazılır. | evet, mixin içindeki hazır metotlar sınıfa eklenir. |
| **kaç tane kullanılabilir?** | sadece 1 tane (dartta çoklu kalıtım yasaktır). | sınırsız (virgülle onlarca interface uygulanabilir). | sınırsız (virgülle birden çok mixin takılabilir). |
| **Constructor var mıdır** | evet | hayır (interfacein constructor ı olmaz). | hayır. |


------

### 1.3. SOLID Prensipleri (Mobil & Dart Odaklı)
#### 1. S - Single Responsibility Principle
**Kural:** bir sınıfın veya dosyanın değişmesi için **yalnızca 1 sebebi** olmalıdır. 

### 2. O - Open / Closed Prinsiple
**Kural:** yazılım varlıkları (sınıflar, modüller) **genişletilmeye AÇIK, ancak değiştirilmeye KAPALI** olmalıdır. 

### 3. L - Liskov Substitution Principle
**Kural:** bir üst sınıfın yerine, onun alt sınıflarından herhangi biri geçirildiğinde sistemin davranışı bozulmamalıdır ve hata fırlatmamalıdır.

### 4. I - Interface Segregation Principle
**Kural:** İstemciler (sınıflar), kullanmadıkları metotları içermeye zorlanmamalıdır. Şişman (fat) interface'ler yerine küçük, amaca yönetik arayüzler kurulmalıdır.

### 5. D - Dependency Inversion Principle
**Kural:** Yüksek seviyeli modüller (UI, iş mantığı), düşük seviyeli modüllere (veritabanı, HTTP istemcisi) bağlı olmamalıdır. Her ikisi de soyutlamalara (`interface`) bağlı olmalıdır.


---

### 1.4. `Coupling` (Bağlaşıklık) ve `Cohesion` (Uyum)
**Tightly Coupled (Sıkı bağımlı):** sınıfların birbirinin her detayını bilmesi. birinde yapılan bir harflik değişiklik, diğer 5 dosyayı bozuyorsa sistem sıkı bağımlıdır. Tightly Couped.

```dart
class Araba {
  // Araba, motoru kendisi üretiyor. Başka motor takılamaz.
  V8Motor motor = V8Motor(); 

  void gazaBas() {
    motor.calistir();
  }
}
```

**Loosely Coupled (Gevşek bağımlı):** sınıfların sadece interface üzerinden konuşması. Biri değiştiğinde diğeri etkilenmez. Loosely Coupled. 

```dart
class Araba {
  Motor motor;
  
  // Motor dışarıdan lego parçası gibi takılır. (Dependency Injection)
  Araba(this.motor); 

  void gazaBas() {
    motor.calistir();
  }
}
```

**High Cohesion (YÜKSEK UYUM):** Bir sınıfın sadece ve sadece kendi uzmanlık alanını yapması. 

**Low cohesion: KÖTÜ ÖRNEK**
```dart
class Personel {
  void yemekYap() { ... }
  void maaslariHesapla() { ... }
  void veritabaninaKaydet() { ... }
}
```

**High Cohesion: İYİ ÖRNEK**
```dart
class Asci {
  void yemekYap() { ... }
}

class Muhasebe {
  void maaslariHesapla() { ... }
}

class Veritabani {
  void kaydet() { ... }
}
```
-------

## STREAM TEMELLERİ, CUBIT & ENTERPRISE BLOC

### 2.1. `Stream` Nedir? (BLoC'un kalbindeki motor)
**sözlük anlamı:** zaman içinde parça parça gelen, akıp giden asenkron veri dizisi.

**BLoC sırrı:** BLOC kütüphanesi sihirli bir şey yapmaz! BLoC un içinde gizli bir `StreamController` vardır. Event'ler borunun bir ucundan girer (`sink.add`), BLoC onları işler ve diğer ucundan ekrana state akıtır. (`stream.listen`).

- Örnek: 
- sink (Giriş/Huni): Makinenin üstünden meyveleri attığın yerdir (Kullanıcının butona basması / Event).
- stream (Çıkış/Musluk): Makineden akan hazır meyve suyudur (Ekranda gösterilecek veri / State).
- listen (Dinleyici): Musluğun altına bardağı koyup yeni meyve suyu gelmesini bekleyen kişidir (Telefon ekranı / UI).

- BLoC mimarisi, bu makineyi senin yerine güvenle kurup kapatan ve içine giren meyveyi (Event) nasıl meyve suyuna (State) dönüştüreceğinin kurallarını yazdığın hazır bir sistemdir. Sen sadece "elma girerse elma suyu ver" kuralını yazarsın, gerisini BLoC halleder.

```dart
import 'dart:async';

void main() {
  // 1. Makineyi kuruyoruz (BLoC'un içindeki gizli motor)
  final makine = StreamController<String>();

  // 2. Müşteri musluğun altına bardağı koyup bekliyor (UI Ekranı)
  // Makineden ne zaman yeni bir şey gelse bu blok otomatik çalışır.
  makine.stream.listen((cikanIcecek) {
    print("Ekranda güncellenen veri: $cikanIcecek hazır! 🥤");
  });

  // 3. Makinenin hunisinden içeri malzeme atıyoruz (Event / Kullanıcı Etkileşimi)
  print("Kullanıcı butona bastı: Portakal atılıyor...");
  makine.sink.add("Portakal Suyu"); // Bu yapıldığı an yukarıdaki listen tetiklenir

  print("Kullanıcı butona bastı: Elma atılıyor...");
  makine.sink.add("Elma Suyu");

  // İş bitince makineyi kapatıyoruz (Hafıza sızıntısı olmaması için)
  makine.close();
}
```

## KARŞILAŞTIRMA TABLOSU
| Kriter | Cubit (hafif BLoC)  | BLoC (event-driven)  |
|---|---|---|
| **tetikleme mekanizması** | Doğrudan metot çağrısı: cubit.loadStations()  | event fırlatma: bloc.add(LoadStationsEvent())  |
| **kod miktarı**  | az dosya, sade ve hızlı  | event dosyası + state dosyası + BLoC dosyası  |
| **izlenebilirlik (traceability)**  | sadece hangi fonksiyonun çağrıldığı bilinir  | hangi event'in hangi state'e yol açtığı saniye saniye izlenir.  |
| **event dönüştürücü (debounce/throttle)**  | Elle Timer veya flag kurmak gerekir  | transformer: restartable() ile tek satırda çözülür  |
| **ne zaman tercih edilmeli**  | basit formlar, tema değiştirme, tab geçişleri, profil  | şarj başlatma/bitirme, sepet akışı, bakiye transferi, kimlik doğrulama  |

---
### 2.3. BLoC'un 3 Temel Elemanı: `Event`, `State`, `Emitter`
**Event (olay):** Kullanıcının veya sistemin BLoC'a attığı emir fişi.

*Mini Sözdizimi:* `class StartChargingRequested extends ChargingEvent { final String sockeetId; } `

**State (durum):** ekranın o milisaniyedeki dondurulmuş fotoğrafı (snapshot).

*Mini Sözdizimi:* `class ChargingActiveState extends ChargingState { final double kwh; }`

**Özel durumlar:** `Initial`, `Loading`, `Loaded`, `Error`

**Emitter:** BLoC'un ürettiği yeni state'i ekrana fırlattığı megafon borusu.

**Kural:** Senkron çalışır: `emit(NewState())` dendiği anda UI'daki builder'lar tetiklenir.

app async işlem başlatır, kullanıcı cevap gelmeden uyg kapatır, yada geri tuşuna basar, ne olur?

### Soru: State değiştiğinde ne yapmak istiyorsun?  

| İhtiyaç | Örnek Durumlar | Kullanılacak Widget |
| :--- | :--- | :--- |
| **Sadece arayüz çizmek**   | - kart basmak  <br>- spinner döndürmek  <br>- liste render etmek   | **`BlocBuilder`**   |
| **Sadece yan etki tetiklemek**   | - snackBar patlatmak  <br>- showDialog() açmak  <br>- context.go() ile gitmek   | **`BlocListener`**   |
| **Hem arayüz çizmek hem yan etki tetiklemek**   | - hata olunca SnackBar bas,  <br>- ama listeyi ekranda tut   | **`BlocConsumer`**   |


## 3.1. `Side Effect` (Yan Etki) Neden `BlockBuilder` İçine Yazılmaz?
* `BlocBuilder`'ın tek görevi **Widget döndürmektir**. 
* Flutter motoru ekranı saniyede 60 kez çizebilir (Rebuild).  Eğer siz `BlocBuilder` içine `ScaffoldMessenger.showSnackBar` veya `Navigator.push` yazarsanız; kullanıcı cihazı yan çevirdiğinde veya klavye açıldığında kullanıcıya **üst üste 10 defa SnackBar patlar veya 10 kez yeni sayfa açılır!** 
* **Kural:** Yan etkiler SADECE `BlocListener` içine yazılır; çünkü `listener` sayfa rebuild olduğunda değil, **yalnızca State değiştiğinde 1 kez** tetiklenir! 

### 3.2. `BlocSelector` (Mikro Performans & Pil Tasarrufu)

* **Kavram:** State'in içindeki onlarca alandan sadece **1 tanesini süzüp izlemek**.

---
## 4. EŞİTLİK, DEĞİŞMEZLİK & BLOCOBSERVER
### 4.1. `Referential Equality` vs `Value Equality`

* **Dart Varsayılanı (Referans Eşitliği):** İki nesnenin bellekteki (RAM) adresi aynı mı?
  `Soket('A') == Soket('A')` -> **FALSE çıkar!** İçerikleri aynı olsa da RAM'deki evleri farklıdır.
  
* **Değer Eşitliği (Value Equality):** Nesnelerin içindeki veriler aynı mı?
  `Equatable` paketi tam olarak bunu çözer: Nesneleri RAM adresine göre değil, `props` listesindeki alanların değerine göre karşılaştırır.


### 4.3. `Immutability` (Değişmezlik) & `copyWith`
* **Kural:** State sınıflarının tüm alanları `final` olmalıdır (Değişmez).
* **`copyWith` Mantığı:** Eski nesnenin 5 alanını koruyup, sadece değişen 1 alanını güncelleyerek taze bir nesne üretme yöntemidir.
```dart
  final guncel = state.copyWith(isCharging: true); // Diğer alanlar bozulmadan kopyalanır
```

## 1. PRESENTATION

- UI ekranları
- butonlar
- theme
- BLoC
- Cubit
- BAĞIMLILIK İÇERİ BAKAR

## 2. DOMAIN

- iş kuralları - en kutsal katman
- entity (saf veri)
- useCase (iş kuralları)
- repository interface (sözleşmeler)

* **Kural:** dış dünyada (JSON, Dio, SQLite) asla bilgi içermez!!!! Sıfır harici paket importu!

## 3. DATA (veri altyapısı)
 
- Model / DTO (fromJson / toJson)
- Remote DataSource (Dio ile API)
- Local DataStorage (Hive / sharedPreferences ile disk)
- Repository Implementation
- SÖZLEŞMEYİ UYGULAR

--------------


## 5. CLEAN ARCHITECTURE KATMANLARI & SORUMLULUK DUVARLARI
### 5.1. `Entity` vs `Model / DTO`

* **`Entity` (Varlık):** Saf iş nesnesidir. Bir şarj soketinin gerçek hayattaki özelliklerini (`id`, `kw`, `durum`) tutar. `fromJson` veya `toJson` İÇERMEZ.

* **`Model / DTO` (Veri Transfer Nesnesi):** 

AP'den gelen ham JSON verisini karşılayan taşıyıcıdır. `Entity`'den türer. `fromJson` ve `toJson` metotlarını barındırır.

* *"Neden Entity içine `fromJson` yazmıyoruz?"*
* *(Cevap: Yarın backend JSON yerine XML veya Protobuf formatına geçerse; Domain katmanındaki iş kurallarımız ve UI sayfalarımız zerre kadar etkilenmesin, sadece DATA katmanındaki Model etkilensin diye!)*

### 5.2. `UseCase` (Kullanım Senaryosu)
* **Kavram:** Kullanıcının veya sistemin gerçekleştirebileceği **tek ve atomik bir iş kuralı**.
* **Örnekler:** `StartChargingSessionUseCase`, `GetStationSocketsUseCase`, `RefundWalletBalanceUseCase`.

* **Kural:** Her UseCase sınıfının içinde sadece tek bir call() veya execute() fonksiyonu bulunur.

### 5.3. `Repository Contract` vs `Repository Implementation`


## 6. BAĞIMLILIK YÖNETİMİ: DEPENDENCY INJECTION & `get_it`

### 6.1. Neden `new Dio()` Yazmak Yasaktır?
Eğer 5 ayrı sayfada `final dio = Dio();` derseniz:

1. Bellekte 5 ayrı bağlantı havuzu açılır, telefonun soket sınırını zorlar.
2. Base URL veya Timeout değiştiğinde 5 ayrı dosyayı elle değiştirmek zorunda kalırsınız.
3. Test yazarken sahte (mock) veri enjekte edemezsiniz.


### 6.2. `GetIt` Kayıt Tipleri: Singleton vs LazySingleton vs Factory

* **`Singleton`:** Uygulama açıldığı milisaniyede nesneyi üretir ve belleğe çiviler.

* **`LazySingleton`:** Uygulama açıldığında üretmez! Ne zaman ilk kez birisi `sl<Dio>()` derse o an üretir ve sonrasında hep aynı nesneyi verir. (Bellek ve açılış hızı dostudur).

* **`Factory`:** Her çağrıldığında **yepyeni, sıfır bir kopya** üretir.


## 7. KURUMSAL AĞ MİMARİSİ: DIO, INTERCEPTOR & HTTP STATUS KODLARI

* **Sözlük Anlamı:** Ağ isteği telefondan çıkıp internete gitmeden önce veya sunucudan cevap gelip koda düşmeden önce araya girip paketi inceleyen/değiştiren güvenlik noktası.

### 7.2. `Bearer Token` & `Payload`


### 7.3. `HTTP STATUS KODLARI` (Sayısal Anlamları)
* **200 OK:** Başarılı 
* **400 Bad Request:** Kötü istek (Formu eksik doldurdun, parolan çok kısa)
* **401 Unauthorized:** Yetkisiz (Giriş yapmadın veya token bayat)
* **403 Forbidden:** Yasak (Token var ama yetkin yetersiz - Admin rolü lazım)
* **404 Not Found:** Sayfa/Kaynak bulunamadı
* **500 Internal Server Error:** Sunucu şoka girdi (Bizim kod hatamız veya backend çöktü)

## 8. VERİ DAYANIKLILIĞI: CACHE-FIRST & SAVUNMACI KODLAMA

### 8.1. `Cache-first` (Önce Bellek) Stratejisi

* **Mantık:** Kullanıcı şarj istasyonu listesini açtığında 1 saniye bile beyaz ekranda spinner bekletme! Diskteki dünkü veriyi **0.01 milisaniyede** ekrana bas. Arka planda sunucudan taze veriyi çek; gelince ekranı ve diski sessizce güncelle.

### 8.2. `Defensive Programming` (Savunmacı Programlama)

* **Mantık:** Sunucudan gelen veriye asla %100 güvenmeme prensibi.


---- 
# SORULAR
blockbuilder içne showbuilder veya snackbar yazılırsa ne felaket olur ?

- BlocBuilder içine showDialog veya SnackBar gibi yan etkiler (side effects) yazılırsa, Flutter'ın ekran çizim (rebuild) döngüsüne yakalanarak aynı işlemin kontrolsüzce defalarca tekrarlanması felaketi yaşanır.



------



