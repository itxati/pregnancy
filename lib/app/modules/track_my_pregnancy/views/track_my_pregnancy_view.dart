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
import '../../../widgets/sync_indicator.dart';
import '../../../widgets/offline_indicator.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';
import '../../profile/views/profile_view.dart';
import '../../profile/controllers/profile_controller.dart';

class TrackMyPregnancyView extends StatelessWidget {
  const TrackMyPregnancyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('TrackMyPregnancyView is being built');
    final controller = Get.put(TrackMyPregnancyController());
    final themeService = Get.find<ThemeService>();

    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final currentWeek = controller.pregnancyWeekNumber.value;
    final alerts = pregnancyWeeks[currentWeek]?.alerts;

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
              expandedHeight: 100.0,
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
                    return Container(
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            themeService.getLightColor(),
                            themeService.getPrimaryColor(),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: themeService.getPrimaryColor().withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.put(ProfileController());
                          Get.to(() => const ProfileView());
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
                              "Today",
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: const Color(
                                    0xFF3D2929), // NeoSafeColors.primaryText
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            // const SyncIndicator(),
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
                  // Offline Indicator
                  // const OfflineIndicator(),

                  // Main Pregnancy Card
                  MainPregnancyCard(controller: controller),

                  const SizedBox(height: 24),

                  // // Pregnancy Status Card
                  PregnancyStatusCard(controller: controller),

                  const SizedBox(height: 24),

                  // Weekly Update Card
                  WeeklyUpdateCard(controller: controller),

                  const SizedBox(height: 24),

                  // Timeline Card
                  TimelineCard(controller: controller),

                  const SizedBox(height: 24),
                  if (alerts != null)
                    Column(
                      children: [
                        AlertCard(controller: controller),
                        const SizedBox(height: 24),
                      ],
                    ),

                  // Baby Size Discovery Card
                  BabySizeCard(controller: controller),
                  const SizedBox(height: 24),

                  BirthPreparednessCard(
                    currentWeek: controller.pregnancyWeekNumber.value,
                  ),

                  const SizedBox(height: 8),
                  // Risk Factor Card
                  RiskFactorCard(),
                  const SizedBox(height: 8),
                  DangerSignsCard(),
                  const SizedBox(height: 8),

                  LifeStyleAdviceCard(),

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
