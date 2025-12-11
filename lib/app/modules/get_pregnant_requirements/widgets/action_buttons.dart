// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:babysafe/app/utils/neo_safe_theme.dart';
// import '../controllers/get_pregnant_requirements_controller.dart';

// class ActionButtonsWidget extends StatelessWidget {
//   final GetPregnantRequirementsController controller;
//   const ActionButtonsWidget({Key? key, required this.controller})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final selectedDay = controller.selectedDay.value;
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   NeoSafeColors.error.withOpacity(0.8),
//                   NeoSafeColors.error,
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: NeoSafeColors.error.withOpacity(0.3),
//                   blurRadius: 12,
//                   offset: const Offset(0, 6),
//                 ),
//               ],
//             ),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 shadowColor: Colors.transparent,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               onPressed: () => _showPeriodDatePicker(context),
//               icon: const Icon(Icons.water_drop, color: Colors.white, size: 20),
//               label: Text(
//                 'set_period_start'.tr,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: NeoSafeGradients.primaryGradient,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: NeoSafeColors.primaryPink.withOpacity(0.3),
//                   blurRadius: 12,
//                   offset: const Offset(0, 6),
//                 ),
//               ],
//             ),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 shadowColor: Colors.transparent,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               onPressed: selectedDay != null
//                   ? () => controller.toggleIntercourse(selectedDay)
//                   : null,
//               icon: Icon(
//                 selectedDay != null && controller.hasIntercourse(selectedDay)
//                     ? Icons.favorite
//                     : Icons.favorite_outline,
//                 color: Colors.white,
//                 size: 20,
//               ),
//               label: Text(
//                 selectedDay != null && controller.hasIntercourse(selectedDay)
//                     ? 'remove_log'.tr
//                     : 'log_intimacy'.tr,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _showPeriodDatePicker(BuildContext context) async {
//     final controller = this.controller;
//     final now = DateTime.now();
//     final firstDayOfPreviousMonth = DateTime(now.year, now.month - 1, 1);
//     final lastDayOfPreviousMonth = DateTime(now.year, now.month, 0);

//     final selectedDate = await showDatePicker(
//       context: context,
//       firstDate: DateTime.now().subtract(const Duration(days: 60)),
//       lastDate: DateTime.now(),
//       initialDate: controller.periodStart.value ?? DateTime.now(),
//       // initialDate: lastDayOfPreviousMonth,
//       // firstDate: firstDayOfPreviousMonth,
//       // lastDate: lastDayOfPreviousMonth,

//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: Theme.of(context).colorScheme.copyWith(
//                   primary: NeoSafeColors.primaryPink,
//                   onPrimary: Colors.white,
//                 ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (selectedDate != null) {
//       await controller.setPeriodStart(selectedDate);
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import '../controllers/get_pregnant_requirements_controller.dart';

class ActionButtonsWidget extends StatefulWidget {
  final GetPregnantRequirementsController controller;
  const ActionButtonsWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  State<ActionButtonsWidget> createState() => _ActionButtonsWidgetState();
}

class _ActionButtonsWidgetState extends State<ActionButtonsWidget> {
  bool _isUpdatingPeriod = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedDay = widget.controller.selectedDay.value;
      final hasIntercourse =
          selectedDay != null && widget.controller.hasIntercourse(selectedDay);

      return Row(
        children: [
          Expanded(
            child: Opacity(
              opacity: _isUpdatingPeriod ? 0.6 : 1.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      NeoSafeColors.error.withOpacity(0.8),
                      NeoSafeColors.error,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: NeoSafeColors.error.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _isUpdatingPeriod
                      ? null
                      : () => _showPeriodDatePicker(context, widget.controller),
                  icon: _isUpdatingPeriod
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.water_drop,
                          color: Colors.white, size: 20),
                  label: Text(
                    'set_period_start'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: NeoSafeGradients.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: NeoSafeColors.primaryPink.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: selectedDay != null
                    ? () => widget.controller.toggleIntercourse(selectedDay)
                    : null,
                icon: Icon(
                  hasIntercourse ? Icons.favorite : Icons.favorite_outline,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  hasIntercourse ? 'remove_log'.tr : 'log_intimacy'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  void _showPeriodDatePicker(BuildContext context,
      GetPregnantRequirementsController controller) async {
    // Prevent multiple date pickers from opening
    if (_isUpdatingPeriod) {
      print('Date picker already open');
      return;
    }

    setState(() => _isUpdatingPeriod = true);

    try {
      final selectedDate = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(
          Duration(days: controller.cycleLength.value),
        ),
        lastDate: DateTime.now(),
        // firstDate: DateTime.now().subtract(const Duration(days: 60)),
        // lastDate: DateTime.now(),
        initialDate: widget.controller.periodStart.value ?? DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: NeoSafeColors.primaryPink,
                    onPrimary: Colors.white,
                  ),
            ),
            child: child!,
          );
        },
      );

      if (selectedDate != null) {
        print('Date selected: $selectedDate');

        // Update period start - this will debounce the save operation
        await widget.controller.setPeriodStart(selectedDate);

        // Show success message
        // if (mounted) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('period_start_updated'.tr),
        //       duration: const Duration(seconds: 2),
        //       backgroundColor: NeoSafeColors.success,
        //     ),
        //   );
        // }
      }
    } catch (e) {
      print('Error in date picker: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating period start: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: NeoSafeColors.error,
          ),
        );
      }
    } finally {
      // Add a small delay to prevent rapid successive opens
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() => _isUpdatingPeriod = false);
      }
    }
  }
}
