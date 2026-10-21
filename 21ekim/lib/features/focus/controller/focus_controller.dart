import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';
import '../data/focus_repository.dart';
import '../data/mock_focus_data.dart';
import '../models/focus_session_model.dart';

/// Odaklanma oturumu, süre hesaplama ve Çiçek yaşam döngüsü Controller'ı.
class FocusController extends ValueNotifier<List<FocusSessionModel>> {
  final FocusRepository _repository;

  FocusController({FocusRepository? repository})
      : _repository = repository ?? MockFocusRepository(),
        super([]);

  static final FocusController instance = FocusController();

  DateTime? _sessionStartTime;
  Timer? _ticker;

  final ValueNotifier<bool> isFocusing = ValueNotifier<bool>(false);
  final ValueNotifier<int> elapsedSeconds = ValueNotifier<int>(0);
  final ValueNotifier<DateTime?> lastActiveTime = ValueNotifier<DateTime?>(null);

  Future<void> init() async {
    final list = await _repository.getSessions();
    value = list;
    lastActiveTime.value = await _repository.getLastActiveTime() ?? DateTime.now();
  }

  // --- Çiçek Yaşam Döngüsü ve Evre Hesaplama (Saf Dart & Birim Test Edilebilir) ---

  static FlowerStage calculateFlowerStage({
    required int totalSeconds,
    required DateTime lastActiveAt,
    DateTime? currentTime,
  }) {
    final now = currentTime ?? DateTime.now();
    final inactiveDays = now.difference(lastActiveAt).inDays;

    // 30 gün girilmezse çiçek ölür ve kullanıcı tohumdan başlar
    if (inactiveDays >= AppConstants.deathDays) {
      return FlowerStage.dead;
    }

    // 7 gün girilmezse çiçek solar ve başını büker
    if (inactiveDays >= AppConstants.wiltDays) {
      return FlowerStage.wilted;
    }

    // Toplam süreye göre büyüme evreleri
    if (totalSeconds >= AppConstants.matureFlowerThresholdSeconds) {
      return FlowerStage.mature;
    } else if (totalSeconds >= AppConstants.bloomingThresholdSeconds) {
      return FlowerStage.blooming;
    } else if (totalSeconds >= AppConstants.budThresholdSeconds) {
      return FlowerStage.bud;
    } else if (totalSeconds >= AppConstants.leafyStemThresholdSeconds) {
      return FlowerStage.leafyStem;
    } else if (totalSeconds >= AppConstants.saplingThresholdSeconds) {
      return FlowerStage.sapling;
    } else if (totalSeconds >= AppConstants.sproutThresholdSeconds) {
      return FlowerStage.sprout;
    } else {
      return FlowerStage.seed;
    }
  }

  FlowerStage get currentFlowerStage {
    final totalSec = totalFocusSeconds;
    final lastActive = lastActiveTime.value ?? DateTime.now();
    return calculateFlowerStage(
      totalSeconds: totalSec,
      lastActiveAt: lastActive,
    );
  }

  // --- Türetilmiş İstatistikler ---

  int get totalFocusSeconds {
    return value.fold(0, (sum, item) => sum + item.durationSeconds);
  }

  int get todayFocusSeconds {
    final now = DateTime.now();
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return value
        .where((s) => s.dayString == todayStr)
        .fold(0, (sum, item) => sum + item.durationSeconds);
  }

  List<FocusSessionModel> get last7DaysSessions {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    return value.where((s) => s.startTime.isAfter(sevenDaysAgo)).toList();
  }

  // --- Oturum Yönetimi (Zaman Doğruluğu: DateTime Farkı ile) ---

  void startFocusSession() {
    _sessionStartTime = DateTime.now();
    elapsedSeconds.value = 0;
    isFocusing.value = true;

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_sessionStartTime != null) {
        // Doğru süre hesabı: şimdiki zaman ile başlangıç zamanı farkı
        elapsedSeconds.value =
            DateTime.now().difference(_sessionStartTime!).inSeconds;
      }
    });
  }

  Future<int> stopFocusSession() async {
    _ticker?.cancel();
    _ticker = null;
    isFocusing.value = false;

    final duration = elapsedSeconds.value;
    if (_sessionStartTime != null && duration > 0) {
      final now = DateTime.now();
      final dayStr =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final session = FocusSessionModel(
        id: 'session_${now.millisecondsSinceEpoch}',
        startTime: _sessionStartTime!,
        durationSeconds: duration,
        dayString: dayStr,
      );

      await _repository.saveSession(session);
      final updatedList = await _repository.getSessions();
      value = updatedList;
      lastActiveTime.value = now;
    }

    _sessionStartTime = null;
    elapsedSeconds.value = 0;
    return duration;
  }

  Future<void> clearAllData() async {
    await _repository.clearAllSessions();
    value = [];
    lastActiveTime.value = DateTime.now();
  }

  // --- Süre Biçimlendirme Yardımcıları ---

  static String formatDigitalTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    final hStr = hours.toString().padLeft(2, '0');
    final mStr = minutes.toString().padLeft(2, '0');
    final sStr = seconds.toString().padLeft(2, '0');

    if (hours > 0) {
      return '$hStr:$mStr:$sStr';
    } else {
      return '$mStr:$sStr';
    }
  }

  static String formatNaturalDuration(
    int totalSeconds, {
    String dayLabel = 'gün',
    String hourLabel = 'saat',
    String minLabel = 'dakika',
  }) {
    final days = totalSeconds ~/ 86400;
    final hours = (totalSeconds % 86400) ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;

    final parts = <String>[];
    if (days > 0) parts.add('$days $dayLabel');
    if (hours > 0) parts.add('$hours $hourLabel');
    if (minutes > 0 || parts.isEmpty) parts.add('$minutes $minLabel');

    return parts.join(' ');
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
