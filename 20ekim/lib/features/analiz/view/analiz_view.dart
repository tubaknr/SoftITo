import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/status_chip.dart';
import '../../fikir_durumu/data/mock_fikir_durumu_data.dart';
import '../../fikir_durumu/models/fikir_model.dart';
import '../../shell/widget/star_field_background.dart';
import '../controller/analiz_controller.dart';
import '../models/analiz_model.dart';
import '../widget/stepper_indicator.dart';

class AnalizView extends StatefulWidget {
  const AnalizView({
    super.key,
    this.onAnalizGonderildi,
  });

  final ValueChanged<GirisimFikri>? onAnalizGonderildi;

  @override
  State<AnalizView> createState() => _AnalizViewState();
}

class _AnalizViewState extends State<AnalizView> {
  late final AnalizController _controller;

  final _stepTitles = const [
    'Fikir Özeti',
    'Ekip Bilgisi',
    'Mevcut Durum (Traction)',
    'İnovasyon & Ar-Ge',
    'Plan & Gantt Tablosu',
    'Pazar & Rekabet',
    'Marka Stratejisi',
    'Özet ve Gönderim',
  ];

  // Controllers for text fields
  final _fikirAdiCtrl = TextEditingController(text: 'BioTarım Sensör');
  final _sektorCtrl = TextEditingController(text: 'AgriTech');
  final _problemCtrl = TextEditingController(text: 'Aşırı su ve gübre israfı, toprak verimsizliği');
  final _cozumCtrl = TextEditingController(text: 'IoT sensörler ve yapay zeka ile dinamik sulama');
  final _hedefKitleCtrl = TextEditingController(text: 'Modern sera işletmeleri ve endüstriyel çiftçiler');

  final _musteriDetayCtrl = TextEditingController(text: '3 pilot sera ile sözleşme imzalandı');
  final _ciroCtrl = TextEditingController(text: '85.000 ₺');
  final _karCtrl = TextEditingController(text: 'Başa baş noktasında (Break-even)');

  final _argeCtrl = TextEditingController(text: 'Düşük güçlü LoRaWAN sensör tasarımı ve toprak nem tahmin modeli');
  final _farkCtrl = TextEditingController(text: 'Yabancı muadillere göre 3 kat ucuz donanım ve yerli bulut');
  final _uygulanabilirlikCtrl = TextEditingController(text: 'TÜBİTAK MAM ile testler başarıyla tamamlandı');

  final _kilometreCtrl = TextEditingController(text: 'Q1: Seri üretim, Q2: 20 sera kurulumu');
  final _butceCtrl = TextEditingController(text: '500.000 ₺');

  final _ticarilesmeCtrl = TextEditingController(text: 'B2B SaaS abonelik + sensör donanım satışı');
  final _tamSamSomCtrl = TextEditingController(text: 'TAM: 4.2 Milyar ₺, SAM: 600 Milyon ₺, SOM: 45 Milyon ₺');
  final _musteriAnaliziCtrl = TextEditingController(text: 'Yıllık 10 dönüm üzeri kapalı sera işletmeleri');
  final _rakiplerCtrl = TextEditingController(text: 'İthal Hollanda menşeili sensör firmaları');

  final _markaAdiCtrl = TextEditingController(text: 'BioTarım Yörünge');
  final _konumlandirmaCtrl = TextEditingController(text: 'Akıllı tarımda güvenilir ve yerli teknoloji ortağı');
  final _kanallarCtrl = TextEditingController(text: 'Tarım fuarları, ziraat odaları, dijital B2B pazarlama');

  @override
  void initState() {
    super.initState();
    _controller = AnalizController();
    _syncFormFromControllers();
  }

  void _syncFormFromControllers() {
    _controller.updateForm((current) => current.copyWith(
          fikirAdi: _fikirAdiCtrl.text,
          sektor: _sektorCtrl.text,
          problem: _problemCtrl.text,
          cozum: _cozumCtrl.text,
          hedefKitle: _hedefKitleCtrl.text,
          musteriDetayi: _musteriDetayCtrl.text,
          aylikCiro: _ciroCtrl.text,
          karDurumu: _karCtrl.text,
          argeYenilikNiteligi: _argeCtrl.text,
          mevcutCozumlerdenFarki: _farkCtrl.text,
          uygulanabilirlikNotu: _uygulanabilirlikCtrl.text,
          kilometreTaslari: _kilometreCtrl.text,
          toplamButce: _butceCtrl.text,
          ticarilesmePlani: _ticarilesmeCtrl.text,
          tamSamSomAnalizi: _tamSamSomCtrl.text,
          musteriAnalizi: _musteriAnaliziCtrl.text,
          rakipler: _rakiplerCtrl.text,
          markaAdi: _markaAdiCtrl.text,
          konumlandirma: _konumlandirmaCtrl.text,
          pazarlamaKanallari: _kanallarCtrl.text,
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _fikirAdiCtrl.dispose();
    _sektorCtrl.dispose();
    _problemCtrl.dispose();
    _cozumCtrl.dispose();
    _hedefKitleCtrl.dispose();
    _musteriDetayCtrl.dispose();
    _ciroCtrl.dispose();
    _karCtrl.dispose();
    _argeCtrl.dispose();
    _farkCtrl.dispose();
    _uygulanabilirlikCtrl.dispose();
    _kilometreCtrl.dispose();
    _butceCtrl.dispose();
    _ticarilesmeCtrl.dispose();
    _tamSamSomCtrl.dispose();
    _musteriAnaliziCtrl.dispose();
    _rakiplerCtrl.dispose();
    _markaAdiCtrl.dispose();
    _konumlandirmaCtrl.dispose();
    _kanallarCtrl.dispose();
    super.dispose();
  }

  void _handleGonder() {
    _syncFormFromControllers();
    final ok = _controller.submitForm();
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_controller.hataMesaji.value ?? 'Lütfen eksik alanları doldurunuz.'),
          backgroundColor: context.spaceColors.danger,
        ),
      );
      return;
    }

    final yeniFikir = GirisimFikri(
      id: 'kullanici_yeni_${DateTime.now().millisecondsSinceEpoch}',
      ad: _controller.formState.value.fikirAdi,
      sektor: _controller.formState.value.sektor,
      ozet: _controller.formState.value.cozum,
      asama: BasvuruAsamasi.onaylandi,
      ekipSayisi: _controller.formState.value.ekipUyeleri.length + 1,
      ilerlemeYuzdesi: 0.35,
      hukukiAdimIndex: 2,
      hukukiAdimlar: MockFikirDurumuData.createStandardHukukiAdimlar(2),
      avukat: MockFikirDurumuData.ornekAvukat1,
      gelirDestek: const GelirDestekDurumu(
        aylikTaahhutTutari: 45000,
        odenenAySayisi: 1,
        toplamAySayisi: 6,
        kalanGun: 28,
        aktif: true,
        sonOdemeTarihi: '20.10.2026',
      ),
    );

    widget.onAnalizGonderildi?.call(yeniFikir);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;

    return ValueListenableBuilder<bool>(
      valueListenable: _controller.isSubmitted,
      builder: (context, submitted, _) {
        if (submitted) {
          return _CelebrationScreen(
            fikirAdi: _controller.formState.value.fikirAdi,
            onDevamEt: () => Navigator.of(context).pop(),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('İş Planı Analiz Formu'),
          ),
          body: ValueListenableBuilder<int>(
            valueListenable: _controller.currentStep,
            builder: (context, step, _) {
              return Column(
                children: [
                  // Stepper Progress Header
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: StepperIndicator(
                      currentStep: step,
                      totalSteps: 8,
                      stepTitles: _stepTitles,
                      onStepTapped: (s) {
                        _syncFormFromControllers();
                        _controller.goToStep(s);
                      },
                    ),
                  ),

                  // Form content scroll view
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      children: [
                        _buildStepContent(step),
                        const SizedBox(height: AppSpacing.giant),
                      ],
                    ),
                  ),

                  // Bottom Navigation controls
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      border: Border(top: BorderSide(color: colors.outline, width: 1)),
                    ),
                    child: Row(
                      children: [
                        if (step > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                _syncFormFromControllers();
                                _controller.previousStep();
                              },
                              child: const Text('Geri'),
                            ),
                          )
                        else
                          const Spacer(),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          flex: 2,
                          child: step == 7
                              ? PrimaryDawnButton(
                                  label: 'Başvuruyu Gönder',
                                  icon: Icons.rocket_launch_rounded,
                                  onPressed: _handleGonder,
                                )
                              : PrimaryDawnButton(
                                  label: 'Sonraki Bölüm',
                                  icon: Icons.arrow_forward_rounded,
                                  onPressed: () {
                                    _syncFormFromControllers();
                                    _controller.nextStep();
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return _StepFikirOzeti(
          adCtrl: _fikirAdiCtrl,
          sektorCtrl: _sektorCtrl,
          problemCtrl: _problemCtrl,
          cozumCtrl: _cozumCtrl,
          hedefKitleCtrl: _hedefKitleCtrl,
        );
      case 1:
        return _StepEkip(
          ekip: _controller.formState.value.ekipUyeleri,
        );
      case 2:
        return _StepTraction(
          detayCtrl: _musteriDetayCtrl,
          ciroCtrl: _ciroCtrl,
          karCtrl: _karCtrl,
          controller: _controller,
        );
      case 3:
        return _StepInovasyon(
          argeCtrl: _argeCtrl,
          farkCtrl: _farkCtrl,
          uygulanabilirlikCtrl: _uygulanabilirlikCtrl,
          controller: _controller,
        );
      case 4:
        return _StepPlanTablolari(
          gorevler: _controller.formState.value.gorevler,
          kilometreCtrl: _kilometreCtrl,
          butceCtrl: _butceCtrl,
        );
      case 5:
        return _StepPazar(
          ticarilesmeCtrl: _ticarilesmeCtrl,
          tamSamSomCtrl: _tamSamSomCtrl,
          musteriAnaliziCtrl: _musteriAnaliziCtrl,
          rakiplerCtrl: _rakiplerCtrl,
        );
      case 6:
        return _StepMarka(
          markaCtrl: _markaAdiCtrl,
          konumlandirmaCtrl: _konumlandirmaCtrl,
          kanallarCtrl: _kanallarCtrl,
        );
      case 7:
        return _StepOzet(
          form: _controller.formState.value,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ----------------- Step 1: Fikir Özeti -----------------
class _StepFikirOzeti extends StatelessWidget {
  const _StepFikirOzeti({
    required this.adCtrl,
    required this.sektorCtrl,
    required this.problemCtrl,
    required this.cozumCtrl,
    required this.hedefKitleCtrl,
  });

  final TextEditingController adCtrl;
  final TextEditingController sektorCtrl;
  final TextEditingController problemCtrl;
  final TextEditingController cozumCtrl;
  final TextEditingController hedefKitleCtrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: '1. Fikir Özeti',
          subtitle: 'Girişiminizin temel kimliğini ve değer önerisini tanımlayın',
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: adCtrl,
          decoration: const InputDecoration(labelText: 'Girişim / Fikir Adı *'),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: sektorCtrl,
          decoration: const InputDecoration(labelText: 'Faaliyet Gösterilen Sektör *'),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: problemCtrl,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Çözülen Problem & İhtiyaç *'),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: cozumCtrl,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Geliştirilen Çözüm & Ürün *'),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: hedefKitleCtrl,
          decoration: const InputDecoration(labelText: 'Hedef Müşteri Kitlesi *'),
        ),
      ],
    );
  }
}

// ----------------- Step 2: Ekip -----------------
class _StepEkip extends StatelessWidget {
  const _StepEkip({required this.ekip});

  final List<EkipUyesi> ekip;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: '2. Ekip Yapısı',
          subtitle: 'Kurucu ortaklar ve kilit ekip üyelerinin yetkinlikleri',
        ),
        const SizedBox(height: AppSpacing.md),
        ...ekip.map((uye) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: AppRadius.md,
              border: Border.all(color: colors.outline, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      uye.adSoyad,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    StatusChip(
                      type: StatusType.onaylandi,
                      customLabel: uye.sorumluluk,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text('Eğitim: ${uye.egitim}', style: textTheme.bodySmall),
                Text('Uzmanlık: ${uye.uzmanlik}', style: textTheme.bodySmall),
                Text('İletişim: ${uye.iletisim}', style: textTheme.bodySmall),
              ],
            ),
          );
        }),
      ],
    );
  }
}

// ----------------- Step 3: Traction -----------------
class _StepTraction extends StatelessWidget {
  const _StepTraction({
    required this.detayCtrl,
    required this.ciroCtrl,
    required this.karCtrl,
    required this.controller,
  });

  final TextEditingController detayCtrl;
  final TextEditingController ciroCtrl;
  final TextEditingController karCtrl;
  final AnalizController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: '3. Mevcut Durum & Traction',
          subtitle: 'Pazar doğrulaması, müşteri ve finansal göstergeler',
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: detayCtrl,
          maxLines: 2,
          decoration: const InputDecoration(labelText: 'Müşteri Kazanımı (Kaç ve Kimler) *'),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: ciroCtrl,
          decoration: const InputDecoration(labelText: 'Aylık Ciro / Gelir *'),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: karCtrl,
          decoration: const InputDecoration(labelText: 'Kârlılık Durumu (Nakit Yakma / Kâr) *'),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Hedefe Yakınlık: %${controller.formState.value.hedefeYakinlikYuzdesi}',
          style: textTheme.titleMedium?.copyWith(color: colors.textPrimary),
        ),
        Slider(
          value: controller.formState.value.hedefeYakinlikYuzdesi.toDouble(),
          min: 0,
          max: 100,
          activeColor: colors.dawn,
          onChanged: (val) {
            controller.updateForm((c) => c.copyWith(hedefeYakinlikYuzdesi: val.toInt()));
          },
        ),
      ],
    );
  }
}

// ----------------- Step 4: İnovasyon -----------------
class _StepInovasyon extends StatelessWidget {
  const _StepInovasyon({
    required this.argeCtrl,
    required this.farkCtrl,
    required this.uygulanabilirlikCtrl,
    required this.controller,
  });

  final TextEditingController argeCtrl;
  final TextEditingController farkCtrl;
  final TextEditingController uygulanabilirlikCtrl;
  final AnalizController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: '4. İnovasyon & Ar-Ge Niteliği',
          subtitle: 'Teknolojik yenilik, farklılaşma ve uygulanabilirlik',
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: argeCtrl,
          maxLines: 2,
          decoration: const InputDecoration(labelText: 'Ar-Ge ve Teknolojik Yenilik Niteliği *'),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: farkCtrl,
          maxLines: 2,
          decoration: const InputDecoration(labelText: 'Mevcut Çözümlerden Temel Farkı *'),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: uygulanabilirlikCtrl,
          maxLines: 2,
          decoration: const InputDecoration(labelText: 'Uygulanabilirlik & Teknik Validasyon *'),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Teknik Yeterlilik Oranı: %${controller.formState.value.yeterlilikOrani}',
          style: textTheme.titleMedium?.copyWith(color: colors.textPrimary),
        ),
        Slider(
          value: controller.formState.value.yeterlilikOrani.toDouble(),
          min: 0,
          max: 100,
          activeColor: colors.orbit,
          onChanged: (val) {
            controller.updateForm((c) => c.copyWith(yeterlilikOrani: val.toInt()));
          },
        ),
      ],
    );
  }
}

// ----------------- Step 5: Plan Tabloları -----------------
class _StepPlanTablolari extends StatelessWidget {
  const _StepPlanTablolari({
    required this.gorevler,
    required this.kilometreCtrl,
    required this.butceCtrl,
  });

  final List<GanttGorevi> gorevler;
  final TextEditingController kilometreCtrl;
  final TextEditingController butceCtrl;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: '5. Plan Tabloları & Gantt',
          subtitle: 'İş planı zaman çizelgesi, kilometre taşları ve bütçe tutarlılığı',
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Gantt Şeması Görevleri',
          style: textTheme.labelLarge?.copyWith(color: colors.dawn),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...gorevler.map((g) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: AppRadius.md,
              border: Border.all(color: colors.outline, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        g.gorevAdi,
                        style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Dönem: Ay ${g.baslangicAy} – Ay ${g.bitisAy}',
                        style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${g.butce.toInt()} ₺',
                  style: textTheme.labelMedium?.copyWith(
                    color: colors.dawn,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: kilometreCtrl,
          decoration: const InputDecoration(labelText: 'Kritik Kilometre Taşları (Milestones) *'),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: butceCtrl,
          decoration: const InputDecoration(labelText: 'Toplam Proje Bütçesi (₺) *'),
        ),
      ],
    );
  }
}

// ----------------- Step 6: Pazar -----------------
class _StepPazar extends StatelessWidget {
  const _StepPazar({
    required this.ticarilesmeCtrl,
    required this.tamSamSomCtrl,
    required this.musteriAnaliziCtrl,
    required this.rakiplerCtrl,
  });

  final TextEditingController ticarilesmeCtrl;
  final TextEditingController tamSamSomCtrl;
  final TextEditingController musteriAnaliziCtrl;
  final TextEditingController rakiplerCtrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: '6. Pazar & Rekabet Analizi',
          subtitle: 'Pazar büyüklüğü, hedefleme ve rakipler',
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: ticarilesmeCtrl,
          maxLines: 2,
          decoration: const InputDecoration(labelText: 'Ticarileşme ve Gelir Modeli Planı *'),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: tamSamSomCtrl,
          decoration: const InputDecoration(labelText: 'Pazar Analizi (TAM / SAM / SOM) *'),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: musteriAnaliziCtrl,
          decoration: const InputDecoration(labelText: 'Müşteri Persona Analizi *'),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: rakiplerCtrl,
          decoration: const InputDecoration(labelText: 'Rakipler ve Rekabetçi Üstünlükler *'),
        ),
      ],
    );
  }
}

// ----------------- Step 7: Marka -----------------
class _StepMarka extends StatelessWidget {
  const _StepMarka({
    required this.markaCtrl,
    required this.konumlandirmaCtrl,
    required this.kanallarCtrl,
  });

  final TextEditingController markaCtrl;
  final TextEditingController konumlandirmaCtrl;
  final TextEditingController kanallarCtrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: '7. Marka & Konumlandırma',
          subtitle: 'Marka kurulumu, tescil kimliği ve dağıtım kanalları',
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: markaCtrl,
          decoration: const InputDecoration(labelText: 'Marka / Ticari İsim *'),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: konumlandirmaCtrl,
          maxLines: 2,
          decoration: const InputDecoration(labelText: 'Marka Konumlandırması & Slogan *'),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: kanallarCtrl,
          decoration: const InputDecoration(labelText: 'Pazarlama ve Dağıtım Kanalları *'),
        ),
      ],
    );
  }
}

// ----------------- Step 8: Özet ve Gönderim -----------------
class _StepOzet extends StatelessWidget {
  const _StepOzet({required this.form});

  final AnalizFormModel form;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    final isAllFilled = form.isAllValid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: '8. Özet ve Gönderim',
          subtitle: 'Tüm bilgileri gözden geçirin ve uzman heyetine iletin',
        ),
        const SizedBox(height: AppSpacing.md),
        _OzetItem(title: 'Fikir Adı', value: form.fikirAdi, isValid: form.isFikirOzetiValid),
        _OzetItem(title: 'Sektör', value: form.sektor, isValid: form.isFikirOzetiValid),
        _OzetItem(title: 'Ekip Sayısı', value: '${form.ekipUyeleri.length} kişi', isValid: form.isEkipValid),
        _OzetItem(title: 'Traction & Müşteri', value: form.musteriDetayi, isValid: form.isTractionValid),
        _OzetItem(title: 'İnovasyon & Ar-Ge', value: form.argeYenilikNiteligi, isValid: form.isInovasyonValid),
        _OzetItem(title: 'Bütçe & Plan', value: form.toplamButce, isValid: form.isPlanValid),
        _OzetItem(title: 'Pazar (TAM/SAM/SOM)', value: form.tamSamSomAnalizi, isValid: form.isPazarValid),
        _OzetItem(title: 'Marka', value: form.markaAdi, isValid: form.isMarkaValid),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isAllFilled
                ? colors.success.withValues(alpha: 0.12)
                : colors.warning.withValues(alpha: 0.12),
            borderRadius: AppRadius.md,
            border: Border.all(
              color: isAllFilled ? colors.success : colors.warning,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isAllFilled ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                color: isAllFilled ? colors.success : colors.warning,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  isAllFilled
                      ? 'Form eksiksiz dolduruldu. Gönderime hazır!'
                      : 'Formda boş alanlar var. Hiç boş yer kalmadan gönderilemez.',
                  style: textTheme.bodySmall?.copyWith(
                    color: isAllFilled ? colors.success : colors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OzetItem extends StatelessWidget {
  const _OzetItem({
    required this.title,
    required this.value,
    required this.isValid,
  });

  final String title;
  final String value;
  final bool isValid;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isValid ? Icons.check_rounded : Icons.close_rounded,
            size: 16,
            color: isValid ? colors.success : colors.danger,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$title: ',
            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '(Boş bırakılamaz)',
              style: textTheme.bodySmall?.copyWith(
                color: value.isNotEmpty ? colors.textPrimary : colors.danger,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------- Celebration Screen -----------------
class _CelebrationScreen extends StatelessWidget {
  const _CelebrationScreen({
    required this.fikirAdi,
    required this.onDevamEt,
  });

  final String fikirAdi;
  final VoidCallback onDevamEt;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Scaffold(
      body: StarFieldBackground(
        showHorizonGlow: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: colors.dawnGradient,
                    boxShadow: [
                      BoxShadow(
                        color: colors.dawn.withValues(alpha: 0.4),
                        blurRadius: 32,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(Icons.rocket_launch_rounded, size: 40, color: colors.onDawn),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Tebrikler!',
                  style: textTheme.displaySmall?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'İş planınız başarıyla uzman kurula gönderildi ve onaylandı.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(color: colors.textMuted),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: AppRadius.lg,
                    border: Border.all(color: colors.dawn, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Text(
                        fikirAdi,
                        style: textTheme.titleLarge?.copyWith(
                          color: colors.dawn,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Şafak Yörüngesine kabul edildiniz! Ücretsiz avukatınız atandı ve aylık gelir destek taahhüdünüz başlatıldı.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(color: colors.textPrimary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.giant),
                PrimaryDawnButton(
                  label: 'Yörüngeye Başla',
                  icon: Icons.check_circle_rounded,
                  onPressed: onDevamEt,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
