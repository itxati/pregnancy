import 'package:get/get.dart';
import 'package:babysafe/app/data/models/baby_development_data.dart';
import '../../../services/auth_service.dart';

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
  void onInit() {
    super.onInit();
    authService = Get.find<AuthService>();
    if (authService.user?.babyBirthDate != null) {
      birthDate.value = authService.user!.babyBirthDate!;
    }
    _calculateBabyAge();
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
    if (babyAgeInMonths.value == 0) {
      return "weeks_old".trParams({"weeks": "${babyAgeInWeeks.value}"});
    } else if (babyAgeInMonths.value == 1) {
      return "one_month_old".tr;
    } else {
      return "months_old".trParams({"months": "${babyAgeInMonths.value}"});
    }
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
