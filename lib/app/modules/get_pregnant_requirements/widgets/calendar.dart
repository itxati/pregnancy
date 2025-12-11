// // // // import 'package:flutter/material.dart';
// // // // import 'package:get/get.dart';
// // // // import 'package:table_calendar/table_calendar.dart';
// // // // import '../controllers/get_pregnant_requirements_controller.dart';
// // // // import 'package:babysafe/app/utils/neo_safe_theme.dart';

// // // // class CalendarWidget extends StatelessWidget {
// // // //   final GetPregnantRequirementsController controller;
// // // //   final ThemeData theme;
// // // //   const CalendarWidget(
// // // //       {Key? key, required this.controller, required this.theme})
// // // //       : super(key: key);

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Container(
// // // //       decoration: BoxDecoration(
// // // //         color: NeoSafeColors.creamWhite,
// // // //         borderRadius: BorderRadius.circular(24),
// // // //         boxShadow: [
// // // //           BoxShadow(
// // // //             color: NeoSafeColors.softGray.withOpacity(0.3),
// // // //             blurRadius: 20,
// // // //             offset: const Offset(0, 8),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       child: ClipRRect(
// // // //         borderRadius: BorderRadius.circular(24),
// // // //         child: Obx(() {
// // // //           // Access reactive values to trigger rebuild when cycle/period length changes
// // // //           final _ = controller.cycleLength.value;
// // // //           final __ = controller.periodLength.value;
// // // //           return TableCalendar(
// // // //             firstDay: DateTime.utc(2020, 1, 1),
// // // //             lastDay: DateTime.utc(2030, 12, 31),
// // // //             focusedDay: controller.focusedDay.value,
// // // //             selectedDayPredicate: (day) =>
// // // //                 controller.selectedDay.value != null &&
// // // //                 controller.isSameDay(controller.selectedDay.value!, day),
// // // //             // enabledDayPredicate: (day) {
// // // //             //   DateTime now = DateTime.now();
// // // //             //   DateTime firstDayOfPreviousMonth =
// // // //             //       DateTime(now.year, now.month - 1, 1);
// // // //             //   DateTime lastDayOfPreviousMonth = DateTime(now.year, now.month, 0);
// // // //             //   return day.isAfter(
// // // //             //           firstDayOfPreviousMonth.subtract(Duration(days: 1))) &&
// // // //             //       day.isBefore(lastDayOfPreviousMonth.add(Duration(days: 1)));
// // // //             // },
// // // //             onDaySelected: (selected, focused) {
// // // //               controller.setSelectedDay(selected);
// // // //             },
// // // //             calendarStyle: CalendarStyle(
// // // //               outsideDaysVisible: false,
// // // //               weekendTextStyle: TextStyle(
// // // //                 color: NeoSafeColors.secondaryText,
// // // //                 fontWeight: FontWeight.w500,
// // // //               ),
// // // //               defaultTextStyle: TextStyle(
// // // //                 color: NeoSafeColors.primaryText,
// // // //                 fontWeight: FontWeight.w500,
// // // //               ),
// // // //               todayDecoration: BoxDecoration(
// // // //                 color: NeoSafeColors.coralPink.withOpacity(0.7),
// // // //                 shape: BoxShape.circle,
// // // //                 boxShadow: [
// // // //                   BoxShadow(
// // // //                     color: NeoSafeColors.coralPink.withOpacity(0.3),
// // // //                     blurRadius: 8,
// // // //                     offset: const Offset(0, 2),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //               selectedDecoration: BoxDecoration(
// // // //                 color: NeoSafeColors.primaryPink,
// // // //                 shape: BoxShape.circle,
// // // //                 boxShadow: [
// // // //                   BoxShadow(
// // // //                     color: NeoSafeColors.primaryPink.withOpacity(0.4),
// // // //                     blurRadius: 8,
// // // //                     offset: const Offset(0, 2),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //               markerDecoration: const BoxDecoration(
// // // //                 color: NeoSafeColors.roseAccent,
// // // //                 shape: BoxShape.circle,
// // // //               ),
// // // //             ),
// // // //             headerStyle: HeaderStyle(
// // // //               formatButtonVisible: false,
// // // //               titleCentered: true,
// // // //               titleTextStyle: theme.textTheme.headlineSmall!.copyWith(
// // // //                 fontWeight: FontWeight.w700,
// // // //                 color: NeoSafeColors.primaryText,
// // // //               ),
// // // //               titleTextFormatter: (date, locale) {
// // // //                 final monthNames = [
// // // //                   '',
// // // //                   'jan'.tr,
// // // //                   'feb'.tr,
// // // //                   'mar'.tr,
// // // //                   'apr'.tr,
// // // //                   'may'.tr,
// // // //                   'jun'.tr,
// // // //                   'jul'.tr,
// // // //                   'aug'.tr,
// // // //                   'sep'.tr,
// // // //                   'oct'.tr,
// // // //                   'nov'.tr,
// // // //                   'dec'.tr
// // // //                 ];
// // // //                 return '${monthNames[date.month]} ${date.year}';
// // // //               },
// // // //               leftChevronIcon: Container(
// // // //                 padding: const EdgeInsets.all(8),
// // // //                 decoration: BoxDecoration(
// // // //                   color: NeoSafeColors.lightPink.withOpacity(0.3),
// // // //                   borderRadius: BorderRadius.circular(12),
// // // //                 ),
// // // //                 child: const Icon(
// // // //                   Icons.chevron_left,
// // // //                   color: NeoSafeColors.primaryPink,
// // // //                 ),
// // // //               ),
// // // //               rightChevronIcon: Container(
// // // //                 padding: const EdgeInsets.all(8),
// // // //                 decoration: BoxDecoration(
// // // //                   color: NeoSafeColors.lightPink.withOpacity(0.3),
// // // //                   borderRadius: BorderRadius.circular(12),
// // // //                 ),
// // // //                 child: const Icon(
// // // //                   Icons.chevron_right,
// // // //                   color: NeoSafeColors.primaryPink,
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             calendarBuilders: CalendarBuilders(
// // // //               defaultBuilder: (context, date, _) =>
// // // //                   _buildCalendarDay(context, date, controller),
// // // //               dowBuilder: (context, day) {
// // // //                 final dayNames = [
// // // //                   'sun'.tr,
// // // //                   'mon'.tr,
// // // //                   'tue'.tr,
// // // //                   'wed'.tr,
// // // //                   'thu'.tr,
// // // //                   'fri'.tr,
// // // //                   'sat'.tr
// // // //                 ];
// // // //                 return Center(
// // // //                   child: Text(
// // // //                     dayNames[day.weekday % 7],
// // // //                     style: TextStyle(
// // // //                       color: NeoSafeColors.secondaryText,
// // // //                       fontWeight: FontWeight.w500,
// // // //                       fontSize: 12,
// // // //                     ),
// // // //                   ),
// // // //                 );
// // // //               },
// // // //             ),
// // // //           );
// // // //         }),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildCalendarDay(BuildContext context, DateTime date,
// // // //       GetPregnantRequirementsController controller) {
// // // //     Widget? overlay;
// // // //     Color? backgroundColor;
// // // //     Color? borderColor;
// // // //     List<BoxShadow>? shadows;
// // // //     double borderWidth = 0;

// // // //     if (controller.isPeriodDay(date)) {
// // // //       backgroundColor = NeoSafeColors.error;
// // // //       shadows = [
// // // //         BoxShadow(
// // // //           color: NeoSafeColors.error.withOpacity(0.4),
// // // //           blurRadius: 8,
// // // //           offset: const Offset(0, 2),
// // // //         ),
// // // //       ];
// // // //     } else if (controller.isOvulationDay(date)) {
// // // //       backgroundColor = NeoSafeColors.ovalutionDay;
// // // //       borderColor = NeoSafeColors.ovalutionDay;
// // // //       borderWidth = 2;
// // // //       shadows = [
// // // //         BoxShadow(
// // // //           color: NeoSafeColors.ovalutionDay.withOpacity(0.5),
// // // //           blurRadius: 12,
// // // //           offset: const Offset(0, 4),
// // // //         ),
// // // //       ];
// // // //       overlay = AnimatedBuilder(
// // // //         animation: controller.pulseAnimation,
// // // //         builder: (context, child) {
// // // //           return Transform.scale(
// // // //             scale: controller.pulseAnimation.value * 0.8,
// // // //             child: const Icon(
// // // //               Icons.star,
// // // //               color: Colors.white,
// // // //               size: 8,
// // // //             ),
// // // //           );
// // // //         },
// // // //       );
// // // //     } else if (controller.isFertileDay(date)) {
// // // //       backgroundColor = NeoSafeColors.success;
// // // //       shadows = [
// // // //         BoxShadow(
// // // //           color: NeoSafeColors.success.withOpacity(0.4),
// // // //           blurRadius: 8,
// // // //           offset: const Offset(0, 2),
// // // //         ),
// // // //       ];
// // // //     }

// // // //     bool isSelected = controller.selectedDay.value != null &&
// // // //         controller.isSameDay(controller.selectedDay.value!, date);
// // // //     if (isSelected && backgroundColor == null) {
// // // //       backgroundColor = NeoSafeColors.primaryPink;
// // // //       shadows = [
// // // //         BoxShadow(
// // // //           color: NeoSafeColors.primaryPink.withOpacity(0.4),
// // // //           blurRadius: 8,
// // // //           offset: const Offset(0, 2),
// // // //         ),
// // // //       ];
// // // //     } else if (isSelected) {
// // // //       borderColor = Colors.white;
// // // //       borderWidth = 2;
// // // //     }

// // // //     bool isToday = controller.isSameDay(DateTime.now(), date);
// // // //     if (isToday && backgroundColor == null) {
// // // //       backgroundColor = NeoSafeColors.coralPink.withOpacity(0.7);
// // // //       shadows = [
// // // //         BoxShadow(
// // // //           color: NeoSafeColors.coralPink.withOpacity(0.3),
// // // //           blurRadius: 8,
// // // //           offset: const Offset(0, 2),
// // // //         ),
// // // //       ];
// // // //     }

// // // //     return GestureDetector(
// // // //       onTap: () {
// // // //         controller.setSelectedDay(date);
// // // //       },
// // // //       child: Container(
// // // //         margin: const EdgeInsets.all(4),
// // // //         width: 36,
// // // //         height: 36,
// // // //         decoration: BoxDecoration(
// // // //           color: backgroundColor ?? Colors.transparent,
// // // //           shape: BoxShape.circle,
// // // //           border: borderColor != null && borderWidth > 0
// // // //               ? Border.all(color: borderColor, width: borderWidth)
// // // //               : null,
// // // //           boxShadow: shadows,
// // // //         ),
// // // //         child: Stack(
// // // //           alignment: Alignment.center,
// // // //           children: [
// // // //             Text(
// // // //               '${date.day}',
// // // //               style: TextStyle(
// // // //                 color: backgroundColor != null
// // // //                     ? Colors.white
// // // //                     : NeoSafeColors.primaryText,
// // // //                 fontWeight: FontWeight.w600,
// // // //                 fontSize: 14,
// // // //               ),
// // // //             ),
// // // //             if (overlay != null)
// // // //               Positioned(
// // // //                 top: 4,
// // // //                 right: 1,
// // // //                 child: overlay,
// // // //               ),
// // // //             if (controller.hasIntercourse(date))
// // // //               Positioned(
// // // //                 bottom: 2,
// // // //                 right: 2,
// // // //                 child: Container(
// // // //                   padding: const EdgeInsets.all(1),
// // // //                   decoration: BoxDecoration(
// // // //                     color: Colors.white.withOpacity(0.9),
// // // //                     shape: BoxShape.circle,
// // // //                   ),
// // // //                   child: const Icon(
// // // //                     Icons.favorite,
// // // //                     color: NeoSafeColors.primaryPink,
// // // //                     size: 8,
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import 'package:table_calendar/table_calendar.dart';
// // // import '../controllers/get_pregnant_requirements_controller.dart';
// // // import 'package:babysafe/app/utils/neo_safe_theme.dart';

// // // class CalendarWidget extends StatelessWidget {
// // //   final GetPregnantRequirementsController controller;
// // //   final ThemeData theme;

// // //   const CalendarWidget({
// // //     Key? key,
// // //     required this.controller,
// // //     required this.theme,
// // //   }) : super(key: key);

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         color: NeoSafeColors.creamWhite,
// // //         borderRadius: BorderRadius.circular(24),
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: NeoSafeColors.softGray.withOpacity(0.3),
// // //             blurRadius: 20,
// // //             offset: const Offset(0, 8),
// // //           ),
// // //         ],
// // //       ),
// // //       child: ClipRRect(
// // //         borderRadius: BorderRadius.circular(24),
// // //         child: Obx(() {
// // //           // Only trigger rebuild when these specific values change
// // //           final focusedDay = controller.focusedDay.value;
// // //           final selectedDay = controller.selectedDay.value;

// // //           return TableCalendar(
// // //             firstDay: DateTime.utc(2020, 1, 1),
// // //             lastDay: DateTime.utc(2030, 12, 31),
// // //             focusedDay: focusedDay,
// // //             selectedDayPredicate: (day) =>
// // //                 selectedDay != null && controller.isSameDay(selectedDay, day),
// // //             onDaySelected: (selected, focused) {
// // //               controller.setSelectedDay(selected);
// // //             },
// // //             // Use a key to prevent unnecessary rebuilds
// // //             calendarFormat: CalendarFormat.month,
// // //             availableCalendarFormats: const {
// // //               CalendarFormat.month: 'Month',
// // //             },
// // //             calendarStyle: CalendarStyle(
// // //               outsideDaysVisible: false,
// // //               weekendTextStyle: TextStyle(
// // //                 color: NeoSafeColors.secondaryText,
// // //                 fontWeight: FontWeight.w500,
// // //               ),
// // //               defaultTextStyle: TextStyle(
// // //                 color: NeoSafeColors.primaryText,
// // //                 fontWeight: FontWeight.w500,
// // //               ),
// // //               todayDecoration: BoxDecoration(
// // //                 color: NeoSafeColors.coralPink.withOpacity(0.7),
// // //                 shape: BoxShape.circle,
// // //                 boxShadow: [
// // //                   BoxShadow(
// // //                     color: NeoSafeColors.coralPink.withOpacity(0.3),
// // //                     blurRadius: 8,
// // //                     offset: const Offset(0, 2),
// // //                   ),
// // //                 ],
// // //               ),
// // //               selectedDecoration: BoxDecoration(
// // //                 color: NeoSafeColors.primaryPink,
// // //                 shape: BoxShape.circle,
// // //                 boxShadow: [
// // //                   BoxShadow(
// // //                     color: NeoSafeColors.primaryPink.withOpacity(0.4),
// // //                     blurRadius: 8,
// // //                     offset: const Offset(0, 2),
// // //                   ),
// // //                 ],
// // //               ),
// // //               markerDecoration: const BoxDecoration(
// // //                 color: NeoSafeColors.roseAccent,
// // //                 shape: BoxShape.circle,
// // //               ),
// // //             ),
// // //             headerStyle: HeaderStyle(
// // //               formatButtonVisible: false,
// // //               titleCentered: true,
// // //               titleTextStyle: theme.textTheme.headlineSmall!.copyWith(
// // //                 fontWeight: FontWeight.w700,
// // //                 color: NeoSafeColors.primaryText,
// // //               ),
// // //               titleTextFormatter: (date, locale) {
// // //                 final monthNames = [
// // //                   '',
// // //                   'jan'.tr,
// // //                   'feb'.tr,
// // //                   'mar'.tr,
// // //                   'apr'.tr,
// // //                   'may'.tr,
// // //                   'jun'.tr,
// // //                   'jul'.tr,
// // //                   'aug'.tr,
// // //                   'sep'.tr,
// // //                   'oct'.tr,
// // //                   'nov'.tr,
// // //                   'dec'.tr
// // //                 ];
// // //                 return '${monthNames[date.month]} ${date.year}';
// // //               },
// // //               leftChevronIcon: Container(
// // //                 padding: const EdgeInsets.all(8),
// // //                 decoration: BoxDecoration(
// // //                   color: NeoSafeColors.lightPink.withOpacity(0.3),
// // //                   borderRadius: BorderRadius.circular(12),
// // //                 ),
// // //                 child: const Icon(
// // //                   Icons.chevron_left,
// // //                   color: NeoSafeColors.primaryPink,
// // //                 ),
// // //               ),
// // //               rightChevronIcon: Container(
// // //                 padding: const EdgeInsets.all(8),
// // //                 decoration: BoxDecoration(
// // //                   color: NeoSafeColors.lightPink.withOpacity(0.3),
// // //                   borderRadius: BorderRadius.circular(12),
// // //                 ),
// // //                 child: const Icon(
// // //                   Icons.chevron_right,
// // //                   color: NeoSafeColors.primaryPink,
// // //                 ),
// // //               ),
// // //             ),
// // //             calendarBuilders: CalendarBuilders(
// // //               defaultBuilder: (context, date, _) => _CalendarDayCell(
// // //                 date: date,
// // //                 controller: controller,
// // //               ),
// // //               dowBuilder: (context, day) {
// // //                 final dayNames = [
// // //                   'sun'.tr,
// // //                   'mon'.tr,
// // //                   'tue'.tr,
// // //                   'wed'.tr,
// // //                   'thu'.tr,
// // //                   'fri'.tr,
// // //                   'sat'.tr
// // //                 ];
// // //                 return Center(
// // //                   child: Text(
// // //                     dayNames[day.weekday % 7],
// // //                     style: TextStyle(
// // //                       color: NeoSafeColors.secondaryText,
// // //                       fontWeight: FontWeight.w500,
// // //                       fontSize: 12,
// // //                     ),
// // //                   ),
// // //                 );
// // //               },
// // //             ),
// // //           );
// // //         }),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // Separate widget for individual calendar day cells to prevent full calendar rebuild
// // // class _CalendarDayCell extends StatelessWidget {
// // //   final DateTime date;
// // //   final GetPregnantRequirementsController controller;

// // //   const _CalendarDayCell({
// // //     required this.date,
// // //     required this.controller,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Obx(() {
// // //       // Access reactive values here - only this cell rebuilds
// // //       final _ = controller.periodStart.value;
// // //       final __ = controller.cycleLength.value;
// // //       final ___ = controller.periodLength.value;
// // //       final ____ = controller.selectedDay.value;
// // //       final _____ = controller.intercourseLog.length; // Track changes

// // //       Widget? overlay;
// // //       Color? backgroundColor;
// // //       Color? borderColor;
// // //       List<BoxShadow>? shadows;
// // //       double borderWidth = 0;

// // //       if (controller.isPeriodDay(date)) {
// // //         backgroundColor = NeoSafeColors.error;
// // //         shadows = [
// // //           BoxShadow(
// // //             color: NeoSafeColors.error.withOpacity(0.4),
// // //             blurRadius: 8,
// // //             offset: const Offset(0, 2),
// // //           ),
// // //         ];
// // //       } else if (controller.isOvulationDay(date)) {
// // //         backgroundColor = NeoSafeColors.ovalutionDay;
// // //         borderColor = NeoSafeColors.ovalutionDay;
// // //         borderWidth = 2;
// // //         shadows = [
// // //           BoxShadow(
// // //             color: NeoSafeColors.ovalutionDay.withOpacity(0.5),
// // //             blurRadius: 12,
// // //             offset: const Offset(0, 4),
// // //           ),
// // //         ];
// // //         overlay = AnimatedBuilder(
// // //           animation: controller.pulseAnimation,
// // //           builder: (context, child) {
// // //             return Transform.scale(
// // //               scale: controller.pulseAnimation.value * 0.8,
// // //               child: const Icon(
// // //                 Icons.star,
// // //                 color: Colors.white,
// // //                 size: 8,
// // //               ),
// // //             );
// // //           },
// // //         );
// // //       } else if (controller.isFertileDay(date)) {
// // //         backgroundColor = NeoSafeColors.success;
// // //         shadows = [
// // //           BoxShadow(
// // //             color: NeoSafeColors.success.withOpacity(0.4),
// // //             blurRadius: 8,
// // //             offset: const Offset(0, 2),
// // //           ),
// // //         ];
// // //       }

// // //       bool isSelected = controller.selectedDay.value != null &&
// // //           controller.isSameDay(controller.selectedDay.value!, date);
// // //       if (isSelected && backgroundColor == null) {
// // //         backgroundColor = NeoSafeColors.primaryPink;
// // //         shadows = [
// // //           BoxShadow(
// // //             color: NeoSafeColors.primaryPink.withOpacity(0.4),
// // //             blurRadius: 8,
// // //             offset: const Offset(0, 2),
// // //           ),
// // //         ];
// // //       } else if (isSelected) {
// // //         borderColor = Colors.white;
// // //         borderWidth = 2;
// // //       }

// // //       bool isToday = controller.isSameDay(DateTime.now(), date);
// // //       if (isToday && backgroundColor == null) {
// // //         backgroundColor = NeoSafeColors.coralPink.withOpacity(0.7);
// // //         shadows = [
// // //           BoxShadow(
// // //             color: NeoSafeColors.coralPink.withOpacity(0.3),
// // //             blurRadius: 8,
// // //             offset: const Offset(0, 2),
// // //           ),
// // //         ];
// // //       }

// // //       return GestureDetector(
// // //         onTap: () {
// // //           controller.setSelectedDay(date);
// // //         },
// // //         child: Container(
// // //           margin: const EdgeInsets.all(4),
// // //           width: 36,
// // //           height: 36,
// // //           decoration: BoxDecoration(
// // //             color: backgroundColor ?? Colors.transparent,
// // //             shape: BoxShape.circle,
// // //             border: borderColor != null && borderWidth > 0
// // //                 ? Border.all(color: borderColor, width: borderWidth)
// // //                 : null,
// // //             boxShadow: shadows,
// // //           ),
// // //           child: Stack(
// // //             alignment: Alignment.center,
// // //             children: [
// // //               Text(
// // //                 '${date.day}',
// // //                 style: TextStyle(
// // //                   color: backgroundColor != null
// // //                       ? Colors.white
// // //                       : NeoSafeColors.primaryText,
// // //                   fontWeight: FontWeight.w600,
// // //                   fontSize: 14,
// // //                 ),
// // //               ),
// // //               if (overlay != null)
// // //                 Positioned(
// // //                   top: 4,
// // //                   right: 1,
// // //                   child: overlay,
// // //                 ),
// // //               if (controller.hasIntercourse(date))
// // //                 Positioned(
// // //                   bottom: 2,
// // //                   right: 2,
// // //                   child: Container(
// // //                     padding: const EdgeInsets.all(1),
// // //                     decoration: BoxDecoration(
// // //                       color: Colors.white.withOpacity(0.9),
// // //                       shape: BoxShape.circle,
// // //                     ),
// // //                     child: const Icon(
// // //                       Icons.favorite,
// // //                       color: NeoSafeColors.primaryPink,
// // //                       size: 8,
// // //                     ),
// // //                   ),
// // //                 ),
// // //             ],
// // //           ),
// // //         ),
// // //       );
// // //     });
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:table_calendar/table_calendar.dart';
// // import '../controllers/get_pregnant_requirements_controller.dart';
// // import 'package:babysafe/app/utils/neo_safe_theme.dart';

// // class CalendarWidget extends StatelessWidget {
// //   final GetPregnantRequirementsController controller;
// //   final ThemeData theme;

// //   const CalendarWidget({
// //     Key? key,
// //     required this.controller,
// //     required this.theme,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: NeoSafeColors.creamWhite,
// //         borderRadius: BorderRadius.circular(24),
// //         boxShadow: [
// //           BoxShadow(
// //             color: NeoSafeColors.softGray.withOpacity(0.3),
// //             blurRadius: 20,
// //             offset: const Offset(0, 8),
// //           ),
// //         ],
// //       ),
// //       child: ClipRRect(
// //         borderRadius: BorderRadius.circular(24),
// //         child: Obx(() {
// //           // CRITICAL: Only listen to focusedDay for navigation
// //           // Don't listen to period/cycle data here to prevent full rebuilds
// //           final focusedDay = controller.focusedDay.value;

// //           return TableCalendar(
// //             key: ValueKey(focusedDay.month), // Only rebuild when month changes
// //             firstDay: DateTime.utc(2020, 1, 1),
// //             lastDay: DateTime.utc(2030, 12, 31),
// //             focusedDay: focusedDay,

// //             // Don't use reactive selected day here - let cells handle it
// //             selectedDayPredicate: (day) => false, // Disable default selection

// //             onDaySelected: (selected, focused) {
// //               controller.setSelectedDay(selected);
// //             },

// //             calendarFormat: CalendarFormat.month,
// //             availableCalendarFormats: const {
// //               CalendarFormat.month: 'Month',
// //             },

// //             calendarStyle: CalendarStyle(
// //               outsideDaysVisible: false,
// //               weekendTextStyle: TextStyle(
// //                 color: NeoSafeColors.secondaryText,
// //                 fontWeight: FontWeight.w500,
// //               ),
// //               defaultTextStyle: TextStyle(
// //                 color: NeoSafeColors.primaryText,
// //                 fontWeight: FontWeight.w500,
// //               ),
// //             ),

// //             headerStyle: HeaderStyle(
// //               formatButtonVisible: false,
// //               titleCentered: true,
// //               titleTextStyle: theme.textTheme.headlineSmall!.copyWith(
// //                 fontWeight: FontWeight.w700,
// //                 color: NeoSafeColors.primaryText,
// //               ),
// //               titleTextFormatter: (date, locale) {
// //                 final monthNames = [
// //                   '',
// //                   'jan'.tr,
// //                   'feb'.tr,
// //                   'mar'.tr,
// //                   'apr'.tr,
// //                   'may'.tr,
// //                   'jun'.tr,
// //                   'jul'.tr,
// //                   'aug'.tr,
// //                   'sep'.tr,
// //                   'oct'.tr,
// //                   'nov'.tr,
// //                   'dec'.tr
// //                 ];
// //                 return '${monthNames[date.month]} ${date.year}';
// //               },
// //               leftChevronIcon: Container(
// //                 padding: const EdgeInsets.all(8),
// //                 decoration: BoxDecoration(
// //                   color: NeoSafeColors.lightPink.withOpacity(0.3),
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: const Icon(
// //                   Icons.chevron_left,
// //                   color: NeoSafeColors.primaryPink,
// //                 ),
// //               ),
// //               rightChevronIcon: Container(
// //                 padding: const EdgeInsets.all(8),
// //                 decoration: BoxDecoration(
// //                   color: NeoSafeColors.lightPink.withOpacity(0.3),
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: const Icon(
// //                   Icons.chevron_right,
// //                   color: NeoSafeColors.primaryPink,
// //                 ),
// //               ),
// //             ),

// //             calendarBuilders: CalendarBuilders(
// //               defaultBuilder: (context, date, _) => _CalendarDayCell(
// //                 key: ValueKey(date.toIso8601String()),
// //                 date: date,
// //                 controller: controller,
// //               ),
// //               dowBuilder: (context, day) {
// //                 final dayNames = [
// //                   'sun'.tr,
// //                   'mon'.tr,
// //                   'tue'.tr,
// //                   'wed'.tr,
// //                   'thu'.tr,
// //                   'fri'.tr,
// //                   'sat'.tr
// //                 ];
// //                 return Center(
// //                   child: Text(
// //                     dayNames[day.weekday % 7],
// //                     style: TextStyle(
// //                       color: NeoSafeColors.secondaryText,
// //                       fontWeight: FontWeight.w500,
// //                       fontSize: 12,
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           );
// //         }),
// //       ),
// //     );
// //   }
// // }

// // // OPTIMIZED: Use shouldRebuild to prevent unnecessary rebuilds
// // class _CalendarDayCell extends StatefulWidget {
// //   final DateTime date;
// //   final GetPregnantRequirementsController controller;

// //   const _CalendarDayCell({
// //     Key? key,
// //     required this.date,
// //     required this.controller,
// //   }) : super(key: key);

// //   @override
// //   State<_CalendarDayCell> createState() => _CalendarDayCellState();
// // }

// // class _CalendarDayCellState extends State<_CalendarDayCell> {
// //   // Cache computed values to avoid recalculating on every rebuild
// //   bool? _cachedIsPeriod;
// //   bool? _cachedIsFertile;
// //   bool? _cachedIsOvulation;
// //   bool? _cachedIsSelected;
// //   bool? _cachedHasIntercourse;
// //   DateTime? _lastPeriodStart;
// //   int? _lastCycleLength;
// //   int? _lastPeriodLength;

// //   bool _needsRecalculation() {
// //     return _lastPeriodStart != widget.controller.periodStart.value ||
// //         _lastCycleLength != widget.controller.cycleLength.value ||
// //         _lastPeriodLength != widget.controller.periodLength.value;
// //   }

// //   void _recalculateValues() {
// //     _lastPeriodStart = widget.controller.periodStart.value;
// //     _lastCycleLength = widget.controller.cycleLength.value;
// //     _lastPeriodLength = widget.controller.periodLength.value;

// //     _cachedIsPeriod = widget.controller.isPeriodDay(widget.date);
// //     _cachedIsFertile = widget.controller.isFertileDay(widget.date);
// //     _cachedIsOvulation = widget.controller.isOvulationDay(widget.date);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Obx(() {
// //       // Only recalculate if dependencies changed
// //       if (_needsRecalculation()) {
// //         _recalculateValues();
// //       }

// //       // Always check these as they can change independently
// //       _cachedIsSelected = widget.controller.selectedDay.value != null &&
// //           widget.controller
// //               .isSameDay(widget.controller.selectedDay.value!, widget.date);
// //       _cachedHasIntercourse = widget.controller.hasIntercourse(widget.date);

// //       Widget? overlay;
// //       Color? backgroundColor;
// //       Color? borderColor;
// //       List<BoxShadow>? shadows;
// //       double borderWidth = 0;

// //       if (_cachedIsPeriod == true) {
// //         backgroundColor = NeoSafeColors.error;
// //         shadows = [
// //           BoxShadow(
// //             color: NeoSafeColors.error.withOpacity(0.4),
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ];
// //       } else if (_cachedIsOvulation == true) {
// //         backgroundColor = NeoSafeColors.ovalutionDay;
// //         borderColor = NeoSafeColors.ovalutionDay;
// //         borderWidth = 2;
// //         shadows = [
// //           BoxShadow(
// //             color: NeoSafeColors.ovalutionDay.withOpacity(0.5),
// //             blurRadius: 12,
// //             offset: const Offset(0, 4),
// //           ),
// //         ];
// //         overlay = AnimatedBuilder(
// //           animation: widget.controller.pulseAnimation,
// //           builder: (context, child) {
// //             return Transform.scale(
// //               scale: widget.controller.pulseAnimation.value * 0.8,
// //               child: const Icon(
// //                 Icons.star,
// //                 color: Colors.white,
// //                 size: 8,
// //               ),
// //             );
// //           },
// //         );
// //       } else if (_cachedIsFertile == true) {
// //         backgroundColor = NeoSafeColors.success;
// //         shadows = [
// //           BoxShadow(
// //             color: NeoSafeColors.success.withOpacity(0.4),
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ];
// //       }

// //       if (_cachedIsSelected == true && backgroundColor == null) {
// //         backgroundColor = NeoSafeColors.primaryPink;
// //         shadows = [
// //           BoxShadow(
// //             color: NeoSafeColors.primaryPink.withOpacity(0.4),
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ];
// //       } else if (_cachedIsSelected == true) {
// //         borderColor = Colors.white;
// //         borderWidth = 2;
// //       }

// //       bool isToday = widget.controller.isSameDay(DateTime.now(), widget.date);
// //       if (isToday && backgroundColor == null) {
// //         backgroundColor = NeoSafeColors.coralPink.withOpacity(0.7);
// //         shadows = [
// //           BoxShadow(
// //             color: NeoSafeColors.coralPink.withOpacity(0.3),
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ];
// //       }

// //       return GestureDetector(
// //         onTap: () {
// //           widget.controller.setSelectedDay(widget.date);
// //         },
// //         child: Container(
// //           margin: const EdgeInsets.all(4),
// //           width: 36,
// //           height: 36,
// //           decoration: BoxDecoration(
// //             color: backgroundColor ?? Colors.transparent,
// //             shape: BoxShape.circle,
// //             border: borderColor != null && borderWidth > 0
// //                 ? Border.all(color: borderColor, width: borderWidth)
// //                 : null,
// //             boxShadow: shadows,
// //           ),
// //           child: Stack(
// //             alignment: Alignment.center,
// //             children: [
// //               Text(
// //                 '${widget.date.day}',
// //                 style: TextStyle(
// //                   color: backgroundColor != null
// //                       ? Colors.white
// //                       : NeoSafeColors.primaryText,
// //                   fontWeight: FontWeight.w600,
// //                   fontSize: 14,
// //                 ),
// //               ),
// //               if (overlay != null)
// //                 Positioned(
// //                   top: 4,
// //                   right: 1,
// //                   child: overlay,
// //                 ),
// //               if (_cachedHasIntercourse == true)
// //                 Positioned(
// //                   bottom: 2,
// //                   right: 2,
// //                   child: Container(
// //                     padding: const EdgeInsets.all(1),
// //                     decoration: BoxDecoration(
// //                       color: Colors.white.withOpacity(0.9),
// //                       shape: BoxShape.circle,
// //                     ),
// //                     child: const Icon(
// //                       Icons.favorite,
// //                       color: NeoSafeColors.primaryPink,
// //                       size: 8,
// //                     ),
// //                   ),
// //                 ),
// //             ],
// //           ),
// //         ),
// //       );
// //     });
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:table_calendar/table_calendar.dart';
// import '../controllers/get_pregnant_requirements_controller.dart';
// import 'package:babysafe/app/utils/neo_safe_theme.dart';

// class CalendarWidget extends StatelessWidget {
//   final GetPregnantRequirementsController controller;
//   final ThemeData theme;

//   const CalendarWidget({
//     Key? key,
//     required this.controller,
//     required this.theme,
//   }) : super(key: key);

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
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(24),
//         child: Obx(() {
//           // Only listen to focusedDay for month navigation
//           final focusedDay = controller.focusedDay.value;

//           // Create a unique key based on month to limit rebuilds
//           final monthKey = '${focusedDay.year}-${focusedDay.month}';

//           return TableCalendar(
//             key: ValueKey(monthKey),
//             firstDay: DateTime.utc(2020, 1, 1),
//             lastDay: DateTime.utc(2030, 12, 31),
//             focusedDay: focusedDay,

//             // Disable default selection styling
//             selectedDayPredicate: (day) => false,

//             onDaySelected: (selected, focused) {
//               controller.setSelectedDay(selected);
//             },

//             calendarFormat: CalendarFormat.month,
//             availableCalendarFormats: const {
//               CalendarFormat.month: 'Month',
//             },

//             calendarStyle: CalendarStyle(
//               outsideDaysVisible: false,
//               weekendTextStyle: TextStyle(
//                 color: NeoSafeColors.secondaryText,
//                 fontWeight: FontWeight.w500,
//               ),
//               defaultTextStyle: TextStyle(
//                 color: NeoSafeColors.primaryText,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),

//             headerStyle: HeaderStyle(
//               formatButtonVisible: false,
//               titleCentered: true,
//               titleTextStyle: theme.textTheme.headlineSmall!.copyWith(
//                 fontWeight: FontWeight.w700,
//                 color: NeoSafeColors.primaryText,
//               ),
//               titleTextFormatter: (date, locale) {
//                 final monthNames = [
//                   '',
//                   'jan'.tr,
//                   'feb'.tr,
//                   'mar'.tr,
//                   'apr'.tr,
//                   'may'.tr,
//                   'jun'.tr,
//                   'jul'.tr,
//                   'aug'.tr,
//                   'sep'.tr,
//                   'oct'.tr,
//                   'nov'.tr,
//                   'dec'.tr
//                 ];
//                 return '${monthNames[date.month]} ${date.year}';
//               },
//               leftChevronIcon: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: NeoSafeColors.lightPink.withOpacity(0.3),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(
//                   Icons.chevron_left,
//                   color: NeoSafeColors.primaryPink,
//                 ),
//               ),
//               rightChevronIcon: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: NeoSafeColors.lightPink.withOpacity(0.3),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(
//                   Icons.chevron_right,
//                   color: NeoSafeColors.primaryPink,
//                 ),
//               ),
//             ),

//             calendarBuilders: CalendarBuilders(
//               defaultBuilder: (context, date, _) => _CalendarDayCell(
//                 key: ValueKey('${date.toIso8601String()}-$monthKey'),
//                 date: date,
//                 controller: controller,
//               ),
//               dowBuilder: (context, day) {
//                 final dayNames = [
//                   'sun'.tr,
//                   'mon'.tr,
//                   'tue'.tr,
//                   'wed'.tr,
//                   'thu'.tr,
//                   'fri'.tr,
//                   'sat'.tr
//                 ];
//                 return Center(
//                   child: Text(
//                     dayNames[day.weekday % 7],
//                     style: TextStyle(
//                       color: NeoSafeColors.secondaryText,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 12,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

// // Optimized calendar day cell with minimal reactive dependencies
// class _CalendarDayCell extends StatefulWidget {
//   final DateTime date;
//   final GetPregnantRequirementsController controller;

//   const _CalendarDayCell({
//     Key? key,
//     required this.date,
//     required this.controller,
//   }) : super(key: key);

//   @override
//   State<_CalendarDayCell> createState() => _CalendarDayCellState();
// }

// class _CalendarDayCellState extends State<_CalendarDayCell> {
//   // Cache computed values with their dependencies
//   DateTime? _lastPeriodStart;
//   int? _lastCycleLength;
//   int? _lastPeriodLength;
//   DateTime? _lastSelectedDay;
//   int? _lastIntercourseCount;

//   // Cached display values
//   bool _isPeriod = false;
//   bool _isFertile = false;
//   bool _isOvulation = false;
//   bool _isSelected = false;
//   bool _hasIntercourse = false;

//   @override
//   void initState() {
//     super.initState();
//     _computeValues();
//   }

//   // Efficiently check if we need to recalculate
//   bool _needsUpdate() {
//     return _lastPeriodStart != widget.controller.periodStart.value ||
//         _lastCycleLength != widget.controller.cycleLength.value ||
//         _lastPeriodLength != widget.controller.periodLength.value ||
//         _lastSelectedDay != widget.controller.selectedDay.value ||
//         _lastIntercourseCount != widget.controller.intercourseLog.length;
//   }

//   // Compute all display values at once
//   void _computeValues() {
//     _lastPeriodStart = widget.controller.periodStart.value;
//     _lastCycleLength = widget.controller.cycleLength.value;
//     _lastPeriodLength = widget.controller.periodLength.value;
//     _lastSelectedDay = widget.controller.selectedDay.value;
//     _lastIntercourseCount = widget.controller.intercourseLog.length;

//     // Only compute if period start is set
//     if (_lastPeriodStart != null) {
//       _isPeriod = widget.controller.isPeriodDay(widget.date);
//       _isFertile = widget.controller.isFertileDay(widget.date);
//       _isOvulation = widget.controller.isOvulationDay(widget.date);
//     } else {
//       _isPeriod = false;
//       _isFertile = false;
//       _isOvulation = false;
//     }

//     _isSelected = _lastSelectedDay != null &&
//         widget.controller.isSameDay(_lastSelectedDay!, widget.date);
//     _hasIntercourse = widget.controller.hasIntercourse(widget.date);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       // Check if update is needed (accessing reactive values)
//       if (_needsUpdate()) {
//         _computeValues();
//       }

//       // Build UI based on cached values
//       Widget? overlay;
//       Color? backgroundColor;
//       Color? borderColor;
//       List<BoxShadow>? shadows;
//       double borderWidth = 0;

//       if (_isPeriod) {
//         backgroundColor = NeoSafeColors.error;
//         shadows = [
//           BoxShadow(
//             color: NeoSafeColors.error.withOpacity(0.4),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ];
//       } else if (_isOvulation) {
//         backgroundColor = NeoSafeColors.ovalutionDay;
//         borderColor = NeoSafeColors.ovalutionDay;
//         borderWidth = 2;
//         shadows = [
//           BoxShadow(
//             color: NeoSafeColors.ovalutionDay.withOpacity(0.5),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ];
//         overlay = AnimatedBuilder(
//           animation: widget.controller.pulseAnimation,
//           builder: (context, child) {
//             return Transform.scale(
//               scale: widget.controller.pulseAnimation.value * 0.8,
//               child: const Icon(
//                 Icons.star,
//                 color: Colors.white,
//                 size: 8,
//               ),
//             );
//           },
//         );
//       } else if (_isFertile) {
//         backgroundColor = NeoSafeColors.success;
//         shadows = [
//           BoxShadow(
//             color: NeoSafeColors.success.withOpacity(0.4),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ];
//       }

//       if (_isSelected && backgroundColor == null) {
//         backgroundColor = NeoSafeColors.primaryPink;
//         shadows = [
//           BoxShadow(
//             color: NeoSafeColors.primaryPink.withOpacity(0.4),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ];
//       } else if (_isSelected) {
//         borderColor = Colors.white;
//         borderWidth = 2;
//       }

//       bool isToday = widget.controller.isSameDay(DateTime.now(), widget.date);
//       if (isToday && backgroundColor == null) {
//         backgroundColor = NeoSafeColors.coralPink.withOpacity(0.7);
//         shadows = [
//           BoxShadow(
//             color: NeoSafeColors.coralPink.withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ];
//       }

//       return GestureDetector(
//         onTap: () {
//           widget.controller.setSelectedDay(widget.date);
//         },
//         child: Container(
//           margin: const EdgeInsets.all(4),
//           width: 36,
//           height: 36,
//           decoration: BoxDecoration(
//             color: backgroundColor ?? Colors.transparent,
//             shape: BoxShape.circle,
//             border: borderColor != null && borderWidth > 0
//                 ? Border.all(color: borderColor, width: borderWidth)
//                 : null,
//             boxShadow: shadows,
//           ),
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Text(
//                 '${widget.date.day}',
//                 style: TextStyle(
//                   color: backgroundColor != null
//                       ? Colors.white
//                       : NeoSafeColors.primaryText,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 14,
//                 ),
//               ),
//               if (overlay != null)
//                 Positioned(
//                   top: 4,
//                   right: 1,
//                   child: overlay,
//                 ),
//               if (_hasIntercourse)
//                 Positioned(
//                   bottom: 2,
//                   right: 2,
//                   child: Container(
//                     padding: const EdgeInsets.all(1),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.9),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.favorite,
//                       color: NeoSafeColors.primaryPink,
//                       size: 8,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/get_pregnant_requirements_controller.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';

class CalendarWidget extends StatelessWidget {
  final GetPregnantRequirementsController controller;
  final ThemeData theme;

  const CalendarWidget({
    Key? key,
    required this.controller,
    required this.theme,
  }) : super(key: key);

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Obx(() {
          // Only listen to focusedDay for month navigation
          final focusedDay = controller.focusedDay.value;

          // Create a unique key based on month to limit rebuilds
          final monthKey = '${focusedDay.year}-${focusedDay.month}';

          return TableCalendar(
            key: ValueKey(monthKey),
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: focusedDay,

            // Disable default selection styling
            selectedDayPredicate: (day) => false,

            onDaySelected: (selected, focused) {
              controller.setSelectedDay(selected);
            },

            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },

            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle: TextStyle(
                color: NeoSafeColors.secondaryText,
                fontWeight: FontWeight.w500,
              ),
              defaultTextStyle: TextStyle(
                color: NeoSafeColors.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),

            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: theme.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w700,
                color: NeoSafeColors.primaryText,
              ),
              titleTextFormatter: (date, locale) {
                final monthNames = [
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
                return '${monthNames[date.month]} ${date.year}';
              },
              leftChevronIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: NeoSafeColors.lightPink.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.chevron_left,
                  color: NeoSafeColors.primaryPink,
                ),
              ),
              rightChevronIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: NeoSafeColors.lightPink.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.chevron_right,
                  color: NeoSafeColors.primaryPink,
                ),
              ),
            ),

            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, _) => _CalendarDayCell(
                key: ValueKey('${date.toIso8601String()}-$monthKey'),
                date: date,
                controller: controller,
              ),
              dowBuilder: (context, day) {
                final dayNames = [
                  'sun'.tr,
                  'mon'.tr,
                  'tue'.tr,
                  'wed'.tr,
                  'thu'.tr,
                  'fri'.tr,
                  'sat'.tr
                ];
                return Center(
                  child: Text(
                    dayNames[day.weekday % 7],
                    style: TextStyle(
                      color: NeoSafeColors.secondaryText,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

// Optimized calendar day cell with minimal reactive dependencies
class _CalendarDayCell extends StatefulWidget {
  final DateTime date;
  final GetPregnantRequirementsController controller;

  const _CalendarDayCell({
    Key? key,
    required this.date,
    required this.controller,
  }) : super(key: key);

  @override
  State<_CalendarDayCell> createState() => _CalendarDayCellState();
}

class _CalendarDayCellState extends State<_CalendarDayCell> {
  // Cache computed values with their dependencies
  DateTime? _lastPeriodStart;
  int? _lastCycleLength;
  int? _lastPeriodLength;
  DateTime? _lastSelectedDay;
  int? _lastIntercourseCount;

  // Cached display values
  bool _isPeriod = false;
  bool _isFertile = false;
  bool _isOvulation = false;
  bool _isSelected = false;
  bool _hasIntercourse = false;

  // Add flag to prevent computation during rebuild storms
  bool _isComputing = false;

  @override
  void initState() {
    super.initState();
    _computeValuesIfNeeded();
  }

  // Efficiently check if we need to recalculate
  bool _needsUpdate() {
    return _lastPeriodStart != widget.controller.periodStart.value ||
        _lastCycleLength != widget.controller.cycleLength.value ||
        _lastPeriodLength != widget.controller.periodLength.value ||
        _lastSelectedDay != widget.controller.selectedDay.value ||
        _lastIntercourseCount != widget.controller.intercourseLog.length;
  }

  // Compute all display values at once with guard
  void _computeValuesIfNeeded() {
    if (_isComputing) return;
    _isComputing = true;

    try {
      _lastPeriodStart = widget.controller.periodStart.value;
      _lastCycleLength = widget.controller.cycleLength.value;
      _lastPeriodLength = widget.controller.periodLength.value;
      _lastSelectedDay = widget.controller.selectedDay.value;
      _lastIntercourseCount = widget.controller.intercourseLog.length;

      // Only compute if period start is set
      if (_lastPeriodStart != null) {
        _isPeriod = _computeIsPeriodDay();
        _isFertile = _computeIsFertileDay();
        _isOvulation = _computeIsOvulationDay();
      } else {
        _isPeriod = false;
        _isFertile = false;
        _isOvulation = false;
      }

      _isSelected = _lastSelectedDay != null &&
          _isSameDayStatic(_lastSelectedDay!, widget.date);
      _hasIntercourse = _computeHasIntercourse();
    } finally {
      _isComputing = false;
    }
  }

  // Local computation methods to avoid controller method calls
  bool _computeIsPeriodDay() {
    if (_lastPeriodStart == null || _lastPeriodLength == null) return false;

    for (int i = 0; i < _lastPeriodLength!; i++) {
      final periodDay = _lastPeriodStart!.add(Duration(days: i));
      if (_isSameDayStatic(periodDay, widget.date)) {
        return true;
      }
    }
    return false;
  }

  bool _computeIsFertileDay() {
    if (_lastPeriodStart == null || _lastCycleLength == null) return false;

    final ovulation =
        _lastPeriodStart!.add(Duration(days: _lastCycleLength! - 14));

    for (int i = 0; i < 7; i++) {
      final fertileDay = ovulation.subtract(Duration(days: 5 - i));
      if (_isSameDayStatic(fertileDay, widget.date)) {
        return true;
      }
    }
    return false;
  }

  bool _computeIsOvulationDay() {
    if (_lastPeriodStart == null || _lastCycleLength == null) return false;

    final ovulation =
        _lastPeriodStart!.add(Duration(days: _lastCycleLength! - 14));
    return _isSameDayStatic(ovulation, widget.date);
  }

  bool _computeHasIntercourse() {
    for (final date in widget.controller.intercourseLog) {
      if (_isSameDayStatic(date, widget.date)) {
        return true;
      }
    }
    return false;
  }

  // Static helper to avoid controller method calls
  static bool _isSameDayStatic(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Check if update is needed (accessing reactive values)
      if (_needsUpdate()) {
        _computeValuesIfNeeded();
      }

      // Build UI based on cached values
      Widget? overlay;
      Color? backgroundColor;
      Color? borderColor;
      List<BoxShadow>? shadows;
      double borderWidth = 0;

      if (_isPeriod) {
        backgroundColor = NeoSafeColors.error;
        shadows = [
          BoxShadow(
            color: NeoSafeColors.error.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];
      } else if (_isOvulation) {
        backgroundColor = NeoSafeColors.ovalutionDay;
        borderColor = NeoSafeColors.ovalutionDay;
        borderWidth = 2;
        shadows = [
          BoxShadow(
            color: NeoSafeColors.ovalutionDay.withOpacity(0.5),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ];
        overlay = AnimatedBuilder(
          animation: widget.controller.pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: widget.controller.pulseAnimation.value * 0.8,
              child: const Icon(
                Icons.star,
                color: Colors.white,
                size: 8,
              ),
            );
          },
        );
      } else if (_isFertile) {
        backgroundColor = NeoSafeColors.success;
        shadows = [
          BoxShadow(
            color: NeoSafeColors.success.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];
      }

      if (_isSelected && backgroundColor == null) {
        backgroundColor = NeoSafeColors.primaryPink;
        shadows = [
          BoxShadow(
            color: NeoSafeColors.primaryPink.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];
      } else if (_isSelected) {
        borderColor = Colors.white;
        borderWidth = 2;
      }

      bool isToday = _isSameDayStatic(DateTime.now(), widget.date);
      if (isToday && backgroundColor == null) {
        backgroundColor = NeoSafeColors.coralPink.withOpacity(0.7);
        shadows = [
          BoxShadow(
            color: NeoSafeColors.coralPink.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];
      }

      return GestureDetector(
        onTap: () {
          widget.controller.setSelectedDay(widget.date);
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.transparent,
            shape: BoxShape.circle,
            border: borderColor != null && borderWidth > 0
                ? Border.all(color: borderColor, width: borderWidth)
                : null,
            boxShadow: shadows,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '${widget.date.day}',
                style: TextStyle(
                  color: backgroundColor != null
                      ? Colors.white
                      : NeoSafeColors.primaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              if (overlay != null)
                Positioned(
                  top: 4,
                  right: 1,
                  child: overlay,
                ),
              if (_hasIntercourse)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: NeoSafeColors.primaryPink,
                      size: 8,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
