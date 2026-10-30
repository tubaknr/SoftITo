import 'package:flutter/material.dart';
import 'widgets/widget1.dart';
import 'modals/urun.dart';

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

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Urun> urunler = [
    const Urun(name: "fdfdffgfd", price: 10, description: "ökjökjöç", id: 0, imgUrl: ""),
    const Urun(name: "etrtetrt", price: 20, description: "ukıkıjök", id: 1, imgUrl: "")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: urunler.length,
        itemBuilder: (context, index){
          return Widget1(urun: urunler[index]);
        },
      ),
    );
  }
}
