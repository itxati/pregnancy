import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import '../controllers/weekly_details_controller.dart';

class WeeklyDetailsHeader extends StatelessWidget {
  final WeeklyDetailsController controller;

  const WeeklyDetailsHeader({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final currentWeek = controller.currentWeek.value;

      return Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: 220,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              child: Image.asset(
                'assets/Safe/week$currentWeek.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: NeoSafeColors.creamWhite,
                ),
              ),
            ),
          ),

          // Dark overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),

          // Navigation and header content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.white.withOpacity(0.2),
                  //     shape: BoxShape.circle,
                  //   ),
                  //   child: IconButton(
                  //     icon: const Icon(Icons.person, color: Colors.white),
                  //     onPressed: () {},
                  //   ),
                  // ),
                ],
              ),
            ),
          ),

          // Week title and subtitle
          Positioned(
            left: 24,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'weeks_pregnant'.trParams({'week': '$currentWeek'}),
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 6),
                // Text(
                //   weekData.whatsHappening ?? "Baby Development",
                //   style: theme.textTheme.titleLarge?.copyWith(
                //     color: Colors.white.withOpacity(0.95),
                //     fontWeight: FontWeight.w600,
                //     shadows: [
                //       Shadow(
                //         color: Colors.black.withOpacity(0.4),
                //         blurRadius: 4,
                //         offset: const Offset(0, 2),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
