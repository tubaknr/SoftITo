// setState() bulunduğu State nesnesinin build() metodunu baştan aşağı tekrar tetikler.
// setState() tüm build ağacını baştan aşağıya yeniden çalıştırır.
// Scaffold appbar tabbar ve eğer varsa 20 tane container baştan hesaplanır.
// tüm alt widget ları yeniden çizer. 

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Singleton tekil örnek tasarım deseniyle sepet ve sayaç işlemlerini yöneten class. 
class SepetKontrolu{
  // sınıfın her yerden erişilebilecek tek ve sabit instance ı. 
    static final SepetKontrolu ornek = SepetKontrolu._dahili();
    // dışarıdan yeni nesne üretilmesini engelleyen private metot.
    SepetKontrolu._dahili();

    // default ürün sayısı = 0
    // sepetteki ürün sayısnı tutar. 
    // ValueNotifier değer değiştikçe listenerları haberdar eden reaktif bir integer değişken. 
    final ValueNotifier<int> urunSayisi = ValueNotifier<int>(0);

    //ürün arttırma metodu 
    void sepeteEkle(){
        urunSayisi.value++; // arayüz güncellenir.
    }

    //ürün sıfırlama metodu
    void sepetSifirla(){
        urunSayisi.value = 0; // arayüz güncellenir.
    }
}

final GoRouter uygulamaRotalari = GoRouter( // uygulamanın sayfa yönlendirme  yapılandımrası
    initialLocation:'/anasayfa', // ilk açıldığında gidilecek sayfa
    routes:[ // rotaların listesi
        ShellRouter( // alt sayfaları ortak bir üst iskelet içinde göstermeyi sağlayan router. 
            builder(BuildContext context, GoRouterState state, Widget child){ // ortak şablonu ve içerisine gelecek alt sayfayı inşa eden builder fonk.
                return AnaKasaEkrani(ekranGovdesi: child); // ortak iskelet ekranını alt sayfa gövdesiyle birlikte döndürür.
            },
            routes: [ // alt rotalar
                GoRoute( // vitrin ekranı için rota tanımı
                    path: '/vitrin', // url yolu
                    builder:(context, state) => const VitrinEkrani(), // vitrin syafasını oluşturan builder fonk.
                ),
                GoRoute( // profil ekranı için rota tanımı
                    path: '/profil', // url yolu
                    builder: (context, state) => const ProfilEkrani(), // profil sayfasını oluşturan builder fonk.
                ),
            ],
        ),
    ],
);

// uygulamanın ana ekranını oluşturur. statei yok. 
class AnaKasaEkrani extends StatelessWidget{
    //BLoC ile stateless içinde veri güncellenebilir.
    // komple ekrranı boymaadan güncelleme uyapılabilir.
    // sadece 1 veri değişiyor, yazı değişiyor, widgetın tamamı değişmez, tamamı yenilenmiyor -> statless kullanılabilir.
    // stateless da komple widget yenilenmez, statefulda komple widget yenilernir.
    
    final Widget ekranGovdesi; 
    const AnaKasaEkrani({super.key, required this.ekranGovdesi});

    @override
    Widget build(BuildContext context){
        return Scaffold(
            body: ekranGovdesi,
            bottomNavigation:.navigationBar(
                selectedIndex: _aktifIndexiBul(context),
                onDestinationSelected:(yeniIndex){
                    if (yeniIndex == 0) {
                        context.go('/vitrin');
                    }
                    else if (yeniIndex == 1){
                        context.go('/profil');
                    }
                },
                destinations: [
                    const NavigationDestination(icon: Icon(Icons.store), label:'Vitrin'),
                    NavigationDestination(
                        icon: ValueListenableBuilder<int>(
                            valueListenable:SepetKontrolu.ornek.urunSayisi,
                            builder:(context, sayi, child){
                                return Badge(
                                    label: Text('${sayi}'),
                                    isLabelVisible: sayi > 0,
                                    child: const Icon(Icons.person),
                                );
                            },
                        ),
                        label: 'Profil',
                    ),
                ],
            ),
        );
    }

    int _aktifIndexiBul(BuildContext context){
        final String konum = GoRouterState.of(context).uri.toString();
        if(konum.startWith('/profil')) return 1;
        return 0;
    }

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
    class ProfilEkrani extends StatelessWidget{
        const ProfilEkrani({super.key});
        @override
        Widget build(BuildContext context){
            return Scaffold(
                appBar: AppBar(
                    title: const Text('Kullanıcı profili'),
                ),
                body: Center(
                    child: TextButton(
                        onPressed: () => SepetKontrolu.ornek.sepetSifirla(),
                        child: const Text('Sepeti Sıfırla (Stateless İçinden)'),
                    )
                )
            ) 
        
        }  
    }
}

