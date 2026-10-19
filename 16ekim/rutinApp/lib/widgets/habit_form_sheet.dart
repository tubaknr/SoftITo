import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../models/habit_presets.dart';
import '../state/habit_store.dart';

/// Yeni alışkanlık ekler; [habit] verilirse onu düzenler.
Future<void> showHabitFormSheet(BuildContext context, HabitStore store, {Habit? habit}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(sheetContext).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: _HabitForm(store: store, habit: habit),
      ),
    ),
  );
}

class _HabitForm extends StatefulWidget {
  const _HabitForm({required this.store, this.habit});

  final HabitStore store;
  final Habit? habit;

  @override
  State<_HabitForm> createState() => _HabitFormState();
}

class _HabitFormState extends State<_HabitForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController =
      TextEditingController(text: widget.habit?.name ?? '');
  late int _iconIndex = widget.habit?.iconIndex ?? 0;
  late int _colorIndex = widget.habit?.colorIndex ?? 0;
  late int _goal = widget.habit?.weeklyGoal ?? 7;
  String? _error;

  bool get _editing => widget.habit != null;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final messenger = ScaffoldMessenger.of(context);
    final name = _nameController.text;
    final error = _editing
        ? widget.store.updateHabit(
            widget.habit!.id,
            name: name,
            iconIndex: _iconIndex,
            colorIndex: _colorIndex,
            weeklyGoal: _goal,
          )
        : widget.store.addHabit(
            name: name,
            iconIndex: _iconIndex,
            colorIndex: _colorIndex,
            weeklyGoal: _goal,
          );
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.pop(context);
    messenger.showSnackBar(
      SnackBar(content: Text(_editing ? 'Alışkanlık güncellendi.' : 'Alışkanlık eklendi.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = habitColors[_colorIndex];
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _editing ? 'Alışkanlığı düzenle' : 'Yeni alışkanlık',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            autofocus: !_editing,
            maxLength: 30,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Alışkanlık adı',
              hintText: 'Örn. 10 dakika esneme',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Bir isim girin.' : null,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
          const SizedBox(height: 8),
          const Text('Simge', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var i = 0; i < habitIcons.length; i++)
                InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => setState(() => _iconIndex = i),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: i == _iconIndex
                        ? selectedColor
                        : Color.alphaBlend(selectedColor.withAlpha(30), Colors.white),
                    child: Icon(
                      habitIcons[i],
                      color: i == _iconIndex ? Colors.white : selectedColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          const Text('Renk', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            children: [
              for (var i = 0; i < habitColors.length; i++)
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => setState(() => _colorIndex = i),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: habitColors[i],
                    child: i == _colorIndex
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                        : null,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Haftalık hedef', style: TextStyle(fontWeight: FontWeight.w600)),
              Text('Haftada $_goal gün', style: TextStyle(color: selectedColor, fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: _goal.toDouble(),
            min: 1,
            max: 7,
            divisions: 6,
            label: '$_goal gün',
            activeColor: selectedColor,
            onChanged: (value) => setState(() => _goal = value.round()),
          ),
          if (_error != null) ...[
            Text(_error!, style: TextStyle(color: Colors.red.shade700)),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submit,
              child: Text(_editing ? 'Kaydet' : 'Ekle'),
            ),
          ),
        ],
      ),
    );
  }
}
