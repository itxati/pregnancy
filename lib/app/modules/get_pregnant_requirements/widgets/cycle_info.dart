// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:babysafe/app/utils/neo_safe_theme.dart';
// import '../controllers/get_pregnant_requirements_controller.dart';

// class CycleInfoWidget extends StatelessWidget {
//   final GetPregnantRequirementsController controller;
//   final ThemeData theme;
//   const CycleInfoWidget(
//       {Key? key, required this.controller, required this.theme})
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

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final periodStart = controller.periodStart.value;
//       if (periodStart == null) {
//         return Container(
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 NeoSafeColors.lightPink.withOpacity(0.3),
//                 NeoSafeColors.palePink.withOpacity(0.5),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: NeoSafeColors.primaryPink.withOpacity(0.2),
//               width: 1,
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "cycle_overview".tr,
//                 style: theme.textTheme.headlineSmall?.copyWith(
//                   fontWeight: FontWeight.w700,
//                   color: NeoSafeColors.primaryText,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 "no_period_data".tr,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   color: NeoSafeColors.secondaryText,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }

//       final nextPeriod = controller.getNextPeriod();
//       final daysToNext = nextPeriod.difference(DateTime.now()).inDays;
//       final ovulationDay = controller.getOvulationDay();
//       final fertileDays = controller.getFertileDays();

//       // Debug logging
//       print('Period Start: ${controller.periodStart.value}');
//       print('Cycle Length: ${controller.cycleLength}');
//       print('Next Period: $nextPeriod');
//       print('Days to Next: $daysToNext');

//       return Container(
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               NeoSafeColors.lightPink.withOpacity(0.3),
//               NeoSafeColors.palePink.withOpacity(0.5),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: NeoSafeColors.primaryPink.withOpacity(0.2),
//             width: 1,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "cycle_overview".tr,
//               style: theme.textTheme.headlineSmall?.copyWith(
//                 fontWeight: FontWeight.w700,
//                 color: NeoSafeColors.primaryText,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: _CycleInfoItem(
//                     title: "last_period".tr,
//                     value:
//                         "${periodStart.day} ${_monthName(periodStart.month)}",
//                     icon: Icons.water_drop,
//                     color: NeoSafeColors.error,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _CycleInfoItem(
//                     title: "next_period".tr,
//                     value: daysToNext > 0
//                         ? 'cycle_in_days'
//                             .trParams({'days': daysToNext.toString()})
//                         : daysToNext == 0
//                             ? 'cycle_today'.tr
//                             : 'cycle_overdue_by_days'
//                                 .trParams({'days': (-daysToNext).toString()}),
//                     icon: Icons.schedule,
//                     color: NeoSafeColors.roseAccent,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: _CycleInfoItem(
//                     title: "ovulation".tr,
//                     value:
//                         "${ovulationDay.day} ${_monthName(ovulationDay.month)}",
//                     icon: Icons.star,
//                     color: NeoSafeColors.ovalutionDay,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _CycleInfoItem(
//                     title: "fertile_window_range".tr,
//                     value:
//                         "${fertileDays.isNotEmpty ? '${fertileDays.first.day}-${fertileDays.last.day}' : '-'}",
//                     icon: Icons.eco,
//                     color: NeoSafeColors.success,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }

// class _CycleInfoItem extends StatelessWidget {
//   final String title;
//   final String value;
//   final IconData icon;
//   final Color color;
//   const _CycleInfoItem(
//       {required this.title,
//       required this.value,
//       required this.icon,
//       required this.color});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.7),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: color.withOpacity(0.2),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(
//                   icon,
//                   size: 16,
//                   color: color,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     color: NeoSafeColors.secondaryText,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w700,
//               color: NeoSafeColors.primaryText,
//             ),
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

class CycleInfoWidget extends StatelessWidget {
  final GetPregnantRequirementsController controller;
  final ThemeData theme;

  const CycleInfoWidget({
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

  @override
  Widget build(BuildContext context) {
    // Use GetBuilder instead of Obx to prevent excessive rebuilds
    return GetBuilder<GetPregnantRequirementsController>(
      id: 'cycle_info', // Unique ID for targeted updates
      builder: (_) {
        final periodStart = controller.periodStart.value;

        if (periodStart == null) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  NeoSafeColors.lightPink.withOpacity(0.3),
                  NeoSafeColors.palePink.withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: NeoSafeColors.primaryPink.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "cycle_overview".tr,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: NeoSafeColors.primaryText,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "no_period_data".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    color: NeoSafeColors.secondaryText,
                  ),
                ),
              ],
            ),
          );
        }

        // Calculate values ONCE outside the widget tree
        final cycleLength = controller.cycleLength.value;
        final nextPeriod = periodStart.add(Duration(days: cycleLength));
        final daysToNext = nextPeriod.difference(DateTime.now()).inDays;
        final ovulationDay = periodStart.add(Duration(days: cycleLength - 14));

        // Calculate fertile window
        final List<DateTime> fertileDays = List.generate(
          7,
          (i) => ovulationDay.subtract(Duration(days: 5 - i)),
        );

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                NeoSafeColors.lightPink.withOpacity(0.3),
                NeoSafeColors.palePink.withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: NeoSafeColors.primaryPink.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "cycle_overview".tr,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: NeoSafeColors.primaryText,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _CycleInfoItem(
                      title: "last_period".tr,
                      value:
                          "${periodStart.day} ${_monthName(periodStart.month)}",
                      icon: Icons.water_drop,
                      color: NeoSafeColors.error,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CycleInfoItem(
                      title: "next_period".tr,
                      value: daysToNext > 0
                          ? 'cycle_in_days'
                              .trParams({'days': daysToNext.toString()})
                          : daysToNext == 0
                              ? 'cycle_today'.tr
                              : 'cycle_overdue_by_days'
                                  .trParams({'days': (-daysToNext).toString()}),
                      icon: Icons.schedule,
                      color: NeoSafeColors.roseAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _CycleInfoItem(
                      title: "ovulation".tr,
                      value:
                          "${ovulationDay.day} ${_monthName(ovulationDay.month)}",
                      icon: Icons.star,
                      color: NeoSafeColors.ovalutionDay,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CycleInfoItem(
                      title: "fertile_window_range".tr,
                      value: fertileDays.isNotEmpty
                          ? "${fertileDays.first.day}-${fertileDays.last.day}"
                          : '-',
                      icon: Icons.eco,
                      color: NeoSafeColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CycleInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _CycleInfoItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: NeoSafeColors.secondaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: NeoSafeColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
