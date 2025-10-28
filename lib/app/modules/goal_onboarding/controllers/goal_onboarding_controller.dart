import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('onboarding_name', name.value);
    await prefs.setString('onboarding_gender', gender.value);
    await prefs.setString('onboarding_purpose', purpose.value);
    if (lastPeriodDate.value != null) {
      await prefs.setString(
          'onboarding_last_period', lastPeriodDate.value!.toIso8601String());
      await prefs.setInt('onboarding_cycle_length', cycleLength.value);
    }
    if (dueDate.value != null) {
      await prefs.setString(
          'onboarding_due_date', dueDate.value!.toIso8601String());
    }
    if (babyGender.value.isNotEmpty) {
      await prefs.setString('onboarding_baby_gender', babyGender.value);
    }
    if (babyBirthDate.value != null) {
      await prefs.setString(
          'onboarding_baby_birth_date', babyBirthDate.value!.toIso8601String());
    }
    if (bornBabyGender.value.isNotEmpty) {
      await prefs.setString(
          'onboarding_born_baby_gender', bornBabyGender.value);
    }
  }
}
