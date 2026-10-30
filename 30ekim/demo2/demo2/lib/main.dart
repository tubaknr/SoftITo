import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: ListView(
        children: const [
          UrunKarti(title2: 'urun1', price: 11, description: 'aciklama1', imageUrl: 'url1', id: 1),
          UrunKarti(title2: 'urun2', price: 22, description: 'aciklama2', imageUrl: 'url2', id: 2),
        ],
      ),
    );
  }
}

class UrunKarti extends StatelessWidget{
  final String title2;
  final double price;
  final String description;
  final String imageUrl;
  final int id;

  const UrunKarti({
    super.key,
    required this.title2,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.id,
  });

  @override
  Widget build(BuildContext context){
    return Card(
      child: ListTile(
        title: Text(title2),
        subtitle: Text(description)
      ),
    );
  }

  
}


