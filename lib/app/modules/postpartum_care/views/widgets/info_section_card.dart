import 'package:flutter/material.dart';
import '../../../../utils/neo_safe_theme.dart';
import '../../../../data/models/postpartum_models.dart';

class InfoSectionCard extends StatelessWidget {
  final InfoSection section;
  const InfoSectionCard({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NeoSafeColors.softGray.withOpacity(0.4)),
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
                  gradient: NeoSafeGradients.roseGradient,
                ),
                child:
                    const Icon(Icons.favorite, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: NeoSafeColors.primaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...section.items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: item.title,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: NeoSafeColors.primaryText,
                              ),
                            ),
                            if (item.description != null) ...[
                              TextSpan(
                                text: ' → ',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: NeoSafeColors.secondaryText,
                                ),
                              ),
                              TextSpan(
                                text: item.description,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: NeoSafeColors.secondaryText,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
