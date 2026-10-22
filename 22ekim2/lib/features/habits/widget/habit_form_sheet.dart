import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_text_field.dart';
import '../models/habit.dart';

/// Unified Add & Edit Habit bottom sheet modal
class HabitFormSheet extends StatefulWidget {
  const HabitFormSheet({
    super.key,
    this.existingHabit,
    required this.onSave,
  });

  final Habit? existingHabit;
  final ValueChanged<Habit> onSave;

  static Future<void> show(
    BuildContext context, {
    Habit? existingHabit,
    required ValueChanged<Habit> onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => HabitFormSheet(
        existingHabit: existingHabit,
        onSave: onSave,
      ),
    );
  }

  @override
  State<HabitFormSheet> createState() => _HabitFormSheetState();
}

class _HabitFormSheetState extends State<HabitFormSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final Set<int> _selectedDays;
  late int _selectedColorIndex;
  TimeOfDay? _reminderTime;
  String? _titleError;
  String? _daysError;

  @override
  void initState() {
    super.initState();
    final habit = widget.existingHabit;
    _titleController = TextEditingController(text: habit?.title ?? '');
    _descController = TextEditingController(text: habit?.description ?? '');
    _selectedDays = habit != null ? habit.repeatDays.toSet() : {1, 2, 3, 4, 5, 6, 7};
    _selectedColorIndex = habit?.colorIndex ?? 0;

    if (habit?.reminderTime != null && habit!.reminderTime!.contains(':')) {
      final parts = habit.reminderTime!.split(':');
      _reminderTime = TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 8,
        minute: int.tryParse(parts[1]) ?? 30,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  bool _validate() {
    final title = _titleController.text.trim();
    setState(() {
      _titleError = title.isEmpty ? context.loc.errorNameRequired : null;
      _daysError = _selectedDays.isEmpty ? context.loc.errorRepeatDaysRequired : null;
    });
    return _titleError == null && _daysError == null;
  }

  void _handleSave() {
    if (!_validate()) return;

    final habit = Habit(
      id: widget.existingHabit?.id ?? 'h_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      repeatDays: _selectedDays.toList()..sort(),
      reminderTime: _reminderTime != null
          ? '${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}'
          : null,
      colorIndex: _selectedColorIndex,
      createdAt: widget.existingHabit?.createdAt ?? DateTime.now(),
    );

    widget.onSave(habit);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: context.padding.bottom + MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDragHandle(context),
            const SizedBox(height: 12),
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildTitleAndDesc(context),
            const SizedBox(height: 16),
            _buildDaySelector(context),
            const SizedBox(height: 16),
            _buildColorSelector(context),
            const SizedBox(height: 16),
            _buildReminderTimeRow(context),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    return Center(
      child: Container(
        width: 44,
        height: 5,
        decoration: BoxDecoration(
          color: context.colors.borderLight,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isEdit = widget.existingHabit != null;
    return Text(
      isEdit ? context.loc.editHabit : context.loc.addHabit,
      style: context.typography.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: context.colors.textMain,
      ),
    );
  }

  Widget _buildTitleAndDesc(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          label: context.loc.habitTitleLabel,
          hintText: context.loc.habitTitleHint,
          controller: _titleController,
          errorText: _titleError,
        ),
        const SizedBox(height: 12),
        AppTextField(
          label: context.loc.habitDescLabel,
          hintText: context.loc.habitDescHint,
          controller: _descController,
        ),
      ],
    );
  }

  Widget _buildDaySelector(BuildContext context) {
    final dayLabels = [
      (1, context.loc.dayMon),
      (2, context.loc.dayTue),
      (3, context.loc.dayWed),
      (4, context.loc.dayThu),
      (5, context.loc.dayFri),
      (6, context.loc.daySat),
      (7, context.loc.daySun),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.loc.repeatDaysLabel,
          style: context.typography.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colors.textMain,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: dayLabels.map((item) {
            final isSelected = _selectedDays.contains(item.$1);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedDays.remove(item.$1);
                  } else {
                    _selectedDays.add(item.$1);
                  }
                });
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isSelected ? context.colors.primary : context.colors.bgCardSubtle,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? context.colors.primary : context.colors.borderLight,
                  ),
                ),
                child: Center(
                  child: Text(
                    item.$2,
                    style: context.typography.bodySmall?.copyWith(
                      color: isSelected ? Colors.white : context.colors.textMuted,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (_daysError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _daysError!,
              style: context.typography.bodySmall?.copyWith(color: Colors.redAccent),
            ),
          ),
      ],
    );
  }

  Widget _buildColorSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.loc.selectColorLabel,
          style: context.typography.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colors.textMain,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(AppColors.habitPalette.length, (idx) {
            final color = AppColors.habitPalette[idx];
            final isSelected = _selectedColorIndex == idx;
            return GestureDetector(
              onTap: () => setState(() => _selectedColorIndex = idx),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? context.colors.textMain : Colors.transparent,
                    width: isSelected ? 3 : 1,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildReminderTimeRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.loc.reminderTimeLabel,
              style: context.typography.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.textMain,
              ),
            ),
            Text(
              _reminderTime != null
                  ? '${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}'
                  : '—',
              style: context.typography.bodyLarge?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: _reminderTime ?? const TimeOfDay(hour: 8, minute: 30),
            );
            if (picked != null) {
              setState(() => _reminderTime = picked);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.bgCardSubtle,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.colors.borderLight),
            ),
          ),
          child: Text(
            context.loc.pickTimeAction,
            style: context.typography.bodyMedium?.copyWith(
              color: context.colors.textMain,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PrimaryGradientButton(
            label: context.loc.saveAction,
            onPressed: _handleSave,
          ),
        ),
        const SizedBox(width: 12),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            context.loc.cancelAction,
            style: context.typography.bodyMedium?.copyWith(
              color: context.colors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}
