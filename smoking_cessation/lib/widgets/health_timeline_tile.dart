// ========================================
// DOSYA: health_timeline_tile.dart
// NE İŞE YARAR: Sağlık zaman çizelgesi,
// metrik kartları ve başlık bloklarını sunar.
// NASIL ÇALIŞIR: Tamamlanma ve süreye göre
// görsel düğüm ve veri kartlarını çizer.
// SOLID: SRP - Sağlık arayüzü görsel bileşenleri.
// ========================================

import 'package:flutter/material.dart';
import '../models/health_milestone.dart';
import '../theme/app_theme.dart';

// SRP: Zaman çizelgesi satır bileşeni.
class HealthTimelineTile extends StatelessWidget {
  final HealthMilestone milestone;
  final bool isCompleted;
  final double progress;
  final bool isFirst;
  final bool isLast;
  final String durationLabel;
  final Duration elapsed;

  const HealthTimelineTile({
    super.key,
    required this.milestone,
    required this.isCompleted,
    required this.progress,
    required this.durationLabel,
    required this.elapsed,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTimelineIndicator(),
          const SizedBox(width: 14),
          Expanded(child: _buildContentCard()),
        ],
      ),
    );
  }

  // Dikey zaman çizgisi ve durum ikonu.
  Widget _buildTimelineIndicator() {
    final isCurrent = !isCompleted && progress > 0;
    final isLocked = !isCompleted &&
        progress == 0 &&
        milestone.startDuration.inDays > 365;

    return Column(
      children: [
        Container(
          width: 2,
          height: 14,
          color: isFirst
              ? Colors.transparent
              : (isCompleted
                  ? AppTheme.primary
                  : const Color(0x33FFFFFF)),
        ),
        _buildNodeCircle(isCurrent, isLocked),
        Expanded(
          child: Container(
            width: 2,
            color: isLast
                ? Colors.transparent
                : (isCompleted
                    ? AppTheme.primary
                    : const Color(0x22FFFFFF)),
          ),
        ),
      ],
    );
  }

  // Düğüm simgesi dairesi.
  Widget _buildNodeCircle(bool isCurrent, bool isLocked) {
    if (isCompleted) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF10B981),
        ),
        child: const Icon(
          Icons.check_rounded,
          size: 15,
          color: Colors.white,
        ),
      );
    }
    if (isCurrent) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0x2606B6D4),
          border: Border.all(
            color: AppTheme.secondaryCyan,
            width: 2,
          ),
        ),
        child: Center(
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.secondaryCyan,
            ),
          ),
        ),
      );
    }
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0x1AFFFFFF),
        border: Border.all(color: const Color(0x33FFFFFF)),
      ),
      child: isLocked
          ? const Icon(
              Icons.lock_outline_rounded,
              size: 12,
              color: Colors.white38,
            )
          : null,
    );
  }

  // Sağ taraftaki detay kartı.
  Widget _buildContentCard() {
    final isCurrent = !isCompleted && progress > 0;
    final isLocked = !isCompleted &&
        progress == 0 &&
        milestone.startDuration.inDays > 365;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF131D26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? const Color(0x3310B981)
              : (isCurrent
                  ? const Color(0x4D06B6D4)
                  : const Color(0x14FFFFFF)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(isCurrent, isLocked),
          const SizedBox(height: 8),
          Text(
            milestone.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            milestone.description,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          _buildProgressBar(isCurrent),
          if (isCurrent) _buildCurrentFooter(),
        ],
      ),
    );
  }

  // Kart üst bilgi ve etiket satırı.
  Widget _buildCardHeader(bool isCurrent, bool isLocked) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              durationLabel,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: isCompleted
                    ? AppTheme.primary
                    : (isCurrent
                        ? AppTheme.secondaryCyan
                        : const Color(0xFF94A3B8)),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            _buildBadge(isCurrent, isLocked),
          ],
        ),
        _buildPercentPill(isCurrent, isLocked),
      ],
    );
  }

  // Durum kapsül rozeti.
  Widget _buildBadge(bool isCurrent, bool isLocked) {
    if (isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: const Color(0x2610B981),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primary,
              ),
              child: SizedBox(width: 5, height: 5),
            ),
            SizedBox(width: 4),
            Text(
              'Tamamlandı',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
      );
    }
    if (isCurrent) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: const Color(0x2606B6D4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.secondaryCyan,
              ),
              child: SizedBox(width: 5, height: 5),
            ),
            SizedBox(width: 4),
            Text(
              'İyileşme Sürüyor',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: AppTheme.secondaryCyan,
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        isLocked ? '🔒 Gelecek Hedef' : 'Uzun Vadeli',
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFF94A3B8),
        ),
      ),
    );
  }

  // Yüzde gösterge hapı.
  Widget _buildPercentPill(bool isCurrent, bool isLocked) {
    if (isLocked) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: const Color(0x1AFFFFFF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.lock_outline_rounded,
          size: 13,
          color: Color(0xFF94A3B8),
        ),
      );
    }
    final pct = (progress * 100).toInt();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$pct%',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isCompleted
              ? AppTheme.primary
              : (isCurrent
                  ? AppTheme.secondaryCyan
                  : const Color(0xFF94A3B8)),
        ),
      ),
    );
  }

  // İlerleme çubuğu.
  Widget _buildProgressBar(bool isCurrent) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 5,
        backgroundColor: const Color(0x1AFFFFFF),
        valueColor: AlwaysStoppedAnimation<Color>(
          isCompleted
              ? const Color(0xFF4EDEA3)
              : const Color(0xFF4CD7F6),
        ),
      ),
    );
  }

  // Sürmekte olan hedef alt bilgi satırı.
  Widget _buildCurrentFooter() {
    final remainingDays = (milestone.endDuration - elapsed).inDays;
    final daysStr = remainingDays > 0 ? '$remainingDays' : '1';

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Dolaşım & Silya Rejenerasyonu',
            style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
          ),
          Text(
            'Hedefe $daysStr Gün Kaldı',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryCyan,
            ),
          ),
        ],
      ),
    );
  }
}

// SRP: Sağlık ekranı üst biyolojik başlık kartı.
class HealthHeaderCard extends StatelessWidget {
  final int completed;
  final int total;

  const HealthHeaderCard({
    super.key,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final level = (completed + 1).clamp(1, 8);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131D26),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x1FFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBadge(),
          const SizedBox(height: 10),
          const Text(
            'Sağlık İyileşme Süreci',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Vücudunun sigarasız geçen her dakikadaki '
            'mucizevi onarımı',
            style: TextStyle(
              fontSize: 12.5,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          _buildFooterRow(level),
        ],
      ),
    );
  }

  // Rozet etiketi.
  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0x1A10B981),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x3310B981)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primary,
            ),
            child: SizedBox(width: 6, height: 6),
          ),
          SizedBox(width: 6),
          Text(
            'Biyolojik İyileşme',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  // Alt seviye ve tamamlanma özeti satırı.
  Widget _buildFooterRow(int level) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.show_chart_rounded,
              color: AppTheme.primary,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              'Toplam Onarım Fazı: Seviye $level',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Text(
          '$completed / $total Tamam',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
        ),
      ],
    );
  }
}

// SRP: Akciğer ve toksin ikili metrik kartı.
class HealthMetricCards extends StatelessWidget {
  final Duration elapsed;

  const HealthMetricCards({super.key, required this.elapsed});

  @override
  Widget build(BuildContext context) {
    final cap = (elapsed.inHours / 72.0 * 30).toInt().clamp(0, 30);
    final coPpm = elapsed.inHours >= 24
        ? 0
        : (15 - (elapsed.inHours * 0.6).toInt()).clamp(0, 15);

    return Row(
      children: [
        Expanded(child: _buildCapacityCard(cap)),
        const SizedBox(width: 12),
        Expanded(child: _buildToxinCard(coPpm)),
      ],
    );
  }

  // Akciğer kapasitesi kartı.
  Widget _buildCapacityCard(int cap) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF131D26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1FFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'AKCİĞER KAPASİTESİ',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF94A3B8),
                  letterSpacing: 0.5,
                ),
              ),
              Icon(
                Icons.air_rounded,
                color: AppTheme.secondaryCyan,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '+$cap%',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryCyan,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Oksijen absorpsiyonu',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  // Hücresel toksin arınma kartı.
  Widget _buildToxinCard(int coPpm) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF131D26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1FFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'HÜCRESEL TOKSİN',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF94A3B8),
                  letterSpacing: 0.5,
                ),
              ),
              Icon(
                Icons.favorite_border_rounded,
                color: AppTheme.primary,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$coPpm',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const Text(
                ' ppm',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Karbonmonoksit arındı',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

// SRP: Hücresel yenilenme motivasyon kartı.
class CellularRenewalCard extends StatelessWidget {
  const CellularRenewalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131D26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1FFFFFFF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSparkleIcon(),
          const SizedBox(width: 14),
          Expanded(child: _buildCardContent()),
        ],
      ),
    );
  }

  // Yıldız ışıltı simge kutusu.
  Widget _buildSparkleIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0x2606B6D4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.auto_awesome_rounded,
        color: AppTheme.secondaryCyan,
        size: 22,
      ),
    );
  }

  // Yenilenme içerik metni.
  Widget _buildCardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Hücresel Yenilenme Sürüyor',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Vücudun 72 saatten beridir kendi silya dokularını '
          '2 kat hızlı örüyor. Kararlılığını koru!',
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
