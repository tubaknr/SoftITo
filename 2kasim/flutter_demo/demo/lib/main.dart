import 'screens/anaKasaEkrani.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/vitrinEkrani.dart';
import 'screens/profilEkrani.dart';
import 'sepetKontrolu.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter uygulamaRotalari = GoRouter(
    initialLocation:'/vitrin',
    routes:[
        ShellRoute(
            builder:(BuildContext context, GoRouterState state, Widget child){
                return AnaKasaEkrani(ekranGovdesi: child);
            },
            routes: [
                GoRoute(
                    path: '/vitrin',
                    builder:(context, state) => const VitrinEkrani(), 
                ),
                GoRoute(
                    path: '/profil',
                    builder: (context, state) => const ProfilEkrani(),
                ),    
            ],
        ),
    ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: uygulamaRotalari,
    );
  }
}
