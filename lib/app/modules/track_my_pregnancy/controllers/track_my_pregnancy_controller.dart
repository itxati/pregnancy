import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../data/models/pregnancy_weeks.dart';
import '../../../data/models/pregnancy_week_data.dart';
import '../../../utils/neo_safe_theme.dart';
import '../../../services/notification_service.dart';
import '../../../services/auth_service.dart';

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

  // Current week data
  Rx<PregnancyWeekData?> currentWeekData = Rx<PregnancyWeekData?>(null);

  @override
  void onInit() {
    super.onInit();
    authService = Get.find<AuthService>();
    _initializeAnimations();
    _loadUserData();
    _calculatePregnancyProgress();
    _updateCurrentWeekData();
    _scheduleWeekAlerts();
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
  void _loadUserData() {
    final user = authService.currentUser.value;
    if (user != null) {
      userName.value = user.fullName;

      // Load due date if available
      if (user.dueDate != null) {
        dueDate.value = _formatDueDate(user.dueDate!);
      }
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
      return "Good morning,";
    } else if (hour < 17) {
      return "Good afternoon,";
    } else if (hour < 21) {
      return "Good evening,";
    } else {
      return "Good night,";
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
    const List<String> months = [
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
      trimester.value = "First trimester";
    } else if (weeksPregnant < 27) {
      trimester.value = "Second trimester";
    } else {
      trimester.value = "Third trimester";
    }

    _updateCurrentWeekData();
    _scheduleWeekAlerts();
    update();
  }

  String getTimelineSubtitle() {
    if (pregnancyWeekNumber.value < 13) {
      return "First trimester milestones";
    } else if (pregnancyWeekNumber.value < 27) {
      return "Second trimester milestones";
    } else {
      return "Third trimester milestones";
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
    );

    // In debug, show all alerts in a single expanded notification now (no extra scheduled immediate notif)
    if (kDebugMode && alerts.isNotEmpty) {
      await NotificationService.instance.showAlertsListNow(alerts: alerts);
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
                // Header
                Row(
                  children: [
                    Text(
                      "Where you are",
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

                // Content
                _buildInfoRow(
                  context,
                  icon: Icons.child_care,
                  iconColor: NeoSafeColors.primaryPink,
                  text: "Your estimated due date is ${dueDate.value}.",
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  context,
                  icon: Icons.pregnant_woman,
                  iconColor: NeoSafeColors.primaryPink,
                  text:
                      "This means you're ${pregnancyWeekNumber.value} weeks and ${pregnancyDays.value % 7} days pregnant.",
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  context,
                  icon: Icons.calendar_today,
                  iconColor: NeoSafeColors.info,
                  text:
                      "This means you have ${40 - pregnancyWeekNumber.value} weeks and ${7 - (pregnancyDays.value % 7)} days to go.",
                ),
                const SizedBox(height: 32),

                // Edit button
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
                      Get.back(); // Close bottom sheet first
                      showDatePickerDialog(context); // Show date picker
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
                      "Edit due date",
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
}
