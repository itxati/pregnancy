import 'package:babysafe/app/modules/get_pregnant_requirements/widgets/go_to_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:babysafe/app/data/models/pregnancy_weeks.dart';
import 'package:babysafe/app/services/theme_service.dart';
import 'package:babysafe/app/modules/track_my_pregnancy/widgets/alert_card.dart';
import 'package:babysafe/app/modules/track_my_pregnancy/widgets/birth_prepadness_card.dart';
import 'package:babysafe/app/modules/track_my_pregnancy/widgets/danger_signs_card.dart';
import 'package:babysafe/app/modules/track_my_pregnancy/widgets/lifestyle_advice_card.dart';
import 'package:babysafe/app/modules/track_my_pregnancy/widgets/risk_factor_card.dart';
import '../controllers/track_my_pregnancy_controller.dart';
import '../widgets/main_pregnancy_card.dart';
import '../widgets/pregnancy_status_card.dart';
import '../widgets/weekly_update_card.dart';
import '../widgets/timeline_card.dart';
import '../widgets/baby_size_card.dart';
import '../widgets/essential_reads_section.dart';
import 'package:babysafe/app/services/auth_service.dart';
import '../../weight_tracking/controllers/weight_tracking_controller.dart';
import '../../weight_tracking/widgets/weight_tracking_card.dart';
import '../../risk_assessment/controllers/risk_assessment_controller.dart';
import '../../risk_assessment/widgets/risk_assessment_card.dart';
import '../widgets/miscarriage_awareness_card.dart';
import '../widgets/preterm_birth_card.dart';
import '../widgets/breastfeeding_card.dart';
import '../widgets/delivery_planning_card.dart';
import '../widgets/pregnancy_risk_factors_card.dart';
import '../views/track_my_pregnancy_profile_view.dart';
import '../../../utils/neo_safe_theme.dart';

class TrackMyPregnancyView extends StatelessWidget {
  const TrackMyPregnancyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('TrackMyPregnancyView is being built');
    final controller = Get.put(TrackMyPregnancyController());
    final themeService = Get.find<ThemeService>();

    final theme = Theme.of(context);
    final currentWeek = controller.pregnancyWeekNumber.value;
    final alerts = pregnancyWeeks[currentWeek].alerts;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFFAFA), // NeoSafeColors.warmWhite
              Color(0xFFF8F2F2), // NeoSafeColors.lightBeige
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverAppBar(
              expandedHeight: 0.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              toolbarHeight: 60.0,

              leading: const SizedBox.shrink(), // Remove back button
              actions: [
                GestureDetector(
                  onTap: () => controller.showBMIDialog(context),
                  child: Container(
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
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // const SizedBox(width: 20),
                const GoToHomeIconButton(
                  circleColor: NeoSafeColors.primaryPink,
                  iconColor: Colors.white,
                  top: 0,
                ),
                const SizedBox(width: 12),
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
                              ? Icon(Icons.person,
                                  color: Colors.white, size: 28)
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ],
              // flexibleSpace: FlexibleSpaceBar(
              //   background: SafeArea(
              //     child: Padding(
              //       padding: const EdgeInsets.all(20),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         mainAxisAlignment: MainAxisAlignment.end,
              //         children: [
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Text(
              //                 "today".tr,
              //                 style: theme.textTheme.displaySmall?.copyWith(
              //                   color: const Color(
              //                       0xFF3D2929), // NeoSafeColors.primaryText
              //                   fontWeight: FontWeight.w700,
              //                 ),
              //               ),
              //               // const SyncIndicator(),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Offline Indicator
                  // const OfflineIndicator(),

                  // Main Pregnancy Card
                  // MainPregnancyCard(controller: controller),
                  // const SizedBox(height: 24),

                  // // Pregnancy Status Card
                  PregnancyStatusCard(controller: controller),

                  const SizedBox(height: 24),

                  // Weekly Update Card
                  // WeeklyUpdateCard(controller: controller),

                  // const SizedBox(height: 24),

                  // Timeline Card
                  TimelineCard(controller: controller),

                  const SizedBox(height: 24),

                  // Baby Size Discovery Card
                  BabySizeCard(controller: controller),
                  const SizedBox(height: 24),

                  // Weight Tracking Card (only show if BMI is calculated)
                  Builder(
                    builder: (context) {
                      WeightTrackingController weightController;
                      if (Get.isRegistered<WeightTrackingController>()) {
                        weightController = Get.find<WeightTrackingController>();
                      } else {
                        weightController = Get.put(WeightTrackingController());
                      }
                      // Sync gestational week and trimester
                      weightController.setCurrentGestationalWeek(
                          controller.pregnancyWeekNumber.value);

                      return Obx(() {
                        // Observe the reactive values directly to ensure rebuild
                        final weight =
                            weightController.prePregnancyWeight.value;
                        final height = weightController.height.value;

                        // Only show card if BMI is calculated (height and weight are set)
                        if (weight > 0 && height > 0) {
                          return WeightTrackingCard(
                              controller: weightController);
                        } else {
                          return const SizedBox.shrink();
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  // Risk Assessment Card
                  Obx(() {
                    RiskAssessmentController riskController;
                    if (Get.isRegistered<RiskAssessmentController>()) {
                      riskController = Get.find<RiskAssessmentController>();
                    } else {
                      riskController = Get.put(RiskAssessmentController());
                    }
                    // Sync gestational week
                    riskController.setCurrentGestationalWeek(
                        controller.pregnancyWeekNumber.value);
                    return RiskAssessmentCard(controller: riskController);
                  }),

                  const SizedBox(height: 24),

                  if (alerts != null)
                    Column(
                      children: [
                        AlertCard(controller: controller),
                        const SizedBox(height: 24),
                      ],
                    ),

                  // Risk Factor Card
                  RiskFactorCard(),
                  const SizedBox(height: 8),

                  // Pregnancy Risk Factors Card
                  const PregnancyRiskFactorsCard(),
                  const SizedBox(height: 24),

                  // Miscarriage Awareness Card
                  const MiscarriageAwarenessCard(),
                  const SizedBox(height: 24),

                  // Preterm Birth Card
                  const PretermBirthCard(),
                  const SizedBox(height: 24),

                  LifeStyleAdviceCard(),

                  const SizedBox(height: 24),

                  DangerSignsCard(),
                  const SizedBox(height: 8),

                  // Delivery Planning Card
                  const DeliveryPlanningCard(),
                  const SizedBox(height: 24),

                  BirthPreparednessCard(
                    currentWeek: controller.pregnancyWeekNumber.value,
                  ),

                  const SizedBox(height: 8),

                  // Breastfeeding Card
                  const BreastfeedingCard(),
                  const SizedBox(height: 24),

                  // Essential Reads Section
                  EssentialReadsSection(controller: controller),

                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
