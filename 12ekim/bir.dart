  // soyutlama abstraction

/*
// 1. Sözleşmeler (contract)
// ABSTRACT CLASS: Sınıfın soyut bir sınıf olduğunu belirtir. Bu sınıftan nesne oluşturulamaz. Sadece alt sınıflar tarafından genişletilebilir.
// SÖZLEŞME
// SÖZLEŞMELERDE SADECE İMZA KULLANILIR, KODUN TAMAMI VERİLMEZ.
abstract class AuthReposity{
  Future<String>login(String email,String password);
  Future<void>logout();
  bool get isAuth;
}

// 2. Sözleşmelerin uygulanması (implementation) FirebaseAuthReposity
// IMPLEMENTS: CONTRACTDIR. KULANILAMAZ. SÖZLEŞME İMZASINI ALIR. 
// EXTEND: HEM DAVRANIŞI HEM KODU ALIR. HEM DAVRANIŞI HEM İMZAYI ALIR.
class FirebaseAuthReposity implements AuthReposity{
  @override
  Future<String> login(String email, String password) async{
    // gerçek firebase SDK çağrısı 
    return "firebase_toke_xyz_123";
  }

  @override
  Future<void> logout() async{
    // Firebase logout
  }

  @override
  bool get isAuth => true;
}

// 3. Mock (sahte) uygulama MockAuthireposity
class MockAuthireposity implements AuthReposity{
  @override 
  Future<String> login(String email, String password) async{
    await Future.delayed(Duration(seconds:1));
    return "mock_token_abc_789";
  }

  @override
  Future<void> logout() async{
  }

  @override
  bool get isAuth => false;
}


mixin Logger {
  void log(String msg) => print("LOG: $msg");
}

mixin Analytics {
  void log(String msg) => print("ANALİZ: $msg");
}

class PaymentService with Logger, Analytics{
  // async yazmadık -> sonradan gelen ilkini ezer, sonradan gelen çalışır. 
  // ANALİZ çalışır. Logger çalışmaz.
  void pay(){
    log("Ödeme Yapıldı.");
  }
}

// ---------------------------------------------------------------------------------------------
abstract class BaseWidget{
}

// sadece baseWidgt ve alts ınıfalrda kullanılsın.
mixin LifeLogger on BaseWidget{
  void logInit() => print("Widget başlatıldı.");
}




extension StringValidator on String{
  bool get isValidEmail{
    final emailRegex=RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  String toCapitalize(){
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

void main(){
  String email = "Selahaddin@kodvance.com";
  if(email.isValidEmail){
    print("Geçerli maildir.");
  } else {
    print("Geçersiz maildir.");
  }
}


// ABSTRACT -> ARAYÜZ INTERFACE!!!!
//Nedir? Bu, soyut (abstract) bir sınıftır ve Dart'ta arayüz (interface) görevi görür.

//Amacı: Bu arayüzü uygulayan (implements eden) her sınıfın zorunlu olarak String türünde bir id getter'ına sahip olması gerektiğini garanti eder. Yani buradaki kural şudur: "Benimle çalışmak istiyorsan, bir id'n olmalı."
abstract class Identifiable{
  String get id;

}

// T tipi Mutlaka Identifiable arayüzünü uygulamak ZORUNDADIR.
class GenericCache<T extends Identifiable>{
  //"T tipi mutlaka Identifiable arayüzünden türemeli veya onu uygulamalıdır" anlamına gelir.
  final Map<String, T> _storage = {};

//Parametre olarak T tipinde bir item alır.
//item.id ifadesini güvenle kullanabilir çünkü T'nin kesinlikle Identifiable olduğunu (id'si olduğunu) biliyoruz.
//Gelen nesneyi dahili _storage haritasına (Map) anahtar olarak item.id, değer olarak ise nesnenin kendisi olacak şekilde kaydeder.
  void save (T item){
    _storage[item.id] = item;
    print("ID: ${item.id} önbelleğe alındı.");
  }

// tipi string gelmezse çalıştırma, number gelirse çalıştırma yazdırma. hiç çalıştırma. 
// burası ekstra güvenlik. tip güvenliği. 
// Dönüş tipi T? (nullable) şeklindedir. Yani aranan id'ye sahip bir nesne bulunamazsa null döner, bulursa T tipindeki nesneyi döndürür.
  T? getById(String id) => _storage[id];

}
*/

// FUTURE: elinde veri tipi yoksa veri tipinden bağımsız çalıştırmayı sağlar. O değişkenle ilgili sana hata fırlatmaz. 
// işlem takibi, hata mı aldım, sonucunu mu aldım, devam mı ediyor buna FUTURE ile bakabiliyorum.
// MICROTASK: kendini öne alır. sonucu döndür hata mı veri mi neyse onu döndür dememizin sebebi. 
// scheduleMicrotask: printler hariç en öne alır. 
import 'dart:async';

void main(){
  // 1-5-2-4-3
  print("1.senkron task");

  scheduleMicrotask(() {
    print("2.task oluştu (vip kuyruk)");
  });

  Future(() {
    print("3.standart Event Kuyruğu");
  });

  Future.microtask(() {
    print("4.Future.microtask çalıştı");
  });

  print("5.senkron kod tamamlandı.");
}











