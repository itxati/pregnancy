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
              color: NeoSafeColors.creamWhite,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: NeoSafeColors.softGray.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "weeks_pregnant".trParams(
                      {"week": "${controller.pregnancyWeekNumber.value}"}),
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
                            controller.trimester.value.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: NeoSafeColors.secondaryText,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "due_date"
                                .trParams({"date": controller.dueDate.value}),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: NeoSafeColors.secondaryText,
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
                          color: NeoSafeColors.palePink,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: NeoSafeColors.primaryPink.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          "edit".tr,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: NeoSafeColors.primaryPink,
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
                      color: NeoSafeColors.softGray,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Stack(
                      children: [
                        // Background (unfilled portion)
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: NeoSafeColors.palePink,
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
                                  NeoSafeColors.roseAccent,
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
