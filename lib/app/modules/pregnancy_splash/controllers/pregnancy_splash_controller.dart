import 'dart:async';
import 'package:get/get.dart';
import '../../../data/models/pregnancy_week_data.dart';
import '../../../data/models/pregnancy_weeks.dart';
import '../../../services/auth_service.dart';

class PregnancySplashController extends GetxController {
  final RxInt currentWeek = 1.obs;
  final RxBool showDetails = false.obs;
  Timer? _weekTimer;

  // Only show the first 7 weeks for now
  List<PregnancyWeekData> get pregnancyData => pregnancyWeeks.take(7).toList();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 800), () {
      showDetails.value = true;
    });
    _startWeekProgression();
  }

  void _startWeekProgression() {
    _weekTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (currentWeek.value < pregnancyData.length) {
        currentWeek.value++;
      } else {
        timer.cancel();
        Future.delayed(const Duration(seconds: 2), () async {
          final authService = Get.find<AuthService>();

          if (authService.isLoggedIn && authService.currentUser.value != null) {
            final userId = authService.currentUser.value!.id;
            final isOnboardingComplete =
                await authService.isOnboardingComplete(userId);

            if (isOnboardingComplete) {
              // Get the user's onboarding purpose to route to the correct screen
              final onboardingPurpose =
                  await authService.getOnboardingPurpose(userId);

              if (onboardingPurpose == 'get_pregnant') {
                Get.offAllNamed('/get_pregnant_requirements');
              } else if (onboardingPurpose == 'pregnant') {
                // Load due date if available
                final dueDateStr = await authService.getOnboardingData(
                    'onboarding_due_date', userId);
                if (dueDateStr != null) {
                  final dueDate = DateTime.parse(dueDateStr);
                  Get.offAllNamed('/track_my_pregnancy',
                      arguments: {'dueDate': dueDate});
                } else {
                  Get.offAllNamed('/track_my_pregnancy');
                }
              } else if (onboardingPurpose == 'have_baby') {
                // Check baby birth date to determine route
                final babyBirthDateStr = await authService.getOnboardingData(
                    'onboarding_baby_birth_date', userId);
                if (babyBirthDateStr != null) {
                  final babyBirthDate = DateTime.parse(babyBirthDateStr);
                  final now = DateTime.now();
                  final daysSinceBirth = now.difference(babyBirthDate).inDays;

                  // If more than 2 weeks (14 days), go to track_my_baby
                  if (daysSinceBirth > 14) {
                    Get.offAllNamed('/track_my_baby');
                  } else {
                    Get.offAllNamed('/goal_selection');
                  }
                } else {
                  // Fallback to goal selection if no birth date
                  Get.offAllNamed('/goal_selection');
                }
              } else {
                // Fallback to goal selection if purpose is unknown
                Get.offAllNamed('/goal_selection');
              }
            } else {
              Get.offAllNamed('/goal_onboarding');
            }
          } else {
            Get.offAllNamed('/google_login');
          }
        });
      }
    });
  }

  @override
  void onClose() {
    _weekTimer?.cancel();
    super.onClose();
  }
}
