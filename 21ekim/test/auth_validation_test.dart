import 'package:flutter_test/flutter_test.dart';
import 'package:focus_and_grow/features/auth/controller/auth_controller.dart';

void main() {
  group('AuthController Şifre ve Form Doğrulama Testleri', () {
    test('Şifre 8 karakterden kısa olamaz', () {
      final error = AuthController.validatePassword('Ab1!');
      expect(error, contains('en az 8 karakter'));
    });

    test('Şifre en az 1 büyük harf içermelidir', () {
      final error = AuthController.validatePassword('abcdef1!');
      expect(error, contains('büyük harf'));
    });

    test('Şifre en az 1 küçük harf içermelidir', () {
      final error = AuthController.validatePassword('ABCDEF1!');
      expect(error, contains('küçük harf'));
    });

    test('Şifre en az 1 sembol içermelidir', () {
      final error = AuthController.validatePassword('Abcdef12');
      expect(error, contains('sembol'));
    });

    test('Geçerli şifrede hata dönmemelidir', () {
      final error = AuthController.validatePassword('Sifre123!');
      expect(error, isNull);
    });

    test('Şifre doğrulama eşleşme kontrolü', () {
      final mismatch = AuthController.validateConfirmPassword('Sifre123!', 'Farkli123!');
      expect(mismatch, contains('eşleşmiyor'));

      final match = AuthController.validateConfirmPassword('Sifre123!', 'Sifre123!');
      expect(match, isNull);
    });

    test('Email doğrulama kontrolü', () {
      expect(AuthController.validateEmail(''), contains('giriniz'));
      expect(AuthController.validateEmail('gecersiz-email'), contains('Geçerli'));
      expect(AuthController.validateEmail('user@focusgrow.app'), isNull);
    });

    test('Yaş doğrulama kontrolü', () {
      expect(AuthController.validateAge(''), contains('giriniz'));
      expect(AuthController.validateAge('-5'), contains('geçerli'));
      expect(AuthController.validateAge('abc'), contains('geçerli'));
      expect(AuthController.validateAge('28'), isNull);
    });
  });
}
