import 'package:flutter/material.dart';
// removed unused imports
import '../../../data/models/postpartum_models.dart';
import 'widgets/info_section_card.dart';

class PostpartumOverviewView extends StatelessWidget {
  final PostpartumContent data;
  const PostpartumOverviewView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _heroBanner()),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              ...data.physicalChanges.map((s) => InfoSectionCard(section: s)),
              const SizedBox(height: 8),
              ...data.emotionalMental.map((s) => InfoSectionCard(section: s)),
              const SizedBox(height: 8),
              ...data.commonConcerns.map((s) => InfoSectionCard(section: s)),
            ]),
          ),
        )
      ],
    );
  }

  Widget _heroBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset('assets/logos/article4.jpg', fit: BoxFit.cover),
        ),
      ),
    );
  }
}
