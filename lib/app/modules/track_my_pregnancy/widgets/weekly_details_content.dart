import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import '../controllers/weekly_details_controller.dart';

class WeeklyDetailsContent extends StatelessWidget {
  final WeeklyDetailsController controller;

  const WeeklyDetailsContent({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final weekData = controller.currentWeekData;

      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Baby size info card
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: NeoSafeColors.primaryPink.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Icon(Icons.straighten,
                          color: NeoSafeColors.primaryPink, size: 22),
                      const SizedBox(height: 4),
                      Text(
                        weekData.length ?? "Length",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: NeoSafeColors.primaryText,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                      ),
                    ],
                  ),
                  if (weekData.weight.trim().isNotEmpty)
                    Column(
                      children: [
                        Icon(Icons.monitor_weight,
                            color: NeoSafeColors.roseAccent, size: 22),
                        const SizedBox(height: 4),
                        Text(
                          weekData.weight ?? "Weight",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: NeoSafeColors.primaryText,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                        ),
                      ],
                    ),
                  Column(
                    children: [
                      Icon(Icons.circle, color: NeoSafeColors.info, size: 22),
                      const SizedBox(height: 4),
                      Text(
                        weekData.size ?? "Size",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: NeoSafeColors.primaryText,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Baby Development
            _buildInfoSection(
              title: "Baby Development",
              description: "", // We'll handle the content differently
              icon: Icons.child_care,
              color: const Color(0xFFEC407A),
              customContent:
                  _buildBabyDevelopmentContent(weekData.details ?? []),
            ),
            const SizedBox(height: 24),

            _buildDosDontsSupplementsSection(
              dos: weekData.dos ?? [],
              donts: weekData.donts ?? [],
              supplements: weekData.suppliments ?? [],
            ),
            const SizedBox(height: 24),
            // Body Changes
            _buildInfoSection(
              title: "Your Body",
              description: weekData.body ??
                  "Your body is adapting to support your growing baby.",
              icon: Icons.pregnant_woman,
              color: const Color(0xFF9C27B0),
            ),
            const SizedBox(height: 24),

            // Health Tips
            _buildInfoSection(
              title: "Health & Tips",
              description: weekData.healthTips ??
                  "Stay healthy and take care of yourself during this important time.",
              icon: Icons.favorite,
              color: const Color(0xFF4CAF50),
            ),
            const SizedBox(height: 24),

            // Partner Info
            _buildInfoSection(
              title: "Partner's Info",
              description: weekData.partnersInfo ??
                  "Support and understanding are key during this journey.",
              icon: Icons.people,
              color: const Color(0xFF2196F3),
            ),
            const SizedBox(height: 24),

            // Twins Info
            _buildInfoSection(
              title: "Twins Info",
              description: weekData.twinsInfo ??
                  "If you're carrying twins, you may need extra care and attention.",
              icon: Icons.child_care,
              color: const Color(0xFFFF9800),
            ),
            const SizedBox(height: 40),
          ],
        ),
      );
    });
  }

  Widget _buildBabyDevelopmentContent(List<String> details) {
    if (details.isEmpty) {
      return Text(
        "Your baby is developing rapidly this week.",
        style: Get.textTheme.bodyMedium?.copyWith(
          color: NeoSafeColors.secondaryText,
          height: 1.5,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: details.map((detail) {
        // Split by colon to separate the header from the content
        final parts = detail.split(':');

        if (parts.length >= 2) {
          final header = parts[0].trim();
          final content = parts.sublist(1).join(':').trim();

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$header: ',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: NeoSafeColors.primaryText,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  TextSpan(
                    text: content,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: NeoSafeColors.secondaryText,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          // If no colon found, display as regular text
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              detail,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: NeoSafeColors.secondaryText,
                height: 1.5,
              ),
            ),
          );
        }
      }).toList(),
    );
  }

// Also update your _buildInfoSection method to accept optional customContent:

  Widget _buildInfoSection({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    Widget? customContent,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: NeoSafeColors.primaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Use customContent if provided, otherwise use description
          customContent ??
              Text(
                description,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: NeoSafeColors.secondaryText,
                  height: 1.5,
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildDosDontsSupplementsSection({
    required List<String> dos,
    required List<String> donts,
    required List<String> supplements,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoSectionWithBullets(
          title: 'Do’s',
          icon: Icons.check_circle_outline,
          color: Colors.green,
          items: dos,
        ),
        const SizedBox(height: 16),
        _buildInfoSectionWithBullets(
          title: 'Don’ts',
          icon: Icons.cancel_outlined,
          color: Colors.redAccent,
          items: donts,
        ),
        const SizedBox(height: 16),
        _buildInfoSectionWithBullets(
          title: 'Supplements',
          icon: Icons.medical_services_outlined,
          color: Colors.blueAccent,
          items: supplements,
        ),
      ],
    );
  }

  Widget _buildInfoSectionWithBullets({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: NeoSafeColors.primaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("•  "),
                    Expanded(
                      child: Text(
                        item,
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: NeoSafeColors.secondaryText,
                          height: 1.5,
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
