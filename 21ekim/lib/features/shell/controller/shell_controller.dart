import 'package:flutter/foundation.dart';

/// Alt navigasyon sekme durum yöneticisi (ValueNotifier tabanlı).
class ShellController extends ValueNotifier<int> {
  ShellController() : super(0);

  static final ShellController instance = ShellController();

  void setTab(int index) {
    if (index >= 0 && index <= 3) {
      value = index;
    }
  }

  void resetToHome() {
    value = 0;
  }
}
