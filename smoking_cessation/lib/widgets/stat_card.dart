// ========================================
// DOSYA: stat_card.dart
// NE İŞE YARAR: Tasarruf, kriz ve zihinsel
// hatırlatıcı kart bileşenlerini görüntüler.
// NASIL ÇALIŞIR: Metrik, kriz ve motivasyon
// kartlarını arayüze parametrik sunar.
// SOLID: SRP - Dashboard kart bileşenleri.
// ========================================

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// SRP: Tekil istatistik kartı bileşeni.
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color accentColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.accentColor = AppTheme.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: accentColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: AppTheme.labelCaps,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTheme.labelMetric.copyWith(color: accentColor),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: AppTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

// SRP: Kriz dalgası panik butonu kartı.
class CrisisSectionCard extends StatelessWidget {
  final VoidCallback onPanicTap;

  const CrisisSectionCard({super.key, required this.onPanicTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.outline),
      ),
      child: Column(
        children: [
          _buildWarningHeader(),
          const SizedBox(height: 8),
          _buildDescription(),
          const SizedBox(height: 14),
          _buildPanicButton(),
        ],
      ),
    );
  }

  // Uyarı başlığı bileşeni.
  Widget _buildWarningHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.warning_amber_rounded,
          color: Color(0xFFFCA5A5),
          size: 18,
        ),
        SizedBox(width: 6),
        Text(
          'KRİZ DALGASI MI GELDİ?',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFCA5A5),
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }

  // Açıklama metni bileşeni.
  Widget _buildDescription() {
    return const Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Sigara isteği ortalama '),
          TextSpan(
            text: '3–5 dakika',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.onSurface,
            ),
          ),
          TextSpan(
            text:
                ' sürer ve sonra söner.\n'
                'Derin nefes al ve panik butonuna bas.',
          ),
        ],
      ),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        height: 1.4,
        color: AppTheme.onSurfaceVariant,
      ),
    );
  }

  // Kırmızı acil nefes egzersizi panik butonu.
  Widget _buildPanicButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPanicTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF991B1B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x66F87171), width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40EF4444),
                blurRadius: 18,
                spreadRadius: -2,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFECDD3),
                ),
                child: const Icon(
                  Icons.air_rounded,
                  color: Color(0xFF991B1B),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Canım Çekti (Kriz Butonu)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'ACİL 4-7-8 NEFES EGZERSİZİ BAŞLAT',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFECDD3),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// SRP: Zihinsel hatırlatıcı motivasyon kartı.
class MentalReminderCard extends StatelessWidget {
  const MentalReminderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMentalIcon(),
          const SizedBox(width: 14),
          Expanded(child: _buildMentalContent()),
        ],
      ),
    );
  }

  // Zihin ve psikoloji simge kutusu.
  Widget _buildMentalIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0x2610B981),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x3310B981)),
      ),
      child: const Icon(
        Icons.psychology_alt_rounded,
        color: AppTheme.primary,
        size: 22,
      ),
    );
  }

  // Motivasyonel hatırlatma metin grubu.
  Widget _buildMentalContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Zihinsel Hatırlatıcı',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.onSurface,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '"Bir sigara yakmak stresi bitirmez, sadece nikotin '
          'eksikliğinin yarattığı stresi geçici olarak '
          'dindirir. Zaten özgürsün."',
          style: TextStyle(
            fontSize: 12,
            height: 1.4,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
