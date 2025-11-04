import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/weight_entry.dart';
import '../../../services/auth_service.dart';
import '../../../services/notification_service.dart';
import 'dart:convert';

class WeightTrackingController extends GetxController {
  late AuthService authService;

  // Pre-pregnancy data
  final RxDouble prePregnancyWeight = 0.0.obs; // kg
  final RxDouble height = 0.0.obs; // cm
  final RxDouble prePregnancyBMI = 0.0.obs;
  final RxString bmiCategory = ''.obs; // Underweight, Normal, Overweight, Obese

  // Weight entries
  final RxList<WeightEntry> weightEntries = <WeightEntry>[].obs;

  // Current pregnancy data (from pregnancy tracking)
  final RxInt currentGestationalWeek = 0.obs;
  final RxString currentTrimester = ''.obs;
  final RxBool isMultipleGestation = false.obs;

  // Weight gain targets (in kg)
  final RxDouble minTargetGain = 0.0.obs;
  final RxDouble maxTargetGain = 0.0.obs;

  // Current weight and gain
  final RxDouble currentWeight = 0.0.obs;
  final RxDouble totalGain = 0.0.obs;
  final RxDouble gainPercentage = 0.0.obs; // percentage of target range

  // Alerts
  final RxBool showInsufficientGainAlert = false.obs;
  final RxBool showExcessiveGainAlert = false.obs;
  final RxBool showRapidGainAlert = false.obs;
  final RxString alertMessage = ''.obs;

  // Reminder settings
  final RxBool reminderEnabled = false.obs;
  final RxInt reminderHour = 9.obs;
  final RxInt reminderMinute = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    authService = Get.find<AuthService>();
    await loadUserData();
    await loadWeightEntries();
    await loadReminderSettings();
    calculateWeightGainTargets();
    updateCurrentWeight();
    checkAlerts();
    _setupReminders();
  }

  Future<void> loadReminderSettings() async {
    final notificationService = NotificationService.instance;
    reminderEnabled.value = await notificationService.isWeightTrackingReminderEnabled();
    final time = await notificationService.getWeightTrackingReminderTime();
    reminderHour.value = time['hour'] ?? 9;
    reminderMinute.value = time['minute'] ?? 0;
  }

  Future<void> _setupReminders() async {
    if (reminderEnabled.value) {
      await enableReminder(reminderHour.value, reminderMinute.value);
    }
  }

  Future<void> enableReminder(int hour, int minute) async {
    try {
      final notificationService = NotificationService.instance;
      await notificationService.scheduleWeightTrackingReminder(
        hour: hour,
        minute: minute,
      );
      reminderEnabled.value = true;
      reminderHour.value = hour;
      reminderMinute.value = minute;
    } catch (e) {
      print('Error enabling reminder: $e');
      rethrow;
    }
  }

  Future<void> disableReminder() async {
    try {
      final notificationService = NotificationService.instance;
      await notificationService.cancelWeightTrackingReminder();
      reminderEnabled.value = false;
    } catch (e) {
      print('Error disabling reminder: $e');
      rethrow;
    }
  }

  Future<void> loadUserData() async {
    final userId = authService.currentUser.value?.id;
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    
    // Load pre-pregnancy weight and height from onboarding
    final weightStr = prefs.getString('onboarding_pre_pregnancy_weight_$userId');
    final heightStr = prefs.getString('onboarding_height_$userId');
    
    if (weightStr != null) {
      prePregnancyWeight.value = double.tryParse(weightStr) ?? 0.0;
    }
    if (heightStr != null) {
      height.value = double.tryParse(heightStr) ?? 0.0;
    }

    // Calculate BMI
    if (prePregnancyWeight.value > 0 && height.value > 0) {
      final heightMeters = height.value / 100.0;
      prePregnancyBMI.value = prePregnancyWeight.value / (heightMeters * heightMeters);
      _determineBMICategory();
    }
  }

  void _determineBMICategory() {
    final bmi = prePregnancyBMI.value;
    if (bmi < 18.5) {
      bmiCategory.value = 'Underweight';
    } else if (bmi < 25.0) {
      bmiCategory.value = 'Normal';
    } else if (bmi < 30.0) {
      bmiCategory.value = 'Overweight';
    } else {
      bmiCategory.value = 'Obese';
    }
  }

  void calculateWeightGainTargets() {
    if (isMultipleGestation.value) {
      // Multiple gestation: higher targets
      if (bmiCategory.value == 'Underweight') {
        minTargetGain.value = 16.8; // 37-54 lb
        maxTargetGain.value = 24.5;
      } else if (bmiCategory.value == 'Normal') {
        minTargetGain.value = 17.0; // 37-54 lb
        maxTargetGain.value = 24.5;
      } else if (bmiCategory.value == 'Overweight') {
        minTargetGain.value = 14.0; // 31-50 lb
        maxTargetGain.value = 22.7;
      } else {
        minTargetGain.value = 11.3; // 25-42 lb
        maxTargetGain.value = 19.1;
      }
    } else {
      // Single gestation
      if (bmiCategory.value == 'Underweight') {
        minTargetGain.value = 12.5; // 28-40 lb
        maxTargetGain.value = 18.0;
      } else if (bmiCategory.value == 'Normal') {
        minTargetGain.value = 11.0; // 25-35 lb
        maxTargetGain.value = 16.0;
      } else if (bmiCategory.value == 'Overweight') {
        minTargetGain.value = 7.0; // 15-25 lb
        maxTargetGain.value = 11.0;
      } else {
        minTargetGain.value = 5.0; // 11-20 lb
        maxTargetGain.value = 9.0;
      }
    }
  }

  Future<void> loadWeightEntries() async {
    final userId = authService.currentUser.value?.id;
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getString('weight_entries_$userId');
    
    if (entriesJson != null) {
      final List<dynamic> decoded = jsonDecode(entriesJson);
      weightEntries.value = decoded
          .map((e) => WeightEntry.fromJson(e))
          .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
    }
  }

  Future<void> saveWeightEntry(double weight, DateTime date, {int? gestationalWeek, String? trimester}) async {
    final userId = authService.currentUser.value?.id;
    if (userId == null) return;

    final entry = WeightEntry(
      date: date,
      weight: weight,
      gestationalWeek: gestationalWeek ?? currentGestationalWeek.value,
      trimester: trimester ?? currentTrimester.value,
    );

    // Remove existing entry for same date if any
    weightEntries.removeWhere((e) => 
      e.date.year == date.year && 
      e.date.month == date.month && 
      e.date.day == date.day
    );

    weightEntries.add(entry);
    weightEntries.sort((a, b) => a.date.compareTo(b.date));

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = jsonEncode(weightEntries.map((e) => e.toJson()).toList());
    await prefs.setString('weight_entries_$userId', entriesJson);

    updateCurrentWeight();
    checkAlerts();
  }

  void updateCurrentWeight() {
    if (weightEntries.isEmpty) {
      currentWeight.value = prePregnancyWeight.value;
      totalGain.value = 0.0;
    } else {
      final latest = weightEntries.last;
      currentWeight.value = latest.weight;
      totalGain.value = currentWeight.value - prePregnancyWeight.value;
    }

    // Calculate percentage of target range
    if (maxTargetGain.value > minTargetGain.value) {
      final range = maxTargetGain.value - minTargetGain.value;
      final progress = totalGain.value - minTargetGain.value;
      gainPercentage.value = (progress / range * 100).clamp(0.0, 100.0);
    }
  }

  void checkAlerts() {
    showInsufficientGainAlert.value = false;
    showExcessiveGainAlert.value = false;
    showRapidGainAlert.value = false;
    alertMessage.value = '';

    if (totalGain.value < minTargetGain.value * 0.8) {
      showInsufficientGainAlert.value = true;
      alertMessage.value = 
          'Your weight gain is below the recommended range. Insufficient weight gain may increase the risk of IUGR and preterm birth. Please consult your healthcare provider for nutrition counseling.';
    } else if (totalGain.value > maxTargetGain.value * 1.1) {
      showExcessiveGainAlert.value = true;
      alertMessage.value = 
          'Your weight gain is above the recommended range. Excessive weight gain may increase the risk of gestational diabetes, hypertension, cesarean delivery, and large-for-gestational-age babies. Please consult your healthcare provider.';
    }

    // Check for rapid gain (more than 2kg in 4 weeks)
    if (weightEntries.length >= 2) {
      final recent = weightEntries.sublist(weightEntries.length - 4);
      if (recent.length >= 2) {
        final gain = recent.last.weight - recent.first.weight;
        final weeksDiff = (recent.last.date.difference(recent.first.date).inDays / 7).ceil();
        if (weeksDiff > 0 && gain / weeksDiff > 0.5) { // More than 0.5kg per week
          showRapidGainAlert.value = true;
          alertMessage.value = 
              'Rapid weight gain detected. Please consult your healthcare provider for dietary guidance.';
        }
      }
    }
  }

  // Get trimester-specific target gain
  Map<String, double> getTrimesterTargets() {
    final totalWeeks = 40.0;
    final firstTrimesterWeeks = 13.0;
    final secondTrimesterWeeks = 14.0; // weeks 14-27
    final thirdTrimesterWeeks = 13.0; // weeks 28-40

    final firstTarget = (minTargetGain.value + maxTargetGain.value) / 2 * (firstTrimesterWeeks / totalWeeks);
    final secondTarget = (minTargetGain.value + maxTargetGain.value) / 2 * (secondTrimesterWeeks / totalWeeks);
    final thirdTarget = (minTargetGain.value + maxTargetGain.value) / 2 * (thirdTrimesterWeeks / totalWeeks);

    return {
      'first': firstTarget,
      'second': secondTarget,
      'third': thirdTarget,
    };
  }

  // Get current trimester gain
  double getCurrentTrimesterGain() {
    if (weightEntries.isEmpty) return 0.0;
    
    final trimester = currentTrimester.value;
    if (trimester.isEmpty) return 0.0;

    final trimesterStartWeek = trimester == 'First trimester' 
        ? 1 
        : trimester == 'Second trimester' 
            ? 14 
            : 28;
    
    final trimesterEntries = weightEntries.where((e) => 
      e.gestationalWeek != null && 
      e.gestationalWeek! >= trimesterStartWeek &&
      e.gestationalWeek! < (trimesterStartWeek + 13)
    ).toList();

    if (trimesterEntries.isEmpty) return 0.0;
    
    final firstInTrimester = trimesterEntries.first.weight;
    final latestInTrimester = trimesterEntries.last.weight;
    
    return latestInTrimester - firstInTrimester;
  }

  void setCurrentGestationalWeek(int week) {
    currentGestationalWeek.value = week;
    if (week <= 13) {
      currentTrimester.value = 'First trimester';
    } else if (week <= 27) {
      currentTrimester.value = 'Second trimester';
    } else {
      currentTrimester.value = 'Third trimester';
    }
  }

  // Check GDM risk based on BMI
  bool shouldScreenForGDM() {
    final week = currentGestationalWeek.value;
    final bmi = prePregnancyBMI.value;
    
    // High risk: BMI >= 30 or BMI >= 25 with other risk factors
    // Screen at 24-28 weeks (or earlier if high risk)
    if (bmi >= 30 && week >= 16) {
      return true; // Early screening for high BMI
    }
    if (week >= 24 && week <= 28) {
      return true; // Standard screening window
    }
    return false;
  }

  // Check anemia risk
  bool isAtRiskForAnemia() {
    return prePregnancyBMI.value < 18.5; // Underweight
  }
}

