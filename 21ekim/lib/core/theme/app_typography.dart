import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Focus & Grow tipografi standartları:
/// - Headline ve Body için: GoogleFonts.ebGaramond()
/// - Label (Etiketler, Girişler ve Butonlar) için: GoogleFonts.plusJakartaSans()
class AppTypography {
  AppTypography._();

  // Display / Hero (Headline / Başlık - EB Garamond)
  static TextStyle heroDisplay({bool isDark = false}) => GoogleFonts.ebGaramond(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        letterSpacing: 0.5,
        color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
      );

  // Büyük Odak Sayacı (Headline / Display - EB Garamond)
  static TextStyle timerDisplay({bool isDark = false}) => GoogleFonts.ebGaramond(
        fontSize: 60,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.italic,
        letterSpacing: 2.5,
        color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
      );

  // Başlık 1 - İnce (Headline - EB Garamond)
  static TextStyle heading1Light({bool isDark = false}) => GoogleFonts.ebGaramond(
        fontSize: 26,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
      );

  // Başlık 1 - Kalın Vurgulu (Headline - EB Garamond)
  static TextStyle heading1Bold({bool isDark = false}) => GoogleFonts.ebGaramond(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.italic,
        color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
      );

  // Başlık 2 (Kart ve Bölüm Başlıkları - Headline - EB Garamond)
  static TextStyle heading2({bool isDark = false}) => GoogleFonts.ebGaramond(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
        color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
      );

  // Motto & Slogan (Body / Metin - EB Garamond)
  static TextStyle mottoText({bool isDark = false}) => GoogleFonts.ebGaramond(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        height: 1.45,
        color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
      );

  // Normal Gövde Metni (Body - EB Garamond)
  static TextStyle body({bool isDark = false}) => GoogleFonts.ebGaramond(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        height: 1.4,
        color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
      );

  // Input Placeholder ve Etiketleri (Label - Plus Jakarta Sans)
  static TextStyle inputLabel({bool isDark = false}) => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.italic,
        color: isDark
            ? AppColors.darkTextPrimary.withValues(alpha: 0.85)
            : AppColors.textCharcoal.withValues(alpha: 0.85),
      );

  // Etiket Stilleri (Label - Plus Jakarta Sans)
  static TextStyle labelLarge({bool isDark = false}) => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
      );

  static TextStyle labelMedium({bool isDark = false}) => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
      );

  static TextStyle labelSmall({bool isDark = false}) => GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
      );

  // Hata Metinleri (Label / Caption - Plus Jakarta Sans)
  static TextStyle errorCaption = GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    color: AppColors.coralRedError,
  );

  // Buton Yazısı (Label - Plus Jakarta Sans)
  static TextStyle buttonText = GoogleFonts.plusJakartaSans(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    letterSpacing: 0.6,
    color: Colors.white,
  );

  // Altı Çizili Bağlantı Metinleri (EB Garamond)
  static TextStyle underlineLink({bool isDark = false}) => GoogleFonts.ebGaramond(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.italic,
        decoration: TextDecoration.underline,
        color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
      );

  // Filigran (EB Garamond)
  static TextStyle watermark({bool isDark = false}) => GoogleFonts.ebGaramond(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        color: isDark
            ? AppColors.darkTextMuted.withValues(alpha: 0.6)
            : AppColors.textMuted.withValues(alpha: 0.6),
        letterSpacing: 1.2,
      );
}
