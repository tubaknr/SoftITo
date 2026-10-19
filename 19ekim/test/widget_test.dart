import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/main.dart';

void main() {
  testWidgets('Susadım app smoke test and dynamic water goal test',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SusadimApp());

    // Başlık ve başlangıç su takip durumu kontrolü
    expect(find.text('SUSADIM • SU'), findsOneWidget);
    expect(find.text('GÜNLÜK HİDRASYON DURUMU'), findsOneWidget);
    expect(find.text('2200 ml'), findsNWidgets(2)); // Temel hedef ve Toplam hedef (0 bonus varken)
    expect(find.text('+0 ml'), findsOneWidget); // Başlangıç antrenman ek
    expect(find.text('+250'), findsOneWidget);

    // Hızlı 250ml ekleme butonuna basıldığında
    await tester.tap(find.text('+250'));
    await tester.pump();

    // 250 ml eklendiğini ve hedefe ulaşım durumunu doğrula
    expect(find.text('250'), findsOneWidget);
    expect(find.text('250 ml Su'), findsOneWidget);
    expect(find.textContaining('Hedefe %11 ulaşıldı'), findsOneWidget);

    // Egzersiz sekmesine geç
    await tester.tap(find.text('Egzersiz'));
    await tester.pumpAndSettle();

    // Egzersiz ekle butonuna bas
    await tester.tap(find.text('Yeni Egzersiz Ekle'));
    await tester.pumpAndSettle();

    // Dialog alanlarını doldur
    final textFields = find.byType(TextField);
    await tester.enterText(textFields.at(0), 'Ağırlık Antrenmanı');
    await tester.enterText(textFields.at(1), '30'); // 30 dakika
    await tester.enterText(textFields.at(2), '250'); // 250 kcal
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();

    // Egzersizin eklendiğini doğrula
    expect(find.text('Ağırlık Antrenmanı'), findsOneWidget);
    expect(find.text('Toplam Süre: 30 dk'), findsOneWidget);

    // Tekrar Su Takibi sekmesine dön
    await tester.tap(find.text('Su Takibi'));
    await tester.pumpAndSettle();

    // 30 dk * 12 ml = +360 ml antrenman ek su ihtiyacı
    // Toplam hedef: 2200 + 360 = 2560 ml
    expect(find.text('+360 ml'), findsOneWidget);
    expect(find.text('2560 ml'), findsOneWidget);
    expect(find.textContaining('Hedefe %9 ulaşıldı'), findsOneWidget);

    // Alışkanlık sekmesine geç
    await tester.tap(find.text('Alışkanlık'));
    await tester.pumpAndSettle();

    // Spor Alışkanlıkları ekranını doğrula
    expect(find.text('SUSADIM • ALIŞKANLIKLAR'), findsOneWidget);
    expect(find.text('HAFTALIK SPOR ALIŞKANLIKLARI'), findsOneWidget);
    expect(find.text('Kuvvet Antrenmanı'), findsOneWidget);
    expect(find.text('Yeni Spor Alışkanlığı Ekle'), findsOneWidget);
  });
}
