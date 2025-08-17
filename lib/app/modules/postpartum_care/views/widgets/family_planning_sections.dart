import 'package:flutter/material.dart';
import '../../../../utils/neo_safe_theme.dart';
import '../../../../data/models/postpartum_models.dart';

class FamilyPlanningSections extends StatelessWidget {
  final FamilyPlanningContent content;
  const FamilyPlanningSections({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(theme, 'Family Planning (Postpartum)'),
        const SizedBox(height: 8),
        _subsectionCardWithImage(theme, 'Why postpartum FP is important',
            content.whyImportant, 'assets/logos/article2.jpeg'),
        const SizedBox(height: 8),
        _subsectionCardWithImage(theme, 'When to start contraception?',
            content.whenToStart, 'assets/logos/article3.webp'),
        const SizedBox(height: 8),
        ...content.categories.map((cat) => _categoryWithImage(theme, cat)),
        const SizedBox(height: 8),
        _subsectionCardWithImage(theme, 'Things to consider',
            content.considerations, 'assets/logos/article4.jpg'),
      ],
    );
  }

  Widget _title(ThemeData theme, String text) => Text(
        text,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: NeoSafeColors.primaryText,
        ),
      );

  Widget _subsectionCard(ThemeData theme, String title, List<String> bullets) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NeoSafeColors.softGray.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: 8),
          _bullets(theme, bullets),
        ],
      ),
    );
  }

  Widget _subsectionCardWithImage(
      ThemeData theme, String title, List<String> bullets, String imagePath) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NeoSafeColors.softGray.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: 8),
          _bullets(theme, bullets),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(imagePath,
                height: 150, width: double.infinity, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }

  Widget _category(ThemeData theme, Category cat) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: NeoSafeColors.warmWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NeoSafeColors.softGray.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: NeoSafeGradients.maternalGradient,
                ),
                child: const Icon(Icons.family_restroom,
                    color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(cat.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...cat.methods.map((m) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: NeoSafeColors.softGray.withOpacity(0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(height: 6),
                      _bullets(theme, m.points),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _categoryWithImage(ThemeData theme, Category cat) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: NeoSafeColors.warmWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NeoSafeColors.softGray.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: NeoSafeGradients.maternalGradient,
                ),
                child: const Icon(Icons.family_restroom,
                    color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(cat.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...cat.methods.map((m) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: NeoSafeColors.softGray.withOpacity(0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(height: 6),
                      _bullets(theme, m.points),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(_getImageForCategory(cat.title),
                height: 150, width: double.infinity, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }

  String _getImageForCategory(String categoryTitle) {
    switch (categoryTitle.toLowerCase()) {
      case 'hormonal methods':
        return 'assets/logos/article5.webp';
      case 'barrier methods':
        return 'assets/logos/article6.jpeg';
      case 'long-acting reversible contraception':
        return 'assets/logos/babycare.jpg';
      case 'permanent methods':
        return 'assets/logos/babymilestone.jpg';
      default:
        return 'assets/logos/article3.webp';
    }
  }

  Widget _bullets(ThemeData theme, List<String> texts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...texts.map((t) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: NeoSafeGradients.primaryGradient,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      t,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: NeoSafeColors.primaryText,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
