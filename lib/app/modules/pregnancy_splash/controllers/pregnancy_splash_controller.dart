import 'dart:async';
import 'package:babysafe/app/modules/track_my_baby/controllers/track_my_baby_controller.dart';
import 'package:babysafe/app/modules/track_my_baby/views/track_my_baby_view.dart';
import 'package:babysafe/app/modules/track_my_pregnancy/controllers/track_my_pregnancy_controller.dart';
import 'package:babysafe/app/modules/track_my_pregnancy/views/weekly_details_page.dart';
import 'package:get/get.dart';
import '../../../data/models/pregnancy_week_data.dart';
import '../../../data/models/pregnancy_weeks.dart';
import '../../../services/auth_service.dart';
import '../../../services/goal_service.dart';

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
            // Check minimal onboarding (name, gender, age) on app start
            final userId = authService.currentUser.value!.id;
            try {
              final name = await authService.getOnboardingData(
                      'onboarding_name', userId) ??
                  '';
              final gender = await authService.getOnboardingData(
                      'onboarding_gender', userId) ??
                  '';
              final age = await authService.getOnboardingData(
                      'onboarding_age', userId) ??
                  '';
              final hasMinimal = name.trim().isNotEmpty &&
                  gender.trim().isNotEmpty &&
                  age.trim().isNotEmpty;
              if (hasMinimal) {
                if (GlobalGoal().goal == "get_pregnant") {
                  Get.toNamed('/get_pregnant_requirements');
                } else if (GlobalGoal().goal == "track_pregnancy") {
                  Get.put(TrackMyPregnancyController()); 
                  Get.to(() => const WeeklyDetailsPage());
                } else if (GlobalGoal().goal == "track_baby") {
                  Get.put(TrackMyBabyController());
                  //           await Future.delayed(Duration(milliseconds: 100));
                  Get.to(() => MilestonesDetailPage());
                } else {
                  Get.offAllNamed('/goal_selection');
                }

                // Get.offAllNamed('/goal_selection');
              } else {
                Get.offAllNamed('/goal_onboarding');
              }
            } catch (e) {
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
