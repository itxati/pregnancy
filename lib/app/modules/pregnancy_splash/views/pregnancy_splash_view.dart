import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/pregnancy_splash_progress.dart';
import '../widgets/pregnancy_baby_image.dart';
import '../widgets/pregnancy_development_info.dart';
import '../widgets/language_switcher.dart';
import '../../../utils/neo_safe_theme.dart';
import '../controllers/pregnancy_splash_controller.dart';

class PregnancySplashView extends StatelessWidget {
  const PregnancySplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PregnancySplashController>();
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: NeoSafeColors.primaryPink,
        child: SafeArea(
          child: Obx(() {
            final week = controller.currentWeek.value;
            final data = controller.pregnancyData[week - 1];
            return Column(
              children: [
                PregnancySplashProgress(currentWeek: week),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '${'week'.tr} $week',
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: screenSize.width * 0.15,
                                ),
                      ),
                      SizedBox(
                        height: screenSize.height * 0.3,
                        child: PregnancyBabyImage(week: week),
                      ),
                      if (controller.showDetails.value)
                        PregnancyDevelopmentInfo(data: data),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'sardar_trust'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'pregnancy_companion'.tr,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                      const SizedBox(height: 16),
                      // Language switcher for changing app language (Pregnancy Splash)
                      // const LanguageSwitcher(
                      //   backgroundColor: Colors.white,
                      //   selectedTextColor: NeoSafeColors.primaryPink,
                      // ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
