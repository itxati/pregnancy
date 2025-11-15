import 'package:get/get.dart';
import 'package:babysafe/app/data/models/baby_development_data.dart';
import '../../../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:babysafe/app/services/theme_service.dart';

class TrackMyBabyController extends GetxController {
  // Baby information
  final RxString babyName = "baby_default_name".tr.obs;
  final RxString babyGender = "boy".tr.obs;
  final Rx<DateTime> birthDate = DateTime.now().obs;

  // Tracking data
  final RxInt babyAgeInDays = 0.obs;
  final RxInt babyAgeInMonths = 0.obs;
  final RxInt babyAgeInWeeks = 0.obs;

  // UI animations
  final RxDouble scaleValue = 1.0.obs;

  // Baby development data
  BabyDevelopmentData? get currentBabyData {
    if (babyAgeInMonths.value >= babyDevelopmentData.length) {
      return babyDevelopmentData.last;
    }
    return babyDevelopmentData[babyAgeInMonths.value];
  }

  late AuthService authService;

  @override
  void onInit() async {
    super.onInit();
    // Ensure authService is available
    authService = Get.find<AuthService>();
    // First: try onboarding gender from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final onboardingGender = prefs.getString('onboarding_born_baby_gender');
    if (onboardingGender != null && onboardingGender.isNotEmpty) {
      babyGender.value = onboardingGender;
      final themeService = Get.find<ThemeService>();
      themeService.setBabyGender(onboardingGender);
    } else if (authService.user?.babyGender != null) {
      babyGender.value = authService.user!.babyGender!;
      final themeService = Get.find<ThemeService>();
      themeService.setBabyGender(authService.user!.babyGender!);
    }
    if (authService.user?.babyBirthDate != null) {
      birthDate.value = authService.user!.babyBirthDate!;
    } else {
      // Fallback: use onboarding saved birth date if available
      final userId = authService.currentUser.value?.id;
      if (userId != null) {
        final birthStr = await authService.getOnboardingData(
            'onboarding_baby_birth_date', userId);
        if (birthStr != null && birthStr.isNotEmpty) {
          try {
            birthDate.value = DateTime.parse(birthStr);
          } catch (_) {
            // ignore parse errors, keep default
          }
        }
      }
    }
    _calculateBabyAge();

    // React to user updates (e.g., birth date changed from Profile page)
    ever(authService.currentUser, (user) {
      if (user != null && user.babyBirthDate != null) {
        birthDate.value = user.babyBirthDate!;
        _calculateBabyAge();
      }
    });
  }

  void _calculateBabyAge() {
    final now = DateTime.now();
    final difference = now.difference(birthDate.value);

    babyAgeInDays.value = difference.inDays;
    babyAgeInWeeks.value = (difference.inDays / 7).floor();
    babyAgeInMonths.value = _calculateMonths(birthDate.value, now);
  }

  int _calculateMonths(DateTime birth, DateTime current) {
    int months =
        (current.year - birth.year) * 12 + (current.month - birth.month);
    if (current.day < birth.day) {
      months--;
    }
    return months < 0 ? 0 : months;
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "good_morning".tr;
    if (hour < 17) return "good_afternoon".tr;
    return "good_evening".tr;
  }

  String getBabyAgeText() {
    return "weeks_old".trParams({"weeks": "${babyAgeInWeeks.value}"});
  }

  String getTimelineSubtitle() {
    if (babyAgeInMonths.value < 3) {
      return "newborn_phase".tr;
    } else if (babyAgeInMonths.value < 6) {
      return "infant_development".tr;
    } else if (babyAgeInMonths.value < 12) {
      return "baby_milestones".tr;
    } else if (babyAgeInMonths.value < 18) {
      return "toddler_growth".tr;
    } else {
      return "early_childhood".tr;
    }
  }

  void updateBabyInfo({
    String? name,
    String? gender,
    DateTime? birth,
  }) {
    if (name != null) babyName.value = name;
    if (gender != null) babyGender.value = gender;
    if (birth != null) {
      birthDate.value = birth;
      _calculateBabyAge();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
