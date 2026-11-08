// ========================================
// DOSYA: craving_controller.dart
// NE İŞE YARAR: 5 dakikalık kriz geri sayımı,
// 4-7-8 nefes fazları ve sesi yönetir.
// NASIL ÇALIŞIR: Timer ile 19 saniyelik
// döngüde fazları ve geri sayımı belirler.
// SOLID: SRP - Kriz anı egzersizi durumunu tutar.
// ========================================

import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// 4-7-8 nefes döngüsü adımları (19 saniye)
enum BreathingPhase {
  inhale, // 0..4 saniye (Nefes Al)
  hold,   // 4..11 saniye (Tut)
  exhale, // 11..19 saniye (Nefes Ver)
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
  bool _isNatureSoundPlaying = false;
  String _currentQuote = '';

  CravingController() {
    _pickRandomQuote();
  }

  int get remainingSeconds => _remainingSeconds;
  bool get isActive => _isActive;
  bool get isSuccess => _isSuccess;
  bool get isNatureSoundPlaying => _isNatureSoundPlaying;
  String get currentQuote => _currentQuote;

  // 19 saniyelik 4-7-8 döngü saniyesi (0..18)
  int get cycleSecond =>
      (totalSessionSeconds - _remainingSeconds) % 19;

  // Aktif nefes fazı
  BreathingPhase get currentPhase {
    if (cycleSecond < 4) return BreathingPhase.inhale;
    if (cycleSecond < 11) return BreathingPhase.hold;
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

  // Mevcut fazın kalan saniyesi
  int get phaseCountdown {
    final sec = cycleSecond;
    if (sec < 4) return 4 - sec;
    if (sec < 11) return 11 - sec;
    return 19 - sec;
  }

  // Nefes dairesi büyüme oranı (0.0..1.0)
  double get phaseProgress {
    final sec = cycleSecond;
    if (sec < 4) {
      return sec / 4.0;
    } else if (sec < 11) {
      return 1.0;
    } else {
      return (19 - sec) / 8.0;
    }
  }

  // Doğa sesi durumunu değiştirir.
  void toggleNatureSound() {
    _isNatureSoundPlaying = !_isNatureSoundPlaying;
    _syncWebAudio();
    notifyListeners();
  }

  // Web ve sistem ses komutunu senkronize eder.
  void _syncWebAudio() {
    try {
      SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
          label: _isNatureSoundPlaying
              ? 'cmd:nature:play'
              : 'cmd:nature:stop',
        ),
      );
    } catch (_) {}
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
    if (_isNatureSoundPlaying) {
      _isNatureSoundPlaying = false;
      _syncWebAudio();
    }
    notifyListeners();
  }

  // Seansı durdurur.
  void stopSession() {
    _timer?.cancel();
    _isActive = false;
    if (_isNatureSoundPlaying) {
      _isNatureSoundPlaying = false;
      _syncWebAudio();
    }
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
    if (_isNatureSoundPlaying) {
      _isNatureSoundPlaying = false;
      _syncWebAudio();
    }
    super.dispose();
  }
}
