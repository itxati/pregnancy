// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:babysafe/app/utils/neo_safe_theme.dart';
// import '../controllers/get_pregnant_requirements_controller.dart';

// class CycleSettingsWidget extends StatelessWidget {
//   final GetPregnantRequirementsController controller;
//   const CycleSettingsWidget({Key? key, required this.controller})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: NeoSafeColors.creamWhite,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: NeoSafeColors.softGray.withOpacity(0.3),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: NeoSafeColors.lightPink.withOpacity(0.3),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(
//                     Icons.settings,
//                     color: NeoSafeColors.primaryPink,
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Text(
//                   'cycle_settings'.tr,
//                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.w700,
//                         color: NeoSafeColors.primaryText,
//                       ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),

//             // Cycle Length Setting
//             Obx(() => Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'cycle_length'.tr,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyMedium
//                                 ?.copyWith(
//                                   fontWeight: FontWeight.w600,
//                                   color: NeoSafeColors.primaryText,
//                                 ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             '${controller.cycleLength.value} ${'days'.tr}',
//                             style:
//                                 Theme.of(context).textTheme.bodySmall?.copyWith(
//                                       color: NeoSafeColors.secondaryText,
//                                     ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             if (controller.cycleLength.value > 21) {
//                               controller.updateCycleSettings(
//                                 newCycleLength:
//                                     controller.cycleLength.value - 1,
//                               );
//                             }
//                           },
//                           icon: Container(
//                             padding: const EdgeInsets.all(4),
//                             decoration: BoxDecoration(
//                               color: NeoSafeColors.lightPink.withOpacity(0.3),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Icon(
//                               Icons.remove,
//                               color: NeoSafeColors.primaryPink,
//                               size: 16,
//                             ),
//                           ),
//                         ),
//                         Container(
//                           width: 50,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 8),
//                           decoration: BoxDecoration(
//                             color: NeoSafeColors.lightPink.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             '${controller.cycleLength.value}',
//                             textAlign: TextAlign.center,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleMedium
//                                 ?.copyWith(
//                                   fontWeight: FontWeight.w700,
//                                   color: NeoSafeColors.primaryPink,
//                                 ),
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             if (controller.cycleLength.value < 35) {
//                               controller.updateCycleSettings(
//                                 newCycleLength:
//                                     controller.cycleLength.value + 1,
//                               );
//                             }
//                           },
//                           icon: Container(
//                             padding: const EdgeInsets.all(4),
//                             decoration: BoxDecoration(
//                               color: NeoSafeColors.lightPink.withOpacity(0.3),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Icon(
//                               Icons.add,
//                               color: NeoSafeColors.primaryPink,
//                               size: 16,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 )),

//             const SizedBox(height: 16),

//             // Period Length Setting
//             Obx(() => Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'period_length'.tr,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyMedium
//                                 ?.copyWith(
//                                   fontWeight: FontWeight.w600,
//                                   color: NeoSafeColors.primaryText,
//                                 ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             '${controller.periodLength.value} ${'days'.tr}',
//                             style:
//                                 Theme.of(context).textTheme.bodySmall?.copyWith(
//                                       color: NeoSafeColors.secondaryText,
//                                     ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             if (controller.periodLength.value > 3) {
//                               controller.updateCycleSettings(
//                                 newPeriodLength:
//                                     controller.periodLength.value - 1,
//                               );
//                             }
//                           },
//                           icon: Container(
//                             padding: const EdgeInsets.all(4),
//                             decoration: BoxDecoration(
//                               color: NeoSafeColors.lightPink.withOpacity(0.3),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Icon(
//                               Icons.remove,
//                               color: NeoSafeColors.primaryPink,
//                               size: 16,
//                             ),
//                           ),
//                         ),
//                         Container(
//                           width: 50,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 8),
//                           decoration: BoxDecoration(
//                             color: NeoSafeColors.lightPink.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             '${controller.periodLength.value}',
//                             textAlign: TextAlign.center,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleMedium
//                                 ?.copyWith(
//                                   fontWeight: FontWeight.w700,
//                                   color: NeoSafeColors.primaryPink,
//                                 ),
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             if (controller.periodLength.value < 7) {
//                               controller.updateCycleSettings(
//                                 newPeriodLength:
//                                     controller.periodLength.value + 1,
//                               );
//                             }
//                           },
//                           icon: Container(
//                             padding: const EdgeInsets.all(4),
//                             decoration: BoxDecoration(
//                               color: NeoSafeColors.lightPink.withOpacity(0.3),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Icon(
//                               Icons.add,
//                               color: NeoSafeColors.primaryPink,
//                               size: 16,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import '../controllers/get_pregnant_requirements_controller.dart';
import 'dart:async';

class CycleSettingsWidget extends StatefulWidget {
  final GetPregnantRequirementsController controller;

  const CycleSettingsWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  State<CycleSettingsWidget> createState() => _CycleSettingsWidgetState();
}

class _CycleSettingsWidgetState extends State<CycleSettingsWidget> {
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _debouncedUpdate(Future<void> Function() updateFunction) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Create new timer - wait 300ms before executing
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      await updateFunction();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NeoSafeColors.creamWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: NeoSafeColors.softGray.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: NeoSafeColors.lightPink.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.settings,
                    color: NeoSafeColors.primaryPink,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'cycle_settings'.tr,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: NeoSafeColors.primaryText,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Cycle Length Setting
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'cycle_length'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: NeoSafeColors.primaryText,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.controller.cycleLength.value} ${'days'.tr}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: NeoSafeColors.secondaryText,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (widget.controller.cycleLength.value > 21) {
                              final newValue =
                                  widget.controller.cycleLength.value - 1;
                              // Update UI immediately
                              widget.controller.cycleLength.value = newValue;
                              // Debounce the save operation
                              _debouncedUpdate(() async {
                                await widget.controller.updateCycleSettings(
                                  newCycleLength: newValue,
                                );
                              });
                            }
                          },
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: NeoSafeColors.lightPink.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.remove,
                              color: NeoSafeColors.primaryPink,
                              size: 16,
                            ),
                          ),
                        ),
                        Container(
                          width: 50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: NeoSafeColors.lightPink.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${widget.controller.cycleLength.value}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: NeoSafeColors.primaryPink,
                                ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (widget.controller.cycleLength.value < 35) {
                              final newValue =
                                  widget.controller.cycleLength.value + 1;
                              // Update UI immediately
                              widget.controller.cycleLength.value = newValue;
                              // Debounce the save operation
                              _debouncedUpdate(() async {
                                await widget.controller.updateCycleSettings(
                                  newCycleLength: newValue,
                                );
                              });
                            }
                          },
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: NeoSafeColors.lightPink.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: NeoSafeColors.primaryPink,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),

            const SizedBox(height: 16),

            // Period Length Setting
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'period_length'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: NeoSafeColors.primaryText,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.controller.periodLength.value} ${'days'.tr}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: NeoSafeColors.secondaryText,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (widget.controller.periodLength.value > 3) {
                              final newValue =
                                  widget.controller.periodLength.value - 1;
                              // Update UI immediately
                              widget.controller.periodLength.value = newValue;
                              // Debounce the save operation
                              _debouncedUpdate(() async {
                                await widget.controller.updateCycleSettings(
                                  newPeriodLength: newValue,
                                );
                              });
                            }
                          },
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: NeoSafeColors.lightPink.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.remove,
                              color: NeoSafeColors.primaryPink,
                              size: 16,
                            ),
                          ),
                        ),
                        Container(
                          width: 50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: NeoSafeColors.lightPink.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${widget.controller.periodLength.value}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: NeoSafeColors.primaryPink,
                                ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (widget.controller.periodLength.value < 7) {
                              final newValue =
                                  widget.controller.periodLength.value + 1;
                              // Update UI immediately
                              widget.controller.periodLength.value = newValue;
                              // Debounce the save operation
                              _debouncedUpdate(() async {
                                await widget.controller.updateCycleSettings(
                                  newPeriodLength: newValue,
                                );
                              });
                            }
                          },
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: NeoSafeColors.lightPink.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: NeoSafeColors.primaryPink,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
