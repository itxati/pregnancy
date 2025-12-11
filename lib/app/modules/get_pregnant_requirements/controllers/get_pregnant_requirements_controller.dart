// // // import 'package:get/get.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:babysafe/app/services/auth_service.dart';
// // // import 'package:babysafe/app/services/notification_service.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import '../../profile/controllers/profile_controller.dart';

// // // class GetPregnantRequirementsController extends GetxController
// // //     with GetTickerProviderStateMixin {
// // //   late AnimationController animationController;
// // //   late AnimationController pulseController;
// // //   late Animation<double> scaleAnimation;
// // //   late Animation<double> pulseAnimation;

// // //   Rx<DateTime> focusedDay = DateTime.now().obs;
// // //   Rxn<DateTime> periodStart = Rxn<DateTime>();
// // //   Rxn<DateTime> periodEnd = Rxn<DateTime>();
// // //   Rxn<DateTime> selectedDay = Rxn<DateTime>();
// // //   RxSet<DateTime> intercourseLog = <DateTime>{}.obs;

// // //   RxInt cycleLength = 28.obs;
// // //   RxInt periodLength = 7.obs;

// // //   late AuthService authService;
// // //   bool _promptActive = false;

// // //   // Pregnancy tracking variables
// // //   RxInt pregnancyWeekNumber = 0.obs;
// // //   RxInt pregnancyDays = 0.obs;
// // //   RxString trimester = "".obs;
// // //   RxString dueDate = "".obs;
// // //   RxString userGender = "".obs;
// // //   RxString userAge = "".obs;

// // //   @override
// // //   void onInit() {
// // //     super.onInit();
// // //     authService = Get.find<AuthService>();

// // //     animationController = AnimationController(
// // //       duration: const Duration(milliseconds: 300),
// // //       vsync: this,
// // //     );
// // //     pulseController = AnimationController(
// // //       duration: const Duration(seconds: 2),
// // //       vsync: this,
// // //     )..repeat(reverse: true);

// // //     scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
// // //       CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
// // //     );
// // //     pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
// // //       CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
// // //     );

// // //     animationController.forward();

// // //     // Load data from SharedPreferences
// // //     _loadUserData();

// // //     // Removed silent auto-update; prompts will handle user-driven updates

// // //     // Load pregnancy data if available
// // //     _loadPregnancyData();
// // //   }

// // //   @override
// // //   void onClose() {
// // //     animationController.dispose();
// // //     pulseController.dispose();
// // //     super.onClose();
// // //   }

// // //   List<DateTime> getPeriodDays() {
// // //     if (periodStart.value == null) return [];
// // //     return List.generate(
// // //         periodLength.value, (i) => periodStart.value!.add(Duration(days: i)));
// // //   }

// // //   // List<DateTime> getFertileDays() {
// // //   //   if (periodStart.value == null) return [];
// // //   //   // Fertile days start after period ends and last for 7 days
// // //   //   final fertileStart = periodStart.value!.add(Duration(days: periodLength));
// // //   //   return List.generate(7, (i) => fertileStart.add(Duration(days: i)));
// // //   // }

// // //   List<DateTime> getFertileDays() {
// // //     if (periodStart.value == null) return [];

// // //     // Fertile window = 5 days before ovulation + ovulation day + 1 day after
// // //     final ovulation = getOvulationDay();
// // //     return List.generate(7, (i) => ovulation.subtract(Duration(days: 5 - i)));
// // //   }

// // //   DateTime getOvulationDay() {
// // //     if (periodStart.value == null) return DateTime.now();
// // //     // Ovulation day is the last day of fertile window (7th day after period ends)
// // //     // return periodStart.value!.add(Duration(days: periodLength.value + 6));
// // //     return periodStart.value!.add(Duration(days: cycleLength.value - 14));
// // //   }

// // //   DateTime getNextPeriod() {
// // //     if (periodStart.value == null) {
// // //       print('GetNextPeriod - Period Start is null, returning now');
// // //       return DateTime.now();
// // //     }
// // //     final nextPeriod =
// // //         periodStart.value!.add(Duration(days: cycleLength.value));
// // //     print(
// // //         'GetNextPeriod - Period Start: ${periodStart.value}, Cycle Length: ${cycleLength.value}, Next Period: $nextPeriod');
// // //     return nextPeriod;
// // //   }

// // //   int getCycleDay(DateTime day) {
// // //     if (periodStart.value == null) return 0;
// // //     final diff = day.difference(periodStart.value!).inDays + 1;
// // //     return diff > 0 ? diff : 0;
// // //   }

// // //   bool isPeriodDay(DateTime day) {
// // //     return getPeriodDays().any((d) => isSameDay(d, day));
// // //   }

// // //   bool isFertileDay(DateTime day) {
// // //     return getFertileDays().any((d) => isSameDay(d, day));
// // //   }

// // //   bool isOvulationDay(DateTime day) {
// // //     return isSameDay(getOvulationDay(), day);
// // //   }

// // //   bool hasIntercourse(DateTime day) {
// // //     return intercourseLog.any((d) => isSameDay(d, day));
// // //   }

// // //   String getPregnancyChance(DateTime day) {
// // //     if (isOvulationDay(day)) return 'pregnancy_chance_peak'.tr;
// // //     if (isFertileDay(day)) return 'pregnancy_chance_high'.tr;
// // //     final cycleDay = getCycleDay(day);
// // //     // Medium chance during the fertile window and a few days before/after
// // //     if (cycleDay >= periodLength.value + 1 &&
// // //         cycleDay <= periodLength.value + 10)
// // //       return 'pregnancy_chance_medium'.tr;
// // //     return 'pregnancy_chance_low'.tr;
// // //   }

// // //   // Helper for TableCalendar
// // //   bool isSameDay(DateTime a, DateTime b) {
// // //     return a.year == b.year && a.month == b.month && a.day == b.day;
// // //   }

// // //   void setPeriod(DateTime start, DateTime end) async {
// // //     periodStart.value = start;
// // //     periodEnd.value = end;
// // //     periodLength.value = end.difference(start).inDays + 1;

// // //     // Save to SharedPreferences
// // //     await authService.updatePeriodStart(start);
// // //     await authService.updateCycleSettings(periodLength: periodLength.value);

// // //     update();
// // //   }

// // //   void setSelectedDay(DateTime day) {
// // //     selectedDay.value = day;
// // //     focusedDay.value = day;
// // //     update();
// // //   }

// // //   // Load user data from SharedPreferences
// // //   void _loadUserData() {
// // //     final user = authService.currentUser.value;
// // //     if (user != null) {
// // //       // Load period start date
// // //       if (user.lastPeriodStart != null) {
// // //         periodStart.value = user.lastPeriodStart;
// // //         periodEnd.value =
// // //             user.lastPeriodStart!.add(Duration(days: user.periodLength - 1));
// // //       }

// // //       // Load cycle settings
// // //       cycleLength.value = user.cycleLength;
// // //       periodLength.value = user.periodLength;

// // //       // Load intercourse log
// // //       intercourseLog.clear();
// // //       intercourseLog.addAll(user.intercourseLog);
// // //       intercourseLog.refresh();
// // //     }

// // //     // Also load data from goal onboarding SharedPreferences
// // //     _loadGoalOnboardingData();

// // //     // Schedule fertility notifications if applicable
// // //     _rescheduleFertilityNotifications();
// // //   }

// // //   // Load data from goal onboarding SharedPreferences
// // //   Future<void> _loadGoalOnboardingData() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     final auth = Get.find<AuthService>();
// // //     final userId = auth.currentUser.value?.id;

// // //     String? lastPeriodString;
// // //     int? cycleLen;
// // //     int? periodLen;
// // //     String? gender;
// // //     String? age;

// // //     // Prefer user-scoped onboarding values
// // //     if (userId != null && userId.isNotEmpty) {
// // //       lastPeriodString =
// // //           await auth.getOnboardingData('onboarding_last_period', userId);
// // //       gender = await auth.getOnboardingData('onboarding_gender', userId);
// // //       age = await auth.getOnboardingData('onboarding_age', userId);
// // //       // Ints are saved under per-user key; read directly from prefs
// // //       final userScopedCycleKey = 'onboarding_cycle_length_user_$userId';
// // //       final userScopedPeriodKey = 'onboarding_period_length_user_$userId';
// // //       cycleLen = prefs.getInt(userScopedCycleKey);
// // //       periodLen = prefs.getInt(userScopedPeriodKey);
// // //     }

// // //     // Fallback to global keys if needed
// // //     lastPeriodString ??= prefs.getString('onboarding_last_period');
// // //     cycleLen ??= prefs.getInt('onboarding_cycle_length');
// // //     periodLen ??= prefs.getInt('onboarding_period_length');
// // //     gender ??= prefs.getString('onboarding_gender');
// // //     age ??= prefs.getString('onboarding_age');

// // //     // Apply period length first (before calculating periodEnd)
// // //     if (periodLen != null) {
// // //       periodLength.value = periodLen;
// // //     }

// // //     // Apply cycle length
// // //     if (cycleLen != null) {
// // //       cycleLength.value = cycleLen;
// // //     }

// // //     // Apply last period (using the loaded periodLength)
// // //     if (lastPeriodString != null) {
// // //       final lastPeriodDate = DateTime.parse(lastPeriodString);
// // //       periodStart.value = lastPeriodDate;
// // //       periodEnd.value =
// // //           lastPeriodDate.add(Duration(days: periodLength.value - 1));
// // //     }

// // //     if (gender != null && gender.isNotEmpty) {
// // //       userGender.value = gender;
// // //     }
// // //     if (age != null && age.isNotEmpty) {
// // //       userAge.value = age;
// // //     }

// // //     // Update the UI
// // //     update();
// // //   }

// // //   // Check and update period start if needed
// // //   Future<void> _checkPeriodUpdate() async {
// // //     // No-op: we now prompt the user instead of silently updating
// // //   }

// // //   // Prompt user about period start or ongoing bleeding; call from view after build
// // //   Future<void> maybePromptUser(BuildContext context) async {
// // //     if (_promptActive) return;
// // //     final user = authService.currentUser.value;
// // //     if (user == null) return;

// // //     final prefs = await SharedPreferences.getInstance();
// // //     final userId = user.id;
// // //     final today = DateTime.now();
// // //     final todayKey = _formatDateKey(today);

// // //     // 1) If today is expected next period day, ask if period started
// // //     final DateTime? lastStartForPrompt =
// // //         periodStart.value ?? user.lastPeriodStart;
// // //     if (lastStartForPrompt != null) {
// // //       final expectedNext = DateTime(
// // //         lastStartForPrompt.year,
// // //         lastStartForPrompt.month,
// // //         lastStartForPrompt.day,
// // //       ).add(Duration(days: cycleLength.value));
// // //       final alreadyAskedKey = 'period_start_prompt_shown_${userId}_$todayKey';
// // //       final alreadyAsked = prefs.getBool(alreadyAskedKey) ?? false;
// // //       // Prompt on expected day and all overdue days until user says Yes
// // //       if (!alreadyAsked &&
// // //           (_isSameCalendarDay(expectedNext, today) ||
// // //               today.isAfter(expectedNext))) {
// // //         _promptActive = true;
// // //         await _askPeriodStartToday(context);
// // //         await prefs.setBool(alreadyAskedKey, true);
// // //         _promptActive = false;
// // //         return; // show only one prompt per day
// // //       }
// // //     }

// // //     // Removed bleeding prompt as requested
// // //   }

// // //   Future<void> _askPeriodStartToday(BuildContext context) async {
// // //     final result = await Get.dialog<bool>(
// // //       AlertDialog(
// // //         title: const Text('Period Check'),
// // //         content: const Text('Did your period start today?'),
// // //         actions: [
// // //           TextButton(
// // //               onPressed: () => Get.back(result: false),
// // //               child: const Text('No')),
// // //           ElevatedButton(
// // //               onPressed: () => Get.back(result: true),
// // //               child: const Text('Yes')),
// // //         ],
// // //       ),
// // //     );

// // //     if (result == true) {
// // //       // Update last period to today and reset period length minimally to 1
// // //       final today = DateTime.now();
// // //       final prevLength =
// // //           periodLength.value; // use previous period length as default
// // //       await setPeriodStart(DateTime(today.year, today.month, today.day));
// // //       await updateCycleSettings(newPeriodLength: prevLength);
// // //     } else if (result == false) {
// // //       // Period not started; increment cycle length by one day
// // //       await updateCycleSettings(newCycleLength: cycleLength.value + 1);
// // //     }
// // //   }

// // //   String _formatDateKey(DateTime date) =>
// // //       '${date.year}-${date.month}-${date.day}';
// // //   String _formatIsoDay(DateTime date) =>
// // //       DateTime(date.year, date.month, date.day).toIso8601String();
// // //   bool _isSameCalendarDay(DateTime a, DateTime b) =>
// // //       a.year == b.year && a.month == b.month && a.day == b.day;

// // //   // Update period start date and save to SharedPreferences
// // //   Future<void> setPeriodStart(DateTime start) async {
// // //     periodStart.value = start;
// // //     periodEnd.value = start.add(Duration(days: periodLength.value - 1));

// // //     // Save to SharedPreferences
// // //     await authService.updatePeriodStart(start);

// // //     // Also persist to user-scoped onboarding for consistency with calendar load
// // //     final userId = authService.currentUser.value?.id;
// // //     if (userId != null && userId.isNotEmpty) {
// // //       await authService.setOnboardingData(
// // //           'onboarding_last_period', userId, start.toIso8601String());
// // //     } else {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setString('onboarding_last_period', start.toIso8601String());
// // //     }

// // //     // Schedule period reminder notification
// // //     await NotificationService.instance.schedulePeriodReminder(
// // //       periodStartDate: start,
// // //       cycleLength: cycleLength.value,
// // //     );

// // //     // Reschedule fertility notifications
// // //     await _rescheduleFertilityNotifications();

// // //     update();
// // //   }

// // //   // Update cycle settings and save to SharedPreferences
// // //   Future<void> updateCycleSettings(
// // //       {int? newCycleLength, int? newPeriodLength}) async {
// // //     if (newCycleLength != null) cycleLength.value = newCycleLength;
// // //     if (newPeriodLength != null) periodLength.value = newPeriodLength;

// // //     // Save to SharedPreferences
// // //     await authService.updateCycleSettings(
// // //       cycleLength: cycleLength.value,
// // //       periodLength: periodLength.value,
// // //     );

// // //     // Also persist to user-scoped onboarding for consistency with calendar load
// // //     final userId = authService.currentUser.value?.id;
// // //     if (userId != null && userId.isNotEmpty) {
// // //       await authService.setOnboardingInt(
// // //           'onboarding_cycle_length', userId, cycleLength.value);
// // //       await authService.setOnboardingInt(
// // //           'onboarding_period_length', userId, periodLength.value);
// // //     } else {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setInt('onboarding_cycle_length', cycleLength.value);
// // //       await prefs.setInt('onboarding_period_length', periodLength.value);
// // //     }

// // //     // Update period reminder if period start is set
// // //     if (periodStart.value != null) {
// // //       await NotificationService.instance.cancelPeriodReminder();
// // //       await NotificationService.instance.schedulePeriodReminder(
// // //         periodStartDate: periodStart.value!,
// // //         cycleLength: cycleLength.value,
// // //       );
// // //     }

// // //     // Reschedule fertility notifications
// // //     await _rescheduleFertilityNotifications();

// // //     update();
// // //   }

// // //   Future<void> _rescheduleFertilityNotifications() async {
// // //     try {
// // //       final user = authService.currentUser.value;
// // //       if (user == null) return;
// // //       // Check onboarding purpose: only schedule in get pregnant flow
// // //       final purpose = await authService.getOnboardingPurpose(user.id);
// // //       if (purpose != 'get_pregnant') {
// // //         await NotificationService.instance.cancelFertilityNotifications();
// // //         return;
// // //       }

// // //       final lastStart = periodStart.value ?? user.lastPeriodStart;
// // //       if (lastStart == null) return;

// // //       await NotificationService.instance.scheduleFertilityAndOvulation(
// // //         lastPeriodStart: lastStart,
// // //         periodLength: periodLength.value,
// // //         cycleLength: cycleLength.value,
// // //         hour: 9,
// // //         minute: 0,
// // //       );
// // //     } catch (e) {
// // //       print('Error scheduling fertility notifications: $e');
// // //     }
// // //   }

// // //   Future<void> updateUserGender(String gender) async {
// // //     userGender.value = gender;
// // //     final userId = authService.currentUser.value?.id;
// // //     if (userId != null && userId.isNotEmpty) {
// // //       await authService.setOnboardingData('onboarding_gender', userId, gender);
// // //     } else {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setString('onboarding_gender', gender);
// // //     }
// // //     // Also update ProfileController if it exists
// // //     try {
// // //       if (Get.isRegistered<ProfileController>()) {
// // //         final profileController = Get.find<ProfileController>();
// // //         profileController.userGender.value = gender;
// // //       }
// // //     } catch (e) {
// // //       print('ProfileController not available: $e');
// // //     }
// // //   }

// // //   Future<void> updateUserAge(String age) async {
// // //     userAge.value = age;
// // //     final userId = authService.currentUser.value?.id;
// // //     if (userId != null && userId.isNotEmpty) {
// // //       await authService.setOnboardingData('onboarding_age', userId, age);
// // //     } else {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setString('onboarding_age', age);
// // //     }
// // //   }

// // //   // Toggle intercourse log and save to SharedPreferences
// // //   Future<void> toggleIntercourse(DateTime day) async {
// // //     final existingDate = intercourseLog.firstWhere(
// // //       (d) => isSameDay(d, day),
// // //       orElse: () => DateTime(0),
// // //     );

// // //     if (existingDate.year != 0) {
// // //       intercourseLog.remove(existingDate);
// // //       await authService.removeIntercourseLog(day);
// // //     } else {
// // //       intercourseLog.add(day);
// // //       await authService.addIntercourseLog(day);
// // //     }
// // //     intercourseLog.refresh();
// // //   }

// // //   // Load pregnancy data from SharedPreferences
// // //   void _loadPregnancyData() {
// // //     final user = authService.currentUser.value;
// // //     if (user?.dueDate != null) {
// // //       dueDate.value = _formatDueDate(user!.dueDate!);
// // //       _calculatePregnancyProgress();
// // //     }
// // //   }

// // //   // Calculate pregnancy progress based on due date
// // //   void _calculatePregnancyProgress() {
// // //     final user = authService.currentUser.value;
// // //     if (user?.dueDate != null) {
// // //       final today = DateTime.now();
// // //       final dueDate = user!.dueDate!;

// // //       // Calculate pregnancy start (40 weeks before due date)
// // //       final pregnancyStart = dueDate.subtract(const Duration(days: 280));

// // //       // Calculate current pregnancy days
// // //       final pregnancyDays = today.difference(pregnancyStart).inDays;
// // //       this.pregnancyDays.value = pregnancyDays > 0 ? pregnancyDays : 0;

// // //       // Calculate current pregnancy week
// // //       final pregnancyWeek = (pregnancyDays / 7).floor();
// // //       pregnancyWeekNumber.value = pregnancyWeek > 0 ? pregnancyWeek : 1;

// // //       // Determine trimester
// // //       if (pregnancyWeek <= 12) {
// // //         trimester.value = "First trimester";
// // //       } else if (pregnancyWeek <= 26) {
// // //         trimester.value = "Second trimester";
// // //       } else {
// // //         trimester.value = "Third trimester";
// // //       }
// // //     }
// // //   }

// // //   String _formatDueDate(DateTime date) {
// // //     final months = [
// // //       'Jan',
// // //       'Feb',
// // //       'Mar',
// // //       'Apr',
// // //       'May',
// // //       'Jun',
// // //       'Jul',
// // //       'Aug',
// // //       'Sep',
// // //       'Oct',
// // //       'Nov',
// // //       'Dec'
// // //     ];
// // //     return '${date.day} ${months[date.month - 1]}';
// // //   }
// // // }

// // import 'package:get/get.dart';
// // import 'package:flutter/material.dart';
// // import 'package:babysafe/app/services/auth_service.dart';
// // import 'package:babysafe/app/services/notification_service.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../../profile/controllers/profile_controller.dart';

// // class GetPregnantRequirementsController extends GetxController
// //     with GetTickerProviderStateMixin {
// //   late AnimationController animationController;
// //   late AnimationController pulseController;
// //   late Animation<double> scaleAnimation;
// //   late Animation<double> pulseAnimation;

// //   Rx<DateTime> focusedDay = DateTime.now().obs;
// //   Rxn<DateTime> periodStart = Rxn<DateTime>();
// //   Rxn<DateTime> periodEnd = Rxn<DateTime>();
// //   Rxn<DateTime> selectedDay = Rxn<DateTime>();
// //   RxSet<DateTime> intercourseLog = <DateTime>{}.obs;

// //   RxInt cycleLength = 28.obs;
// //   RxInt periodLength = 7.obs;

// //   late AuthService authService;
// //   bool _promptActive = false;

// //   // Pregnancy tracking variables
// //   RxInt pregnancyWeekNumber = 0.obs;
// //   RxInt pregnancyDays = 0.obs;
// //   RxString trimester = "".obs;
// //   RxString dueDate = "".obs;
// //   RxString userGender = "".obs;
// //   RxString userAge = "".obs;

// //   // Flag to prevent redundant updates
// //   bool _isUpdating = false;

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     authService = Get.find<AuthService>();

// //     animationController = AnimationController(
// //       duration: const Duration(milliseconds: 300),
// //       vsync: this,
// //     );
// //     pulseController = AnimationController(
// //       duration: const Duration(seconds: 2),
// //       vsync: this,
// //     )..repeat(reverse: true);

// //     scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
// //       CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
// //     );
// //     pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
// //       CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
// //     );

// //     animationController.forward();

// //     // Load data from SharedPreferences
// //     _loadUserData();

// //     // Load pregnancy data if available
// //     _loadPregnancyData();
// //   }

// //   @override
// //   void onClose() {
// //     animationController.dispose();
// //     pulseController.dispose();
// //     super.onClose();
// //   }

// //   List<DateTime> getPeriodDays() {
// //     if (periodStart.value == null) return [];
// //     return List.generate(
// //         periodLength.value, (i) => periodStart.value!.add(Duration(days: i)));
// //   }

// //   List<DateTime> getFertileDays() {
// //     if (periodStart.value == null) return [];

// //     // Fertile window = 5 days before ovulation + ovulation day + 1 day after
// //     final ovulation = getOvulationDay();
// //     return List.generate(7, (i) => ovulation.subtract(Duration(days: 5 - i)));
// //   }

// //   DateTime getOvulationDay() {
// //     if (periodStart.value == null) return DateTime.now();
// //     return periodStart.value!.add(Duration(days: cycleLength.value - 14));
// //   }

// //   DateTime getNextPeriod() {
// //     if (periodStart.value == null) {
// //       print('GetNextPeriod - Period Start is null, returning now');
// //       return DateTime.now();
// //     }
// //     final nextPeriod =
// //         periodStart.value!.add(Duration(days: cycleLength.value));
// //     print(
// //         'GetNextPeriod - Period Start: ${periodStart.value}, Cycle Length: ${cycleLength.value}, Next Period: $nextPeriod');
// //     return nextPeriod;
// //   }

// //   int getCycleDay(DateTime day) {
// //     if (periodStart.value == null) return 0;
// //     final diff = day.difference(periodStart.value!).inDays + 1;
// //     return diff > 0 ? diff : 0;
// //   }

// //   bool isPeriodDay(DateTime day) {
// //     return getPeriodDays().any((d) => isSameDay(d, day));
// //   }

// //   bool isFertileDay(DateTime day) {
// //     return getFertileDays().any((d) => isSameDay(d, day));
// //   }

// //   bool isOvulationDay(DateTime day) {
// //     return isSameDay(getOvulationDay(), day);
// //   }

// //   bool hasIntercourse(DateTime day) {
// //     return intercourseLog.any((d) => isSameDay(d, day));
// //   }

// //   String getPregnancyChance(DateTime day) {
// //     if (isOvulationDay(day)) return 'pregnancy_chance_peak'.tr;
// //     if (isFertileDay(day)) return 'pregnancy_chance_high'.tr;
// //     final cycleDay = getCycleDay(day);
// //     // Medium chance during the fertile window and a few days before/after
// //     if (cycleDay >= periodLength.value + 1 &&
// //         cycleDay <= periodLength.value + 10)
// //       return 'pregnancy_chance_medium'.tr;
// //     return 'pregnancy_chance_low'.tr;
// //   }

// //   // Helper for TableCalendar
// //   bool isSameDay(DateTime a, DateTime b) {
// //     return a.year == b.year && a.month == b.month && a.day == b.day;
// //   }

// //   void setPeriod(DateTime start, DateTime end) async {
// //     periodStart.value = start;
// //     periodEnd.value = end;
// //     periodLength.value = end.difference(start).inDays + 1;

// //     // Save to SharedPreferences
// //     await authService.updatePeriodStart(start);
// //     await authService.updateCycleSettings(periodLength: periodLength.value);

// //     // No need to call update() - reactive values handle UI updates
// //   }

// //   void setSelectedDay(DateTime day) {
// //     selectedDay.value = day;
// //     focusedDay.value = day;
// //     // No need to call update() - reactive values handle UI updates
// //   }

// //   // Load user data from SharedPreferences
// //   void _loadUserData() {
// //     final user = authService.currentUser.value;
// //     if (user != null) {
// //       // Load period start date
// //       if (user.lastPeriodStart != null) {
// //         periodStart.value = user.lastPeriodStart;
// //         periodEnd.value =
// //             user.lastPeriodStart!.add(Duration(days: user.periodLength - 1));
// //       }

// //       // Load cycle settings
// //       cycleLength.value = user.cycleLength;
// //       periodLength.value = user.periodLength;

// //       // Load intercourse log
// //       intercourseLog.clear();
// //       intercourseLog.addAll(user.intercourseLog);
// //       intercourseLog.refresh();
// //     }

// //     // Also load data from goal onboarding SharedPreferences
// //     _loadGoalOnboardingData();

// //     // Schedule fertility notifications if applicable
// //     _rescheduleFertilityNotifications();
// //   }

// //   // Load data from goal onboarding SharedPreferences
// //   Future<void> _loadGoalOnboardingData() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final auth = Get.find<AuthService>();
// //     final userId = auth.currentUser.value?.id;

// //     String? lastPeriodString;
// //     int? cycleLen;
// //     int? periodLen;
// //     String? gender;
// //     String? age;

// //     // Prefer user-scoped onboarding values
// //     if (userId != null && userId.isNotEmpty) {
// //       lastPeriodString =
// //           await auth.getOnboardingData('onboarding_last_period', userId);
// //       gender = await auth.getOnboardingData('onboarding_gender', userId);
// //       age = await auth.getOnboardingData('onboarding_age', userId);
// //       // Ints are saved under per-user key; read directly from prefs
// //       final userScopedCycleKey = 'onboarding_cycle_length_user_$userId';
// //       final userScopedPeriodKey = 'onboarding_period_length_user_$userId';
// //       cycleLen = prefs.getInt(userScopedCycleKey);
// //       periodLen = prefs.getInt(userScopedPeriodKey);
// //     }

// //     // Fallback to global keys if needed
// //     lastPeriodString ??= prefs.getString('onboarding_last_period');
// //     cycleLen ??= prefs.getInt('onboarding_cycle_length');
// //     periodLen ??= prefs.getInt('onboarding_period_length');
// //     gender ??= prefs.getString('onboarding_gender');
// //     age ??= prefs.getString('onboarding_age');

// //     // Apply period length first (before calculating periodEnd)
// //     if (periodLen != null) {
// //       periodLength.value = periodLen;
// //     }

// //     // Apply cycle length
// //     if (cycleLen != null) {
// //       cycleLength.value = cycleLen;
// //     }

// //     // Apply last period (using the loaded periodLength)
// //     if (lastPeriodString != null) {
// //       final lastPeriodDate = DateTime.parse(lastPeriodString);
// //       periodStart.value = lastPeriodDate;
// //       periodEnd.value =
// //           lastPeriodDate.add(Duration(days: periodLength.value - 1));
// //     }

// //     if (gender != null && gender.isNotEmpty) {
// //       userGender.value = gender;
// //     }
// //     if (age != null && age.isNotEmpty) {
// //       userAge.value = age;
// //     }

// //     // No need to call update() - reactive values handle UI updates
// //   }

// //   // Prompt user about period start or ongoing bleeding; call from view after build
// //   Future<void> maybePromptUser(BuildContext context) async {
// //     if (_promptActive) return;
// //     final user = authService.currentUser.value;
// //     if (user == null) return;

// //     final prefs = await SharedPreferences.getInstance();
// //     final userId = user.id;
// //     final today = DateTime.now();
// //     final todayKey = _formatDateKey(today);

// //     // 1) If today is expected next period day, ask if period started
// //     final DateTime? lastStartForPrompt =
// //         periodStart.value ?? user.lastPeriodStart;
// //     if (lastStartForPrompt != null) {
// //       final expectedNext = DateTime(
// //         lastStartForPrompt.year,
// //         lastStartForPrompt.month,
// //         lastStartForPrompt.day,
// //       ).add(Duration(days: cycleLength.value));
// //       final alreadyAskedKey = 'period_start_prompt_shown_${userId}_$todayKey';
// //       final alreadyAsked = prefs.getBool(alreadyAskedKey) ?? false;
// //       // Prompt on expected day and all overdue days until user says Yes
// //       if (!alreadyAsked &&
// //           (_isSameCalendarDay(expectedNext, today) ||
// //               today.isAfter(expectedNext))) {
// //         _promptActive = true;
// //         await _askPeriodStartToday(context);
// //         await prefs.setBool(alreadyAskedKey, true);
// //         _promptActive = false;
// //         return; // show only one prompt per day
// //       }
// //     }
// //   }

// //   Future<void> _askPeriodStartToday(BuildContext context) async {
// //     final result = await Get.dialog<bool>(
// //       AlertDialog(
// //         title: const Text('Period Check'),
// //         content: const Text('Did your period start today?'),
// //         actions: [
// //           TextButton(
// //               onPressed: () => Get.back(result: false),
// //               child: const Text('No')),
// //           ElevatedButton(
// //               onPressed: () => Get.back(result: true),
// //               child: const Text('Yes')),
// //         ],
// //       ),
// //     );

// //     if (result == true) {
// //       // Update last period to today and reset period length minimally to 1
// //       final today = DateTime.now();
// //       final prevLength =
// //           periodLength.value; // use previous period length as default
// //       await setPeriodStart(DateTime(today.year, today.month, today.day));
// //       await updateCycleSettings(newPeriodLength: prevLength);
// //     } else if (result == false) {
// //       // Period not started; increment cycle length by one day
// //       await updateCycleSettings(newCycleLength: cycleLength.value + 1);
// //     }
// //   }

// //   String _formatDateKey(DateTime date) =>
// //       '${date.year}-${date.month}-${date.day}';
// //   String _formatIsoDay(DateTime date) =>
// //       DateTime(date.year, date.month, date.day).toIso8601String();
// //   bool _isSameCalendarDay(DateTime a, DateTime b) =>
// //       a.year == b.year && a.month == b.month && a.day == b.day;

// //   // Update period start date and save to SharedPreferences
// //   Future<void> setPeriodStart(DateTime start) async {
// //     // Check if value actually changed to prevent unnecessary updates
// //     if (periodStart.value != null &&
// //         periodStart.value!.year == start.year &&
// //         periodStart.value!.month == start.month &&
// //         periodStart.value!.day == start.day) {
// //       return; // No change needed
// //     }

// //     // Prevent multiple simultaneous updates
// //     if (_isUpdating) return;
// //     _isUpdating = true;

// //     try {
// //       periodStart.value = start;
// //       periodEnd.value = start.add(Duration(days: periodLength.value - 1));

// //       // Save to SharedPreferences
// //       await authService.updatePeriodStart(start);

// //       // Also persist to user-scoped onboarding for consistency with calendar load
// //       final userId = authService.currentUser.value?.id;
// //       if (userId != null && userId.isNotEmpty) {
// //         await authService.setOnboardingData(
// //             'onboarding_last_period', userId, start.toIso8601String());
// //       } else {
// //         final prefs = await SharedPreferences.getInstance();
// //         await prefs.setString(
// //             'onboarding_last_period', start.toIso8601String());
// //       }

// //       // Schedule period reminder notification
// //       await NotificationService.instance.schedulePeriodReminder(
// //         periodStartDate: start,
// //         cycleLength: cycleLength.value,
// //       );

// //       // Reschedule fertility notifications
// //       await _rescheduleFertilityNotifications();
// //     } finally {
// //       _isUpdating = false;
// //     }

// //     // Removed update() call - reactive values handle UI updates
// //   }

// //   // Update cycle settings and save to SharedPreferences
// //   Future<void> updateCycleSettings({
// //     int? newCycleLength,
// //     int? newPeriodLength,
// //   }) async {
// //     bool hasChanges = false;

// //     // Check if there are actual changes
// //     if (newCycleLength != null && cycleLength.value != newCycleLength) {
// //       cycleLength.value = newCycleLength;
// //       hasChanges = true;
// //     }
// //     if (newPeriodLength != null && periodLength.value != newPeriodLength) {
// //       periodLength.value = newPeriodLength;
// //       hasChanges = true;
// //     }

// //     if (!hasChanges) return; // Skip if no actual changes

// //     // Prevent multiple simultaneous updates
// //     if (_isUpdating) return;
// //     _isUpdating = true;

// //     try {
// //       // Save to SharedPreferences
// //       await authService.updateCycleSettings(
// //         cycleLength: cycleLength.value,
// //         periodLength: periodLength.value,
// //       );

// //       // Also persist to user-scoped onboarding for consistency with calendar load
// //       final userId = authService.currentUser.value?.id;
// //       if (userId != null && userId.isNotEmpty) {
// //         await authService.setOnboardingInt(
// //             'onboarding_cycle_length', userId, cycleLength.value);
// //         await authService.setOnboardingInt(
// //             'onboarding_period_length', userId, periodLength.value);
// //       } else {
// //         final prefs = await SharedPreferences.getInstance();
// //         await prefs.setInt('onboarding_cycle_length', cycleLength.value);
// //         await prefs.setInt('onboarding_period_length', periodLength.value);
// //       }

// //       // Update period reminder if period start is set
// //       if (periodStart.value != null) {
// //         await NotificationService.instance.cancelPeriodReminder();
// //         await NotificationService.instance.schedulePeriodReminder(
// //           periodStartDate: periodStart.value!,
// //           cycleLength: cycleLength.value,
// //         );
// //       }

// //       // Reschedule fertility notifications
// //       await _rescheduleFertilityNotifications();
// //     } finally {
// //       _isUpdating = false;
// //     }

// //     // Removed update() call - reactive values handle UI updates
// //   }

// //   Future<void> _rescheduleFertilityNotifications() async {
// //     try {
// //       final user = authService.currentUser.value;
// //       if (user == null) return;
// //       // Check onboarding purpose: only schedule in get pregnant flow
// //       final purpose = await authService.getOnboardingPurpose(user.id);
// //       if (purpose != 'get_pregnant') {
// //         await NotificationService.instance.cancelFertilityNotifications();
// //         return;
// //       }

// //       final lastStart = periodStart.value ?? user.lastPeriodStart;
// //       if (lastStart == null) return;

// //       await NotificationService.instance.scheduleFertilityAndOvulation(
// //         lastPeriodStart: lastStart,
// //         periodLength: periodLength.value,
// //         cycleLength: cycleLength.value,
// //         hour: 9,
// //         minute: 0,
// //       );
// //     } catch (e) {
// //       print('Error scheduling fertility notifications: $e');
// //     }
// //   }

// //   Future<void> updateUserGender(String gender) async {
// //     userGender.value = gender;
// //     final userId = authService.currentUser.value?.id;
// //     if (userId != null && userId.isNotEmpty) {
// //       await authService.setOnboardingData('onboarding_gender', userId, gender);
// //     } else {
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setString('onboarding_gender', gender);
// //     }
// //     // Also update ProfileController if it exists
// //     try {
// //       if (Get.isRegistered<ProfileController>()) {
// //         final profileController = Get.find<ProfileController>();
// //         profileController.userGender.value = gender;
// //       }
// //     } catch (e) {
// //       print('ProfileController not available: $e');
// //     }
// //   }

// //   Future<void> updateUserAge(String age) async {
// //     userAge.value = age;
// //     final userId = authService.currentUser.value?.id;
// //     if (userId != null && userId.isNotEmpty) {
// //       await authService.setOnboardingData('onboarding_age', userId, age);
// //     } else {
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setString('onboarding_age', age);
// //     }
// //   }

// //   // Toggle intercourse log and save to SharedPreferences
// //   Future<void> toggleIntercourse(DateTime day) async {
// //     final existingDate = intercourseLog.firstWhere(
// //       (d) => isSameDay(d, day),
// //       orElse: () => DateTime(0),
// //     );

// //     if (existingDate.year != 0) {
// //       intercourseLog.remove(existingDate);
// //       await authService.removeIntercourseLog(day);
// //     } else {
// //       intercourseLog.add(day);
// //       await authService.addIntercourseLog(day);
// //     }
// //     intercourseLog.refresh();
// //     // Removed update() call - reactive values handle UI updates
// //   }

// //   // Load pregnancy data from SharedPreferences
// //   void _loadPregnancyData() {
// //     final user = authService.currentUser.value;
// //     if (user?.dueDate != null) {
// //       dueDate.value = _formatDueDate(user!.dueDate!);
// //       _calculatePregnancyProgress();
// //     }
// //   }

// //   // Calculate pregnancy progress based on due date
// //   void _calculatePregnancyProgress() {
// //     final user = authService.currentUser.value;
// //     if (user?.dueDate != null) {
// //       final today = DateTime.now();
// //       final dueDate = user!.dueDate!;

// //       // Calculate pregnancy start (40 weeks before due date)
// //       final pregnancyStart = dueDate.subtract(const Duration(days: 280));

// //       // Calculate current pregnancy days
// //       final pregnancyDays = today.difference(pregnancyStart).inDays;
// //       this.pregnancyDays.value = pregnancyDays > 0 ? pregnancyDays : 0;

// //       // Calculate current pregnancy week
// //       final pregnancyWeek = (pregnancyDays / 7).floor();
// //       pregnancyWeekNumber.value = pregnancyWeek > 0 ? pregnancyWeek : 1;

// //       // Determine trimester
// //       if (pregnancyWeek <= 12) {
// //         trimester.value = "First trimester";
// //       } else if (pregnancyWeek <= 26) {
// //         trimester.value = "Second trimester";
// //       } else {
// //         trimester.value = "Third trimester";
// //       }
// //     }
// //   }

// //   String _formatDueDate(DateTime date) {
// //     final months = [
// //       'Jan',
// //       'Feb',
// //       'Mar',
// //       'Apr',
// //       'May',
// //       'Jun',
// //       'Jul',
// //       'Aug',
// //       'Sep',
// //       'Oct',
// //       'Nov',
// //       'Dec'
// //     ];
// //     return '${date.day} ${months[date.month - 1]}';
// //   }
// // }

// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:babysafe/app/services/auth_service.dart';
// import 'package:babysafe/app/services/notification_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../profile/controllers/profile_controller.dart';
// import 'dart:async';

// class GetPregnantRequirementsController extends GetxController
//     with GetTickerProviderStateMixin {
//   late AnimationController animationController;
//   late AnimationController pulseController;
//   late Animation<double> scaleAnimation;
//   late Animation<double> pulseAnimation;

//   Rx<DateTime> focusedDay = DateTime.now().obs;
//   Rxn<DateTime> periodStart = Rxn<DateTime>();
//   Rxn<DateTime> periodEnd = Rxn<DateTime>();
//   Rxn<DateTime> selectedDay = Rxn<DateTime>();
//   RxSet<DateTime> intercourseLog = <DateTime>{}.obs;

//   RxInt cycleLength = 28.obs;
//   RxInt periodLength = 7.obs;

//   late AuthService authService;
//   bool _promptActive = false;

//   // Pregnancy tracking variables
//   RxInt pregnancyWeekNumber = 0.obs;
//   RxInt pregnancyDays = 0.obs;
//   RxString trimester = "".obs;
//   RxString dueDate = "".obs;
//   RxString userGender = "".obs;
//   RxString userAge = "".obs;

//   // Flag to prevent redundant updates
//   bool _isUpdating = false;

//   // Add debounce timer for period start updates
//   Timer? _periodStartDebounce;

//   @override
//   void onInit() {
//     super.onInit();
//     authService = Get.find<AuthService>();

//     animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     pulseController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);

//     scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
//     );
//     pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
//       CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
//     );

//     animationController.forward();

//     // Load data from SharedPreferences
//     _loadUserData();

//     // Load pregnancy data if available
//     _loadPregnancyData();
//   }

//   @override
//   void onClose() {
//     animationController.dispose();
//     pulseController.dispose();
//     _periodStartDebounce?.cancel();
//     super.onClose();
//   }

//   List<DateTime> getPeriodDays() {
//     if (periodStart.value == null) return [];
//     return List.generate(
//         periodLength.value, (i) => periodStart.value!.add(Duration(days: i)));
//   }

//   List<DateTime> getFertileDays() {
//     if (periodStart.value == null) return [];

//     // Fertile window = 5 days before ovulation + ovulation day + 1 day after
//     final ovulation = getOvulationDay();
//     return List.generate(7, (i) => ovulation.subtract(Duration(days: 5 - i)));
//   }

//   DateTime getOvulationDay() {
//     if (periodStart.value == null) return DateTime.now();
//     return periodStart.value!.add(Duration(days: cycleLength.value - 14));
//   }

//   DateTime getNextPeriod() {
//     if (periodStart.value == null) {
//       print('GetNextPeriod - Period Start is null, returning now');
//       return DateTime.now();
//     }
//     final nextPeriod =
//         periodStart.value!.add(Duration(days: cycleLength.value));
//     print(
//         'GetNextPeriod - Period Start: ${periodStart.value}, Cycle Length: ${cycleLength.value}, Next Period: $nextPeriod');
//     return nextPeriod;
//   }

//   int getCycleDay(DateTime day) {
//     if (periodStart.value == null) return 0;
//     final diff = day.difference(periodStart.value!).inDays + 1;
//     return diff > 0 ? diff : 0;
//   }

//   bool isPeriodDay(DateTime day) {
//     return getPeriodDays().any((d) => isSameDay(d, day));
//   }

//   bool isFertileDay(DateTime day) {
//     return getFertileDays().any((d) => isSameDay(d, day));
//   }

//   bool isOvulationDay(DateTime day) {
//     return isSameDay(getOvulationDay(), day);
//   }

//   bool hasIntercourse(DateTime day) {
//     return intercourseLog.any((d) => isSameDay(d, day));
//   }

//   String getPregnancyChance(DateTime day) {
//     if (isOvulationDay(day)) return 'pregnancy_chance_peak'.tr;
//     if (isFertileDay(day)) return 'pregnancy_chance_high'.tr;
//     final cycleDay = getCycleDay(day);
//     // Medium chance during the fertile window and a few days before/after
//     if (cycleDay >= periodLength.value + 1 &&
//         cycleDay <= periodLength.value + 10)
//       return 'pregnancy_chance_medium'.tr;
//     return 'pregnancy_chance_low'.tr;
//   }

//   // Helper for TableCalendar
//   bool isSameDay(DateTime a, DateTime b) {
//     return a.year == b.year && a.month == b.month && a.day == b.day;
//   }

//   void setPeriod(DateTime start, DateTime end) async {
//     periodStart.value = start;
//     periodEnd.value = end;
//     periodLength.value = end.difference(start).inDays + 1;

//     // Save to SharedPreferences
//     await authService.updatePeriodStart(start);
//     await authService.updateCycleSettings(periodLength: periodLength.value);
//   }

//   void setSelectedDay(DateTime day) {
//     selectedDay.value = day;
//     focusedDay.value = day;
//   }

//   // Load user data from SharedPreferences
//   void _loadUserData() {
//     final user = authService.currentUser.value;
//     if (user != null) {
//       // Load period start date
//       if (user.lastPeriodStart != null) {
//         periodStart.value = user.lastPeriodStart;
//         periodEnd.value =
//             user.lastPeriodStart!.add(Duration(days: user.periodLength - 1));
//       }

//       // Load cycle settings
//       cycleLength.value = user.cycleLength;
//       periodLength.value = user.periodLength;

//       // Load intercourse log
//       intercourseLog.clear();
//       intercourseLog.addAll(user.intercourseLog);
//       intercourseLog.refresh();
//     }

//     // Also load data from goal onboarding SharedPreferences
//     _loadGoalOnboardingData();

//     // Schedule fertility notifications if applicable
//     _rescheduleFertilityNotifications();
//   }

//   // Load data from goal onboarding SharedPreferences
//   Future<void> _loadGoalOnboardingData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final auth = Get.find<AuthService>();
//     final userId = auth.currentUser.value?.id;

//     String? lastPeriodString;
//     int? cycleLen;
//     int? periodLen;
//     String? gender;
//     String? age;

//     // Prefer user-scoped onboarding values
//     if (userId != null && userId.isNotEmpty) {
//       lastPeriodString =
//           await auth.getOnboardingData('onboarding_last_period', userId);
//       gender = await auth.getOnboardingData('onboarding_gender', userId);
//       age = await auth.getOnboardingData('onboarding_age', userId);
//       // Ints are saved under per-user key; read directly from prefs
//       final userScopedCycleKey = 'onboarding_cycle_length_user_$userId';
//       final userScopedPeriodKey = 'onboarding_period_length_user_$userId';
//       cycleLen = prefs.getInt(userScopedCycleKey);
//       periodLen = prefs.getInt(userScopedPeriodKey);
//     }

//     // Fallback to global keys if needed
//     lastPeriodString ??= prefs.getString('onboarding_last_period');
//     cycleLen ??= prefs.getInt('onboarding_cycle_length');
//     periodLen ??= prefs.getInt('onboarding_period_length');
//     gender ??= prefs.getString('onboarding_gender');
//     age ??= prefs.getString('onboarding_age');

//     // Apply period length first (before calculating periodEnd)
//     if (periodLen != null) {
//       periodLength.value = periodLen;
//     }

//     // Apply cycle length
//     if (cycleLen != null) {
//       cycleLength.value = cycleLen;
//     }

//     // Apply last period (using the loaded periodLength)
//     if (lastPeriodString != null) {
//       final lastPeriodDate = DateTime.parse(lastPeriodString);
//       periodStart.value = lastPeriodDate;
//       periodEnd.value =
//           lastPeriodDate.add(Duration(days: periodLength.value - 1));
//     }

//     if (gender != null && gender.isNotEmpty) {
//       userGender.value = gender;
//     }
//     if (age != null && age.isNotEmpty) {
//       userAge.value = age;
//     }
//   }

//   // Prompt user about period start or ongoing bleeding; call from view after build
//   Future<void> maybePromptUser(BuildContext context) async {
//     if (_promptActive) return;
//     final user = authService.currentUser.value;
//     if (user == null) return;

//     final prefs = await SharedPreferences.getInstance();
//     final userId = user.id;
//     final today = DateTime.now();
//     final todayKey = _formatDateKey(today);

//     // 1) If today is expected next period day, ask if period started
//     final DateTime? lastStartForPrompt =
//         periodStart.value ?? user.lastPeriodStart;
//     if (lastStartForPrompt != null) {
//       final expectedNext = DateTime(
//         lastStartForPrompt.year,
//         lastStartForPrompt.month,
//         lastStartForPrompt.day,
//       ).add(Duration(days: cycleLength.value));
//       final alreadyAskedKey = 'period_start_prompt_shown_${userId}_$todayKey';
//       final alreadyAsked = prefs.getBool(alreadyAskedKey) ?? false;
//       // Prompt on expected day and all overdue days until user says Yes
//       if (!alreadyAsked &&
//           (_isSameCalendarDay(expectedNext, today) ||
//               today.isAfter(expectedNext))) {
//         _promptActive = true;
//         await _askPeriodStartToday(context);
//         await prefs.setBool(alreadyAskedKey, true);
//         _promptActive = false;
//         return; // show only one prompt per day
//       }
//     }
//   }

//   Future<void> _askPeriodStartToday(BuildContext context) async {
//     final result = await Get.dialog<bool>(
//       AlertDialog(
//         title: const Text('Period Check'),
//         content: const Text('Did your period start today?'),
//         actions: [
//           TextButton(
//               onPressed: () => Get.back(result: false),
//               child: const Text('No')),
//           ElevatedButton(
//               onPressed: () => Get.back(result: true),
//               child: const Text('Yes')),
//         ],
//       ),
//     );

//     if (result == true) {
//       // Update last period to today and reset period length minimally to 1
//       final today = DateTime.now();
//       final prevLength =
//           periodLength.value; // use previous period length as default
//       await setPeriodStart(DateTime(today.year, today.month, today.day));
//       await updateCycleSettings(newPeriodLength: prevLength);
//     } else if (result == false) {
//       // Period not started; increment cycle length by one day
//       await updateCycleSettings(newCycleLength: cycleLength.value + 1);
//     }
//   }

//   String _formatDateKey(DateTime date) =>
//       '${date.year}-${date.month}-${date.day}';
//   String _formatIsoDay(DateTime date) =>
//       DateTime(date.year, date.month, date.day).toIso8601String();
//   bool _isSameCalendarDay(DateTime a, DateTime b) =>
//       a.year == b.year && a.month == b.month && a.day == b.day;

//   // OPTIMIZED: Update period start date with debouncing
//   // Future<void> setPeriodStart(DateTime start) async {
//   //   // Check if value actually changed to prevent unnecessary updates
//   //   if (periodStart.value != null &&
//   //       periodStart.value!.year == start.year &&
//   //       periodStart.value!.month == start.month &&
//   //       periodStart.value!.day == start.day) {
//   //     return; // No change needed
//   //   }

//   //   // Update UI immediately for responsiveness
//   //   periodStart.value = start;
//   //   periodEnd.value = start.add(Duration(days: periodLength.value - 1));

//   //   // Cancel any existing debounce timer
//   //   _periodStartDebounce?.cancel();

//   //   // Set up new debounce timer - only save after user stops changing dates
//   //   _periodStartDebounce = Timer(const Duration(milliseconds: 500), () async {
//   //     await _savePeriodStartToStorage(start);
//   //   });
//   // }

//   Future<void> setPeriodStart(DateTime start) async {
//     // Check if value actually changed to prevent unnecessary updates
//     if (periodStart.value != null &&
//         periodStart.value!.year == start.year &&
//         periodStart.value!.month == start.month &&
//         periodStart.value!.day == start.day) {
//       return; // No change needed
//     }

//     // Update UI immediately for responsiveness
//     periodStart.value = start;
//     periodEnd.value = start.add(Duration(days: periodLength.value - 1));

//     // Notify CycleInfoWidget to rebuild
//     update(['cycle_info']);

//     // Cancel any existing debounce timer
//     _periodStartDebounce?.cancel();

//     // Set up new debounce timer - only save after user stops changing dates
//     _periodStartDebounce = Timer(const Duration(milliseconds: 500), () async {
//       await _savePeriodStartToStorage(start);
//     });
//   }

//   // Separate method for actual saving to storage
//   Future<void> _savePeriodStartToStorage(DateTime start) async {
//     if (_isUpdating) return;
//     _isUpdating = true;

//     try {
//       // Save to SharedPreferences
//       await authService.updatePeriodStart(start);

//       // Also persist to user-scoped onboarding for consistency with calendar load
//       final userId = authService.currentUser.value?.id;
//       if (userId != null && userId.isNotEmpty) {
//         await authService.setOnboardingData(
//             'onboarding_last_period', userId, start.toIso8601String());
//       } else {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString(
//             'onboarding_last_period', start.toIso8601String());
//       }

//       // Schedule period reminder notification
//       await NotificationService.instance.schedulePeriodReminder(
//         periodStartDate: start,
//         cycleLength: cycleLength.value,
//       );

//       // Reschedule fertility notifications
//       await _rescheduleFertilityNotifications();
//     } catch (e) {
//       print('Error saving period start: $e');
//     } finally {
//       _isUpdating = false;
//     }
//   }

//   // // Update cycle settings and save to SharedPreferences
//   // Future<void> updateCycleSettings({
//   //   int? newCycleLength,
//   //   int? newPeriodLength,
//   // }) async {
//   //   bool hasChanges = false;

//   //   // Check if there are actual changes
//   //   if (newCycleLength != null && cycleLength.value != newCycleLength) {
//   //     cycleLength.value = newCycleLength;
//   //     hasChanges = true;
//   //   }
//   //   if (newPeriodLength != null && periodLength.value != newPeriodLength) {
//   //     periodLength.value = newPeriodLength;
//   //     hasChanges = true;
//   //   }

//   //   if (!hasChanges) return; // Skip if no actual changes

//   //   // Prevent multiple simultaneous updates
//   //   if (_isUpdating) return;
//   //   _isUpdating = true;

//   //   try {
//   //     // Save to SharedPreferences
//   //     await authService.updateCycleSettings(
//   //       cycleLength: cycleLength.value,
//   //       periodLength: periodLength.value,
//   //     );

//   //     // Also persist to user-scoped onboarding for consistency with calendar load
//   //     final userId = authService.currentUser.value?.id;
//   //     if (userId != null && userId.isNotEmpty) {
//   //       await authService.setOnboardingInt(
//   //           'onboarding_cycle_length', userId, cycleLength.value);
//   //       await authService.setOnboardingInt(
//   //           'onboarding_period_length', userId, periodLength.value);
//   //     } else {
//   //       final prefs = await SharedPreferences.getInstance();
//   //       await prefs.setInt('onboarding_cycle_length', cycleLength.value);
//   //       await prefs.setInt('onboarding_period_length', periodLength.value);
//   //     }

//   //     // Update period reminder if period start is set
//   //     if (periodStart.value != null) {
//   //       await NotificationService.instance.cancelPeriodReminder();
//   //       await NotificationService.instance.schedulePeriodReminder(
//   //         periodStartDate: periodStart.value!,
//   //         cycleLength: cycleLength.value,
//   //       );
//   //     }

//   //     // Reschedule fertility notifications
//   //     await _rescheduleFertilityNotifications();
//   //   } finally {
//   //     _isUpdating = false;
//   //   }
//   // }

//   Future<void> updateCycleSettings({
//     int? newCycleLength,
//     int? newPeriodLength,
//   }) async {
//     bool hasChanges = false;

//     // Check if there are actual changes
//     if (newCycleLength != null && cycleLength.value != newCycleLength) {
//       cycleLength.value = newCycleLength;
//       hasChanges = true;
//     }
//     if (newPeriodLength != null && periodLength.value != newPeriodLength) {
//       periodLength.value = newPeriodLength;
//       hasChanges = true;
//     }

//     if (!hasChanges) return; // Skip if no actual changes

//     // Notify CycleInfoWidget to rebuild
//     update(['cycle_info']);

//     // Prevent multiple simultaneous updates
//     if (_isUpdating) return;
//     _isUpdating = true;

//     try {
//       // Save to SharedPreferences
//       await authService.updateCycleSettings(
//         cycleLength: cycleLength.value,
//         periodLength: periodLength.value,
//       );

//       // Also persist to user-scoped onboarding for consistency with calendar load
//       final userId = authService.currentUser.value?.id;
//       if (userId != null && userId.isNotEmpty) {
//         await authService.setOnboardingInt(
//             'onboarding_cycle_length', userId, cycleLength.value);
//         await authService.setOnboardingInt(
//             'onboarding_period_length', userId, periodLength.value);
//       } else {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setInt('onboarding_cycle_length', cycleLength.value);
//         await prefs.setInt('onboarding_period_length', periodLength.value);
//       }

//       // Update period reminder if period start is set
//       if (periodStart.value != null) {
//         await NotificationService.instance.cancelPeriodReminder();
//         await NotificationService.instance.schedulePeriodReminder(
//           periodStartDate: periodStart.value!,
//           cycleLength: cycleLength.value,
//         );
//       }

//       // Reschedule fertility notifications
//       await _rescheduleFertilityNotifications();
//     } finally {
//       _isUpdating = false;
//     }
//   }

//   Future<void> _rescheduleFertilityNotifications() async {
//     try {
//       final user = authService.currentUser.value;
//       if (user == null) return;
//       // Check onboarding purpose: only schedule in get pregnant flow
//       final purpose = await authService.getOnboardingPurpose(user.id);
//       if (purpose != 'get_pregnant') {
//         await NotificationService.instance.cancelFertilityNotifications();
//         return;
//       }

//       final lastStart = periodStart.value ?? user.lastPeriodStart;
//       if (lastStart == null) return;

//       await NotificationService.instance.scheduleFertilityAndOvulation(
//         lastPeriodStart: lastStart,
//         periodLength: periodLength.value,
//         cycleLength: cycleLength.value,
//         hour: 9,
//         minute: 0,
//       );
//     } catch (e) {
//       print('Error scheduling fertility notifications: $e');
//     }
//   }

//   Future<void> updateUserGender(String gender) async {
//     userGender.value = gender;
//     final userId = authService.currentUser.value?.id;
//     if (userId != null && userId.isNotEmpty) {
//       await authService.setOnboardingData('onboarding_gender', userId, gender);
//     } else {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('onboarding_gender', gender);
//     }
//     // Also update ProfileController if it exists
//     try {
//       if (Get.isRegistered<ProfileController>()) {
//         final profileController = Get.find<ProfileController>();
//         profileController.userGender.value = gender;
//       }
//     } catch (e) {
//       print('ProfileController not available: $e');
//     }
//   }

//   Future<void> updateUserAge(String age) async {
//     userAge.value = age;
//     final userId = authService.currentUser.value?.id;
//     if (userId != null && userId.isNotEmpty) {
//       await authService.setOnboardingData('onboarding_age', userId, age);
//     } else {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('onboarding_age', age);
//     }
//   }

//   // Toggle intercourse log and save to SharedPreferences
//   Future<void> toggleIntercourse(DateTime day) async {
//     final existingDate = intercourseLog.firstWhere(
//       (d) => isSameDay(d, day),
//       orElse: () => DateTime(0),
//     );

//     if (existingDate.year != 0) {
//       intercourseLog.remove(existingDate);
//       await authService.removeIntercourseLog(day);
//     } else {
//       intercourseLog.add(day);
//       await authService.addIntercourseLog(day);
//     }
//     intercourseLog.refresh();
//   }

//   // Load pregnancy data from SharedPreferences
//   void _loadPregnancyData() {
//     final user = authService.currentUser.value;
//     if (user?.dueDate != null) {
//       dueDate.value = _formatDueDate(user!.dueDate!);
//       _calculatePregnancyProgress();
//     }
//   }

//   // Calculate pregnancy progress based on due date
//   void _calculatePregnancyProgress() {
//     final user = authService.currentUser.value;
//     if (user?.dueDate != null) {
//       final today = DateTime.now();
//       final dueDate = user!.dueDate!;

//       // Calculate pregnancy start (40 weeks before due date)
//       final pregnancyStart = dueDate.subtract(const Duration(days: 280));

//       // Calculate current pregnancy days
//       final pregnancyDays = today.difference(pregnancyStart).inDays;
//       this.pregnancyDays.value = pregnancyDays > 0 ? pregnancyDays : 0;

//       // Calculate current pregnancy week
//       final pregnancyWeek = (pregnancyDays / 7).floor();
//       pregnancyWeekNumber.value = pregnancyWeek > 0 ? pregnancyWeek : 1;

//       // Determine trimester
//       if (pregnancyWeek <= 12) {
//         trimester.value = "First trimester";
//       } else if (pregnancyWeek <= 26) {
//         trimester.value = "Second trimester";
//       } else {
//         trimester.value = "Third trimester";
//       }
//     }
//   }

//   String _formatDueDate(DateTime date) {
//     final months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec'
//     ];
//     return '${date.day} ${months[date.month - 1]}';
//   }
// }

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:babysafe/app/services/auth_service.dart';
import 'package:babysafe/app/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../profile/controllers/profile_controller.dart';
import 'dart:async';

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

  RxInt cycleLength = 28.obs;
  RxInt periodLength = 7.obs;

  late AuthService authService;
  bool _promptActive = false;

  // Pregnancy tracking variables
  RxInt pregnancyWeekNumber = 0.obs;
  RxInt pregnancyDays = 0.obs;
  RxString trimester = "".obs;
  RxString dueDate = "".obs;
  RxString userGender = "".obs;
  RxString userAge = "".obs;

  // Flag to prevent redundant updates
  bool _isUpdating = false;
  bool _isSaving = false;

  // Add debounce timer for period start updates
  Timer? _periodStartDebounce;

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

    // Load pregnancy data if available
    _loadPregnancyData();
  }

  @override
  void onClose() {
    animationController.dispose();
    pulseController.dispose();
    _periodStartDebounce?.cancel();
    super.onClose();
  }

  List<DateTime> getPeriodDays() {
    if (periodStart.value == null) return [];
    return List.generate(
        periodLength.value, (i) => periodStart.value!.add(Duration(days: i)));
  }

  List<DateTime> getFertileDays() {
    if (periodStart.value == null) return [];

    // Fertile window = 5 days before ovulation + ovulation day + 1 day after
    final ovulation = getOvulationDay();
    return List.generate(7, (i) => ovulation.subtract(Duration(days: 5 - i)));
  }

  DateTime getOvulationDay() {
    if (periodStart.value == null) return DateTime.now();
    return periodStart.value!.add(Duration(days: cycleLength.value - 14));
  }

  DateTime getNextPeriod() {
    if (periodStart.value == null) {
      return DateTime.now();
    }
    final nextPeriod =
        periodStart.value!.add(Duration(days: cycleLength.value));
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
    if (isOvulationDay(day)) return 'pregnancy_chance_peak'.tr;
    if (isFertileDay(day)) return 'pregnancy_chance_high'.tr;
    final cycleDay = getCycleDay(day);
    // Medium chance during the fertile window and a few days before/after
    if (cycleDay >= periodLength.value + 1 &&
        cycleDay <= periodLength.value + 10)
      return 'pregnancy_chance_medium'.tr;
    return 'pregnancy_chance_low'.tr;
  }

  // Helper for TableCalendar
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void setPeriod(DateTime start, DateTime end) async {
    periodStart.value = start;
    periodEnd.value = end;
    periodLength.value = end.difference(start).inDays + 1;

    // Save to SharedPreferences
    await authService.updatePeriodStart(start);
    await authService.updateCycleSettings(periodLength: periodLength.value);
  }

  void setSelectedDay(DateTime day) {
    selectedDay.value = day;
    focusedDay.value = day;
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
      cycleLength.value = user.cycleLength;
      periodLength.value = user.periodLength;

      // Load intercourse log
      intercourseLog.clear();
      intercourseLog.addAll(user.intercourseLog);
      intercourseLog.refresh();
    }

    // Also load data from goal onboarding SharedPreferences
    _loadGoalOnboardingData();

    // Schedule fertility notifications if applicable
    _rescheduleFertilityNotifications();
  }

  // Load data from goal onboarding SharedPreferences
  Future<void> _loadGoalOnboardingData() async {
    final prefs = await SharedPreferences.getInstance();
    final auth = Get.find<AuthService>();
    final userId = auth.currentUser.value?.id;

    String? lastPeriodString;
    int? cycleLen;
    int? periodLen;
    String? gender;
    String? age;

    // Prefer user-scoped onboarding values
    if (userId != null && userId.isNotEmpty) {
      lastPeriodString =
          await auth.getOnboardingData('onboarding_last_period', userId);
      gender = await auth.getOnboardingData('onboarding_gender', userId);
      age = await auth.getOnboardingData('onboarding_age', userId);
      // Ints are saved under per-user key; read directly from prefs
      final userScopedCycleKey = 'onboarding_cycle_length_user_$userId';
      final userScopedPeriodKey = 'onboarding_period_length_user_$userId';
      cycleLen = prefs.getInt(userScopedCycleKey);
      periodLen = prefs.getInt(userScopedPeriodKey);
    }

    // Fallback to global keys if needed
    lastPeriodString ??= prefs.getString('onboarding_last_period');
    cycleLen ??= prefs.getInt('onboarding_cycle_length');
    periodLen ??= prefs.getInt('onboarding_period_length');
    gender ??= prefs.getString('onboarding_gender');
    age ??= prefs.getString('onboarding_age');

    // Apply period length first (before calculating periodEnd)
    if (periodLen != null) {
      periodLength.value = periodLen;
    }

    // Apply cycle length
    if (cycleLen != null) {
      cycleLength.value = cycleLen;
    }

    // Apply last period (using the loaded periodLength)
    if (lastPeriodString != null) {
      final lastPeriodDate = DateTime.parse(lastPeriodString);
      periodStart.value = lastPeriodDate;
      periodEnd.value =
          lastPeriodDate.add(Duration(days: periodLength.value - 1));
    }

    if (gender != null && gender.isNotEmpty) {
      userGender.value = gender;
    }
    if (age != null && age.isNotEmpty) {
      userAge.value = age;
    }
  }

  // Prompt user about period start or ongoing bleeding; call from view after build
  Future<void> maybePromptUser(BuildContext context) async {
    if (_promptActive) return;
    final user = authService.currentUser.value;
    if (user == null) return;

    final prefs = await SharedPreferences.getInstance();
    final userId = user.id;
    final today = DateTime.now();
    final todayKey = _formatDateKey(today);

    // 1) If today is expected next period day, ask if period started
    final DateTime? lastStartForPrompt =
        periodStart.value ?? user.lastPeriodStart;
    if (lastStartForPrompt != null) {
      final expectedNext = DateTime(
        lastStartForPrompt.year,
        lastStartForPrompt.month,
        lastStartForPrompt.day,
      ).add(Duration(days: cycleLength.value));
      final alreadyAskedKey = 'period_start_prompt_shown_${userId}_$todayKey';
      final alreadyAsked = prefs.getBool(alreadyAskedKey) ?? false;
      // Prompt on expected day and all overdue days until user says Yes
      if (!alreadyAsked &&
          (_isSameCalendarDay(expectedNext, today) ||
              today.isAfter(expectedNext))) {
        _promptActive = true;
        await _askPeriodStartToday(context);
        await prefs.setBool(alreadyAskedKey, true);
        _promptActive = false;
        return; // show only one prompt per day
      }
    }
  }

  Future<void> _askPeriodStartToday(BuildContext context) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Period Check'),
        content: const Text('Did your period start today?'),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('No')),
          ElevatedButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Yes')),
        ],
      ),
    );

    if (result == true) {
      // Update last period to today and reset period length minimally to 1
      final today = DateTime.now();
      final prevLength =
          periodLength.value; // use previous period length as default
      await setPeriodStart(DateTime(today.year, today.month, today.day));
      await updateCycleSettings(newPeriodLength: prevLength);
    } else if (result == false) {
      // Period not started; increment cycle length by one day
      await updateCycleSettings(newCycleLength: cycleLength.value + 1);
    }
  }

  String _formatDateKey(DateTime date) =>
      '${date.year}-${date.month}-${date.day}';
  String _formatIsoDay(DateTime date) =>
      DateTime(date.year, date.month, date.day).toIso8601String();
  bool _isSameCalendarDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // OPTIMIZED: Update period start date with debouncing and guards
  Future<void> setPeriodStart(DateTime start) async {
    // Check if value actually changed to prevent unnecessary updates
    if (periodStart.value != null &&
        periodStart.value!.year == start.year &&
        periodStart.value!.month == start.month &&
        periodStart.value!.day == start.day) {
      return; // No change needed
    }

    // Prevent multiple simultaneous updates
    if (_isUpdating) {
      print('Update already in progress, skipping...');
      return;
    }

    // Update UI immediately for responsiveness
    periodStart.value = start;
    periodEnd.value = start.add(Duration(days: periodLength.value - 1));

    // Cancel any existing debounce timer
    _periodStartDebounce?.cancel();

    // Set up new debounce timer - only save after user stops changing dates
    _periodStartDebounce = Timer(const Duration(milliseconds: 800), () async {
      await _savePeriodStartToStorage(start);
    });
  }

  // Separate method for actual saving to storage
  Future<void> _savePeriodStartToStorage(DateTime start) async {
    if (_isSaving) {
      print('Save already in progress, skipping...');
      return;
    }

    _isSaving = true;

    try {
      print('Saving period start: $start');

      // Save to SharedPreferences
      await authService.updatePeriodStart(start);

      // Also persist to user-scoped onboarding for consistency with calendar load
      final userId = authService.currentUser.value?.id;
      if (userId != null && userId.isNotEmpty) {
        await authService.setOnboardingData(
            'onboarding_last_period', userId, start.toIso8601String());
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'onboarding_last_period', start.toIso8601String());
      }

      // Schedule period reminder notification
      await NotificationService.instance.schedulePeriodReminder(
        periodStartDate: start,
        cycleLength: cycleLength.value,
      );

      // Reschedule fertility notifications
      await _rescheduleFertilityNotifications();

      print('Period start saved successfully');
    } catch (e) {
      print('Error saving period start: $e');
    } finally {
      _isSaving = false;
    }
  }

  // Update cycle settings with guards
  Future<void> updateCycleSettings({
    int? newCycleLength,
    int? newPeriodLength,
  }) async {
    bool hasChanges = false;

    // Check if there are actual changes
    if (newCycleLength != null && cycleLength.value != newCycleLength) {
      cycleLength.value = newCycleLength;
      hasChanges = true;
    }
    if (newPeriodLength != null && periodLength.value != newPeriodLength) {
      periodLength.value = newPeriodLength;
      hasChanges = true;
    }

    if (!hasChanges) return; // Skip if no actual changes

    // Prevent multiple simultaneous updates
    if (_isUpdating) {
      print('Update already in progress for cycle settings');
      return;
    }

    _isUpdating = true;

    try {
      print(
          'Updating cycle settings: cycle=$newCycleLength, period=$newPeriodLength');

      // Save to SharedPreferences
      await authService.updateCycleSettings(
        cycleLength: cycleLength.value,
        periodLength: periodLength.value,
      );

      // Also persist to user-scoped onboarding for consistency with calendar load
      final userId = authService.currentUser.value?.id;
      if (userId != null && userId.isNotEmpty) {
        await authService.setOnboardingInt(
            'onboarding_cycle_length', userId, cycleLength.value);
        await authService.setOnboardingInt(
            'onboarding_period_length', userId, periodLength.value);
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('onboarding_cycle_length', cycleLength.value);
        await prefs.setInt('onboarding_period_length', periodLength.value);
      }

      // Update period reminder if period start is set
      if (periodStart.value != null) {
        await NotificationService.instance.cancelPeriodReminder();
        await NotificationService.instance.schedulePeriodReminder(
          periodStartDate: periodStart.value!,
          cycleLength: cycleLength.value,
        );
      }

      // Reschedule fertility notifications
      await _rescheduleFertilityNotifications();

      print('Cycle settings updated successfully');
    } catch (e) {
      print('Error updating cycle settings: $e');
    } finally {
      _isUpdating = false;
    }
  }

  Future<void> _rescheduleFertilityNotifications() async {
    try {
      final user = authService.currentUser.value;
      if (user == null) return;
      // Check onboarding purpose: only schedule in get pregnant flow
      final purpose = await authService.getOnboardingPurpose(user.id);
      if (purpose != 'get_pregnant') {
        await NotificationService.instance.cancelFertilityNotifications();
        return;
      }

      final lastStart = periodStart.value ?? user.lastPeriodStart;
      if (lastStart == null) return;

      await NotificationService.instance.scheduleFertilityAndOvulation(
        lastPeriodStart: lastStart,
        periodLength: periodLength.value,
        cycleLength: cycleLength.value,
        hour: 9,
        minute: 0,
      );
    } catch (e) {
      print('Error scheduling fertility notifications: $e');
    }
  }

  Future<void> updateUserGender(String gender) async {
    userGender.value = gender;
    final userId = authService.currentUser.value?.id;
    if (userId != null && userId.isNotEmpty) {
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

  Future<void> updateUserAge(String age) async {
    userAge.value = age;
    final userId = authService.currentUser.value?.id;
    if (userId != null && userId.isNotEmpty) {
      await authService.setOnboardingData('onboarding_age', userId, age);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('onboarding_age', age);
    }
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
