import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class GoalOnboardingController extends GetxController {
  final RxInt currentStep = 0.obs;

  // User answers
  final RxString name = ''.obs;
  final RxString gender = ''.obs; // 'female'/'male'
  final RxString purpose = ''.obs; // 'pregnant', 'get_pregnant', 'have_baby'

  // For "Trying to get pregnant"
  final Rx<DateTime?> lastPeriodDate = Rx<DateTime?>(null);
  final RxInt cycleLength = 28.obs;

  // For "I'm pregnant"
  final Rx<DateTime?> dueDate = Rx<DateTime?>(null);
  final RxString babyGender = ''.obs;

  // For "I have a baby"
  final Rx<DateTime?> babyBirthDate = Rx<DateTime?>(null);
  final RxString bornBabyGender = ''.obs;

  // Navigation helpers
  void nextStep() => currentStep.value++;
  void previousStep() => currentStep.value--;

  Future<void> saveToPrefs() async {
    final authService = Get.find<AuthService>();
    final userId = authService.currentUser.value?.id;
    
    if (userId == null) {
      print('Error: No user ID available to save onboarding data');
      return;
    }

    // Save onboarding data with user-specific keys
    await authService.setOnboardingData('onboarding_name', userId, name.value);
    await authService.setOnboardingData('onboarding_gender', userId, gender.value);
    await authService.setOnboardingData('onboarding_purpose', userId, purpose.value);
    
    if (lastPeriodDate.value != null) {
      await authService.setOnboardingData(
          'onboarding_last_period', userId, lastPeriodDate.value!.toIso8601String());
      await authService.setOnboardingInt('onboarding_cycle_length', userId, cycleLength.value);
    }
    if (dueDate.value != null) {
      await authService.setOnboardingData(
          'onboarding_due_date', userId, dueDate.value!.toIso8601String());
    }
    if (babyGender.value.isNotEmpty) {
      await authService.setOnboardingData('onboarding_baby_gender', userId, babyGender.value);
    }
    if (babyBirthDate.value != null) {
      await authService.setOnboardingData(
          'onboarding_baby_birth_date', userId, babyBirthDate.value!.toIso8601String());
    }
    if (bornBabyGender.value.isNotEmpty) {
      await authService.setOnboardingData(
          'onboarding_born_baby_gender', userId, bornBabyGender.value);
    }
    // Save onboarding complete flag for this user
    await authService.setOnboardingBool('onboarding_complete', userId, true);
  }
}
