import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/section_header.dart';
import '../../fikir_durumu/view/fikir_durumu.dart';
import '../controller/mentor_controller.dart';
import '../models/mentor_model.dart';
import '../widget/mentor_card.dart';
import '../widget/mentor_filter_bar.dart';

class MentorView extends StatefulWidget {
  final MentorController? controller;

  const MentorView({super.key, this.controller});

  @override
  State<MentorView> createState() => _MentorViewState();
}

class _MentorViewState extends State<MentorView> {
  late final MentorController _controller;
  late final bool _internalController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _internalController = false;
    } else {
      _controller = MentorController();
      _internalController = true;
    }
  }

  @override
  void dispose() {
    if (_internalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildFilterSection()),
          SliverToBoxAdapter(child: _buildRecommendedSection()),
          const SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Tüm Mentor Havuzu',
              subtitle: 'Uzmanlık ve sektöre göre listelenen danışmanlar',
            ),
          ),
          _buildMentorList(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final colors = context.spaceColors;
    return AppBar(
      title: const Text('Mentor & Danışman'),
      actions: [
        IconButton(
          tooltip: AppStrings.fikirDurumum,
          icon: Icon(Icons.rocket_rounded, color: colors.rocketFlame),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const FikirDurumuView()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return ValueListenableBuilder<String?>(
      valueListenable: _controller.seciliSektor,
      builder: (context, secili, _) {
        return MentorFilterBar(
          sektorler: _controller.sektorler,
          seciliSektor: secili,
          onSektorSelected: _controller.sektorSec,
          onSearchChanged: _controller.aramaYap,
        );
      },
    );
  }

  Widget _buildRecommendedSection() {
    final onerilenler = _controller.onerilenMentorlar;
    if (onerilenler.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Öne Çıkan Mentorlar',
          subtitle: 'En yüksek değerlendirmeye sahip uzmanlar',
        ),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: onerilenler.length,
            itemBuilder: (context, index) {
              final m = onerilenler[index];
              return SizedBox(
                width: 310,
                child: MentorCard(
                  mentor: m,
                  onEslesmeIste: () => _controller.eslesmeIste(m.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMentorList() {
    return ValueListenableBuilder<List<MentorModel>>(
      valueListenable: _controller.gorunenMentorlar,
      builder: (context, mentorlar, _) {
        if (mentorlar.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text('Arama kriterinize uygun mentor bulunamadı.'),
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final mentor = mentorlar[index];
            return MentorCard(
              mentor: mentor,
              onEslesmeIste: () => _controller.eslesmeIste(mentor.id),
            );
          }, childCount: mentorlar.length),
        );
      },
    );
  }
}
