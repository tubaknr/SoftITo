import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// BuildContext için pratik ve temiz erişim eklentileri.
extension ContextExtensions on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
}
