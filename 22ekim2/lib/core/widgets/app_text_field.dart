import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';

/// Standard input field styled per `style.md`
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.errorText,
    this.isPassword = false,
    this.keyboardType,
    this.prefixIcon,
    this.onChanged,
    this.maxLines = 1,
  });

  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? errorText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context),
        const SizedBox(height: 6),
        _buildInputContainer(context, colors, hasError),
        if (hasError) _buildErrorText(context),
      ],
    );
  }

  Widget _buildLabel(BuildContext context) {
    return Text(
      widget.label,
      style: context.typography.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: context.colors.textMain,
      ),
    );
  }

  Widget _buildInputContainer(
    BuildContext context,
    dynamic colors,
    bool hasError,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colors.bgCardSubtle,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasError
              ? Colors.redAccent
              : colors.borderLight,
          width: hasError ? 1.5 : 1.0,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword && _obscured,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        onChanged: widget.onChanged,
        style: context.typography.bodyLarge?.copyWith(
          color: colors.textMain,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: context.typography.bodyLarge?.copyWith(
            color: colors.textMuted,
          ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPassword ? _buildPasswordToggle(colors) : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildPasswordToggle(dynamic colors) {
    return IconButton(
      icon: Icon(
        _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: colors.textMuted,
        size: 20,
      ),
      onPressed: () => setState(() => _obscured = !_obscured),
    );
  }

  Widget _buildErrorText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Text(
        widget.errorText!,
        style: context.typography.bodySmall?.copyWith(
          color: Colors.redAccent,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
