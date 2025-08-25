import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/routes/app_pages.dart';
import '../controllers/get_pregnant_requirements_controller.dart';
import '../widgets/legend.dart';
import '../widgets/calendar.dart';
import '../widgets/action_buttons.dart';
import '../widgets/day_info.dart';
import '../widgets/cycle_info.dart';
import '../widgets/insights.dart';
import '../widgets/cycle_settings.dart';
import '../widgets/pregnancy_status.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import 'package:babysafe/app/services/auth_service.dart';
import 'dart:io';

class GetPregnantRequirementsView extends StatelessWidget {
  const GetPregnantRequirementsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<GetPregnantRequirementsController>(
      builder: (controller) {
        final today = DateTime.now();
        final currentDay = controller.selectedDay.value ?? today;
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: NeoSafeGradients.backgroundGradient,
            ),
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: 120.0,
                  floating: false,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: const SizedBox.shrink(), // Remove back button
                  actions: [
                    GetX<AuthService>(
                      builder: (authService) {
                        final user = authService.currentUser.value;
                        final profileImagePath = user?.profileImagePath;
                        return Padding(
                          padding: const EdgeInsets.only(
                            right: 16,
                            top: 12,
                            left: 16,
                          ),
                          child: GestureDetector(
                            onTap: () => Get.toNamed(Routes.profile),
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white,
                              backgroundImage: (profileImagePath != null &&
                                      profileImagePath.isNotEmpty)
                                  ? Image.file(
                                      File(profileImagePath),
                                    ).image
                                  : null,
                              child: (profileImagePath == null ||
                                      profileImagePath.isEmpty)
                                  ? Icon(Icons.person,
                                      color: NeoSafeColors.primaryPink,
                                      size: 28)
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: NeoSafeGradients.primaryGradient,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "fertility_journey".tr,
                                style: theme.textTheme.displaySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "track_your_cycle".tr,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Text(
                              //   "Current Locale: ${Get.locale?.languageCode}",
                              //   style: theme.textTheme.bodySmall?.copyWith(
                              //     color: Colors.white.withOpacity(0.7),
                              //   ),
                              // ),
                              // const SizedBox(height: 4),
                              // Text(
                              //   "test_translation".tr,
                              //   style: theme.textTheme.bodySmall?.copyWith(
                              //     color: Colors.white.withOpacity(0.7),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      LegendWidget(controller: controller),
                      const SizedBox(height: 24),
                      // PregnancyStatusWidget(controller: controller),
                      // const SizedBox(height: 24),
                      CycleSettingsWidget(controller: controller),
                      const SizedBox(height: 24),
                      CalendarWidget(controller: controller, theme: theme),
                      const SizedBox(height: 24),
                      ActionButtonsWidget(controller: controller),
                      const SizedBox(height: 24),
                      if (controller.selectedDay.value != null)
                        DayInfoWidget(controller: controller, theme: theme),
                      const SizedBox(height: 24),
                      if (controller.periodStart.value != null) ...[
                        CycleInfoWidget(controller: controller, theme: theme),
                        const SizedBox(height: 24),
                      ],
                      InsightsWidget(controller: controller, theme: theme),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
