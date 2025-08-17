import 'package:flutter/material.dart';
import '../../../data/models/postpartum_models.dart';
import 'widgets/family_planning_sections.dart';

class PostpartumFamilyPlanningView extends StatelessWidget {
  final FamilyPlanningContent content;
  const PostpartumFamilyPlanningView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset('assets/logos/article3.webp', fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 12),
        FamilyPlanningSections(content: content),
      ],
    );
  }
}
