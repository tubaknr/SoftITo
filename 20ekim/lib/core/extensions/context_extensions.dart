import 'package:flutter/material.dart';
import '../theme/space_colors.dart';

extension SpaceContext on BuildContext {
  SpaceColors get spaceColors => Theme.of(this).extension<SpaceColors>()!;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
