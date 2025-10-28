import 'package:get/get.dart';
import '../controllers/goal_onboarding_controller.dart';

class GoalOnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoalOnboardingController>(() => GoalOnboardingController());
  }
}
