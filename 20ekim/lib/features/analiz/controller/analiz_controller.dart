import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/analiz_model.dart';

class AnalizController {
  AnalizController() {
    currentStep = ValueNotifier<int>(0);
    formState = ValueNotifier<AnalizFormModel>(const AnalizFormModel(
      // Default sample fields to ease user input
      ekipUyeleri: [
        EkipUyesi(
          adSoyad: 'Ali Kaya',
          egitim: 'İTÜ Bilgisayar Müh.',
          uzmanlik: 'Yapay Zeka & Backend',
          sorumluluk: 'CTO / Kurucu Ortak',
          iletisim: 'ali@girisim.com',
        ),
      ],
      gorevler: [
        GanttGorevi(
          gorevAdi: 'MVP Geliştirme & Test',
          baslangicAy: 1,
          bitisAy: 3,
          butce: 120000,
        ),
        GanttGorevi(
          gorevAdi: 'Pilot Saha Entegrasyonu',
          baslangicAy: 4,
          bitisAy: 6,
          butce: 180000,
        ),
      ],
    ));
    isSavingDraft = ValueNotifier<bool>(false);
    isSubmitted = ValueNotifier<bool>(false);
    hataMesaji = ValueNotifier<String?>(null);
    _loadDraft();
  }

  late final ValueNotifier<int> currentStep;
  late final ValueNotifier<AnalizFormModel> formState;
  late final ValueNotifier<bool> isSavingDraft;
  late final ValueNotifier<bool> isSubmitted;
  late final ValueNotifier<String?> hataMesaji;

  static const String _prefDraftKey = 'yorunge_analiz_draft_v1';

  Future<void> _loadDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftFikir = prefs.getString('${_prefDraftKey}_fikir');
      if (draftFikir != null && draftFikir.isNotEmpty) {
        formState.value = formState.value.copyWith(fikirAdi: draftFikir);
      }
    } catch (_) {}
  }

  Future<void> saveDraft() async {
    isSavingDraft.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('${_prefDraftKey}_fikir', formState.value.fikirAdi);
    } catch (_) {}
    isSavingDraft.value = false;
  }

  void updateForm(AnalizFormModel Function(AnalizFormModel current) updater) {
    formState.value = updater(formState.value);
    saveDraft();
  }

  void nextStep() {
    if (currentStep.value < 7) {
      currentStep.value = currentStep.value + 1;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value = currentStep.value - 1;
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 7) {
      currentStep.value = step;
    }
  }

  bool submitForm() {
    if (!formState.value.isAllValid) {
      hataMesaji.value = 'Formda boş bırakılmış alanlar bulunmaktadır. Tüm bölümleri eksiksiz doldurunuz.';
      return false;
    }
    isSubmitted.value = true;
    return true;
  }

  void dispose() {
    currentStep.dispose();
    formState.dispose();
    isSavingDraft.dispose();
    isSubmitted.dispose();
    hataMesaji.dispose();
  }
}
