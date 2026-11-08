// ========================================
// DOSYA: onboarding_cost_screen.dart
// NE İŞE YARAR: Tüketim ve maliyet formunu
// alıp profili oluşturur.
// NASIL ÇALIŞIR: Girdileri doğrular ve kaydeder.
// SOLID: SRP - Sadece maliyet formu görevi.
// ========================================

import 'package:flutter/material.dart';
import '../features/quit/quit_controller.dart';
import '../models/user_profile.dart';
import '../theme/app_theme.dart';
import 'home_shell_screen.dart';

// SRP: Maliyet ve tüketim formu ekranı.
class OnboardingCostScreen extends StatefulWidget {
  final QuitController quitController;
  final DateTime quitDateTime;
  final bool isEditing;

  const OnboardingCostScreen({
    super.key,
    required this.quitController,
    required this.quitDateTime,
    this.isEditing = false,
  });

  @override
  State<OnboardingCostScreen> createState() => _OnboardingCostScreenState();
}

class _OnboardingCostScreenState extends State<OnboardingCostScreen> {
  late double _cigs;
  late TextEditingController _price;
  late TextEditingController _pack;
  String? _error;

  @override
  void initState() {
    super.initState();
    final p = widget.quitController.profile;
    _cigs = (p?.cigarettesPerDay ?? 20).toDouble();
    _price = TextEditingController(text: (p?.packPrice ?? 100.0).toStringAsFixed(0));
    _pack = TextEditingController(text: (p?.cigarettesPerPack ?? 20).toString());
  }

  @override
  void dispose() {
    _price.dispose();
    _pack.dispose();
    super.dispose();
  }

  double get _savings {
    final pr = double.tryParse(_price.text) ?? 100.0;
    final pk = int.tryParse(_pack.text) ?? 20;
    return pk > 0 ? (365.0 * _cigs * (pr / pk)) : 0.0;
  }

  void _save() async {
    final pr = double.tryParse(_price.text);
    final pk = int.tryParse(_pack.text);
    if (pr == null || pr <= 0 || pr > 10000) {
      setState(() => _error = 'Geçerli paket fiyatı giriniz.');
      return;
    }
    if (pk == null || pk < 1 || pk > 50) {
      setState(() => _error = 'Paketteki adet 1-50 arası olmalıdır.');
      return;
    }
    final p = UserProfile(
      quitDateTime: widget.quitDateTime,
      cigarettesPerDay: _cigs.round().clamp(1, 100),
      packPrice: pr,
      cigarettesPerPack: pk,
    );
    try {
      await widget.quitController.saveProfile(p);
    } catch (_) {}
    if (!mounted) return;
    if (widget.isEditing) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => HomeShellScreen(quitController: widget.quitController),
        ),
        (r) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceLowest,
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Maliyeti Düzenle' : 'Alışkanlık'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Tüketim ve Harcama', style: AppTheme.headlineLarge),
            const SizedBox(height: 6),
            const Text('Tasarrufunu hesaplayalım.', style: AppTheme.bodyMedium),
            const SizedBox(height: 18),
            _buildCard(),
            const SizedBox(height: 14),
            _buildSavingsTile(),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_error!, style: const TextStyle(color: AppTheme.dangerSos)),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.surfaceLowest,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: _save,
              child: Text(widget.isEditing ? 'Güncelle' : 'Sayacı Başlat',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsTile() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.outlineActive),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Yıllık Tasarruf:', style: AppTheme.bodyLarge),
            Text('${_savings.toStringAsFixed(0)} ₺', style: AppTheme.labelMetric),
          ],
        ),
      );

  Widget _buildCard() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.outline),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Günlük Tüketim', style: AppTheme.titleSmall),
                Text('${_cigs.round()} adet',
                    style: const TextStyle(
                        color: AppTheme.primary, fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: _cigs,
              min: 1,
              max: 60,
              activeColor: AppTheme.primary,
              onChanged: (v) => setState(() => _cigs = v),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _price,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Paket (₺)'),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _pack,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Adet/Paket'),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
