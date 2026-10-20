import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiralago/core/validators/app_validators.dart';
import 'package:kiralago/l10n/app_localizations.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('tr'));
  });

  group('AppValidators Unit Tests', () {
    test('email validator accepts valid emails and rejects invalid ones', () {
      final FormFieldValidator<String> validator = AppValidators.email(l10n);

      expect(validator(null), equals(l10n.valRequired));
      expect(validator(''), equals(l10n.valRequired));
      expect(validator('invalid_email'), equals(l10n.valEmail));
      expect(validator('test@domain'), equals(l10n.valEmail));
      expect(validator('user@example.com'), isNull);
      expect(validator('ahmet.yilmaz@kiralago.com.tr'), isNull);
    });

    test('password validator enforces 8+ chars, letter and number', () {
      final FormFieldValidator<String> validator = AppValidators.password(l10n);

      expect(validator('short'), equals(l10n.valPasswordLength));
      expect(validator('allletterspassword'), equals(l10n.valPasswordRule));
      expect(validator('1234567890'), equals(l10n.valPasswordRule));
      expect(validator('ValidPass123'), isNull);
    });

    test('turkishPlate validator validates Turkish license plate format', () {
      final FormFieldValidator<String> validator = AppValidators.turkishPlate(l10n);

      expect(validator('34 ABC 123'), isNull);
      expect(validator('06 AY 201'), isNull);
      expect(validator('35 BD 301'), isNull);
      expect(validator('99 ABC 123'), equals(l10n.valTurkishPlate)); // Geçersiz il kodu
      expect(validator('invalid-plate'), equals(l10n.valTurkishPlate));
    });

    test('positivePrice validator validates numeric greater than 0', () {
      final FormFieldValidator<String> validator = AppValidators.positivePrice(l10n);

      expect(validator('0'), equals(l10n.valPositivePrice));
      expect(validator('-50'), equals(l10n.valPositivePrice));
      expect(validator('abc'), equals(l10n.valPositivePrice));
      expect(validator('1250'), isNull);
      expect(validator('99.50'), isNull);
    });

    test('phone validator validates Turkish mobile phone numbers', () {
      final FormFieldValidator<String> validator = AppValidators.phone(l10n);

      expect(validator('0532 123 45 67'), isNull);
      expect(validator('05321234567'), isNull);
      expect(validator('0212 123 45 67'), equals(l10n.valPhone));
      expect(validator('12345'), equals(l10n.valPhone));
    });
  });
}
