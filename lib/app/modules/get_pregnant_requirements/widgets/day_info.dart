// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:babysafe/app/utils/neo_safe_theme.dart';
// import '../controllers/get_pregnant_requirements_controller.dart';

// class DayInfoWidget extends StatelessWidget {
//   final GetPregnantRequirementsController controller;
//   final ThemeData theme;
//   const DayInfoWidget({Key? key, required this.controller, required this.theme})
//       : super(key: key);

//   String _monthName(int month) {
//     final months = [
//       '',
//       'jan'.tr,
//       'feb'.tr,
//       'mar'.tr,
//       'apr'.tr,
//       'may'.tr,
//       'jun'.tr,
//       'jul'.tr,
//       'aug'.tr,
//       'sep'.tr,
//       'oct'.tr,
//       'nov'.tr,
//       'dec'.tr
//     ];
//     return months[month];
//   }

//   Color _getChanceColor(String chance) {
//     switch (chance) {
//       case "Peak":
//         return NeoSafeColors.error;
//       case "High":
//         return NeoSafeColors.warning;
//       case "Medium":
//         return NeoSafeColors.coralPink;
//       default:
//         return NeoSafeColors.mediumGray;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (controller.selectedDay.value == null) {
//       return const SizedBox.shrink();
//     }
//     final day = controller.selectedDay.value!;
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             NeoSafeColors.palePink.withOpacity(0.3),
//             NeoSafeColors.blushRose.withOpacity(0.3),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: NeoSafeColors.primaryPink.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: NeoSafeColors.primaryPink.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: const Icon(
//                   Icons.calendar_today,
//                   color: NeoSafeColors.primaryText,
//                   size: 24,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "${day.day} ${_monthName(day.month)} ${day.year}",
//                       style: theme.textTheme.headlineSmall?.copyWith(
//                         fontWeight: FontWeight.w700,
//                         color: NeoSafeColors.primaryText,
//                       ),
//                     ),
//                     Text(
//                       "day_of_cycle".trParams(
//                           {'day': controller.getCycleDay(day).toString()}),
//                       style: theme.textTheme.bodyMedium?.copyWith(
//                         color: NeoSafeColors.secondaryText,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Wrap(
//             spacing: 12,
//             runSpacing: 8,
//             children: [
//               _StatusChip(
//                 label: "pregnancy_chance"
//                     .trParams({'chance': controller.getPregnancyChance(day)}),
//                 color: _getChanceColor(controller.getPregnancyChance(day)),
//                 icon: Icons.trending_up,
//               ),
//               if (controller.isPeriodDay(day))
//                 _StatusChip(
//                   label: "period_day".tr,
//                   color: NeoSafeColors.error,
//                   icon: Icons.water_drop,
//                 ),
//               if (controller.isFertileDay(day))
//                 _StatusChip(
//                   label: "fertile_window".tr,
//                   color: NeoSafeColors.success,
//                   icon: Icons.eco,
//                 ),
//               if (controller.isOvulationDay(day))
//                 _StatusChip(
//                   label: "ovulation_day".tr,
//                   color: NeoSafeColors.ovalutionDay,
//                   icon: Icons.star,
//                 ),
//               if (controller.hasIntercourse(day))
//                 _StatusChip(
//                   label: "intimacy_logged".tr,
//                   color: NeoSafeColors.primaryPink,
//                   icon: Icons.favorite,
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import '../controllers/get_pregnant_requirements_controller.dart';

class DayInfoWidget extends StatelessWidget {
  final GetPregnantRequirementsController controller;
  final ThemeData theme;

  const DayInfoWidget({
    Key? key,
    required this.controller,
    required this.theme,
  }) : super(key: key);

  String _monthName(int month) {
    final months = [
      '',
      'jan'.tr,
      'feb'.tr,
      'mar'.tr,
      'apr'.tr,
      'may'.tr,
      'jun'.tr,
      'jul'.tr,
      'aug'.tr,
      'sep'.tr,
      'oct'.tr,
      'nov'.tr,
      'dec'.tr
    ];
    return months[month];
  }

  Color _getChanceColor(String chance) {
    // Handle translated values
    if (chance.contains('Peak') || chance.contains('peak')) {
      return NeoSafeColors.error;
    } else if (chance.contains('High') || chance.contains('high')) {
      return NeoSafeColors.warning;
    } else if (chance.contains('Medium') || chance.contains('medium')) {
      return NeoSafeColors.coralPink;
    }
    return NeoSafeColors.mediumGray;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final day = controller.selectedDay.value;

      // If no day is selected, don't show anything
      if (day == null) {
        return const SizedBox.shrink();
      }

      // Access all reactive dependencies to trigger rebuild when they change
      final _ = controller.periodStart.value;
      final __ = controller.cycleLength.value;
      final ___ = controller.periodLength.value;
      final ____ = controller.intercourseLog.length;

      // Calculate values
      final cycleDay = controller.getCycleDay(day);
      final pregnancyChance = controller.getPregnancyChance(day);
      final isPeriod = controller.isPeriodDay(day);
      final isFertile = controller.isFertileDay(day);
      final isOvulation = controller.isOvulationDay(day);
      final hasIntercourseLogged = controller.hasIntercourse(day);

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Container(
          key: ValueKey(day.toIso8601String()),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                NeoSafeColors.palePink.withOpacity(0.3),
                NeoSafeColors.blushRose.withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: NeoSafeColors.primaryPink.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: NeoSafeColors.primaryPink.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: NeoSafeColors.primaryText,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${day.day} ${_monthName(day.month)} ${day.year}",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: NeoSafeColors.primaryText,
                          ),
                        ),
                        Text(
                          cycleDay > 0
                              ? "day_of_cycle"
                                  .trParams({'day': cycleDay.toString()})
                              : 'no_cycle_data'.tr,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: NeoSafeColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  // Always show pregnancy chance
                  _StatusChip(
                    label: "pregnancy_chance"
                        .trParams({'chance': pregnancyChance}),
                    color: _getChanceColor(pregnancyChance),
                    icon: Icons.trending_up,
                  ),
                  // Show period day chip
                  if (isPeriod)
                    _StatusChip(
                      label: "period_day".tr,
                      color: NeoSafeColors.error,
                      icon: Icons.water_drop,
                    ),
                  // Show fertile window chip
                  if (isFertile)
                    _StatusChip(
                      label: "fertile_window".tr,
                      color: NeoSafeColors.success,
                      icon: Icons.eco,
                    ),
                  // Show ovulation day chip
                  if (isOvulation)
                    _StatusChip(
                      label: "ovulation_day".tr,
                      color: NeoSafeColors.ovalutionDay,
                      icon: Icons.star,
                    ),
                  // Show intimacy logged chip
                  if (hasIntercourseLogged)
                    _StatusChip(
                      label: "intimacy_logged".tr,
                      color: NeoSafeColors.primaryPink,
                      icon: Icons.favorite,
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusChip({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// class _StatusChip extends StatelessWidget {
//   final String label;
//   final Color color;
//   final IconData icon;
//   const _StatusChip(
//       {required this.label, required this.color, required this.icon});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: color.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             size: 14,
//             color: color,
//           ),
//           const SizedBox(width: 6),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
