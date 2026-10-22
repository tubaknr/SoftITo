import 'package:flutter_test/flutter_test.dart';
import 'package:penguhabit/features/auth/controller/auth_controller.dart';

void main() {
  group('Auth Form Validation Unit Tests', () {
    test('Name validation: non-empty required', () {
      expect(AuthController.isValidName(''), isFalse);
      expect(AuthController.isValidName('   '), isFalse);
      expect(AuthController.isValidName('Ayşe'), isTrue);
      expect(AuthController.isValidName(' Mehmet Ali '), isTrue);
    });

    test('Email validation: valid format required', () {
      expect(AuthController.isValidEmail(''), isFalse);
      expect(AuthController.isValidEmail('invalid-email'), isFalse);
      expect(AuthController.isValidEmail('test@'), isFalse);
      expect(AuthController.isValidEmail('test@domain'), isFalse);
      expect(AuthController.isValidEmail('ayse@example.com'), isTrue);
      expect(AuthController.isValidEmail('user.name+tag@sub.domain.org'), isTrue);
    });

    test('Password validation: minimum 8 characters required', () {
      expect(AuthController.isValidPassword(''), isFalse);
      expect(AuthController.isValidPassword('1234567'), isFalse);
      expect(AuthController.isValidPassword('12345678'), isTrue);
      expect(AuthController.isValidPassword('SecurePassword123!'), isTrue);
    });

    test('Password confirmation: passwords must match exactly', () {
      expect(AuthController.doPasswordsMatch('pass1234', 'pass1234'), isTrue);
      expect(AuthController.doPasswordsMatch('pass1234', 'pass1235'), isFalse);
      expect(AuthController.doPasswordsMatch('Pass1234', 'pass1234'), isFalse);
    });
  });
}
