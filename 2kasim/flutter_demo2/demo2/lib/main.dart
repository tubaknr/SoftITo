import 'package:flutter/material.dart';
import 'UrunServisi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const UrunlerPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class UrunlerPage extends StatefulWidget {
  const UrunlerPage({super.key, required this.title});

  final String title;

  @override
  State<UrunlerPage> createState() => _UrunlerPageState();
}

class _UrunlerPageState extends State<UrunlerPage> {
  final urunServisi = CanliApiUrunServisi();

  @override
  void initState() {
    super.initState();
    urunServisi.urunleriGetir();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
          Expanded(
            child: FutureBuilder<List<UrunModel>>(
              future: urunServisi.urunleriGetir(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  final urunler = snapshot.data!;
                  return ListView.builder(
                    itemCount: urunler.length,
                    itemBuilder: (context, index){
                      return ListTile(
                        title: Text(urunler[index].baslik),
                        subtitle: Text(urunler[index].fiyat.toString()),
                      );
                    },
                  );
                }else if(snapshot.hasError){
                  return Text('Hata: ${snapshot.error}');
                }else{
                  return const CircularProgressIndicator();
                }
              },
            )
          ),  
        ],
      ),
    ),
    );
  }
}
