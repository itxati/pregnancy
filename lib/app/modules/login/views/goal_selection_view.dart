import 'package:babysafe/app/modules/login/widgets/login_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/neo_safe_theme.dart';
import 'dart:ui';
import '../controllers/goal_selection_controller.dart';
import '../widgets/goal_card.dart';
import '../../pregnancy_splash/widgets/language_switcher.dart';

class GoalSelectionView extends StatelessWidget {
  const GoalSelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(GoalSelectionController());

    return Scaffold(
      body: Stack(
        children: [
          // Background image with maternal overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: NeoSafeGradients.backgroundGradient,
              ),
              child: Image.asset(
                'assets/logos/login_bg.jpeg',
                fit: BoxFit.cover,
                color: NeoSafeColors.maternalGlow.withOpacity(0.4),
                colorBlendMode: BlendMode.overlay,
              ),
            ),
          ),

          // Backdrop filter overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: NeoSafeColors.primaryPink.withOpacity(0.15),
              ),
            ),
          ),

          // Goal selection form container
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    width: 370,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 26),
                    decoration: BoxDecoration(
                      color: NeoSafeColors.creamWhite.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                          color: NeoSafeColors.lightPink.withOpacity(0.5),
                          width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: NeoSafeColors.primaryPink.withOpacity(0.15),
                          blurRadius: 32,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: GetBuilder<GoalSelectionController>(
                      builder: (controller) => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Logo with maternal glow
                            LoginLogo(),
                            const SizedBox(height: 12),

                            // Language switcher
                            // const LanguageSwitcher(),
                            // const SizedBox(height: 18),

                            // Title text
                            Text(
                              'what_is_your_goal'.tr,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                      color: NeoSafeColors.primaryText,
                                      letterSpacing: 1.1,
                                      fontSize: 22),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'choose_your_journey'.tr,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: 12,
                                    color: NeoSafeColors.secondaryText,
                                  ),
                            ),
                            const SizedBox(height: 18),

                            // Goal cards
                            GoalCard(
                              gradient: const LinearGradient(
                                colors: [
                                  NeoSafeColors.palePink,
                                  NeoSafeColors.lightPink
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              icon: Icons.favorite,
                              iconColor: NeoSafeColors.primaryPink,
                              title: "get_pregnant".tr,
                              subtitle: "get_pregnant_subtitle".tr,
                              onTap: () =>
                                  controller.onGoalCardTap('get_pregnant'),
                            ),
                            const SizedBox(height: 16),
                            GoalCard(
                              gradient: const LinearGradient(
                                colors: [
                                  NeoSafeColors.babyPink,
                                  NeoSafeColors.coralPink
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              icon: Icons.pregnant_woman,
                              iconColor: NeoSafeColors.roseAccent,
                              title: "track_my_pregnancy".tr,
                              subtitle: "track_my_pregnancy_subtitle".tr,
                              onTap: () =>
                                  controller.onGoalCardTap('track_pregnance'),
                            ),
                            const SizedBox(height: 16),
                            GoalCard(
                              gradient: const LinearGradient(
                                colors: [
                                  NeoSafeColors.softLavender,
                                  NeoSafeColors.lavenderPink
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              icon: Icons.child_care,
                              iconColor: NeoSafeColors.primaryPink,
                              title: "child_development".tr,
                              subtitle: "child_development_subtitle".tr,
                              onTap: () =>
                                  controller.onGoalCardTap('child_development'),
                            ),
                            const SizedBox(height: 16),
                            GoalCard(
                              gradient: const LinearGradient(
                                colors: [
                                  NeoSafeColors.softLavender,
                                  NeoSafeColors.palePink
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              icon: Icons.local_hospital,
                              iconColor: NeoSafeColors.roseAccent,
                              title: "postpartum_care".tr,
                              subtitle: "postpartum_care_subtitle".tr,
                              onTap: () =>
                                  controller.onGoalCardTap('postpartum_care'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 42,
            right: 24,
            child: const LanguageSwitcher(),
          ),
        ],
      ),
    );
  }
}
