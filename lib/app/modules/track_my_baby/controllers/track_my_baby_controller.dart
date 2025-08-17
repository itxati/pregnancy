import 'package:get/get.dart';
import 'package:babysafe/app/data/models/baby_development_data.dart';
import '../../../services/auth_service.dart';

class TrackMyBabyController extends GetxController {
  // Baby information
  final RxString babyName = "Baby".obs;
  final RxString babyGender = "Boy".obs;
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
    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
  }

  String getBabyAgeText() {
    if (babyAgeInMonths.value == 0) {
      return "${babyAgeInWeeks.value} weeks old";
    } else if (babyAgeInMonths.value == 1) {
      return "1 month old";
    } else {
      return "${babyAgeInMonths.value} months old";
    }
  }

  String getTimelineSubtitle() {
    if (babyAgeInMonths.value < 3) {
      return "Newborn phase";
    } else if (babyAgeInMonths.value < 6) {
      return "Infant development";
    } else if (babyAgeInMonths.value < 12) {
      return "Baby milestones";
    } else if (babyAgeInMonths.value < 18) {
      return "Toddler growth";
    } else {
      return "Early childhood";
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
