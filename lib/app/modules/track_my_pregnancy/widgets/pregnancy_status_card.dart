import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import '../controllers/track_my_pregnancy_controller.dart';

class PregnancyStatusCard extends StatelessWidget {
  final TrackMyPregnancyController controller;

  const PregnancyStatusCard({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () => controller.showWhereYouAreBottomSheet(context),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFAFA), // NeoSafeColors.creamWhite
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE8E2E2)
                      .withOpacity(0.2), // NeoSafeColors.softGray
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${controller.pregnancyWeekNumber.value} weeks pregnant",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: NeoSafeColors.primaryPink,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.trimester.value,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: const Color(
                                      0xFF6B5555), // NeoSafeColors.secondaryText
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Due ${controller.dueDate.value}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: const Color(
                                      0xFF6B5555), // NeoSafeColors.secondaryText
                                ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.showDatePickerDialog(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFFAE8E8), // NeoSafeColors.palePink
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFE8A5A5)
                                .withOpacity(0.3), // NeoSafeColors.primaryPink
                          ),
                        ),
                        child: Text(
                          "Edit",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(
                                        0xFFE8A5A5), // NeoSafeColors.primaryPink
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    height: 8, // Thicker bar for better visibility
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E2E2), // NeoSafeColors.softGray
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Stack(
                      children: [
                        // Background (unfilled portion)
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFFFAE8E8), // NeoSafeColors.palePink
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        // Filled portion
                        FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: controller.pregnancyWeekNumber.value /
                              40, // Dynamic progress based on current weeks
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  NeoSafeColors.primaryPink,
                                  NeoSafeColors.roseAccent
                                ],
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
