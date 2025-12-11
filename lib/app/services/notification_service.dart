import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  static const String _trackRoute = '/track_pregnance';
  String? _pendingRoute;
  bool _appReady = false;

  // Fertility/ovulation channel
  static const String _fertilityChannelId = 'fertility_reminders';
  static const int _fertilityBaseId = 7000; // reserve 7000-7099

  Future<void> initialize() async {
    if (_initialized) return;

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit);

    // Check if app was launched by tapping a notification
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp == true) {
      _pendingRoute = details?.notificationResponse?.payload ?? _trackRoute;
    }

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final String route = (response.payload?.isNotEmpty ?? false)
            ? response.payload!
            : _trackRoute;

        _pendingRoute = route;
        if (_appReady) {
          Get.offAllNamed(route);
          _pendingRoute = null;
        }
      },
    );

    // Android 13+ may require notification permission; ensure app requests it elsewhere if needed

    // Timezone setup
    tz.initializeTimeZones();
    final String localTz = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTz));

    _initialized = true;

    // Create notification channels
    await _createFertilityNotificationChannel();

    // Request exact alarm permissions (Android 12+)
    // await _requestExactAlarmPermissions();
  }

  void markAppReady() {
    _appReady = true;
    if (_pendingRoute != null) {
      Get.offAllNamed(_pendingRoute!);
      _pendingRoute = null;
    }
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  Future<void> _createFertilityNotificationChannel() async {
    try {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        _fertilityChannelId,
        'Fertility & Ovulation',
        description: 'Reminders for fertile window and ovulation day',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    } catch (e) {
      print('Error creating fertility channel: $e');
    }
  }

  Future<void> cancelFertilityNotifications() async {
    for (int i = 0; i < 100; i++) {
      await _plugin.cancel(_fertilityBaseId + i);
    }
  }

  Future<void> scheduleFertilityAndOvulation({
    required DateTime lastPeriodStart,
    required int periodLength,
    required int cycleLength,
    int hour = 10,
    int minute = 6,
  }) async {
    await _createFertilityNotificationChannel();
    // Clear existing fertility notifications in our reserved range
    await cancelFertilityNotifications();

    final now = DateTime.now();
    // normalize base to start-of-day
    DateTime base = DateTime(
        lastPeriodStart.year, lastPeriodStart.month, lastPeriodStart.day);
    // find the cycle window that includes or is after today
    int k = 0;
    while (base
        .add(Duration(days: cycleLength))
        .isBefore(DateTime(now.year, now.month, now.day))) {
      k++;
    }
    base = base.add(Duration(days: k * cycleLength));

    final fertileStart = base.add(Duration(days: periodLength));
    final fertileDays =
        List<DateTime>.generate(7, (i) => fertileStart.add(Duration(days: i)));
    final ovulationDay = fertileStart.add(const Duration(days: 6));

    int scheduledCount = 0;
    for (final day in fertileDays) {
      if (!day.isBefore(now)) {
        final tz.TZDateTime nowTz = tz.TZDateTime.now(tz.local);
        tz.TZDateTime whenTz = tz.TZDateTime.from(
          DateTime(day.year, day.month, day.day, hour, minute),
          tz.local,
        );
        // If scheduling for today and time already passed, schedule in 1 minute
        if (day.year == now.year &&
            day.month == now.month &&
            day.day == now.day &&
            whenTz.isBefore(nowTz)) {
          whenTz = nowTz.add(const Duration(minutes: 1));
        }
        await _plugin.zonedSchedule(
          _fertilityBaseId + scheduledCount,
          'Fertile day',
          'You\'re in your fertile window. Try to conceive today 💕',
          whenTz,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              _fertilityChannelId,
              'Fertility & Ovulation',
              channelDescription:
                  'Reminders for fertile window and ovulation day',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
          payload: '/get_pregnant_requirements',
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
        scheduledCount++;
      }
    }

    if (!ovulationDay.isBefore(now)) {
      final tz.TZDateTime nowTz = tz.TZDateTime.now(tz.local);
      tz.TZDateTime whenTz = tz.TZDateTime.from(
        DateTime(ovulationDay.year, ovulationDay.month, ovulationDay.day, hour,
            minute),
        tz.local,
      );
      if (ovulationDay.year == now.year &&
          ovulationDay.month == now.month &&
          ovulationDay.day == now.day &&
          whenTz.isBefore(nowTz)) {
        whenTz = nowTz.add(const Duration(minutes: 1));
      }
      await _plugin.zonedSchedule(
        _fertilityBaseId + 50, // fixed id for ovulation in current cycle
        'Ovulation today',
        'Ovulation day! Highest chances to conceive today 🌸',
        whenTz,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _fertilityChannelId,
            'Fertility & Ovulation',
            channelDescription:
                'Reminders for fertile window and ovulation day',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        payload: '/get_pregnant_requirements',
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  Future<void> scheduleDailyWeekAlerts({
    required int startDayIndex,
    required List<String> alerts,
    required String alertText,
    required int week,
    int hour = 9,
    int minute = 0,
  }) async {
    // Schedule up to 7 notifications, repeating daily for one week window from startDayIndex.
    for (int i = 0; i < 7; i++) {
      // final int alertIndex = i % alerts.length;
      // final String body = alerts.isNotEmpty
      //     ? alerts[alertIndex]
      //     : 'Check your pregnancy alerts for today.';

      // final String body = alertText;
      final body = 'pregnancy_week_${week}_alertText'.tr;

      final tz.TZDateTime scheduled = _nextInstanceOfTime(
        dayOffset: i,
        hour: hour,
        minute: minute,
      );

      await _plugin.zonedSchedule(
        // Unique id per day in week window
        1000 + startDayIndex + i,
        'Pregnancy alert',
        body,
        scheduled,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'pregnancy_alerts',
            'Pregnancy Alerts',
            channelDescription: 'Daily alerts for the current pregnancy week',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        payload: _trackRoute,
        // One-time schedule per day; no repeating components
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  Future<void> showTestNow({String? body}) async {
    await _plugin.show(
      9999,
      'Pregnancy alert (test)',
      body ?? 'This is a test notification',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'pregnancy_alerts',
          'Pregnancy Alerts',
          channelDescription: 'Daily alerts for the current pregnancy week',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: _trackRoute,
    );
  }

  // Future<void> showAlertsBurstNow({
  //   required List<String> alerts,
  //   int initialDelaySeconds = 1,
  //   required String alertText,
  //   int gapSeconds = 2,
  // }) async {
  //   final tz.TZDateTime base = tz.TZDateTime.now(tz.local).add(
  //     Duration(seconds: initialDelaySeconds),
  //   );
  //   for (int i = 0; i < alerts.length; i++) {
  //     final tz.TZDateTime at = base.add(Duration(seconds: i * gapSeconds));
  //     await _plugin.zonedSchedule(
  //       2000 + i,
  //       'Pregnancy alert',
  //       alerts[i],
  //       at,
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'pregnancy_alerts',
  //           'Pregnancy Alerts',
  //           channelDescription: 'Daily alerts for the current pregnancy week',
  //           importance: Importance.high,
  //           priority: Priority.high,
  //         ),
  //       ),
  //       payload: _trackRoute,
  //       androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
  //     );
  //   }
  // }

  Future<void> showAlertsBurstNow({
    required String alertText,
    required int week,
    int initialDelaySeconds = 1,
    int gapSeconds = 2,
  }) async {
    final tz.TZDateTime base = tz.TZDateTime.now(tz.local).add(
      Duration(seconds: initialDelaySeconds),
    );
    for (int i = 0; i < 1; i++) {
      // only one notification
      final tz.TZDateTime at = base.add(Duration(seconds: i * gapSeconds));
      await _plugin.zonedSchedule(
        2000 + i,
        'Pregnancy alert',
        'pregnancy_week_${week}_alertText'.tr,
        // alertText,
        at,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'pregnancy_alerts',
            'Pregnancy Alerts',
            channelDescription: 'Daily alerts for the current pregnancy week',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        payload: _trackRoute,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  // Future<void> showAlertsListNow({
  //   required List<String> alerts,
  // }) async {
  //   final String title = "This week's alerts (${alerts.length})";
  //   final String bigText = alerts.isNotEmpty
  //       ? alerts.map((a) => '• ' + a).join('\n')
  //       : 'No alerts for this week.';

  //   final androidDetails = AndroidNotificationDetails(
  //     'pregnancy_alerts',
  //     'Pregnancy Alerts',
  //     channelDescription: 'Daily alerts for the current pregnancy week',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //     styleInformation: BigTextStyleInformation(
  //       bigText,
  //       contentTitle: title,
  //       summaryText: 'Pregnancy Alerts',
  //     ),
  //   );

  //   await _plugin.show(
  //     3000,
  //     title,
  //     null,
  //     NotificationDetails(android: androidDetails),
  //     payload: _trackRoute,
  //   );
  // }

  Future<void> showAlertsListNow({
    required String alertText,
    required int week,
  }) async {
    final String title = "This week's alert";
    // final String bigText = alertText;
    final String bigText = 'pregnancy_week_${week}_alertText'.tr;

    final androidDetails = AndroidNotificationDetails(
      'pregnancy_alerts',
      'Pregnancy Alerts',
      channelDescription: 'Daily alerts for the current pregnancy week',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(
        bigText,
        contentTitle: title,
        summaryText: 'Pregnancy Alert',
      ),
    );

    await _plugin.show(
      3000,
      title,
      null,
      NotificationDetails(android: androidDetails),
      payload: _trackRoute,
    );
  }

  tz.TZDateTime _nextInstanceOfTime({
    required int dayOffset,
    required int hour,
    required int minute,
  }) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    ).add(Duration(days: dayOffset));

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  // Schedule period reminder notification
  Future<void> schedulePeriodReminder({
    required DateTime periodStartDate,
    required int cycleLength,
    int hour = 9,
    int minute = 0,
  }) async {
    // Calculate next expected period date
    final DateTime nextPeriodDate =
        periodStartDate.add(Duration(days: cycleLength));

    // Schedule reminder 2 days before expected period
    final DateTime reminderDate =
        nextPeriodDate.subtract(const Duration(days: 2));

    // Only schedule if reminder date is in the future
    if (reminderDate.isAfter(DateTime.now())) {
      final tz.TZDateTime scheduled =
          tz.TZDateTime.from(reminderDate, tz.local);

      await _plugin.zonedSchedule(
        4000, // Unique ID for period reminder
        'Period Reminder',
        'Your period is expected to start in 2 days. Don\'t forget to log it!',
        scheduled,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'period_reminders',
            'Period Reminders',
            channelDescription: 'Reminders for period tracking',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        payload: '/get_pregnant_requirements',
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  // Cancel period reminder
  Future<void> cancelPeriodReminder() async {
    await _plugin.cancel(4000);
  }

  // =================
  // WEIGHT TRACKING REMINDERS
  // =================

  static const int _weightTrackingNotificationId = 6000;
  static const String _weightTrackingChannelId = 'weight_tracking_reminders';
  static const String _weightTrackingEnabledKey =
      'weight_tracking_reminder_enabled';
  static const String _weightTrackingHourKey = 'weight_tracking_reminder_hour';
  static const String _weightTrackingMinuteKey =
      'weight_tracking_reminder_minute';

  /// Create weight tracking notification channel
  Future<void> _createWeightTrackingNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _weightTrackingChannelId,
      'Weight Tracking Reminders',
      description: 'Daily reminders to log your weight during pregnancy',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Schedule daily weight tracking reminder
  Future<void> scheduleWeightTrackingReminder({
    int hour = 9,
    int minute = 0,
  }) async {
    await _createWeightTrackingNotificationChannel();

    // Cancel any existing weight tracking reminders
    await cancelWeightTrackingReminder();

    // Schedule daily recurring reminder
    final tz.TZDateTime scheduled = _nextInstanceOfTime(
      dayOffset: 0,
      hour: hour,
      minute: minute,
    );

    // Use inexact alarms for daily reminders - they're reliable and don't require special permission
    // Inexact alarms are usually within a few minutes of the scheduled time, which is fine for reminders
    await _plugin.zonedSchedule(
      _weightTrackingNotificationId,
      'Weight Tracking Reminder',
      'Don\'t forget to log your weight today! 📊',
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _weightTrackingChannelId,
          'Weight Tracking Reminders',
          channelDescription:
              'Daily reminders to log your weight during pregnancy',
          importance: Importance.high,
          priority: Priority.high,
          enableVibration: true,
          playSound: true,
        ),
      ),
      payload: '/track_my_pregnancy',
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    // Save preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_weightTrackingEnabledKey, true);
    await prefs.setInt(_weightTrackingHourKey, hour);
    await prefs.setInt(_weightTrackingMinuteKey, minute);
  }

  /// Cancel weight tracking reminder
  Future<void> cancelWeightTrackingReminder() async {
    await _plugin.cancel(_weightTrackingNotificationId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_weightTrackingEnabledKey, false);
  }

  /// Check if weight tracking reminder is enabled
  Future<bool> isWeightTrackingReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_weightTrackingEnabledKey) ?? false;
  }

  /// Get weight tracking reminder time
  Future<Map<String, int>> getWeightTrackingReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'hour': prefs.getInt(_weightTrackingHourKey) ?? 9,
      'minute': prefs.getInt(_weightTrackingMinuteKey) ?? 0,
    };
  }

  Future<void> scheduleBabyTipDosNotifications(List<String> tipKeys,
      {int hour = 11, int minute = 0}) async {
    // Request permissions if needed (Android 13+)
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      final permissionGranted =
          await androidPlugin.areNotificationsEnabled() ?? false;
      if (!permissionGranted) {
        await androidPlugin.requestNotificationsPermission();
      }
    }

    await cancelBabyTipDosNotifications();
    for (int i = 0; i < tipKeys.length; i++) {
      final String tipKey = tipKeys[i];
      final String body = tipKey.tr;
      final tz.TZDateTime scheduledTime =
          _nextInstanceOfTime(dayOffset: i, hour: hour, minute: minute);

      await _plugin.zonedSchedule(
        2000 + i,
        'BabyCare Tip',
        body,
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'baby_tips_dos',
            'Baby Tips Dos',
            channelDescription: 'Daily notifications for baby care dos tips',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: '/track_my_baby',
      );
    }
  }

  Future<void> cancelBabyTipDosNotifications() async {
    for (int i = 0; i < 30; i++) {
      await _plugin.cancel(2000 + i);
    }
  }
}
