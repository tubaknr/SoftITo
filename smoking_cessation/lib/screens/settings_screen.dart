// ========================================
// DOSYA: settings_screen.dart
// NE İŞE YARAR: Kutlama, rozet ve profil
// ayarlarını kullanıcıya sunar.
// NASIL ÇALIŞIR: Başarıları, rozetleri ve
// profil yapılandırmasını listeler.
// SOLID: SRP - Ayarlar ve başarılar ekranı.
// ========================================

import 'package:flutter/material.dart';
import '../features/quit/quit_controller.dart';
import '../main.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import 'onboarding_cost_screen.dart';
import 'onboarding_date_screen.dart';

// SRP: Ayarlar ve kutlamalar ana ekranı.
class SettingsScreen extends StatelessWidget {
  final QuitController quitController;

  const SettingsScreen({super.key, required this.quitController});

  void _editDate(BuildContext ctx) {
    Navigator.of(ctx).push(MaterialPageRoute(
      builder: (_) => OnboardingDateScreen(
          quitController: quitController, isEditing: true),
    ));
  }

  void _editCost(BuildContext ctx) {
    final p = quitController.profile;
    if (p == null) return;
    Navigator.of(ctx).push(MaterialPageRoute(
      builder: (_) => OnboardingCostScreen(
        quitController: quitController,
        quitDateTime: p.quitDateTime,
        isEditing: true,
      ),
    ));
  }

  Future<void> _reset(BuildContext ctx) async {
    final ok = await showDialog<bool>(
      context: ctx,
      builder: (c) => AlertDialog(
        backgroundColor: AppTheme.surfaceLow,
        title: const Text('Verileri Sıfırla'),
        content: const Text('Tüm veriler kalıcı olarak silinecektir.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerSos,
            ),
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Sıfırla'),
          ),
        ],
      ),
    );
    if (ok == true && ctx.mounted) {
      await AppScope.of(ctx).diaryController.clearAll();
      await quitController.clearAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: quitController,
      builder: (context, _) => _buildList(context),
    );
  }

  // Ayarlar ve kutlamalar kaydırılabilir listesi.
  Widget _buildList(BuildContext ctx) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SettingsHeader(),
          const SizedBox(height: 14),
          _buildCelebration(),
          const SizedBox(height: 14),
          const RecoveryBadgesSection(unlockedCount: 3),
          const SizedBox(height: 16),
          _buildProfileSection(ctx),
          const SizedBox(height: 20),
          SettingsResetButton(onReset: () => _reset(ctx)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Dönüm noktası kutlama kartı.
  Widget _buildCelebration() {
    final sVal = quitController.moneySaved;
    final saved = sVal > 0 ? sVal : 455.0;
    final sText = '${saved.toStringAsFixed(2).replaceAll('.', ',')} TL';

    return MilestoneCelebrationCard(
      title: '1. Hafta Tamamlandı!',
      description:
          'Vücudundaki nikotin tamamen temizlendi. Tat alma '
          'duyuların yeniden doğdu ve akciğerlerindeki siller '
          'kendini onarmaya başladı.',
      savedAmount: sText,
    );
  }

  // Profil düzenleme kartı bileşeni.
  Widget _buildProfileSection(BuildContext ctx) {
    return SettingsProfileCard(
      profile: quitController.profile,
      onEditDate: () => _editDate(ctx),
      onEditCost: () => _editCost(ctx),
    );
  }
}
