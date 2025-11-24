import 'package:get/get.dart';
import 'package:babysafe/app/data/models/baby_development_data.dart';
import '../../../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:babysafe/app/services/theme_service.dart';
import '../../../services/vaccination_notification_service.dart';
import 'dart:convert';

class ChildData {
  final String name;
  final DateTime dob;
  final String gender;

  ChildData({required this.name, required this.dob, required this.gender});

  Map<String, dynamic> toJson() => {
        'name': name,
        'dob': dob.toIso8601String(),
        'gender': gender,
      };

  factory ChildData.fromJson(Map<String, dynamic> json) => ChildData(
        name: json['name'] ?? '',
        dob: DateTime.parse(json['dob']),
        gender: json['gender'] ?? 'male',
      );
}

class TrackMyBabyController extends GetxController {
  // Multiple children support
  final RxList<ChildData> allChildren = <ChildData>[].obs;
  final RxInt selectedChildIndex = 0.obs;

  // Current selected baby information
  final RxString babyName = "baby_default_name".tr.obs;
  final RxString babyGender = "boy".tr.obs;
  final Rx<DateTime> birthDate = DateTime.now().obs;

  // Tracking data
  final RxInt babyAgeInDays = 0.obs;
  final RxInt babyAgeInMonths = 0.obs;
  final RxInt babyAgeInWeeks = 0.obs;

  // Vaccination completion status cache (stage -> isCompleted)
  final RxMap<int, bool> vaccinationCompletionStatus = <int, bool>{}.obs;

  // UI animations
  final RxDouble scaleValue = 1.0.obs;

  // Baby development data
  BabyDevelopmentData? get currentBabyData {
    if (babyAgeInMonths.value >= babyDevelopmentData.length) {
      return babyDevelopmentData.last;
    }
    return babyDevelopmentData[babyAgeInMonths.value];
  }

  // Get current selected child
  ChildData? get selectedChild {
    if (allChildren.isEmpty) return null;
    if (selectedChildIndex.value >= allChildren.length) {
      selectedChildIndex.value = 0;
    }
    return allChildren[selectedChildIndex.value];
  }

  late AuthService authService;

  @override
  void onInit() async {
    super.onInit();
    // Ensure authService is available
    authService = Get.find<AuthService>();

    // Load children data from SharedPreferences
    await loadChildrenData();

    // If no children loaded, try legacy single child data
    if (allChildren.isEmpty) {
      await _loadLegacyChildData();
    }

    // Set first child as selected by default
    if (allChildren.isNotEmpty) {
      selectChild(0);
    }

    // Schedule vaccination notifications for all children
    _scheduleAllVaccinationNotifications();
  }

  /// Schedule vaccination notifications for all children
  Future<void> _scheduleAllVaccinationNotifications() async {
    try {
      await VaccinationNotificationService.instance
          .scheduleVaccinationNotificationsForAllChildren();
    } catch (e) {
      print('Error scheduling vaccination notifications: $e');
    }
  }

  Future<void> loadChildrenData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final childrenDataStr = prefs.getString('all_children_data');

      if (childrenDataStr != null && childrenDataStr.isNotEmpty) {
        // Try to parse as JSON first
        try {
          final List<dynamic> childrenList = jsonDecode(childrenDataStr);
          allChildren.value =
              childrenList.map((child) => ChildData.fromJson(child)).toList();
        } catch (e) {
          // If JSON parsing fails, it might be stored as string representation
          // In that case, we'll fall back to legacy data
        }
      }
    } catch (e) {
      // Ignore errors, fall back to legacy data
    }
  }

  Future<void> _loadLegacyChildData() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingGender = prefs.getString('onboarding_born_baby_gender');
    DateTime? legacyBirthDate;

    if (authService.user?.babyBirthDate != null) {
      legacyBirthDate = authService.user!.babyBirthDate!;
    } else {
      final userId = authService.currentUser.value?.id;
      if (userId != null) {
        final birthStr = await authService.getOnboardingData(
            'onboarding_baby_birth_date', userId);
        if (birthStr != null && birthStr.isNotEmpty) {
          try {
            legacyBirthDate = DateTime.parse(birthStr);
          } catch (_) {
            // ignore parse errors
          }
        }
      }
    }

    if (legacyBirthDate != null) {
      final gender = onboardingGender ?? authService.user?.babyGender ?? "male";
      allChildren.add(ChildData(
        name: "baby_default_name".tr,
        dob: legacyBirthDate,
        gender: gender,
      ));
    }
  }

  void selectChild(int index) {
    if (index >= 0 && index < allChildren.length) {
      selectedChildIndex.value = index;
      final child = allChildren[index];
      babyName.value = child.name;
      babyGender.value = child.gender;
      birthDate.value = child.dob;
      _calculateBabyAge();

      // Update theme service
      final themeService = Get.find<ThemeService>();
      themeService.setBabyGender(child.gender);

      // Reschedule vaccination notifications for this child
      _rescheduleVaccinationNotifications(index);

      // Load vaccination completion status
      loadVaccinationCompletionStatus();

      // Notify listeners that child data has changed
      update();
    }
  }

  /// Reschedule vaccination notifications for a child
  Future<void> _rescheduleVaccinationNotifications(int childIndex) async {
    try {
      final childId = 'child_$childIndex';
      await VaccinationNotificationService.instance
          .scheduleVaccinationNotificationsForChild(childId);
    } catch (e) {
      print('Error rescheduling vaccination notifications: $e');
    }
  }

  /// Mark a vaccination stage as completed for the selected child
  Future<void> markVaccinationCompleted(int stage) async {
    try {
      final childId = 'child_${selectedChildIndex.value}';
      await VaccinationNotificationService.instance
          .markVaccinationCompleted(childId, 'stage_$stage');
      // Update cache immediately - trigger reactivity
      vaccinationCompletionStatus[stage] = true;
      vaccinationCompletionStatus.refresh();
    } catch (e) {
      print('Error marking vaccination as completed: $e');
    }
  }

  /// Check if a vaccination stage is completed for the selected child
  Future<bool> isVaccinationCompleted(int stage) async {
    try {
      final childId = 'child_${selectedChildIndex.value}';
      final completed = await VaccinationNotificationService.instance
          .getCompletedVaccinations(childId);
      final isCompleted = completed.contains('stage_$stage');
      // Update cache
      vaccinationCompletionStatus[stage] = isCompleted;
      return isCompleted;
    } catch (e) {
      print('Error checking vaccination completion: $e');
      vaccinationCompletionStatus[stage] = false;
      return false;
    }
  }

  /// Get vaccination completion status (synchronous, from cache)
  bool getVaccinationCompleted(int stage) {
    return vaccinationCompletionStatus[stage] ?? false;
  }

  /// Load vaccination completion status for all stages
  Future<void> loadVaccinationCompletionStatus() async {
    for (int stage = 1; stage <= 7; stage++) {
      await isVaccinationCompleted(stage);
    }
  }

  /// Get vaccination date for a stage
  DateTime? getVaccinationDate(int stage) {
    try {
      final ageKey = 'vaccination_table_age_$stage';
      final ageStr = ageKey.tr;
      final ageInfo = _parseVaccinationAge(ageStr);
      if (ageInfo == null) return null;

      final daysFromBirth =
          _calculateDaysForVaccination(birthDate.value, ageInfo);
      return birthDate.value.add(Duration(days: daysFromBirth));
    } catch (e) {
      print('Error getting vaccination date: $e');
      return null;
    }
  }

  /// Check if vaccination date has passed
  /// Returns true if the vaccination date is in the past (not today or future)
  bool hasVaccinationDatePassed(int stage) {
    final vaccinationDate = getVaccinationDate(stage);
    if (vaccinationDate == null) return false;

    // Compare dates only (ignore time)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final vaxDate = DateTime(
        vaccinationDate.year, vaccinationDate.month, vaccinationDate.day);

    // Date has passed if today is after the vaccination date
    // Allow checking on the vaccination date itself (today >= vaxDate means not passed yet)
    return today.isAfter(vaxDate);
  }

  /// Check if vaccination is due (can be checked)
  /// Returns true if vaccination date is today or in the past
  bool isVaccinationDue(int stage) {
    final vaccinationDate = getVaccinationDate(stage);
    if (vaccinationDate == null) return false;

    // Compare dates only (ignore time)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final vaxDate = DateTime(
        vaccinationDate.year, vaccinationDate.month, vaccinationDate.day);

    // Vaccination is due if today is on or after the vaccination date
    return today.isAtSameMomentAs(vaxDate) || today.isAfter(vaxDate);
  }

  /// Parse age from translation string
  Map<String, dynamic>? _parseVaccinationAge(String ageStr) {
    ageStr = ageStr.toLowerCase().trim();

    if (ageStr.contains('at birth') ||
        ageStr.contains('پیدائش') ||
        ageStr.contains('پیدائش دے ویلے')) {
      return {'type': 'birth', 'value': 0};
    }

    final RegExp weekRegex =
        RegExp(r'(\d+)\s*(week|ہفتے|ہفتہ)', caseSensitive: false);
    final RegExp monthRegex =
        RegExp(r'(\d+)\s*(month|ماہ|مہینے|مہینہ)', caseSensitive: false);

    final weekMatch = weekRegex.firstMatch(ageStr);
    if (weekMatch != null) {
      final weeks = int.tryParse(weekMatch.group(1) ?? '0') ?? 0;
      return {'type': 'weeks', 'value': weeks};
    }

    final monthMatch = monthRegex.firstMatch(ageStr);
    if (monthMatch != null) {
      final months = int.tryParse(monthMatch.group(1) ?? '0') ?? 0;
      return {'type': 'months', 'value': months};
    }

    return null;
  }

  /// Calculate days from birth date for vaccination
  int _calculateDaysForVaccination(
      DateTime birthDate, Map<String, dynamic> ageInfo) {
    if (ageInfo['type'] == 'birth') return 0;
    if (ageInfo['type'] == 'weeks') {
      return ageInfo['value'] * 7;
    }
    if (ageInfo['type'] == 'months') {
      return ageInfo['value'] * 30; // Approximate: 30 days per month
    }
    return 0;
  }

  /// Toggle vaccination completion (check/uncheck)
  Future<void> toggleVaccinationCompleted(int stage) async {
    try {
      final childId = 'child_${selectedChildIndex.value}';
      final completed = await VaccinationNotificationService.instance
          .getCompletedVaccinations(childId);

      if (completed.contains('stage_$stage')) {
        // Uncheck - remove from completed
        completed.remove('stage_$stage');
        final prefs = await SharedPreferences.getInstance();
        final key = 'completed_vaccinations_$childId';
        await prefs.setString(key, jsonEncode(completed.toList()));
        // Update cache immediately - trigger reactivity
        vaccinationCompletionStatus[stage] = false;
        vaccinationCompletionStatus.refresh();
        // Reschedule notifications
        await VaccinationNotificationService.instance
            .scheduleVaccinationNotificationsForChild(childId);
      } else {
        // Check - mark as completed
        // Update cache FIRST for immediate UI update
        vaccinationCompletionStatus[stage] = true;
        vaccinationCompletionStatus.refresh();

        // Then save to storage directly (don't call markVaccinationCompleted to avoid double update)
        completed.add('stage_$stage');
        final prefs = await SharedPreferences.getInstance();
        final key = 'completed_vaccinations_$childId';
        await prefs.setString(key, jsonEncode(completed.toList()));
        // Reschedule notifications
        await VaccinationNotificationService.instance
            .scheduleVaccinationNotificationsForChild(childId);
      }
      update();
    } catch (e) {
      print('Error toggling vaccination completion: $e');
    }
  }

  // React to user updates (e.g., birth date changed from Profile page)
  void _setupUserUpdatesListener() {
    ever(authService.currentUser, (user) {
      if (user != null && user.babyBirthDate != null && allChildren.isEmpty) {
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
    int totalDays = babyAgeInDays.value;
    int years = totalDays ~/ 365;
    int daysRemaining = totalDays % 365;
    int months = daysRemaining ~/ 30;
    daysRemaining = daysRemaining % 30;
    int weeks = daysRemaining ~/ 7;
    int days = daysRemaining % 7;

    // List<String> parts = [];
    // if (years > 0) parts.add("$years year${years == 1 ? '' : 's'}");
    // if (months > 0) parts.add("$months month${months == 1 ? '' : 's'}");
    // if (weeks > 0) parts.add("$weeks week${weeks == 1 ? '' : 's'}");

    List<String> parts = [];

    if (years > 0) {
      parts.add("$years ${years == 1 ? 'age_year'.tr : 'age_years'.tr}");
    }
    if (months > 0) {
      parts.add("$months ${months == 1 ? 'age_month'.tr : 'age_months'.tr}");
    }
    if (weeks > 0) {
      parts.add("$weeks ${weeks == 1 ? 'age_week'.tr : 'age_weeks'.tr}");
    }
    if (days > 0) {
      parts.add("$days ${days == 1 ? 'age_day'.tr : 'age_days'.tr}");
    }

    String ageText = parts.join(" ");

    if (parts.isEmpty) {
      return 'newborn'.tr; // or e.g. '< 1 week old' as you wish
    }
    return ageText;
    // return parts.join(' ') + ' old';
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
