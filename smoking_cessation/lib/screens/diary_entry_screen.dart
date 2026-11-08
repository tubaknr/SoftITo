// ========================================
// DOSYA: diary_entry_screen.dart
// NE İŞE YARAR: Seçilen günün içmeme durumu,
// kriz seviyesi ve notunu düzenler.
// NASIL ÇALIŞIR: Form değerlerini alır ve
// DiaryController üzerinden kaydeder.
// SOLID: SRP - Sadece günlük kayıt formu.
// ========================================

import 'package:flutter/material.dart';
import '../features/diary/diary_controller.dart';
import '../models/daily_log.dart';
import '../theme/app_theme.dart';

// SRP: Tek güne ait kayıt formu.
class DiaryEntryScreen extends StatefulWidget {
  final DiaryController diaryController;
  final DateTime date;

  const DiaryEntryScreen({
    super.key,
    required this.diaryController,
    required this.date,
  });

  @override
  State<DiaryEntryScreen> createState() => _DiaryEntryScreenState();
}

class _DiaryEntryScreenState extends State<DiaryEntryScreen> {
  late bool _smokeFree;
  late int? _craving;
  late TextEditingController _noteCtrl;
  bool _hasExisting = false;

  @override
  void initState() {
    super.initState();
    final log = widget.diaryController.getLog(DateKey.format(widget.date));
    _hasExisting = log != null;
    _smokeFree = log?.smokeFree ?? true;
    _craving = log?.cravingLevel;
    _noteCtrl = TextEditingController(text: log?.note ?? '');
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final note = _noteCtrl.text.trim();
    final log = DailyLog(
      date: DateKey.format(widget.date),
      smokeFree: _smokeFree,
      cravingLevel: _craving,
      note: note.isEmpty ? null : note,
    );
    await widget.diaryController.saveLog(log);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final d = DateKey.format(widget.date);
    return Scaffold(
      backgroundColor: AppTheme.surfaceLowest,
      appBar: AppBar(
        title: Text('Kayıt ($d)'),
        actions: [
          if (_hasExisting)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppTheme.dangerSos),
              onPressed: () async {
                await widget.diaryController.deleteLog(d);
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildStatusSection(),
            const SizedBox(height: 16),
            _buildCravingSection(),
            const SizedBox(height: 16),
            _buildNoteSection(),
            const SizedBox(height: 24),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection() => _card(
        'GÜNÜN DURUMU',
        Row(
          children: [
            Expanded(child: _chip('İçmedim', _smokeFree, AppTheme.primary,
                () => setState(() => _smokeFree = true))),
            const SizedBox(width: 12),
            Expanded(child: _chip('İçtim', !_smokeFree, AppTheme.dangerSos,
                () => setState(() => _smokeFree = false))),
          ],
        ),
      );

  Widget _buildCravingSection() => _card(
        'KRİZ SEVİYESİ (1-5)',
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (i) {
            final lvl = i + 1;
            final sel = _craving == lvl;
            return GestureDetector(
              onTap: () => setState(() => _craving = sel ? null : lvl),
              child: CircleAvatar(
                radius: 18,
                backgroundColor:
                    sel ? AppTheme.warningAmber : AppTheme.surfaceContainer,
                child: Text('$lvl',
                    style: TextStyle(
                        color:
                            sel ? AppTheme.surfaceLowest : AppTheme.onSurface,
                        fontWeight: FontWeight.bold)),
              ),
            );
          }),
        ),
      );

  Widget _buildNoteSection() => _card(
        'GÜNLÜK NOT (MAX 200 KRK)',
        TextField(
          controller: _noteCtrl,
          maxLength: 200,
          maxLines: 2,
          decoration: const InputDecoration(
            hintText: 'Zorlandığın anları not al...',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget _buildSaveButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: AppTheme.surfaceLowest,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24)),
        ),
        onPressed: _save,
        child: const Text('Kaydet',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      );

  Widget _card(String title, Widget content) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTheme.labelCaps),
            const SizedBox(height: 10),
            content,
          ],
        ),
      );

  Widget _chip(String label, bool sel, Color color, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: sel ? color.withValues(alpha: 0.2) : AppTheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: sel ? color : AppTheme.outline, width: sel ? 2 : 1),
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                    color: sel ? color : AppTheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      );
}
