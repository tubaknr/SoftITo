import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_text_field.dart';
import '../models/mood_entry.dart';

/// Modal bottom sheet for optional post-completion reflection & awareness note
class ReflectionBottomSheet extends StatefulWidget {
  const ReflectionBottomSheet({
    super.key,
    required this.habitTitle,
    this.initialMood,
    this.initialNote,
    required this.onSave,
  });

  final String habitTitle;
  final Mood? initialMood;
  final String? initialNote;
  final void Function(Mood mood, String note) onSave;

  static Future<void> show(
    BuildContext context, {
    required String habitTitle,
    Mood? initialMood,
    String? initialNote,
    required void Function(Mood mood, String note) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => ReflectionBottomSheet(
        habitTitle: habitTitle,
        initialMood: initialMood,
        initialNote: initialNote,
        onSave: onSave,
      ),
    );
  }

  @override
  State<ReflectionBottomSheet> createState() => _ReflectionBottomSheetState();
}

class _ReflectionBottomSheetState extends State<ReflectionBottomSheet> {
  late Mood _selectedMood;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _selectedMood = widget.initialMood ?? Mood.happy;
    _noteController = TextEditingController(text: widget.initialNote ?? '');
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDragHandle(context),
          const SizedBox(height: 12),
          _buildHeader(context),
          const SizedBox(height: 18),
          _buildMoodEmojiSelector(context),
          const SizedBox(height: 18),
          _buildNoteField(context),
          const SizedBox(height: 24),
          _buildActions(context),
        ],
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
    final colors = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFD1FAE5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Text('🐧', style: TextStyle(fontSize: 22)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.habitTitle,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                context.loc.reflectionQuestion,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colors.textMain,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoodEmojiSelector(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: Mood.values.map((m) {
        final isSelected = _selectedMood == m;
        return GestureDetector(
          onTap: () => setState(() => _selectedMood = m),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? context.colors.primaryLight.withValues(alpha: 0.3)
                  : context.colors.bgCardSubtle,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? context.colors.primary
                    : context.colors.borderLight,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: context.colors.primary.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              children: [
                Text(m.emoji, style: const TextStyle(fontSize: 26)),
                const SizedBox(height: 4),
                Text(
                  _moodLabel(context, m),
                  style: context.typography.bodySmall?.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? context.colors.primary
                        : context.colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _moodLabel(BuildContext context, Mood m) {
    switch (m) {
      case Mood.awesome:
        return context.loc.moodAwesome;
      case Mood.happy:
        return context.loc.moodHappy;
      case Mood.calm:
        return context.loc.moodCalm;
      case Mood.tired:
        return context.loc.moodTired;
      case Mood.challenging:
        return context.loc.moodChallenging;
    }
  }

  Widget _buildNoteField(BuildContext context) {
    return AppTextField(
      label: context.loc.awarenessNoteLabel,
      hintText: context.loc.awarenessNoteLabel,
      controller: _noteController,
      maxLines: 3,
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: PrimaryGradientButton(
            label: context.loc.saveNoteAction,
            height: 48,
            onPressed: () {
              widget.onSave(_selectedMood, _noteController.text);
              Navigator.of(context).pop();
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 1,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              context.loc.skipAction,
              style: context.typography.bodyMedium?.copyWith(
                color: context.colors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
