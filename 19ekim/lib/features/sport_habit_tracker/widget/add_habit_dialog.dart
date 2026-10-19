import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AddHabitDialog extends StatefulWidget {
  const AddHabitDialog({super.key});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final _titleController = TextEditingController();
  int _targetDays = 3;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _onSave() {
    final title = _titleController.text.trim();
    if (title.isNotEmpty && _targetDays > 0) {
      Navigator.of(context).pop({
        'title': title,
        'targetDays': _targetDays,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      title: const Text('Yeni Spor Alışkanlığı Ekle'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Alışkanlık Adı (örn: Sabah Koşusu)',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.neonCyan),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Haftalık Hedef Gün Sayısı:',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 8),
            _DaysSliderRow(
              value: _targetDays,
              onChanged: (val) => setState(() => _targetDays = val),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.neonCyan,
            foregroundColor: AppColors.background,
          ),
          onPressed: _onSave,
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}

class _DaysSliderRow extends StatelessWidget {
  const _DaysSliderRow({
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: 1,
            max: 7,
            divisions: 6,
            activeColor: AppColors.neonCyan,
            inactiveColor: AppColors.surfaceVariant,
            onChanged: (val) => onChanged(val.round()),
          ),
        ),
        Text(
          '$value Gün',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.neonCyan,
          ),
        ),
      ],
    );
  }
}
