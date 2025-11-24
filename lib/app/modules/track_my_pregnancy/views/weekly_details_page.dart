import 'dart:io';

import 'package:babysafe/app/data/models/pregnancy_weeks.dart';
import 'package:babysafe/app/modules/get_pregnant_requirements/widgets/go_to_home.dart';
import 'package:babysafe/app/modules/track_my_pregnancy/views/track_my_pregnancy_profile_view.dart';
import 'package:babysafe/app/modules/track_my_pregnancy/views/track_my_pregnancy_view.dart';
import 'package:babysafe/app/modules/track_my_pregnancy/widgets/main_pregnancy_card.dart';
import 'package:babysafe/app/services/auth_service.dart';
import 'package:babysafe/app/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import '../controllers/weekly_details_controller.dart';
import '../bindings/weekly_details_binding.dart';
import '../widgets/weekly_details_content.dart';
import '../widgets/weekly_details_week_selector.dart';
import '../controllers/track_my_pregnancy_controller.dart';

class WeeklyDetailsPage extends StatelessWidget {
  final int? currentWeek;

  const WeeklyDetailsPage({Key? key, this.currentWeek}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize binding
    WeeklyDetailsBinding().dependencies();
    final controller = Get.find<WeeklyDetailsController>();
    final pregnancyController = Get.find<TrackMyPregnancyController>();
    final themeService = Get.find<ThemeService>();

    final initialWeek =
        (currentWeek ?? pregnancyController.pregnancyWeekNumber.value)
            .clamp(1, pregnancyWeeks.length);

    // Initialize controller with current week
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialize(initialWeek);
    });

    // final isEnglish = (Get.locale?.languageCode ?? 'en').startsWith('en');
    // final horizontalMargin = EdgeInsets.only(
    //   left: isEnglish ? 0 : 2,
    //   right: isEnglish ? 2 : 0,
    // );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: NeoSafeGradients.backgroundGradient,
        ),
        child: CustomScrollView(
          slivers: [
            // Header with image and overlay
            SliverAppBar(
              expandedHeight: 100.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: const SizedBox.shrink(), // Remove back button
              actions: [
                GestureDetector(
                  onTap: () => pregnancyController.showBMIDialog(context),
                  child: Container(
                    // margin: horizontalMargin,
                    height: 42,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: NeoSafeColors.primaryPink,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.monitor_weight_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'bmi'.tr,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // const SizedBox(width: 12),
                const GoToHomeIconButton(
                  circleColor: NeoSafeColors.primaryPink,
                  iconColor: Colors.white,
                  top: 0,
                ),
                const SizedBox(width: 12),
                // GetX<AuthService>(
                //   builder: (authService) {
                //     final user = authService.currentUser.value;
                //     final profileImagePath = user?.profileImagePath;
                //     return Container(
                //       margin: const EdgeInsets.only(right: 16, left: 16),
                //       decoration: BoxDecoration(
                //         gradient: LinearGradient(
                //           colors: [
                //             themeService.getLightColor(),
                //             themeService.getPrimaryColor(),
                //           ],
                //         ),
                //         shape: BoxShape.circle,
                //         boxShadow: [
                //           BoxShadow(
                //             color:
                //                 themeService.getPrimaryColor().withOpacity(0.3),
                //             blurRadius: 8,
                //             offset: const Offset(0, 2),
                //           ),
                //         ],
                //       ),
                //       child: GestureDetector(
                //         onTap: () {
                //           Get.to(() => const TrackMyPregnancyProfileView());
                //         },
                //         child: CircleAvatar(
                //           radius: 22,
                //           backgroundColor: Colors.transparent,
                //           backgroundImage: (profileImagePath != null &&
                //                   profileImagePath.isNotEmpty)
                //               ? Image.file(
                //                   File(profileImagePath),
                //                 ).image
                //               : null,
                //           child: (profileImagePath == null ||
                //                   profileImagePath.isEmpty)
                //               ? Icon(Icons.person,
                //                   color: Colors.white, size: 28)
                //               : null,
                //         ),
                //       ),
                //     );
                //   },
                // ),
                GetX<AuthService>(
                  builder: (authService) {
                    final user = authService.currentUser.value;
                    final profileImagePath = user?.profileImagePath;
                    final isEnglish =
                        (Get.locale?.languageCode ?? 'en').startsWith('en');
                    final horizontalMargin = EdgeInsets.only(
                      left: isEnglish ? 0 : 16,
                      right: isEnglish ? 16 : 0,
                    );
                    return Container(
                      margin: horizontalMargin,
                      decoration: BoxDecoration(
                        color: NeoSafeColors.primaryPink,
                        // gradient: LinearGradient(
                        //   colors: [
                        //     themeService.getLightColor(),
                        //     themeService.getPrimaryColor(),
                        //   ],
                        // ),
                        shape: BoxShape.circle,
                        // boxShadow: [
                        //   BoxShadow(
                        //     color:
                        //         themeService.getPrimaryColor().withOpacity(0.3),
                        //     blurRadius: 8,
                        //     offset: const Offset(0, 2),
                        //   ),
                        // ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const TrackMyPregnancyProfileView());
                        },
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.transparent,
                          backgroundImage: (profileImagePath != null &&
                                  profileImagePath.isNotEmpty)
                              ? Image.file(
                                  File(profileImagePath),
                                ).image
                              : null,
                          child: (profileImagePath == null ||
                                  profileImagePath.isEmpty)
                              ? const Icon(Icons.person,
                                  color: Colors.white, size: 28)
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "today".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                    color: const Color(0xFF3D2929),
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  MainPregnancyCard(controller: pregnancyController),
                ]),
              ),
            ),

            // Week selector
            SliverToBoxAdapter(
              child: WeeklyDetailsWeekSelector(controller: controller),
            ),

            // Content sections
            SliverToBoxAdapter(
              child: WeeklyDetailsContent(controller: controller),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),

            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    backgroundColor: NeoSafeColors.primaryPink,
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    elevation: 3,
                  ),
                  onPressed: () {
                    Get.to(() => TrackMyPregnancyView());
                  },
                  child: Text('explain_in_detail'.tr,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white)),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            //   child: Center(
            //     child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         shape: StadiumBorder(),
            //         backgroundColor: NeoSafeColors.primaryPink,
            //         padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            //         elevation: 3,
            //       ),
            //       onPressed: () {
            //         // Get.to(() => TrackMyPregnancyView());
            //       },
            //       child: Text('More Details',
            //           style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //               fontSize: 17,
            //               color: Colors.white)),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
