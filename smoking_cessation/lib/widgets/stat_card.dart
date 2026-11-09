// ========================================
// DOSYA: stat_card.dart
// NE İŞE YARAR: İstatistik, kriz ve kutlama
// rozet kartı bileşenlerini görüntüler.
// NASIL ÇALIŞIR: Metrik, kriz, rozet ve
// profil kartlarını arayüze sunar.
// SOLID: SRP - Yeniden kullanılabilir kartlar.
// ========================================

import 'package:flutter/material.dart';
import '../models/user_profile.dart';
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
                ' sürer ve sonra söner.\\n'
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
              _buildPanicIcon(),
              const SizedBox(width: 14),
              Expanded(child: _buildPanicLabels()),
            ],
          ),
        ),
      ),
    );
  }

  // Panik butonu sol nefes ikonu.
  Widget _buildPanicIcon() {
    return Container(
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
    );
  }

  // Panik butonu metin sütunu.
  Widget _buildPanicLabels() {
    return Column(
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

// SRP: Ayarlar sayfası başlık bileşeni.
class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.circle, size: 7, color: AppTheme.primary),
            SizedBox(width: 6),
            Text(
              'CANLI REKOR & KUTLAMALAR',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Kutlamalar ve Rozetler',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Biyolojik iyileşme dönüm noktaların ve başarı rozetlerin.',
          style: TextStyle(
            fontSize: 12.5,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// SRP: Büyük dönüm noktası kutlama kartı.
class MilestoneCelebrationCard extends StatelessWidget {
  final String title;
  final String description;
  final String savedAmount;

  const MilestoneCelebrationCard({
    super.key,
    required this.title,
    required this.description,
    required this.savedAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131927),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x3310B981)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A10B981),
            blurRadius: 16,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopRow(),
          const SizedBox(height: 14),
          _buildInnerBox(),
        ],
      ),
    );
  }

  // Üst ikon ve altın dönüm noktası başlığı.
  Widget _buildTopRow() {
    return Row(
      children: [
        _buildMedalIcon(),
        const SizedBox(width: 14),
        Expanded(child: _buildMilestoneTag()),
      ],
    );
  }

  // Altın madalya rozet simgesi.
  Widget _buildMedalIcon() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0x2610B981),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0x6610B981),
              width: 1.5,
            ),
          ),
          child: const Icon(
            Icons.workspace_premium_rounded,
            color: AppTheme.primary,
            size: 28,
          ),
        ),
        Positioned(
          top: -2,
          right: -2,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              size: 11,
              color: AppTheme.surfaceLowest,
            ),
          ),
        ),
      ],
    );
  }

  // Altın dönüm noktası etiket sütunu.
  Widget _buildMilestoneTag() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMilestoneBadge(),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // Altın dönüm noktası küçük rozeti.
  Widget _buildMilestoneBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0x2610B981),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x4010B981)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.circle, size: 6, color: AppTheme.primary),
          SizedBox(width: 4),
          Text(
            'ALTIN DÖNÜM NOKTASI',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBright,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(width: 4),
          Icon(Icons.spa_rounded, size: 12, color: AppTheme.primary),
        ],
      ),
    );
  }

  // Tebrik ve tasarruf edilen miktar kutusu.
  Widget _buildInnerBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D121D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Tebrikler! ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBright,
                  ),
                ),
                TextSpan(
                  text: description,
                  style: const TextStyle(
                    color: AppTheme.onSurfaceVariant,
                    height: 1.4,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildSavedRow(),
        ],
      ),
    );
  }

  // Tasarruf edilen tutar satırı.
  Widget _buildSavedRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Icon(
              Icons.autorenew_rounded,
              size: 16,
              color: AppTheme.secondaryCyan,
            ),
            SizedBox(width: 6),
            Text(
              'Tasarruf Edilen:',
              style: TextStyle(
                color: AppTheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ),
        Text(
          savedAmount,
          style: const TextStyle(
            color: AppTheme.primaryBright,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// SRP: İyileşme rozetleri kart bileşeni.
class RecoveryBadgesSection extends StatelessWidget {
  final int unlockedCount;

  const RecoveryBadgesSection({
    super.key,
    this.unlockedCount = 3,
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
          _buildHeader(),
          const SizedBox(height: 12),
          _buildGrid(),
        ],
      ),
    );
  }

  // Başlık ve açılan rozet sayısı rozeti.
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'İyileşme Rozetleri',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Biyolojik yenilenme yolculuğun',
              style: TextStyle(
                fontSize: 11.5,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        _buildBadgePill(),
      ],
    );
  }

  // Açılan rozet sayaç kapsülü.
  Widget _buildBadgePill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
      decoration: BoxDecoration(
        color: const Color(0x2006B6D4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x4006B6D4)),
      ),
      child: Text(
        '$unlockedCount / 6 Açıldı',
        style: const TextStyle(
          color: AppTheme.secondaryCyan,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  // 6 rozet içeren 2 satırlı ızgara.
  Widget _buildGrid() {
    return Column(
      children: [
        _buildRowOne(),
        const SizedBox(height: 8),
        _buildRowTwo(),
      ],
    );
  }

  // İlk 3 rozet satırı.
  Widget _buildRowOne() {
    return Row(
      children: const [
        Expanded(
          child: _BadgeCard(
            title: '24 Saat',
            status: 'KAZANILDI',
            icon: Icons.schedule_rounded,
            accentColor: AppTheme.primary,
            isUnlocked: true,
            showDot: true,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _BadgeCard(
            title: '3 Gün',
            status: 'KAZANILDI',
            icon: Icons.auto_awesome_rounded,
            accentColor: AppTheme.primary,
            isUnlocked: true,
            showDot: true,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _BadgeCard(
            title: '1 Hafta',
            status: 'KAZANILDI',
            icon: Icons.verified_rounded,
            accentColor: AppTheme.primary,
            isUnlocked: true,
            isHighlighted: true,
            showNewBadge: true,
          ),
        ),
      ],
    );
  }

  // İkinci 3 rozet satırı.
  Widget _buildRowTwo() {
    return Row(
      children: const [
        Expanded(
          child: _BadgeCard(
            title: '1 Ay',
            status: 'SIRADA (%23)',
            icon: Icons.lock_open_rounded,
            accentColor: AppTheme.secondaryCyan,
            progressPercent: 0.23,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _BadgeCard(
            title: '3 Ay',
            status: 'KİLİTLİ',
            icon: Icons.lock_outline_rounded,
            accentColor: AppTheme.onSurfaceMuted,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _BadgeCard(
            title: '1 Yıl',
            status: 'EFSANE',
            icon: Icons.military_tech_rounded,
            accentColor: AppTheme.warningAmber,
          ),
        ),
      ],
    );
  }
}

// SRP: Tekil rozet kartı bileşeni.
class _BadgeCard extends StatelessWidget {
  final String title;
  final String status;
  final IconData icon;
  final Color accentColor;
  final bool isUnlocked;
  final bool isHighlighted;
  final bool showDot;
  final bool showNewBadge;
  final double? progressPercent;

  const _BadgeCard({
    required this.title,
    required this.status,
    required this.icon,
    required this.accentColor,
    this.isUnlocked = false,
    this.isHighlighted = false,
    this.showDot = false,
    this.showNewBadge = false,
    this.progressPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildContainer(),
        if (showDot) _buildDot(),
        if (showNewBadge) _buildNewTag(),
      ],
    );
  }

  // Rozet ana çerçevesi.
  Widget _buildContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0D121D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted ? AppTheme.primary : const Color(0x1FFFFFFF),
          width: isHighlighted ? 1.5 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIconCircle(),
          const SizedBox(height: 6),
          _buildTextContent(),
        ],
      ),
    );
  }

  // Rozet başlık ve durum metinleri.
  Widget _buildTextContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          status,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.bold,
            color: accentColor,
            letterSpacing: 0.3,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (progressPercent != null) ...[
          const SizedBox(height: 4),
          _buildProgressBar(),
        ],
      ],
    );
  }

  // Üst köşe yeşil nokta.
  Widget _buildDot() {
    return Positioned(
      top: 6,
      right: 6,
      child: Container(
        width: 5,
        height: 5,
        decoration: const BoxDecoration(
          color: AppTheme.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  // Yeni rozeti etiketi.
  Widget _buildNewTag() {
    return Positioned(
      top: -5,
      right: 6,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
        decoration: BoxDecoration(
          color: const Color(0xFF6EE7B7),
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Text(
          'YENİ',
          style: TextStyle(
            fontSize: 8.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF064E3B),
          ),
        ),
      ),
    );
  }

  // Rozet simge dairesi.
  Widget _buildIconCircle() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: accentColor,
        size: 19,
      ),
    );
  }

  // İlerleme yüzdesi çubuğu.
  Widget _buildProgressBar() {
    return Container(
      height: 2.5,
      width: 38,
      decoration: BoxDecoration(
        color: const Color(0x3306B6D4),
        borderRadius: BorderRadius.circular(2),
      ),
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: progressPercent,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.secondaryCyan,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

// SRP: Profil bilgileri ayar kartı bileşeni.
class SettingsProfileCard extends StatelessWidget {
  final UserProfile? profile;
  final VoidCallback onEditDate;
  final VoidCallback onEditCost;

  const SettingsProfileCard({
    super.key,
    required this.profile,
    required this.onEditDate,
    required this.onEditCost,
  });

  @override
  Widget build(BuildContext context) {
    final p = profile;
    final dStr = p == null
        ? '-'
        : '${p.quitDateTime.day}.${p.quitDateTime.month}.${p.quitDateTime.year}';
    final cStr = p == null
        ? '-'
        : 'Günde ${p.cigarettesPerDay} adet • Paket ${p.packPrice.toStringAsFixed(0)} ₺';

    return Material(
      color: AppTheme.surfaceLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text('PROFİL BİLGİLERİ', style: AppTheme.labelCaps),
          ),
          ListTile(
            leading: const Icon(Icons.edit_calendar, color: AppTheme.primary),
            title: const Text('Bırakma Tarihi', style: AppTheme.titleSmall),
            subtitle: Text(dStr, style: AppTheme.bodySmall),
            trailing: const Icon(Icons.chevron_right),
            onTap: onEditDate,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.attach_money, color: AppTheme.warningAmber),
            title: const Text('Tüketim ve Fiyat', style: AppTheme.titleSmall),
            subtitle: Text(cStr, style: AppTheme.bodySmall),
            trailing: const Icon(Icons.chevron_right),
            onTap: onEditCost,
          ),
        ],
      ),
    );
  }
}

// SRP: Tüm verileri sıfırlama butonu bileşeni.
class SettingsResetButton extends StatelessWidget {
  final VoidCallback onReset;

  const SettingsResetButton({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.dangerSos,
        side: const BorderSide(color: AppTheme.dangerSos),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      icon: const Icon(Icons.delete_forever_rounded),
      label: const Text('Tüm Verileri Sıfırla'),
      onPressed: onReset,
    );
  }
}
