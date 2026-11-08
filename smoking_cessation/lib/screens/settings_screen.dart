// ========================================
// DOSYA: settings_screen.dart
// NE İŞE YARAR: Profil düzenleme, bildirim ve
// veri sıfırlama ayarlarını sunar.
// NASIL ÇALIŞIR: Controller durumunu günceller
// ve ilgili form ekranlarına yönlendirir.
// SOLID: SRP - Sadece ayarlar görünümü.
// ========================================

import 'package:flutter/material.dart';
import '../features/quit/quit_controller.dart';
import '../main.dart';
import '../theme/app_theme.dart';
import 'onboarding_cost_screen.dart';
import 'onboarding_date_screen.dart';

// SRP: Ayarlar ve profil yapılandırma ekranı.
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

  Future<void> _pickTime(BuildContext ctx) async {
    final s = quitController.settings;
    final picked = await showTimePicker(
      context: ctx,
      initialTime: TimeOfDay(hour: s.reminderHour, minute: s.reminderMinute),
      builder: (c, w) => Theme(data: AppTheme.darkTheme, child: w!),
    );
    if (picked != null) {
      await quitController.saveSettings(s.copyWith(
        reminderHour: picked.hour,
        reminderMinute: picked.minute,
      ));
    }
  }

  Future<void> _reset(BuildContext ctx) async {
    final ok = await showDialog<bool>(
      context: ctx,
      builder: (c) => AlertDialog(
        backgroundColor: AppTheme.surfaceLow,
        title: const Text('Verileri Sıfırla'),
        content: const Text('Tüm veriler kalıcı olarak silinecektir.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Vazgeç')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.dangerSos),
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
      builder: (context, _) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildProfile(context),
          const SizedBox(height: 16),
          _buildNotifications(context),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.dangerSos,
              side: const BorderSide(color: AppTheme.dangerSos),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            icon: const Icon(Icons.delete_forever_rounded),
            label: const Text('Tüm Verileri Sıfırla'),
            onPressed: () => _reset(context),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile(BuildContext ctx) {
    final p = quitController.profile;
    final dStr = p == null
        ? '-'
        : '${p.quitDateTime.day}.${p.quitDateTime.month}.${p.quitDateTime.year}';
    final cStr = p == null
        ? '-'
        : 'Günde ${p.cigarettesPerDay} adet • Paket ${p.packPrice.toStringAsFixed(0)} ₺';

    return Material(
      color: AppTheme.surfaceLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text('PROFİL BİLGİLERİ', style: AppTheme.labelCaps),
          ),
          ListTile(
            leading: const Icon(Icons.edit_calendar, color: AppTheme.primary),
            title: const Text('Bırakma Tarihi', style: AppTheme.titleSmall),
            subtitle: Text(dStr, style: AppTheme.bodySmall),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _editDate(ctx),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.attach_money, color: AppTheme.warningAmber),
            title: const Text('Tüketim ve Fiyat', style: AppTheme.titleSmall),
            subtitle: Text(cStr, style: AppTheme.bodySmall),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _editCost(ctx),
          ),
        ],
      ),
    );
  }

  Widget _buildNotifications(BuildContext ctx) {
    final s = quitController.settings;
    final tStr = '${s.reminderHour.toString().padLeft(2, '0')}:'
        '${s.reminderMinute.toString().padLeft(2, '0')}';

    return Material(
      color: AppTheme.surfaceLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text('BİLDİRİMLER', style: AppTheme.labelCaps),
          ),
          SwitchListTile(
            title: const Text('Günlük Bildirim', style: AppTheme.titleSmall),
            subtitle: const Text('Her gün motivasyon mesajı gönderir', style: AppTheme.bodySmall),
            value: s.notificationsEnabled,
            activeThumbColor: AppTheme.primary,
            onChanged: (v) => quitController.saveSettings(s.copyWith(notificationsEnabled: v)),
          ),
          if (s.notificationsEnabled) ...[
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.alarm, color: AppTheme.secondaryCyan),
              title: const Text('Bildirim Saati', style: AppTheme.titleSmall),
              trailing: Text(tStr, style: AppTheme.labelMetric),
              onTap: () => _pickTime(ctx),
            ),
          ],
        ],
      ),
    );
  }
}
