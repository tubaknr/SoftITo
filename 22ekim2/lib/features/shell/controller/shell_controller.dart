import 'package:flutter/foundation.dart';

/// Manages bottom navigation active tab index
class ShellController extends ValueNotifier<int> {
  ShellController() : super(0);

  void setTab(int index) {
    if (value != index && index >= 0 && index < 4) {
      value = index;
    }
  }
}
