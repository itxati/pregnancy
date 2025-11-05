import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:babysafe/app/services/auth_service.dart';
import 'package:babysafe/app/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetPregnantRequirementsController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController pulseController;
  late Animation<double> scaleAnimation;
  late Animation<double> pulseAnimation;

  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rxn<DateTime> periodStart = Rxn<DateTime>();
  Rxn<DateTime> periodEnd = Rxn<DateTime>();
  Rxn<DateTime> selectedDay = Rxn<DateTime>();
  RxSet<DateTime> intercourseLog = <DateTime>{}.obs;

  int cycleLength = 28;
  int periodLength = 5;

  late AuthService authService;

  // Pregnancy tracking variables
  RxInt pregnancyWeekNumber = 0.obs;
  RxInt pregnancyDays = 0.obs;
  RxString trimester = "".obs;
  RxString dueDate = "".obs;

  @override
  void onInit() {
    super.onInit();
    authService = Get.find<AuthService>();

    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
    );
    pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );

    animationController.forward();

    // Load data from SharedPreferences
    _loadUserData();

    // Check for auto-update of period start
    _checkPeriodUpdate();

    // Load pregnancy data if available
    _loadPregnancyData();
  }

  @override
  void onClose() {
    animationController.dispose();
    pulseController.dispose();
    super.onClose();
  }

  List<DateTime> getPeriodDays() {
    if (periodStart.value == null) return [];
    return List.generate(
        periodLength, (i) => periodStart.value!.add(Duration(days: i)));
  }

  List<DateTime> getFertileDays() {
    if (periodStart.value == null) return [];
    // Fertile days start after period ends and last for 7 days
    final fertileStart = periodStart.value!.add(Duration(days: periodLength));
    return List.generate(7, (i) => fertileStart.add(Duration(days: i)));
  }

  DateTime getOvulationDay() {
    if (periodStart.value == null) return DateTime.now();
    // Ovulation day is the last day of fertile window (7th day after period ends)
    return periodStart.value!.add(Duration(days: periodLength + 6));
  }

  DateTime getNextPeriod() {
    if (periodStart.value == null) {
      print('GetNextPeriod - Period Start is null, returning now');
      return DateTime.now();
    }
    final nextPeriod = periodStart.value!.add(Duration(days: cycleLength));
    print(
        'GetNextPeriod - Period Start: ${periodStart.value}, Cycle Length: $cycleLength, Next Period: $nextPeriod');
    return nextPeriod;
  }

  int getCycleDay(DateTime day) {
    if (periodStart.value == null) return 0;
    final diff = day.difference(periodStart.value!).inDays + 1;
    return diff > 0 ? diff : 0;
  }

  bool isPeriodDay(DateTime day) {
    return getPeriodDays().any((d) => isSameDay(d, day));
  }

  bool isFertileDay(DateTime day) {
    return getFertileDays().any((d) => isSameDay(d, day));
  }

  bool isOvulationDay(DateTime day) {
    return isSameDay(getOvulationDay(), day);
  }

  bool hasIntercourse(DateTime day) {
    return intercourseLog.any((d) => isSameDay(d, day));
  }

  String getPregnancyChance(DateTime day) {
    if (isOvulationDay(day)) return "Peak";
    if (isFertileDay(day)) return "High";
    final cycleDay = getCycleDay(day);
    // Medium chance during the fertile window and a few days before/after
    if (cycleDay >= periodLength + 1 && cycleDay <= periodLength + 10)
      return "Medium";
    return "Low";
  }

  // Helper for TableCalendar
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void setPeriod(DateTime start, DateTime end) async {
    periodStart.value = start;
    periodEnd.value = end;
    periodLength = end.difference(start).inDays + 1;

    // Save to SharedPreferences
    await authService.updatePeriodStart(start);
    await authService.updateCycleSettings(periodLength: periodLength);

    update();
  }

  void setSelectedDay(DateTime day) {
    selectedDay.value = day;
    focusedDay.value = day;
    update();
  }

  // Load user data from SharedPreferences
  void _loadUserData() {
    final user = authService.currentUser.value;
    if (user != null) {
      // Load period start date
      if (user.lastPeriodStart != null) {
        periodStart.value = user.lastPeriodStart;
        periodEnd.value =
            user.lastPeriodStart!.add(Duration(days: user.periodLength - 1));
      }

      // Load cycle settings
      cycleLength = user.cycleLength;
      periodLength = user.periodLength;

      // Load intercourse log
      intercourseLog.clear();
      intercourseLog.addAll(user.intercourseLog);
      intercourseLog.refresh();
    }

    // Also load data from goal onboarding SharedPreferences
    _loadGoalOnboardingData();
  }

  // Load data from goal onboarding SharedPreferences
  Future<void> _loadGoalOnboardingData() async {
    final prefs = await SharedPreferences.getInstance();
    final auth = Get.find<AuthService>();
    final userId = auth.currentUser.value?.id;

    String? lastPeriodString;
    int? cycleLen;

    // Prefer user-scoped onboarding values
    if (userId != null && userId.isNotEmpty) {
      lastPeriodString = await auth.getOnboardingData('onboarding_last_period', userId);
      // Ints are saved under per-user key; read directly from prefs
      final userScopedCycleKey = 'onboarding_cycle_length_user_$userId';
      cycleLen = prefs.getInt(userScopedCycleKey);
    }

    // Fallback to global keys if needed
    lastPeriodString ??= prefs.getString('onboarding_last_period');
    cycleLen ??= prefs.getInt('onboarding_cycle_length');

    // Apply last period
    if (lastPeriodString != null) {
      final lastPeriodDate = DateTime.parse(lastPeriodString);
      periodStart.value = lastPeriodDate;
      periodEnd.value = lastPeriodDate.add(Duration(days: periodLength - 1));
    }

    // Apply cycle length
    if (cycleLen != null) {
      cycleLength = cycleLen;
    }

    // Update the UI
    update();
  }

  // Check and update period start if needed
  Future<void> _checkPeriodUpdate() async {
    await authService.checkAndUpdatePeriodStart();
    _loadUserData(); // Reload data after potential update
  }

  // Update period start date and save to SharedPreferences
  Future<void> setPeriodStart(DateTime start) async {
    periodStart.value = start;
    periodEnd.value = start.add(Duration(days: periodLength - 1));

    // Save to SharedPreferences
    await authService.updatePeriodStart(start);

    // Schedule period reminder notification
    await NotificationService.instance.schedulePeriodReminder(
      periodStartDate: start,
      cycleLength: cycleLength,
    );

    update();
  }

  // Update cycle settings and save to SharedPreferences
  Future<void> updateCycleSettings(
      {int? newCycleLength, int? newPeriodLength}) async {
    if (newCycleLength != null) cycleLength = newCycleLength;
    if (newPeriodLength != null) periodLength = newPeriodLength;

    // Save to SharedPreferences
    await authService.updateCycleSettings(
      cycleLength: cycleLength,
      periodLength: periodLength,
    );

    // Update period reminder if period start is set
    if (periodStart.value != null) {
      await NotificationService.instance.cancelPeriodReminder();
      await NotificationService.instance.schedulePeriodReminder(
        periodStartDate: periodStart.value!,
        cycleLength: cycleLength,
      );
    }

    update();
  }

  // Toggle intercourse log and save to SharedPreferences
  Future<void> toggleIntercourse(DateTime day) async {
    final existingDate = intercourseLog.firstWhere(
      (d) => isSameDay(d, day),
      orElse: () => DateTime(0),
    );

    if (existingDate.year != 0) {
      intercourseLog.remove(existingDate);
      await authService.removeIntercourseLog(day);
    } else {
      intercourseLog.add(day);
      await authService.addIntercourseLog(day);
    }
    intercourseLog.refresh();
  }

  // Load pregnancy data from SharedPreferences
  void _loadPregnancyData() {
    final user = authService.currentUser.value;
    if (user?.dueDate != null) {
      dueDate.value = _formatDueDate(user!.dueDate!);
      _calculatePregnancyProgress();
    }
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
        trimester.value = "First trimester";
      } else if (pregnancyWeek <= 26) {
        trimester.value = "Second trimester";
      } else {
        trimester.value = "Third trimester";
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
    return '${date.day} ${months[date.month - 1]}';
  }
}
