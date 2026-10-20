import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class AppValidators {
  AppValidators._();

  static FormFieldValidator<String> required(AppLocalizations l10n) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return l10n.valRequired;
      }
      return null;
    };
  }

  static FormFieldValidator<String> email(AppLocalizations l10n) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$',
    );
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return l10n.valRequired;
      }
      if (!emailRegex.hasMatch(value.trim())) {
        return l10n.valEmail;
      }
      return null;
    };
  }

  static FormFieldValidator<String> password(AppLocalizations l10n) {
    final RegExp hasLetter = RegExp(r'[a-zA-Z]');
    final RegExp hasDigit = RegExp(r'[0-9]');
    return (String? value) {
      if (value == null || value.isEmpty) {
        return l10n.valRequired;
      }
      if (value.length < 8) {
        return l10n.valPasswordLength;
      }
      if (!hasLetter.hasMatch(value) || !hasDigit.hasMatch(value)) {
        return l10n.valPasswordRule;
      }
      return null;
    };
  }

  static FormFieldValidator<String> confirmPassword(
    String Function() originalPasswordProvider,
    AppLocalizations l10n,
  ) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return l10n.valRequired;
      }
      if (value != originalPasswordProvider()) {
        return l10n.valPasswordMatch;
      }
      return null;
    };
  }

  static FormFieldValidator<String> phone(AppLocalizations l10n) {
    final RegExp phoneRegex = RegExp(r'^(05\d{2}\s?\d{3}\s?\d{2}\s?\d{2}|05\d{9})$');
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return l10n.valRequired;
      }
      final String cleaned = value.replaceAll(RegExp(r'\s+'), '');
      if (!phoneRegex.hasMatch(cleaned)) {
        return l10n.valPhone;
      }
      return null;
    };
  }

  static FormFieldValidator<String> onlyLetters(AppLocalizations l10n) {
    final RegExp letterRegex = RegExp(r'^[a-zA-ZçÇğĞıİöÖşŞüÜ\s]+$');
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return l10n.valRequired;
      }
      if (!letterRegex.hasMatch(value.trim())) {
        return l10n.valLettersOnly;
      }
      return null;
    };
  }

  static FormFieldValidator<String> age(AppLocalizations l10n) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return l10n.valRequired;
      }
      final int? ageNum = int.tryParse(value.trim());
      if (ageNum == null || ageNum < 18) {
        return l10n.valAge;
      }
      return null;
    };
  }

  static FormFieldValidator<String> minLength(int min, AppLocalizations l10n) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return l10n.valRequired;
      }
      if (value.trim().length < min) {
        return l10n.valMinLength(min);
      }
      return null;
    };
  }

  static FormFieldValidator<String> turkishPlate(AppLocalizations l10n) {
    final RegExp plateRegex = RegExp(
      r'^(0[1-9]|[1-7][0-9]|8[01])\s?[A-ZÇĞİÖŞÜ]{1,3}\s?\d{2,4}$',
      caseSensitive: false,
    );
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return l10n.valRequired;
      }
      if (!plateRegex.hasMatch(value.trim())) {
        return l10n.valTurkishPlate;
      }
      return null;
    };
  }

  static FormFieldValidator<String> positivePrice(AppLocalizations l10n) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return l10n.valRequired;
      }
      final double? price = double.tryParse(value.trim().replaceAll(',', '.'));
      if (price == null || price <= 0) {
        return l10n.valPositivePrice;
      }
      return null;
    };
  }

  static String? validateDateRange({
    required DateTime? start,
    required DateTime? end,
    required List<DateTimeRange> bookedRanges,
    required AppLocalizations l10n,
  }) {
    if (start == null || end == null) {
      return l10n.selectDatesWarning;
    }
    if (end.isBefore(start) || end.isAtSameMomentAs(start)) {
      return l10n.valReturnAfterPickup;
    }

    final DateTimeRange selected = DateTimeRange(start: start, end: end);
    for (final DateTimeRange booked in bookedRanges) {
      final bool overlaps = selected.start.isBefore(booked.end) &&
          selected.end.isAfter(booked.start);
      if (overlaps) {
        return l10n.bookedDateWarning;
      }
    }
    return null;
  }
}
