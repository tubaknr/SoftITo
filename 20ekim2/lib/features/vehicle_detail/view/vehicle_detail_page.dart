import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/controllers/session_controller.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/primary_cta_button.dart';
import '../../../core/widgets/rating_stars.dart';
import '../../../core/widgets/section_header.dart';
import '../../auth/view/welcome_page.dart';
import '../../../core/controllers/locale_controller.dart';
import '../../../core/controllers/theme_controller.dart';
import '../../owner_profile/data/mock_owner_data.dart';
import '../../owner_profile/models/owner_user.dart';
import '../../owner_profile/view/owner_profile_page.dart';
import '../../renter_profile/view/renter_profile_page.dart';
import '../../reservation/view/rental_form_page.dart';
import '../../vehicle_list/models/enums.dart';
import '../../vehicle_list/models/review.dart';
import '../../vehicle_list/models/vehicle.dart';
import '../widget/availability_calendar.dart';

enum PricingPeriod { hourly, daily, weekly, monthly }

class VehicleDetailPage extends StatefulWidget {
  const VehicleDetailPage({
    required this.vehicle,
    required this.sessionController,
    super.key,
  });

  final Vehicle vehicle;
  final SessionController sessionController;

  @override
  State<VehicleDetailPage> createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends State<VehicleDetailPage> {
  PricingPeriod _selectedPeriod = PricingPeriod.daily;
  DateTimeRange? _selectedDateRange;
  bool _showAllReviews = false;
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  double get _currentPrice {
    switch (_selectedPeriod) {
      case PricingPeriod.hourly:
        return widget.vehicle.hourlyPrice;
      case PricingPeriod.daily:
        return widget.vehicle.dailyPrice;
      case PricingPeriod.weekly:
        return widget.vehicle.weeklyPrice;
      case PricingPeriod.monthly:
        return widget.vehicle.monthlyPrice;
    }
  }

  String? get _priceSummary {
    if (_selectedDateRange == null) return null;
    final int days = _selectedDateRange!.duration.inDays == 0
        ? 1
        : _selectedDateRange!.duration.inDays;
    final double total = days * widget.vehicle.dailyPrice;
    return '$days gün • ₺${total.toStringAsFixed(0)}';
  }

  void _showExpertiseReport() {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Row(
          children: <Widget>[
            const Icon(Icons.verified_rounded, color: Colors.blue),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(context.l10n.expertiseReportDialogTitle),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 360,
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.8,
            maxScale: 3.5,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: context.colorScheme.outlineVariant),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.assignment_turned_in_rounded,
                    size: 72,
                    color: context.appColors.success,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'TÜV & TSE ONAYLI EKSPERTİZ RAPORU',
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Araç: ${widget.vehicle.fullName}\nPlaka: ${widget.vehicle.plate}\nŞase: ${widget.vehicle.chassisOrIdNo}\n\nKaza/Tramer: ${widget.vehicle.accidentHistory.localized(context.l10n)}\nDetay: ${widget.vehicle.accidentDescription}\nMotor Kondisyonu: %96 (Mükemmel)\nFrenaj & Yürüyen: Kusursuz',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.l10n.dialogClose),
          ),
        ],
      ),
    );
  }

  void _handleRentAction() {
    // 1. Giriş kontrolü
    if (!widget.sessionController.value.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.loginRequiredWarning),
          action: SnackBarAction(
            label: context.l10n.loginButton,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => WelcomePage(
                    sessionController: widget.sessionController,
                    themeController: ThemeController(),
                    localeController: LocaleController(),
                  ),
                ),
              );
            },
          ),
        ),
      );
      return;
    }

    // 2. Tarih seçimi kontrolü
    if (_selectedDateRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.selectDatesWarning),
          backgroundColor: context.appColors.warning,
        ),
      );
      return;
    }

    // 3. Kiralama Formu Açılışı
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RentalFormPage(
          vehicle: widget.vehicle,
          selectedRange: _selectedDateRange!,
          sessionController: widget.sessionController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final OwnerUser? owner = MockOwnerData.getById(widget.vehicle.ownerId);
    final List<Review> displayedReviews = _showAllReviews
        ? widget.vehicle.reviews
        : widget.vehicle.reviews.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicle.fullName),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // 1. Görsel Galerisi (PageView)
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          PageView(
                            controller: _pageController,
                            onPageChanged: (int idx) => setState(() => _currentImageIndex = idx),
                            children: <Widget>[
                              Hero(
                                tag: 'vehicle_image_${widget.vehicle.id}',
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        context.colorScheme.primary.withAlpha(50),
                                        context.colorScheme.secondaryContainer,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      widget.vehicle.type.icon,
                                      size: 96,
                                      color: context.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: context.colorScheme.surfaceContainerHighest,
                                child: Center(
                                  child: Icon(
                                    Icons.photo_library_rounded,
                                    size: 64,
                                    color: context.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Sayfa Noktaları
                          Positioned(
                            bottom: AppSpacing.sm,
                            child: Row(
                              children: List<Widget>.generate(2, (int i) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  width: _currentImageIndex == i ? 16 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: _currentImageIndex == i
                                        ? context.colorScheme.primary
                                        : Colors.white.withAlpha(120),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          // 2. Başlık, Puan, Kiralama Sayısı
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      widget.vehicle.fullName,
                                      style: context.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      'Plaka: ${widget.vehicle.plate} • Şase: ${widget.vehicle.chassisOrIdNo}',
                                      style: context.textTheme.bodySmall?.copyWith(
                                        color: context.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  RatingStars(
                                    rating: widget.vehicle.rating,
                                    ratingCount: widget.vehicle.ratingCount,
                                    starSize: 20,
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    '${widget.vehicle.rentCount} kez kiralandı',
                                    style: context.textTheme.labelSmall?.copyWith(
                                      color: context.appColors.success,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // 3. Teknik Özellikler Grid
                          SectionHeader(title: context.l10n.technicalSpecs),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      _SpecTile(
                                        icon: Icons.speed_rounded,
                                        label: 'Kilometre',
                                        value: context.l10n.mileageKm(widget.vehicle.mileageKm),
                                      ),
                                      _SpecTile(
                                        icon: Icons.tune_rounded,
                                        label: 'Vites',
                                        value: widget.vehicle.transmission.localized(context.l10n),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  Row(
                                    children: <Widget>[
                                      _SpecTile(
                                        icon: Icons.local_gas_station_rounded,
                                        label: 'Yakıt',
                                        value: widget.vehicle.fuelType.localized(context.l10n),
                                      ),
                                      _SpecTile(
                                        icon: Icons.airline_seat_recline_normal_rounded,
                                        label: 'Koltuk',
                                        value: '${widget.vehicle.seatCount} Kişilik',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  Row(
                                    children: <Widget>[
                                      _SpecTile(
                                        icon: Icons.health_and_safety_rounded,
                                        label: context.l10n.accidentStatusLabel,
                                        value: widget.vehicle.accidentHistory.localized(context.l10n),
                                        highlightColor: widget.vehicle.accidentHistory == AccidentHistory.clean
                                            ? context.appColors.success
                                            : context.appColors.warning,
                                      ),
                                      _SpecTile(
                                        icon: Icons.videocam_rounded,
                                        label: 'İç Kamera',
                                        value: widget.vehicle.hasInteriorCamera ? 'Mevcut' : 'Yok',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),

                          // 4. Ekspertiz Raporunu Gör Butonu
                          FilledButton.tonalIcon(
                            onPressed: _showExpertiseReport,
                            icon: const Icon(Icons.assignment_turned_in_rounded),
                            label: Text(context.l10n.viewExpertiseReport),
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // 5. Fiyat Seçenekleri
                          SectionHeader(title: context.l10n.pricingOptions),
                          SegmentedButton<PricingPeriod>(
                            segments: <ButtonSegment<PricingPeriod>>[
                              ButtonSegment<PricingPeriod>(
                                value: PricingPeriod.hourly,
                                label: Text(context.l10n.hourlyPrice),
                              ),
                              ButtonSegment<PricingPeriod>(
                                value: PricingPeriod.daily,
                                label: Text(context.l10n.dailyPrice),
                              ),
                              ButtonSegment<PricingPeriod>(
                                value: PricingPeriod.weekly,
                                label: Text(context.l10n.weeklyPrice),
                              ),
                              ButtonSegment<PricingPeriod>(
                                value: PricingPeriod.monthly,
                                label: Text(context.l10n.monthlyPrice),
                              ),
                            ],
                            selected: <PricingPeriod>{_selectedPeriod},
                            onSelectionChanged: (Set<PricingPeriod> s) {
                              setState(() => _selectedPeriod = s.first);
                            },
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Card(
                            color: context.colorScheme.primaryContainer.withAlpha(50),
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Seçilen Tarife Tutarı:',
                                    style: context.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '₺${_currentPrice.toStringAsFixed(0)}',
                                    style: context.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: context.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // 6. Takvim
                          SectionHeader(title: context.l10n.availabilityCalendar),
                          AvailabilityCalendar(
                            bookedRanges: widget.vehicle.bookedRanges,
                            initialRange: _selectedDateRange,
                            onRangeSelected: (DateTimeRange? range) {
                              setState(() => _selectedDateRange = range);
                            },
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // 7. Satıcı Hakkında Kartı
                          SectionHeader(title: context.l10n.aboutOwner),
                          if (owner != null)
                            Card(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(AppRadius.lg),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => OwnerProfilePage(
                                        sessionController: widget.sessionController,
                                        ownerId: owner.id,
                                        isOwnProfile: false,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 28,
                                        backgroundColor: context.colorScheme.primaryContainer,
                                        child: Text(
                                          owner.firstName.substring(0, 1),
                                          style: context.textTheme.titleLarge?.copyWith(
                                            color: context.colorScheme.primary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.md),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '${owner.displayName} (${owner.ageRange})',
                                              style: context.textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: AppSpacing.xs),
                                            Text(
                                              owner.location,
                                              style: context.textTheme.bodySmall?.copyWith(
                                                color: context.colorScheme.onSurfaceVariant,
                                              ),
                                            ),
                                            const SizedBox(height: AppSpacing.xs),
                                            Row(
                                              children: <Widget>[
                                                RatingStars(rating: owner.ownerRating),
                                                const SizedBox(width: AppSpacing.sm),
                                                Text(
                                                  owner.responseTime,
                                                  style: context.textTheme.labelSmall?.copyWith(
                                                    color: context.appColors.success,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: AppSpacing.xl),

                          // 8. Yorumlar
                          SectionHeader(
                            title: context.l10n.reviewsTitle,
                            subtitle: context.l10n.reviewsCount(widget.vehicle.reviews.length),
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: displayedReviews.length,
                            separatorBuilder: (BuildContext _, int index) => const SizedBox(height: AppSpacing.md),
                            itemBuilder: (BuildContext ctx, int index) {
                              final Review r = displayedReviews[index];
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute<void>(
                                                  builder: (_) => RenterProfilePage(
                                                    sessionController: widget.sessionController,
                                                    renterId: r.authorId,
                                                    isOwnProfile: false,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: <Widget>[
                                                CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor: context.colorScheme.primaryContainer,
                                                  child: Icon(
                                                    Icons.person_rounded,
                                                    size: 14,
                                                    color: context.colorScheme.primary,
                                                  ),
                                                ),
                                                const SizedBox(width: AppSpacing.sm),
                                                Text(
                                                  r.authorName,
                                                  style: context.textTheme.labelLarge?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          RatingStars(rating: r.rating),
                                        ],
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                      Text(
                                        r.text,
                                        style: context.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          if (widget.vehicle.reviews.length > 3)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: AppSpacing.md),
                                child: TextButton.icon(
                                  icon: Icon(
                                    _showAllReviews
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded,
                                  ),
                                  label: Text(
                                    _showAllReviews
                                        ? context.l10n.showLessReviews
                                        : context.l10n.showMoreReviews,
                                  ),
                                  onPressed: () {
                                    setState(() => _showAllReviews = !_showAllReviews);
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Sabit Alt CTA [Kirala] Butonu
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: PrimaryCtaButton(
                text: context.l10n.rentCtaButton,
                priceSummary: _priceSummary,
                onPressed: _handleRentAction,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecTile extends StatelessWidget {
  const _SpecTile({
    required this.icon,
    required this.label,
    required this.value,
    this.highlightColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: context.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 18, color: context.colorScheme.onSecondaryContainer),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: highlightColor ?? context.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
