import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/pregnancy_weeks.dart';
import '../../../data/models/pregnancy_week_data.dart';
import '../../../utils/neo_safe_theme.dart';
import '../../../services/notification_service.dart';
import '../../../services/auth_service.dart';
import '../../weight_tracking/controllers/weight_tracking_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class TrackMyPregnancyController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController pulseController;
  late Animation<double> scaleAnimation;
  late Animation<double> pulseAnimation;
  late AuthService authService;

  // Pregnancy data
  RxInt pregnancyWeekNumber = 6.obs;
  RxInt pregnancyDays = 42.obs;
  RxString trimester = "First trimester".obs;
  RxString dueDate = "".obs;
  RxString babySize = "Blueberry".obs;
  RxString userName = "".obs;
  RxString userAge = "".obs;
  RxString userGender = "".obs;

  // Current week data
  Rx<PregnancyWeekData?> currentWeekData = Rx<PregnancyWeekData?>(null);

  @override
  void onInit() {
    super.onInit();
    authService = Get.find<AuthService>();
    final args = Get.arguments;
    if (args != null && args['dueDate'] != null) {
      final due = args['dueDate'];
      if (due is DateTime) {
        _initializeWithDueDate(due);
      } else if (due is String) {
        final parsedDue = DateTime.tryParse(due);
        if (parsedDue != null) {
          _initializeWithDueDate(parsedDue);
        }
      }
    } else {
      _initializeAnimations();
      _loadUserData();
      _calculatePregnancyProgress();
      _updateCurrentWeekData();
      _scheduleWeekAlerts();
    }
  }

  @override
  void onReady() async {
    super.onReady();
    // Ensure user data is loaded after controller is ready
    await _loadUserData();
  }

  void _initializeAnimations() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
    );
    pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );

    animationController.forward();
  }

  void _updateCurrentWeekData() {
    try {
      currentWeekData.value = pregnancyWeeks.firstWhere(
        (week) => week.week == pregnancyWeekNumber.value,
        orElse: () => pregnancyWeeks.first,
      );
    } catch (e) {
      currentWeekData.value = pregnancyWeeks.first;
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    pulseController.dispose();
    super.onClose();
  }

  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    final user = authService.currentUser.value;
    String? loadedName;
    String? loadedAge;

    // Load due date if available
    if (user != null && user.dueDate != null) {
      dueDate.value = _formatDueDate(user.dueDate!);
    }

    // Priority: Try onboarding data first (most recent/accurate)
    final userId = user?.id;
    if (userId != null && userId.isNotEmpty) {
      // Try from AuthService onboarding data first
      final onboardingName =
          await authService.getOnboardingData('onboarding_name', userId);
      final onboardingAge =
          await authService.getOnboardingData('onboarding_age', userId);
      if (onboardingName != null && onboardingName.isNotEmpty) {
        loadedName = onboardingName;
      }
      if (onboardingAge != null && onboardingAge.isNotEmpty) {
        loadedAge = onboardingAge;
      }
    }

    // Fallback to SharedPreferences directly if still no name/age
    if (loadedName == null || loadedName.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final prefsName = prefs.getString('onboarding_name');
      if (prefsName != null && prefsName.isNotEmpty) {
        loadedName = prefsName;
      }
    }
    if (loadedAge == null || loadedAge.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final prefsAge = prefs.getString('onboarding_age');
      if (prefsAge != null && prefsAge.isNotEmpty) {
        loadedAge = prefsAge;
      }
    }

    // Final fallback: use user model fullName if available
    if ((loadedName == null || loadedName.isEmpty) && user != null) {
      if (user.fullName.isNotEmpty && user.fullName != 'User') {
        loadedName = user.fullName;
      }
    }
    // If we want a fallback value for age, could add here
    userName.value = loadedName?.isNotEmpty == true ? loadedName! : 'User';
    userAge.value = loadedAge?.isNotEmpty == true ? loadedAge! : '';
  }

  // Calculate pregnancy progress based on due date
  void _calculatePregnancyProgress() {
    final user = authService.currentUser.value;
    if (user?.dueDate != null) {
      final today = DateTime.now();
      final dueDate = user!.dueDate!;

      // Calculate pregnancy start (40 weeks before due date)
      final pregnancyStart = dueDate.subtract(const Duration(days: 280));

      // Calculate current pregnancy days
      final pregnancyDays = today.difference(pregnancyStart).inDays;
      this.pregnancyDays.value = pregnancyDays > 0 ? pregnancyDays : 0;

      // Calculate current pregnancy week
      final pregnancyWeek = (pregnancyDays / 7).floor();
      pregnancyWeekNumber.value = pregnancyWeek > 0 ? pregnancyWeek : 1;

      // Determine trimester
      if (pregnancyWeek <= 12) {
        trimester.value = "first_trimester".tr;
      } else if (pregnancyWeek <= 26) {
        trimester.value = "second_trimester".tr;
      } else {
        trimester.value = "third_trimester".tr;
      }
    }
  }

  String _formatDueDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // Update due date and recalculate pregnancy progress
  Future<void> updateDueDate(DateTime newDueDate) async {
    await authService.updateDueDate(newDueDate);
    dueDate.value = _formatDueDate(newDueDate);
    _calculatePregnancyProgress();
    _updateCurrentWeekData();

    Get.snackbar(
      'Success',
      'Due date updated successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );
  }

  String getGreeting() {
    final int hour = DateTime.now().hour;
    if (hour < 12) {
      return "good_morning".tr;
    } else if (hour < 17) {
      return "good_afternoon".tr;
    } else if (hour < 21) {
      return "good_evening".tr;
    } else {
      return "good_night".tr;
    }
  }

  Future<void> showDatePickerDialog(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: authService.currentUser.value?.dueDate ??
          DateTime.now().add(const Duration(days: 280)), // 40 weeks from now
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: NeoSafeColors.primaryPink,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: NeoSafeColors.primaryText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      updatePregnancyData(picked);
    }
  }

  String getMonthName(int month) {
    final List<String> months = [
      'jan'.tr,
      'feb'.tr,
      'mar'.tr,
      'apr'.tr,
      'may'.tr,
      'jun'.tr,
      'jul'.tr,
      'aug'.tr,
      'sep'.tr,
      'oct'.tr,
      'nov'.tr,
      'dec'.tr
    ];
    return months[month - 1];
  }

  String getFormattedDueDate(DateTime date) {
    return "${date.day} ${getMonthName(date.month)} ${date.year}";
  }

  void updatePregnancyData(DateTime selectedDueDate) {
    final DateTime today = DateTime.now();
    final DateTime conceptionDate =
        selectedDueDate.subtract(const Duration(days: 280)); // 40 weeks back
    final int daysPregnant = today.difference(conceptionDate).inDays;

    // Validate the pregnancy data
    int weeksPregnant = (daysPregnant / 7).floor();
    // final int daysInCurrentWeek = daysPregnant % 7;

    // Ensure weeks are within valid range (0-40 weeks)
    if (weeksPregnant < 0) {
      weeksPregnant = 0;
    } else if (weeksPregnant > 40) {
      weeksPregnant = 40;
    }

    pregnancyWeekNumber.value = weeksPregnant;
    pregnancyDays.value = daysPregnant > 0 ? daysPregnant : 0;
    dueDate.value = getFormattedDueDate(selectedDueDate);

    // Update trimester
    if (weeksPregnant < 13) {
      trimester.value = "first_trimester".tr;
    } else if (weeksPregnant < 27) {
      trimester.value = "second_trimester".tr;
    } else {
      trimester.value = "third_trimester".tr;
    }

    _updateCurrentWeekData();
    _scheduleWeekAlerts();
    update();
  }

  String getTimelineSubtitle() {
    if (pregnancyWeekNumber.value < 13) {
      return "first_trimester_milestones".tr;
    } else if (pregnancyWeekNumber.value < 27) {
      return "second_trimester_milestones".tr;
    } else {
      return "third_trimester_milestones".tr;
    }
  }

  Future<void> _scheduleWeekAlerts() async {
    final PregnancyWeekData? data = currentWeekData.value;
    final List<String> alerts = data?.alerts ?? const [];
    // Use day-of-year as start index seed to avoid id collisions across weeks
    final int startIndex =
        DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    await NotificationService.instance.cancelAll();
    await NotificationService.instance.scheduleDailyWeekAlerts(
      startDayIndex: startIndex,
      alerts: alerts.isNotEmpty
          ? alerts
          : ['Check your pregnancy alerts for today.'],
      hour: 9,
      minute: 0,
      alertText: alerts.isNotEmpty && data?.alertText != null
          ? data!.alertText!
          : 'Stay informed about your pregnancy progress.',
      week: pregnancyWeekNumber.value,
    );

    // In debug, show all alerts in a single expanded notification now (no extra scheduled immediate notif)
    if (kDebugMode && alerts.isNotEmpty) {
      await NotificationService.instance.showAlertsListNow(
        // alerts: alerts,
        alertText:
            data?.alertText ?? 'Stay informed about your pregnancy progress.',
        week: pregnancyWeekNumber.value,
      );
    }
  }

  void showWhereYouAreBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              NeoSafeColors.creamWhite,
              NeoSafeColors.lightBeige,
            ],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "where_you_are".tr,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: NeoSafeColors.primaryText,
                              ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: NeoSafeColors.primaryPink.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.close,
                          color: NeoSafeColors.primaryPink,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildInfoRow(
                  context,
                  icon: Icons.child_care,
                  iconColor: NeoSafeColors.primaryPink,
                  text: "estimated_due_date".trParams({"date": dueDate.value}),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  context,
                  icon: Icons.pregnant_woman,
                  iconColor: NeoSafeColors.primaryPink,
                  text: "pregnancy_progress".trParams({
                    "weeks": "${pregnancyWeekNumber.value}",
                    "days": "${pregnancyDays.value % 7}"
                  }),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  context,
                  icon: Icons.calendar_today,
                  iconColor: NeoSafeColors.info,
                  text: "time_remaining".trParams({
                    "weeks": "${40 - pregnancyWeekNumber.value}",
                    "days": "${7 - (pregnancyDays.value % 7)}"
                  }),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        NeoSafeColors.lightPink,
                        NeoSafeColors.primaryPink,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: NeoSafeColors.primaryPink.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      showDatePickerDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "edit_due_date".tr,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  iconColor.withOpacity(0.2),
                  iconColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: NeoSafeColors.primaryText,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  void _initializeWithDueDate(DateTime due) {
    dueDate.value = getFormattedDueDate(due);
    final conceptionDate =
        due.subtract(const Duration(days: 280)); // 9 months ~ 40 weeks
    final today = DateTime.now();
    final daysPregnant = today.difference(conceptionDate).inDays;
    int weeksPregnant = (daysPregnant / 7).floor();
    if (weeksPregnant < 0) {
      weeksPregnant = 0;
    } else if (weeksPregnant > 40) {
      weeksPregnant = 40;
    }
    pregnancyWeekNumber.value = weeksPregnant;
    pregnancyDays.value = daysPregnant > 0 ? daysPregnant : 0;
    // Update trimester
    if (weeksPregnant < 13) {
      trimester.value = "first_trimester".tr;
    } else if (weeksPregnant < 27) {
      trimester.value = "second_trimester".tr;
    } else {
      trimester.value = "third_trimester".tr;
    }
    _initializeAnimations();
    _loadUserData(); // Load username when initializing with due date
    _updateCurrentWeekData();
    _scheduleWeekAlerts();
    update();
  }

  // Show BMI calculation dialog
  void showBMIDialog(BuildContext context) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Load existing values
    final userId = authService.currentUser.value?.id;
    String initialHeightStr = '5-6'; // Default: 5 feet 6 inches
    String initialWeightStr = '';

    if (userId != null) {
      final prefs = await SharedPreferences.getInstance();

      // Try to load existing height and weight
      String? savedHeightStr =
          await authService.getOnboardingData('onboarding_height', userId);
      savedHeightStr ??= prefs.getString('onboarding_height_$userId');

      String? savedWeightStr = await authService.getOnboardingData(
          'onboarding_pre_pregnancy_weight', userId);
      savedWeightStr ??=
          prefs.getString('onboarding_pre_pregnancy_weight_$userId');

      // Convert height from cm to feet-inches if available
      if (savedHeightStr != null && savedHeightStr.isNotEmpty) {
        final heightCm = double.tryParse(savedHeightStr);
        if (heightCm != null && heightCm > 0) {
          final totalInches = heightCm / 2.54;
          final feet = (totalInches / 12).floor();
          final inches = (totalInches % 12).round();
          initialHeightStr = '$feet-$inches';
        }
      }

      if (savedWeightStr != null && savedWeightStr.isNotEmpty) {
        initialWeightStr = savedWeightStr;
      }
    }

    final heightStrNotifier = ValueNotifier<String>(initialHeightStr);
    final bmiNotifier = ValueNotifier<double>(0.0);
    final weightController = TextEditingController(text: initialWeightStr);
    bool isDisposed = false;

    // Calculate initial BMI if we have values
    if (initialWeightStr.isNotEmpty && initialHeightStr != '5-6') {
      final parts = initialHeightStr.split('-');
      if (parts.length == 2) {
        final feet = int.tryParse(parts[0]);
        final inches = int.tryParse(parts[1]);
        if (feet != null && inches != null) {
          final cm = (feet * 30.48) + (inches * 2.54);
          final weightValue = double.tryParse(initialWeightStr);
          if (weightValue != null && weightValue > 0 && cm > 0) {
            final heightMeters = cm / 100.0;
            bmiNotifier.value = weightValue / (heightMeters * heightMeters);
          }
        }
      }
    }

    double _computeBmi(String h, String w) {
      // h is in format "feet-inches" (e.g., "5-6")
      final parts = h.split('-');
      if (parts.length != 2) return 0.0;
      final feet = int.tryParse(parts[0]);
      final inches = int.tryParse(parts[1]);
      if (feet == null || inches == null) return 0.0;

      // Convert to cm
      final cm = (feet * 30.48) + (inches * 2.54);
      final ww = double.tryParse(w);
      if (ww == null || ww <= 0 || cm <= 0) return 0.0;

      final meters = cm / 100.0;
      return ww / (meters * meters);
    }

    void _updateBMI() {
      if (isDisposed) return;
      final heightStr = heightStrNotifier.value;
      final weightStr = weightController.text.trim();

      // Parse height
      final parts = heightStr.split('-');
      if (parts.length != 2) {
        bmiNotifier.value = 0.0;
        return;
      }

      final feet = int.tryParse(parts[0]);
      final inches = int.tryParse(parts[1]);
      if (feet == null || inches == null) {
        bmiNotifier.value = 0.0;
        return;
      }

      // Convert to cm
      final cm = (feet * 30.48) + (inches * 2.54);

      // Parse weight
      final weightValue = double.tryParse(weightStr);
      if (weightValue == null || weightValue <= 0 || cm <= 0) {
        bmiNotifier.value = 0.0;
        return;
      }

      // Calculate BMI: weight (kg) / (height in meters)^2
      final heightMeters = cm / 100.0;
      bmiNotifier.value = weightValue / (heightMeters * heightMeters);
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    NeoSafeColors.creamWhite,
                    NeoSafeColors.lightBeige,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'height_weight_calculate_bmi'.tr,
                          style: Get.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: NeoSafeColors.primaryText,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: NeoSafeColors.primaryPink.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () => Get.back(),
                            icon: Icon(
                              Icons.close,
                              color: NeoSafeColors.primaryPink,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // BMI Input Container
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: NeoSafeColors.softGray,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ValueListenableBuilder<String>(
                                        valueListenable: heightStrNotifier,
                                        builder: (context, heightStr, _) {
                                          return DropdownButtonFormField<int>(
                                            value: int.tryParse(heightStr
                                                        .split('-')
                                                        .firstOrNull ??
                                                    '5') ??
                                                5,
                                            items: List.generate(
                                                    9, (i) => i + 3)
                                                .map((ft) => DropdownMenuItem(
                                                      value: ft,
                                                      child: Text(
                                                        "${ft}ft",
                                                        style: TextStyle(
                                                          fontSize:
                                                              screenWidth *
                                                                  0.033,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                            onChanged: (ft) {
                                              final inches = int.tryParse(
                                                      heightStrNotifier.value
                                                              .split('-')
                                                              .lastOrNull ??
                                                          '6') ??
                                                  6;
                                              heightStrNotifier.value =
                                                  "${ft ?? 5}-${inches}";
                                              _updateBMI();
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'feet'.tr,
                                              labelStyle: TextStyle(
                                                  fontSize: screenWidth * 0.03),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: screenWidth * 0.02,
                                                vertical: screenHeight * 0.01,
                                              ),
                                              isDense: true,
                                            ),
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.033,
                                                color: Colors.black87),
                                            dropdownColor: Colors.white,
                                            isExpanded: true,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.015),
                                    Expanded(
                                      child: ValueListenableBuilder<String>(
                                        valueListenable: heightStrNotifier,
                                        builder: (context, heightStr, _) {
                                          return DropdownButtonFormField<int>(
                                            value: int.tryParse(heightStr
                                                        .split('-')
                                                        .lastOrNull ??
                                                    '6') ??
                                                6,
                                            items: List.generate(12, (i) => i)
                                                .map((inch) => DropdownMenuItem(
                                                      value: inch,
                                                      child: Text(
                                                        "${inch}in",
                                                        style: TextStyle(
                                                          fontSize:
                                                              screenWidth *
                                                                  0.033,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                            onChanged: (inch) {
                                              final feet = int.tryParse(
                                                      heightStrNotifier.value
                                                              .split('-')
                                                              .firstOrNull ??
                                                          '5') ??
                                                  5;
                                              heightStrNotifier.value =
                                                  "$feet-${inch ?? 0}";
                                              _updateBMI();
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'inch'.tr,
                                              labelStyle: TextStyle(
                                                  fontSize: screenWidth * 0.03),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: screenWidth * 0.02,
                                                vertical: screenHeight * 0.01,
                                              ),
                                              isDense: true,
                                            ),
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.033,
                                                color: Colors.black87),
                                            dropdownColor: Colors.white,
                                            isExpanded: true,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Expanded(
                                flex: 4,
                                child: TextField(
                                  key: const ValueKey('bmi_weight_field'),
                                  controller: weightController,
                                  decoration: InputDecoration(
                                    labelText: 'weight'.tr,
                                    labelStyle:
                                        TextStyle(fontSize: screenWidth * 0.03),
                                    hintText: '62.5',
                                    hintStyle:
                                        TextStyle(fontSize: screenWidth * 0.03),
                                    suffixText: 'kg',
                                    suffixStyle:
                                        TextStyle(fontSize: screenWidth * 0.03),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.025,
                                      vertical: screenHeight * 0.01,
                                    ),
                                    isDense: true,
                                  ),
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.033),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  onChanged: (v) {
                                    _updateBMI();
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.012),
                          ValueListenableBuilder<double>(
                            valueListenable: bmiNotifier,
                            builder: (context, bmi, _) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    bmi > 0
                                        // ? 'BMI: ${bmi.toStringAsFixed(1)}'
                                        // : 'BMI: --',
                                        ? '${'bmi'.tr}: ${bmi.toStringAsFixed(1)}'
                                        : '${'bmi'.tr}: --',
                                    style: Get.textTheme.bodyMedium?.copyWith(
                                      color: NeoSafeColors.primaryText,
                                      fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.038,
                                    ),
                                  ),
                                  if (bmi > 0)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.025,
                                        vertical: screenHeight * 0.007,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (bmi < 18.5
                                            ? Colors.orange.shade100
                                            : bmi < 25
                                                ? Colors.green.shade100
                                                : bmi < 30
                                                    ? Colors.yellow.shade100
                                                    : Colors.red.shade100),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        bmi < 18.5
                                            ? 'bmi_underweight'.tr
                                            : bmi < 25
                                                ? 'bmi_normal'.tr
                                                : bmi < 30
                                                    ? 'bmi_overweight'.tr
                                                    : 'bmi_obese'.tr,
                                        style: TextStyle(
                                          color: (bmi < 18.5
                                              ? Colors.orange.shade800
                                              : bmi < 25
                                                  ? Colors.green.shade800
                                                  : bmi < 30
                                                      ? Colors.amber.shade800
                                                      : Colors.red.shade800),
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenWidth * 0.032,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.065,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (isDisposed) return;

                          try {
                            final weightStr = weightController.text.trim();

                            // Recalculate BMI before saving to ensure it's up to date
                            _updateBMI();
                            final bmi = bmiNotifier.value;

                            print(
                                'Save button pressed - Weight: $weightStr, BMI: $bmi');

                            // Validate weight is not empty
                            if (weightStr.isEmpty) {
                              Get.snackbar(
                                'oops'.tr,
                                'please_enter_height_and_weight'.tr,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                    NeoSafeColors.primaryPink.withOpacity(0.9),
                                colorText: Colors.white,
                                margin: EdgeInsets.all(screenWidth * 0.04),
                                borderRadius: 12,
                              );
                              return;
                            }

                            // Validate weight is a valid number
                            final weightValue = double.tryParse(weightStr);
                            if (weightValue == null || weightValue <= 0) {
                              Get.snackbar(
                                'oops'.tr,
                                'please_enter_valid_height_and_weight'.tr,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                    NeoSafeColors.primaryPink.withOpacity(0.9),
                                colorText: Colors.white,
                                margin: EdgeInsets.all(screenWidth * 0.04),
                                borderRadius: 12,
                              );
                              return;
                            }

                            // Save height and weight
                            final userId = authService.currentUser.value?.id;
                            print('User ID: $userId');

                            if (userId == null || userId.isEmpty) {
                              Get.snackbar(
                                'oops'.tr,
                                'user_not_found'.tr,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                    NeoSafeColors.primaryPink.withOpacity(0.9),
                                colorText: Colors.white,
                                margin: EdgeInsets.all(screenWidth * 0.04),
                                borderRadius: 12,
                              );
                              return;
                            }

                            final prefs = await SharedPreferences.getInstance();

                            // Convert height to cm
                            final heightStr = heightStrNotifier.value;
                            final parts = heightStr.split('-');
                            if (parts.length != 2) {
                              Get.snackbar(
                                'oops'.tr,
                                'invalid_height_format'.tr,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                    NeoSafeColors.primaryPink.withOpacity(0.9),
                                colorText: Colors.white,
                                margin: EdgeInsets.all(screenWidth * 0.04),
                                borderRadius: 12,
                              );
                              return;
                            }

                            final feet = int.tryParse(parts[0]) ?? 5;
                            final inches = int.tryParse(parts[1]) ?? 6;
                            final cm = (feet * 30.48) + (inches * 2.54);

                            print('Height: $feet feet $inches inches = $cm cm');

                            // Validate height
                            if (cm <= 0) {
                              Get.snackbar(
                                'oops'.tr,
                                'please_enter_valid_height_and_weight'.tr,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                    NeoSafeColors.primaryPink.withOpacity(0.9),
                                colorText: Colors.white,
                                margin: EdgeInsets.all(screenWidth * 0.04),
                                borderRadius: 12,
                              );
                              return;
                            }

                            // Save to SharedPreferences first
                            print('Saving to SharedPreferences...');
                            final heightSaved = await prefs.setString(
                                'onboarding_height_$userId',
                                cm.toStringAsFixed(2));
                            final weightSaved = await prefs.setString(
                                'onboarding_pre_pregnancy_weight_$userId',
                                weightStr);

                            print(
                                'SharedPreferences save - Height: $heightSaved, Weight: $weightSaved');

                            if (!heightSaved || !weightSaved) {
                              print(
                                  'Error: Failed to save to SharedPreferences');
                            }

                            // Also save via AuthService
                            print('Saving via AuthService...');
                            await authService.setOnboardingData(
                                'onboarding_height',
                                userId,
                                cm.toStringAsFixed(2));
                            await authService.setOnboardingData(
                                'onboarding_pre_pregnancy_weight',
                                userId,
                                weightStr);

                            // Verify the save
                            final savedHeight = await authService
                                .getOnboardingData('onboarding_height', userId);
                            final savedWeight =
                                await authService.getOnboardingData(
                                    'onboarding_pre_pregnancy_weight', userId);

                            print(
                                'Verification - Saved height: $savedHeight, Saved weight: $savedWeight');

                            if (savedHeight == null || savedWeight == null) {
                              print('Warning: Save verification failed!');
                            }

                            // Reload WeightTrackingController if it exists
                            if (Get.isRegistered<WeightTrackingController>()) {
                              print('Reloading WeightTrackingController...');
                              final weightTrackingController =
                                  Get.find<WeightTrackingController>();
                              await weightTrackingController.loadUserData();
                              await weightTrackingController
                                  .loadWeightEntries();
                              weightTrackingController
                                  .calculateWeightGainTargets();
                              weightTrackingController.updateCurrentWeight();
                              weightTrackingController.checkAlerts();
                              weightTrackingController.update();
                              print(
                                  'WeightTrackingController reloaded - Pre-pregnancy weight: ${weightTrackingController.prePregnancyWeight.value}, Current weight: ${weightTrackingController.currentWeight.value}, BMI: ${weightTrackingController.prePregnancyBMI.value.toStringAsFixed(1)}, Weight entries: ${weightTrackingController.weightEntries.length}');
                            } else {
                              print('Creating new WeightTrackingController...');
                              // If not registered, put it so it can load the data
                              final weightTrackingController =
                                  Get.put(WeightTrackingController());
                              await weightTrackingController.loadUserData();
                              await weightTrackingController
                                  .loadWeightEntries();
                              weightTrackingController
                                  .calculateWeightGainTargets();
                              weightTrackingController.updateCurrentWeight();
                              weightTrackingController.checkAlerts();
                              print(
                                  'WeightTrackingController created and loaded - Pre-pregnancy weight: ${weightTrackingController.prePregnancyWeight.value}, Current weight: ${weightTrackingController.currentWeight.value}, BMI: ${weightTrackingController.prePregnancyBMI.value.toStringAsFixed(1)}, Weight entries: ${weightTrackingController.weightEntries.length}');
                            }

                            // Mark as disposed before closing
                            isDisposed = true;

                            Get.back();

                            // Small delay to ensure dialog is closed
                            await Future.delayed(
                                const Duration(milliseconds: 100));

                            Get.snackbar(
                              'success'.tr,
                              'bmi_saved_successfully'.tr,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green.withOpacity(0.9),
                              colorText: Colors.white,
                              margin: EdgeInsets.all(screenWidth * 0.04),
                              borderRadius: 12,
                              duration: const Duration(seconds: 2),
                            );
                          } catch (e, stackTrace) {
                            print('Error saving BMI: $e');
                            print('Stack trace: $stackTrace');
                            Get.snackbar(
                              'error'.tr,
                              'failed_to_save_bmi'.tr,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red.withOpacity(0.9),
                              colorText: Colors.white,
                              margin: EdgeInsets.all(screenWidth * 0.04),
                              borderRadius: 12,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: NeoSafeColors.primaryPink,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          'save'.tr,
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ).then((_) {
      // Cleanup when dialog is closed - with delay to ensure dialog is fully closed
      Future.delayed(const Duration(milliseconds: 300), () {
        try {
          if (!isDisposed) {
            isDisposed = true;
          }
          weightController.dispose();
          heightStrNotifier.dispose();
          bmiNotifier.dispose();
        } catch (e) {
          print('Error disposing BMI dialog resources: $e');
        }
      });
    });
  }

  Future<void> updateUserAge(String age) async {
    userAge.value = age;
    if (authService.currentUser.value != null) {
      final userId = authService.currentUser.value!.id;
      await authService.setOnboardingData('onboarding_age', userId, age);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('onboarding_age', age);
    }
  }

  Future<void> updateUserGender(String gender) async {
    userGender.value = gender;
    if (authService.currentUser.value != null) {
      final userId = authService.currentUser.value!.id;
      await authService.setOnboardingData('onboarding_gender', userId, gender);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('onboarding_gender', gender);
    }
    // Also update ProfileController if it exists
    try {
      if (Get.isRegistered<ProfileController>()) {
        final profileController = Get.find<ProfileController>();
        profileController.userGender.value = gender;
      }
    } catch (e) {
      print('ProfileController not available: $e');
    }
  }
}
