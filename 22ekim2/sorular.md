1. *"Bir sınıfı `implements` ettiğimizde üst sınıftaki dolu bir fonksiyonun gövdesi miras gelir mi?"*  
   ➔ **HAYIR!** `implements` bir sözleşmedir; üst sınıfın içi dolu olsa bile tüm metotları sıfırdan `@override` edip kendiniz yazmak zorundasınız.
2. *"BlocBuilder içine `showDialog()` veya `SnackBar` yazarsak ne felaket yaşanır?"*  
   ➔ Sayfa her çizildiğinde (orientation değiştiğinde, klavye açıldığında) sonsuz döngüde kullanıcıya onlarca dialog fırlar. Dialoglar **SADECE `BlocListener`** içine yazılır!
3. *"Equatable kullanıyoruz ama yeni eklediğimiz `bool isFavorite` alanını `props` listesine yazmayı unuttuk. Ne olur?"*  
   ➔ BLoC nesnenin değiştiğini anlayamaz (içerik aynı sanır); veritabanında favori değişse bile ekrandaki kalp ikonu kırmızıya dönmez!
4. *"GetIt'te BLoC sınıfını `registerLazySingleton` yaparsak ne hata alırız?"*  
   ➔ Sayfadan çıkıp 1 saat sonra tekrar girdiğimizde eski sayfanın verileri ve hataları ekranda kalır; BLoC sıfırlanmaz. BLoC'lar her zaman **`registerFactory`** olmalıdır.
5. *"Clean Architecture'da neden `Entity` içine `fromJson` yazmıyoruz?"*  
   ➔ Domain katmanı dış dünyaya ve API formatına (JSON/XML) bağımlı olmasın, saf kalsın diye.
6. *"Asenkron `await` cevabı geldikten hemen sonra `emit(State)` yazmadan önce hangi kontrolü yapmazsak uygulama çöker?"*  
   ➔ `if (!isClosed)`. Kullanıcı o sırada sayfayı kapattıysa uygulama çöker.
7. *"`BlocSelector`'ın `BlocBuilder`'dan farkı ve esprisi nedir?"*  
   ➔ State içindeki 30 alandan sadece 1 tanesini süzer; diğer 29 alan değiştikçe o widget'ı gereksiz yere baştan çizmez (GPU ve pil tasarrufu).
8. *"`DIP` (Dependency Inversion) prensibine göre UI katmanı neden doğrudan somut servise değil de `interface`'e bağımlı olmalıdır?"*  
   ➔ Test yazarken sahte (mock) servis verebilmek ve yarın kütüphane değiştiğinde UI koduna dokunmamak için.
9. *"Interceptor nedir ve en yaygın kullanım alanı neresidir?"*  
   ➔ Ağ istekleri çıkmadan araya giren güvenlik istasyonudur; en yaygın kullanım alanı her isteğin Header'ına otomatik Bearer JWT Token eklemektir.
10. *"Dart 3'te `abstract interface class` olarak tanımlanan bir sınıfı başka bir sınıf `extends` edebilir mi?"*  
    ➔ **HAYIR!** Derleyici `interface class`'ların miras alınmasını (`extends`) yasaklar; yalnızca `implements` edilmeye zorlar.
11. *"HTTP `401` ile `403` arasındaki fark nedir?"*  
    ➔ `401`: Kim olduğunu bilmiyorum (Giriş yapmamışsın). `403`: Kim olduğunu biliyorum ama bu veriyi görmeye yetkin yok!
12. *"Stream ile Future arasındaki en temel fark nedir?"*  
    ➔ Future tek bir değer döner ve biter. Stream ise musluk gibidir; zaman içinde sürekli yeni veri akıtabilir.
13. *"BlocObserver ne işe yarar?"*  
    ➔ Uygulamadaki tüm State ve Event geçişlerini tek merkezden konsola ve analitik servisine loglar.
14. *"Single Responsibility Prensibi widget seviyesinde nasıl uygulanır?"*  
    ➔ Bir widget hem veri çekip hem UI çizip hem depolama yapmaz; 100 satırı geçen widget'lar küçük parçalara bölünür.
15. *"Savunmacı programlamada `(json['rate'] as num?)?.toDouble() ?? 0.0` yazmak bizi hangi hatadan kurtarır?"*  
    ➔ `type 'int' is not a subtype of type 'double'` ve `Null check operator used on null value` çökmesinden kurtarır.