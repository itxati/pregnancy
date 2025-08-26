import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/data/models/baby_milestone_data.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';

class JaundiceSymptomsView extends StatelessWidget {
  final List<BabyHealthInfo> data;
  const JaundiceSymptomsView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final symptomsData = data
        .where((item) =>
            item.title.contains('Signs and Symptoms') ||
            item.title.contains('Risk Factors') ||
            item.title.contains('When to Seek Medical Attention'))
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: NeoSafeGradients.roseGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: NeoSafeColors.primaryPink.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.warning_amber,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'symptoms_warning_signs'.tr,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'know_when_to_be_concerned'.tr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Symptoms content
        ...symptomsData.map((item) => _buildInfoCard(context, item)),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, BabyHealthInfo item) {
    final sectionIndex = data.indexOf(item) + 1;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  NeoSafeColors.primaryPink.withOpacity(0.1),
                  NeoSafeColors.lightPink.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: NeoSafeColors.primaryPink,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.medical_information,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'jaundice_${sectionIndex}_title'.tr,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: NeoSafeColors.primaryText,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.description != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: NeoSafeColors.softGray.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: NeoSafeColors.primaryPink.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: NeoSafeColors.primaryPink,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'jaundice_${sectionIndex}_desc'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: NeoSafeColors.primaryText,
                                  fontStyle: FontStyle.italic,
                                  height: 1.4,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Points list
                ...item.points.asMap().entries.map((entry) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: NeoSafeColors.softGray.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: NeoSafeColors.primaryPink,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'jaundice_${sectionIndex}_point_${entry.key + 1}'
                                  .tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: NeoSafeColors.primaryText,
                                    height: 1.5,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
