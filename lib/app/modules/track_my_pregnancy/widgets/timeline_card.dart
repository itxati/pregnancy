import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/track_my_pregnancy_controller.dart';
import '../../timeline/controllers/timeline_controller.dart';
import '../../timeline/views/timeline_view.dart';

class TimelineCard extends StatelessWidget {
  final TrackMyPregnancyController controller;

  const TimelineCard({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('TimelineCard is being built');
    return GestureDetector(
      onTap: () {
        // print('Navigating to timeline page...');
        // Get.put(TimelineController());
        // Get.to(() => const TimelineView());
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFAFA), // NeoSafeColors.creamWhite
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFE8A5A5)
                .withOpacity(0.1), // NeoSafeColors.primaryPink
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE8A5A5)
                  .withOpacity(0.1), // NeoSafeColors.primaryPink
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
                    "Your timeline",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(
                              0xFF3D2929), // NeoSafeColors.primaryText
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.getTimelineSubtitle(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(
                              0xFF6B5555), // NeoSafeColors.secondaryText
                        ),
                  ),
                  const SizedBox(height: 16),
                  // Timeline visualization with maternal colors
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFE8A5A5), // NeoSafeColors.primaryPink
                              Color(0xFFF2C2C2), // NeoSafeColors.lightPink
                            ],
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 60,
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFD4A5A5), // NeoSafeColors.roseAccent
                              Color(0xFFFFB3BA), // NeoSafeColors.coralPink
                            ],
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 40,
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFE8C5E8), // NeoSafeColors.lavenderPink
                              Color(0xFFF0E5F0), // NeoSafeColors.softLavender
                            ],
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.all(8),
            //   decoration: BoxDecoration(
            //     color: const Color(0xFFFAE8E8), // NeoSafeColors.palePink
            //     shape: BoxShape.circle,
            //   ),
            //   child: const Icon(
            //     Icons.arrow_forward_ios,
            //     color: Color(0xFFE8A5A5), // NeoSafeColors.primaryPink
            //     size: 16,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
