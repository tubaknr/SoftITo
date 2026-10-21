import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../theme/app_typography.dart';

/// Focus & Grow 20px radiuslu hata duyarlı input bileşeni.
class FGTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? placeholder;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;

  const FGTextField({
    super.key,
    this.controller,
    required this.label,
    this.placeholder,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Alan Üst Etiketi
        Padding(
          padding: const EdgeInsets.only(left: 6, bottom: 6),
          child: Text(
            label,
            style: AppTypography.inputLabel(isDark: isDark),
          ),
        ),
        // Girdi Kutusu
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          readOnly: readOnly,
          onTap: onTap,
          style: GoogleFonts.plusJakartaSans(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: GoogleFonts.plusJakartaSans(
              color: isDark
                  ? AppColors.darkTextMuted.withValues(alpha: 0.6)
                  : AppColors.textMuted.withValues(alpha: 0.7),
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
            filled: true,
            fillColor: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.65),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: hasError
                    ? AppColors.coralRedError
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.85)),
                width: hasError ? 1.5 : 1.2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: hasError
                    ? AppColors.coralRedError
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.85)),
                width: hasError ? 1.5 : 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: hasError
                    ? AppColors.coralRedError
                    : AppColors.dustyRoseAccent,
                width: 1.5,
              ),
            ),
          ),
        ),
        // Hata Metni
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: Text(
              errorText!,
              style: AppTypography.errorCaption,
            ),
          ),
      ],
    );
  }
}
