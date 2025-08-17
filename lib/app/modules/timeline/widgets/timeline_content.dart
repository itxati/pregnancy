import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/neo_safe_theme.dart';
import '../controllers/timeline_controller.dart';
import 'timeline_card.dart';
import 'timeline_marker.dart';

class TimelineContent extends StatelessWidget {
  final TimelineController controller;

  const TimelineContent({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            // Central Timeline Line
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 1,
              top: 0,
              bottom: 0,
              child: Container(
                width: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      NeoSafeColors.primaryPink,
                      NeoSafeColors.primaryPink.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),

            // Timeline Content
            ListView.builder(
              controller: controller.scrollController,
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: 40,
              itemBuilder: (context, index) {
                final isLeft = index % 2 == 0;
                final weekNumber = index + 1;
                final isCurrentWeek =
                    weekNumber == controller.currentWeek.value;
                final weekData = controller.getWeekData(weekNumber);

                return _buildTimelineItem(
                  weekNumber,
                  isLeft,
                  isCurrentWeek,
                  weekData,
                );
              },
            ),
          ],
        ));
  }

  Widget _buildTimelineItem(
    int week,
    bool isLeft,
    bool isCurrentWeek,
    Map<String, dynamic> weekData,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Row(
        children: [
          // Left side content
          if (isLeft) ...[
            Expanded(
              child: TimelineCard(
                controller: controller,
                week: week,
                weekData: weekData,
                isCurrentWeek: isCurrentWeek,
              ),
            ),
            const SizedBox(width: 20),
            // Timeline marker
            TimelineMarker(
              color: weekData['color'],
              icon: weekData['icon'],
            ),
            const SizedBox(width: 20),
            // Empty space for right side
            const Expanded(child: SizedBox()),
          ] else ...[
            // Empty space for left side
            const Expanded(child: SizedBox()),
            const SizedBox(width: 20),
            // Timeline marker
            TimelineMarker(
              color: weekData['color'],
              icon: weekData['icon'],
            ),
            const SizedBox(width: 20),
            // Right side content
            Expanded(
              child: TimelineCard(
                controller: controller,
                week: week,
                weekData: weekData,
                isCurrentWeek: isCurrentWeek,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
