import 'package:flutter/foundation.dart';

class ShellController {
  ShellController({int initialIndex = 0}) {
    currentIndex = ValueNotifier<int>(initialIndex);
  }

  late final ValueNotifier<int> currentIndex;

  void setIndex(int index) {
    if (index >= 0 && index <= 3) {
      currentIndex.value = index;
    }
  }

  void dispose() {
    currentIndex.dispose();
  }
}
