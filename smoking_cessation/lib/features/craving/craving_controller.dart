// ========================================
// DOSYA: craving_controller.dart
// NE İŞE YARAR: 5 dakikalık kriz geri sayımı,
// nefes fazları ve motivasyon sözlerini yönetir.
// NASIL ÇALIŞIR: Timer ile saniye saniye
// geri sayar ve nefes fazını belirler.
// SOLID: SRP - Kriz anı egzersizi durumunu tutar.
// ========================================

import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

// Nefes döngüsü adımları (4-4-4 ritmi)
enum BreathingPhase {
  inhale, // 0..4 saniye
  hold,   // 4..8 saniye
  exhale, // 8..12 saniye
}

// SRP: Canım çekti egzersizini yönetir.
class CravingController extends ChangeNotifier {
  static const int totalSessionSeconds = 300; // 5 dk

  static const List<String> quotes = [
    'Bu istek sadece geçici bir dalga. Birazdan dinecek.',
    'Derin bir nefes al. Ciğerlerin kendini yeniliyor.',
    'Sigara stresi azaltmaz, yeni bir kriz yaratır.',
    'Bugün gösterdiğin irade, yarınki özgürlüğündür.',
    'Zor anlar geçer, bu istekten daha güçlüsün.',
    'Zihnindeki nikotin sesini duy ama teslim olma.',
    'Her temiz dakika, bedenine en büyük hediyedir.',
    'Bir sigara hiçbir şeyi çözmez, temiz kal.',
    'Bir yudum soğuk su iç ve nefesine odaklan.',
    'Kendine olan sözünü hatırla, sen kazanacaksın.',
    'Duman geçti, hayat başladı. İradene güven.',
    'Şu anki his, vücudunun iyileşme kanıtıdır.',
  ];

  final Random _random = Random();
  Timer? _timer;
  int _remainingSeconds = totalSessionSeconds;
  bool _isActive = false;
  bool _isSuccess = false;
  String _currentQuote = '';

  CravingController() {
    _pickRandomQuote();
  }

  int get remainingSeconds => _remainingSeconds;
  bool get isActive => _isActive;
  bool get isSuccess => _isSuccess;
  String get currentQuote => _currentQuote;

  // 12 saniyelik döngüdeki mevcut saniye (0..11)
  int get cycleSecond =>
      (totalSessionSeconds - _remainingSeconds) % 12;

  // Aktif nefes fazı
  BreathingPhase get currentPhase {
    if (cycleSecond < 4) return BreathingPhase.inhale;
    if (cycleSecond < 8) return BreathingPhase.hold;
    return BreathingPhase.exhale;
  }

  // Faz başlığı
  String get phaseTitle {
    switch (currentPhase) {
      case BreathingPhase.inhale:
        return 'Nefes Al';
      case BreathingPhase.hold:
        return 'Tut';
      case BreathingPhase.exhale:
        return 'Nefes Ver';
    }
  }

  // Nefes dairesi büyüme oranı (0.0..1.0)
  double get phaseProgress {
    final sec = cycleSecond;
    if (sec < 4) {
      return sec / 4.0;
    } else if (sec < 8) {
      return 1.0;
    } else {
      return (12 - sec) / 4.0;
    }
  }

  // Seansı başlatır veya yeniden başlatır.
  void startSession() {
    _remainingSeconds = totalSessionSeconds;
    _isActive = true;
    _isSuccess = false;
    _pickRandomQuote();
    _startTimer();
    notifyListeners();
  }

  // Zamanlayıcıyı çalıştırır.
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds > 1) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _remainingSeconds = 0;
        completeSession();
      }
    });
  }

  // Seansı başarıyla tamamlar.
  void completeSession() {
    _timer?.cancel();
    _isActive = false;
    _isSuccess = true;
    notifyListeners();
  }

  // Seansı durdurur.
  void stopSession() {
    _timer?.cancel();
    _isActive = false;
    notifyListeners();
  }

  // Rastgele yeni bir motivasyon sözü seçer.
  void nextQuote() {
    _pickRandomQuote();
    notifyListeners();
  }

  void _pickRandomQuote() {
    final index = _random.nextInt(quotes.length);
    _currentQuote = quotes[index];
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
