// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:babysafe/app/utils/neo_safe_theme.dart';
// import '../controllers/track_my_pregnancy_controller.dart';
// import '../views/weekly_details_page.dart';

// class WeeklyUpdateCard extends StatelessWidget {
//   final TrackMyPregnancyController controller;

//   const WeeklyUpdateCard({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => GestureDetector(
//           onTap: () {
//             // Navigate to weekly details page with current pregnancy week
//             Get.to(() => WeeklyDetailsPage(
//                 currentWeek: controller.pregnancyWeekNumber.value));
//           },
//           child: Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xFFFCE4EC),
//                   Color(0xFFF8BBD9).withOpacity(0.7),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFFEC407A).withOpacity(0.1),
//                   blurRadius: 15,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Stack(
//               children: [
//                 // Sprinkles image as full background
//                 Positioned.fill(
//                   child: Image.asset(
//                     'assets/logos/sprinkels.png',
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) => Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Color(0xFFFCE4EC),
//                             Color(0xFFF8BBD9).withOpacity(0.7),
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Centered text content
//                 Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         "${controller.pregnancyWeekNumber.value}",
//                         style:
//                             Theme.of(context).textTheme.displayLarge?.copyWith(
//                                   color: NeoSafeColors.primaryPink,
//                                   fontWeight: FontWeight.w900,
//                                   fontSize: 48,
//                                 ),
//                       ),
//                       Text(
//                         "WEEKS",
//                         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                               color: NeoSafeColors.primaryPink,
//                               fontWeight: FontWeight.w700,
//                               letterSpacing: 2,
//                             ),
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         "Your weekly update",
//                         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                               color: const Color(
//                                   0xFF3D2929), // NeoSafeColors.primaryText
//                               fontWeight: FontWeight.w500,
//                             ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   top: 0,
//                   right: 0,
//                   child: Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFEC407A),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: const Text(
//                       "Open",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import 'package:babysafe/app/services/theme_service.dart';
import '../controllers/track_my_pregnancy_controller.dart';
import '../views/weekly_details_page.dart';

class WeeklyUpdateCard extends StatelessWidget {
  final TrackMyPregnancyController controller;

  const WeeklyUpdateCard({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    return Obx(() => GestureDetector(
          onTap: () {
            // Navigate to weekly details page with current pregnancy week
            Get.to(() => WeeklyDetailsPage(
                currentWeek: controller.pregnancyWeekNumber.value));
          },
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  themeService.getPaleColor(),
                  themeService.getLightColor().withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: themeService.getPrimaryColor().withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Sprinkles image as subtle background
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.20, // Very subtle background
                    child: Image.asset(
                      'assets/logos/sprinkels.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(),
                    ),
                  ),
                ),
                // Centered text content with improved visibility
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Week number - clean and bold
                      Text(
                        "${controller.pregnancyWeekNumber.value}",
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: themeService.getPrimaryColor(),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 48,
                                ),
                      ),
                      // "WEEKS" text
                      Text(
                        "WEEKS",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: themeService.getPrimaryColor(),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                      ),
                      const SizedBox(height: 12),
                      // Simple description text
                      Text(
                        "Your weekly update",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: themeService.getPrimaryColor(),
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                ),
                // Clean "Open" button
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: themeService.getPrimaryColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Open",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
