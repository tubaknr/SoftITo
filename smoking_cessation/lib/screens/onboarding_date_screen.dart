// ========================================
// DOSYA: onboarding_date_screen.dart
// NE İŞE YARAR: Sigara bırakma tarihi ve
// saatini kullanıcıdan alır.
// NASIL ÇALIŞIR: Tarih ve saat seçimi
// sunar, gelecekteki tarihleri engeller.
// SOLID: SRP - Sadece bırakma zamanı formu.
// ========================================

import 'package:flutter/material.dart';
import '../features/quit/quit_controller.dart';
import '../theme/app_theme.dart';
import 'onboarding_cost_screen.dart';

// SRP: Bırakma zamanı seçim ekranı.
class OnboardingDateScreen extends StatefulWidget {
  final QuitController quitController;
  final bool isEditing;

  const OnboardingDateScreen({
    super.key,
    required this.quitController,
    this.isEditing = false,
  });

  @override
  State<OnboardingDateScreen> createState() =>
      _OnboardingDateScreenState();
}

class _OnboardingDateScreenState
    extends State<OnboardingDateScreen> {
  late DateTime _dt;
  String? _error;

  @override
  void initState() {
    super.initState();
    final p = widget.quitController.profile;
    _dt = (widget.isEditing && p != null) ? p.quitDateTime : DateTime.now();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dt,
      firstDate: DateTime(2000),
      lastDate: now,
      builder: (c, w) => Theme(data: AppTheme.darkTheme, child: w!),
    );
    if (picked != null) {
      setState(() {
        _dt = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _dt.hour,
          _dt.minute,
        );
        _error = null;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dt),
      builder: (c, w) => Theme(data: AppTheme.darkTheme, child: w!),
    );
    if (picked != null) {
      final u = DateTime(_dt.year, _dt.month, _dt.day, picked.hour, picked.minute);
      if (u.isAfter(DateTime.now())) {
        setState(() => _error = 'Gelecek seçilemez.');
        return;
      }
      setState(() {
        _dt = u;
        _error = null;
      });
    }
  }

  void _onContinue() {
    if (_dt.isAfter(DateTime.now())) {
      setState(() => _error = 'Gelecek seçilemez.');
      return;
    }
    if (widget.isEditing && widget.quitController.profile != null) {
      final p = widget.quitController.profile!.copyWith(quitDateTime: _dt);
      widget.quitController.saveProfile(p);
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => OnboardingCostScreen(
        quitController: widget.quitController,
        quitDateTime: _dt,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceLowest,
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Tarih Düzenle' : 'Başlangıç'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Sigarayı ne zaman bıraktın?',
                  style: AppTheme.headlineLarge),
              const SizedBox(height: 8),
              const Text('Geçen her an ciğerlerin yenilenir.',
                  style: AppTheme.bodyMedium),
              const SizedBox(height: 24),
              _buildCard(),
              if (_error != null) _buildError(),
              const Spacer(),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError() => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(_error!, style: const TextStyle(color: AppTheme.dangerSos)),
      );

  Widget _buildSubmitButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: AppTheme.surfaceLowest,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        onPressed: _onContinue,
        child: Text(widget.isEditing ? 'Kaydet' : 'Devam Et',
            style: const TextStyle(fontWeight: FontWeight.bold)),
      );

  Widget _buildCard() {
    final d = '${_dt.day.toString().padLeft(2, '0')}.'
        '${_dt.month.toString().padLeft(2, '0')}.${_dt.year}';
    final t = '${_dt.hour.toString().padLeft(2, '0')}:'
        '${_dt.minute.toString().padLeft(2, '0')}';
    return Material(
      color: AppTheme.surfaceLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today, color: AppTheme.primary),
              title: const Text('Bırakma Tarihi', style: AppTheme.titleSmall),
              trailing: Text(d, style: AppTheme.labelMetric),
              onTap: _pickDate,
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.access_time, color: AppTheme.secondaryCyan),
              title: const Text('Bırakma Saati', style: AppTheme.titleSmall),
              trailing: Text(t, style: AppTheme.labelMetric),
              onTap: _pickTime,
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => setState(() {
                _dt = DateTime.now();
                _error = null;
              }),
              child: const Text('Şu An İtibarıyla Bıraktım'),
            ),
          ],
        ),
      ),
    );
  }
}
