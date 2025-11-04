import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  // -- Enhanced for better pregnancy dating --
  final RxBool knowsDueDate = RxBool(true);
  final Rx<DateTime?> lmpDate = Rx<DateTime?>(null);
  final RxInt lmpCycleLength = 28.obs;
  final RxBool showRedFlag = false.obs;
  final Rx<DateTime?> ultrasoundDate = Rx<DateTime?>(null);
  final RxInt ultrasoundGAWeeks = 0.obs;
  final RxInt ultrasoundGADays = 0.obs;
  final RxInt calcGestationalDays = 0.obs;
  final RxString calcTrimester = ''.obs;
  final RxString datingMethod = ''.obs; // 'EDD', 'LMP', 'US'

  // For "I have a baby"
  final Rx<DateTime?> babyBirthDate = Rx<DateTime?>(null);
  final RxString bornBabyGender = ''.obs;

  // User age
  final RxString age = ''.obs;

  // Maternal data
  final RxString prePregnancyWeight = ''.obs; // kg or lbs
  final RxString height = ''.obs; // cm or feet+inches
  final RxDouble bmi = 0.0.obs;

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
    await authService.setOnboardingData(
        'onboarding_gender', userId, gender.value);
    await authService.setOnboardingData(
        'onboarding_purpose', userId, purpose.value);

    if (lastPeriodDate.value != null) {
      await authService.setOnboardingData('onboarding_last_period', userId,
          lastPeriodDate.value!.toIso8601String());
      await authService.setOnboardingInt(
          'onboarding_cycle_length', userId, cycleLength.value);
    }
    if (dueDate.value != null) {
      await authService.setOnboardingData(
          'onboarding_due_date', userId, dueDate.value!.toIso8601String());
    }
    if (babyGender.value.isNotEmpty) {
      await authService.setOnboardingData(
          'onboarding_baby_gender', userId, babyGender.value);
    }
    if (babyBirthDate.value != null) {
      await authService.setOnboardingData('onboarding_baby_birth_date', userId,
          babyBirthDate.value!.toIso8601String());
    }
    if (bornBabyGender.value.isNotEmpty) {
      await authService.setOnboardingData(
          'onboarding_born_baby_gender', userId, bornBabyGender.value);
    }
    
    // Save height and weight for weight tracking
    if (height.value.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('onboarding_height_$userId', height.value);
    }
    if (prePregnancyWeight.value.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('onboarding_pre_pregnancy_weight_$userId', prePregnancyWeight.value);
    }
    
    // Save onboarding complete flag for this user
    await authService.setOnboardingBool('onboarding_complete', userId, true);
  }

  // --- Enhanced methods for EDD/LMP/US dating ---
  /// Calculate gestational age in days from LMP or from ultrasound
  void calculateDating() {
    DateTime today = DateTime.now();

    if (knowsDueDate.value && dueDate.value != null) {
      // If due date known, calculate LMP backwards
      final lmpEstimate = dueDate.value!.subtract(const Duration(days: 280));
      calcGestationalDays.value = today.difference(lmpEstimate).inDays;
      datingMethod.value = 'EDD';
    } else if (ultrasoundDate.value != null &&
        (ultrasoundGAWeeks.value > 0 || ultrasoundGADays.value > 0)) {
      // If ultrasound info available, preferred
      final refGA = ultrasoundGAWeeks.value * 7 + ultrasoundGADays.value;
      final gaByToday = today.difference(ultrasoundDate.value!).inDays + refGA;
      calcGestationalDays.value = gaByToday;
      // Calculate EDD: ref_date + (280 - refGA)
      dueDate.value = ultrasoundDate.value!.add(Duration(days: 280 - refGA));
      datingMethod.value = 'US';
    } else if (lmpDate.value != null) {
      // If LMP given
      final gaByLmp = today.difference(lmpDate.value!).inDays;
      calcGestationalDays.value = gaByLmp;
      dueDate.value = lmpDate.value!.add(const Duration(days: 280));
      datingMethod.value = 'LMP';
    }

    // Trimester mapping
    final weeks = (calcGestationalDays.value / 7).floor();
    if (weeks <= 13) {
      calcTrimester.value = 'First trimester';
    } else if (weeks <= 27) {
      calcTrimester.value = 'Second trimester';
    } else {
      calcTrimester.value = 'Third trimester';
    }

    // Red flag if <4 or >46 weeks
    showRedFlag.value = (weeks < 4 || weeks > 46);
  }
}
