// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/track_my_pregnancy_controller.dart';
// import '../../timeline/controllers/timeline_controller.dart';
// import '../../timeline/views/timeline_view.dart';

// class TimelineCard extends StatelessWidget {
//   final TrackMyPregnancyController controller;

//   const TimelineCard({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     print('TimelineCard is being built');
//     return GestureDetector(
//       onTap: () {
//         // print('Navigating to timeline page...');
//         // Get.put(TimelineController());
//         // Get.to(() => const TimelineView());
//       },
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: const Color(0xFFFFFAFA), // NeoSafeColors.creamWhite
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: const Color(0xFFE8A5A5)
//                 .withOpacity(0.1), // NeoSafeColors.primaryPink
//             width: 1,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFFE8A5A5)
//                   .withOpacity(0.1), // NeoSafeColors.primaryPink
//               blurRadius: 15,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Your timeline",
//                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                           fontWeight: FontWeight.w700,
//                           color: const Color(
//                               0xFF3D2929), // NeoSafeColors.primaryText
//                         ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     controller.getTimelineSubtitle(),
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           color: const Color(
//                               0xFF6B5555), // NeoSafeColors.secondaryText
//                         ),
//                   ),
//                   const SizedBox(height: 16),
//                   // Timeline visualization with maternal colors
//                   Row(
//                     children: [
//                       Container(
//                         width: 80,
//                         height: 6,
//                         decoration: BoxDecoration(
//                           gradient: const LinearGradient(
//                             colors: [
//                               Color(0xFFE8A5A5), // NeoSafeColors.primaryPink
//                               Color(0xFFF2C2C2), // NeoSafeColors.lightPink
//                             ],
//                           ),
//                           borderRadius: BorderRadius.circular(3),
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       Container(
//                         width: 60,
//                         height: 6,
//                         decoration: BoxDecoration(
//                           gradient: const LinearGradient(
//                             colors: [
//                               Color(0xFFD4A5A5), // NeoSafeColors.roseAccent
//                               Color(0xFFFFB3BA), // NeoSafeColors.coralPink
//                             ],
//                           ),
//                           borderRadius: BorderRadius.circular(3),
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       Container(
//                         width: 40,
//                         height: 6,
//                         decoration: BoxDecoration(
//                           gradient: const LinearGradient(
//                             colors: [
//                               Color(0xFFE8C5E8), // NeoSafeColors.lavenderPink
//                               Color(0xFFF0E5F0), // NeoSafeColors.softLavender
//                             ],
//                           ),
//                           borderRadius: BorderRadius.circular(3),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // Container(
//             //   padding: const EdgeInsets.all(8),
//             //   decoration: BoxDecoration(
//             //     color: const Color(0xFFFAE8E8), // NeoSafeColors.palePink
//             //     shape: BoxShape.circle,
//             //   ),
//             //   child: const Icon(
//             //     Icons.arrow_forward_ios,
//             //     color: Color(0xFFE8A5A5), // NeoSafeColors.primaryPink
//             //     size: 16,
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/services/theme_service.dart';
import '../controllers/track_my_pregnancy_controller.dart';
import '../../timeline/controllers/timeline_controller.dart';
import '../../timeline/views/timeline_view.dart';

class TimelineCard extends StatelessWidget {
  final TrackMyPregnancyController controller;

  const TimelineCard({
    Key? key,
    required this.controller,
  }) : super(key: key);

  // Calculate trimester progress percentages
  Map<String, double> _calculateProgress() {
    final int currentWeek = controller.pregnancyWeekNumber.value;

    // Pregnancy is typically 40 weeks
    // First trimester: weeks 1-12 (12 weeks)
    // Second trimester: weeks 13-27 (15 weeks)
    // Third trimester: weeks 28-40 (13 weeks)

    double firstTrimesterProgress = 0.0;
    double secondTrimesterProgress = 0.0;
    double thirdTrimesterProgress = 0.0;

    if (currentWeek <= 12) {
      // In first trimester
      firstTrimesterProgress = (currentWeek / 12).clamp(0.0, 1.0);
    } else if (currentWeek <= 27) {
      // In second trimester
      firstTrimesterProgress = 1.0;
      secondTrimesterProgress = ((currentWeek - 12) / 15).clamp(0.0, 1.0);
    } else {
      // In third trimester - weeks 28-40 (13 weeks total)
      firstTrimesterProgress = 1.0;
      secondTrimesterProgress = 1.0;
      thirdTrimesterProgress = ((currentWeek - 27) / 13).clamp(0.0, 1.0);
    }

    return {
      'first': firstTrimesterProgress,
      'second': secondTrimesterProgress,
      'third': thirdTrimesterProgress,
    };
  }

  // Get current trimester info
  Map<String, dynamic> _getCurrentTrimesterInfo() {
    final int currentWeek = controller.pregnancyWeekNumber.value;

    if (currentWeek <= 12) {
      return {
        'trimester': 'first_trimester_title'.tr,
        'weekRange': 'week_of'.trParams({'current': currentWeek.toString(), 'total': '12'}),
        'description': 'early_development_stage'.tr
      };
    } else if (currentWeek <= 27) {
      return {
        'trimester': 'second_trimester_title'.tr,
        'weekRange': 'week_of'.trParams({'current': (currentWeek - 12).toString(), 'total': '15'}),
        'description': 'growth_and_movement'.tr
      };
    } else {
      return {
        'trimester': 'third_trimester_title'.tr,
        'weekRange': 'week_of'.trParams({'current': (currentWeek - 27).toString(), 'total': '13'}),
        'description': 'final_preparation'.tr
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    print('TimelineCard is being built');
    return Obx(() {
      final progress = _calculateProgress();
      final trimesterInfo = _getCurrentTrimesterInfo();

      return GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFAFA), // NeoSafeColors.creamWhite
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: themeService.getPrimaryColor().withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: themeService.getPrimaryColor().withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trimesterInfo['trimester'],
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF3D2929),
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${trimesterInfo['weekRange']} • ${trimesterInfo['description']}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF6B5555),
                          ),
                    ),
                    const SizedBox(height: 16),
                    // Dynamic timeline visualization
                    Row(
                      children: [
                        // First Trimester Progress Bar
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8E8E8),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: progress['first'],
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      themeService.getPrimaryColor(),
                                      themeService.getLightColor(),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Second Trimester Progress Bar
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8E8E8),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: progress['second'],
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      themeService.getAccentColor(),
                                      themeService.getBabyColor(),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Third Trimester Progress Bar
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8E8E8),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: progress['third'],
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      themeService
                                          .getPrimaryColor()
                                          .withOpacity(0.8),
                                      themeService
                                          .getAccentColor()
                                          .withOpacity(0.6),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Trimester labels
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            "1st",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF6B5555),
                                      fontSize: 10,
                                    ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "2nd",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF6B5555),
                                      fontSize: 10,
                                    ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "3rd",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF6B5555),
                                      fontSize: 10,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Uncomment if you want the arrow icon
            ],
          ),
        ),
      );
    });
  }
}
