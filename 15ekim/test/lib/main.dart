import 'package:flutter/material.dart';
import 'screen/01_layout_screen.dart';

void main() {
  runApp(const DtmMasterApp());
}

class DtmMasterApp extends StatelessWidget {
  const DtmMasterApp({super.key});

  // ThemeData oluşturmak görece maliyetlidir. Uygulama yaşam döngüsünde aynı
  // tema kullanılacağı için her build çağrısında yeniden üretmek yerine sakla.
  static final ThemeData _theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6366F1),
      brightness: Brightness.light,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "DTM Flutter Sınıfı",
      theme: _theme,
      home: const HomeShell(),
    );
  }
}

// LayoutStylingScreen bir Scaffold döndürmediği için onu Scaffold içine alıyoruz
class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: SafeArea(
        child: LayoutStylingScreen(),
      ),
    );
  }
}
