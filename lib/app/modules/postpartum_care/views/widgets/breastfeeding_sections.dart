import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/neo_safe_theme.dart';
import '../../../../data/models/postpartum_models.dart';

class BreastfeedingSections extends StatelessWidget {
  final BreastfeedingContent content;
  const BreastfeedingSections({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(theme, 'breastfeeding_guidance'.tr),
        const SizedBox(height: 8),
        ...content.sections.map((section) => _sectionCard(theme, section)),
        const SizedBox(height: 12),
        _title(theme, 'common_breastfeeding_challenges'.tr),
        const SizedBox(height: 8),
        ...content.challenges.map((c) => _challengeCard(theme, c)),
        const SizedBox(height: 12),
        _bulletListCard(theme, Icons.medical_services,
            'when_to_seek_medical_help'.tr, content.whenToSeekHelp),
        const SizedBox(height: 12),
        _bulletListCard(theme, Icons.block, 'contraindications_breastfeed'.tr,
            content.contraindications),
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

  Widget _sectionCard(ThemeData theme, BreastfeedingSection section) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NeoSafeColors.softGray.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: NeoSafeGradients.primaryGradient,
              ),
              child: const Icon(Icons.local_florist,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                section.title.tr,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          _bullets(theme, section.bullets),
        ],
      ),
    );
  }

  Widget _header(ThemeData theme, IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: NeoSafeGradients.primaryGradient,
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: NeoSafeColors.primaryText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _bulletListCard(
      ThemeData theme, IconData icon, String title, List<String> bullets) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NeoSafeColors.softGray.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: NeoSafeGradients.primaryGradient,
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: NeoSafeColors.primaryText,
                ),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          _bullets(theme, bullets),
        ],
      ),
    );
  }

  Widget _challengeCard(ThemeData theme, Challenge challenge) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NeoSafeColors.softGray.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: NeoSafeGradients.roseGradient,
              ),
              child: const Icon(Icons.healing, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                challenge.title.tr,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          _bullets(theme, challenge.management),
        ],
      ),
    );
  }

  Widget _bullets(ThemeData theme, List<String> texts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...texts.map((t) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: NeoSafeGradients.primaryGradient,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      t.tr,
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
