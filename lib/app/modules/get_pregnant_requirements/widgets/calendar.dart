import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/get_pregnant_requirements_controller.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';

class CalendarWidget extends StatelessWidget {
  final GetPregnantRequirementsController controller;
  final ThemeData theme;
  const CalendarWidget(
      {Key? key, required this.controller, required this.theme})
      : super(key: key);

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
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: controller.focusedDay.value,
          selectedDayPredicate: (day) =>
              controller.selectedDay.value != null &&
              controller.isSameDay(controller.selectedDay.value!, day),
          onDaySelected: (selected, focused) {
            controller.setSelectedDay(selected);
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
            todayDecoration: BoxDecoration(
              color: NeoSafeColors.coralPink.withOpacity(0.7),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: NeoSafeColors.coralPink.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            selectedDecoration: BoxDecoration(
              color: NeoSafeColors.primaryPink,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: NeoSafeColors.primaryPink.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            markerDecoration: const BoxDecoration(
              color: NeoSafeColors.roseAccent,
              shape: BoxShape.circle,
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
                '', 'jan'.tr, 'feb'.tr, 'mar'.tr, 'apr'.tr, 'may'.tr, 'jun'.tr,
                'jul'.tr, 'aug'.tr, 'sep'.tr, 'oct'.tr, 'nov'.tr, 'dec'.tr
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
            defaultBuilder: (context, date, _) =>
                _buildCalendarDay(context, date, controller),
            dowBuilder: (context, day) {
              final dayNames = [
                'sun'.tr, 'mon'.tr, 'tue'.tr, 'wed'.tr, 'thu'.tr, 'fri'.tr, 'sat'.tr
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
        ),
      ),
    );
  }

  Widget _buildCalendarDay(BuildContext context, DateTime date,
      GetPregnantRequirementsController controller) {
    Widget? overlay;
    Color? backgroundColor;
    Color? borderColor;
    List<BoxShadow>? shadows;
    double borderWidth = 0;

    if (controller.isPeriodDay(date)) {
      backgroundColor = NeoSafeColors.error;
      shadows = [
        BoxShadow(
          color: NeoSafeColors.error.withOpacity(0.4),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
    } else if (controller.isOvulationDay(date)) {
      backgroundColor = NeoSafeColors.warning;
      borderColor = const Color(0xFFFF9800);
      borderWidth = 2;
      shadows = [
        BoxShadow(
          color: NeoSafeColors.warning.withOpacity(0.5),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
      overlay = AnimatedBuilder(
        animation: controller.pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: controller.pulseAnimation.value * 0.8,
            child: const Icon(
              Icons.star,
              color: Color(0xFFFF6F00),
              size: 8,
            ),
          );
        },
      );
    } else if (controller.isFertileDay(date)) {
      backgroundColor = NeoSafeColors.success;
      shadows = [
        BoxShadow(
          color: NeoSafeColors.success.withOpacity(0.4),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
    }

    bool isSelected = controller.selectedDay.value != null &&
        controller.isSameDay(controller.selectedDay.value!, date);
    if (isSelected && backgroundColor == null) {
      backgroundColor = NeoSafeColors.primaryPink;
      shadows = [
        BoxShadow(
          color: NeoSafeColors.primaryPink.withOpacity(0.4),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
    } else if (isSelected) {
      borderColor = Colors.white;
      borderWidth = 2;
    }

    bool isToday = controller.isSameDay(DateTime.now(), date);
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
        controller.setSelectedDay(date);
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
              '${date.day}',
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
            if (controller.hasIntercourse(date))
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
  }
}
