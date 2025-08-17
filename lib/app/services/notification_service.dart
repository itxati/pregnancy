import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  static const String _trackRoute = '/track_pregnance';
  String? _pendingRoute;
  bool _appReady = false;

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
      onDidReceiveNotificationResponse: (NotificationResponse response) {
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

    // Timezone setup
    tz.initializeTimeZones();
    final String localTz = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTz));

    _initialized = true;
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

  Future<void> scheduleDailyWeekAlerts({
    required int startDayIndex,
    required List<String> alerts,
    int hour = 9,
    int minute = 0,
  }) async {
    // Schedule up to 7 notifications, repeating daily for one week window from startDayIndex.
    for (int i = 0; i < 7; i++) {
      final int alertIndex = i % alerts.length;
      final String body = alerts.isNotEmpty
          ? alerts[alertIndex]
          : 'Check your pregnancy alerts for today.';

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

  Future<void> showAlertsBurstNow({
    required List<String> alerts,
    int initialDelaySeconds = 1,
    int gapSeconds = 2,
  }) async {
    final tz.TZDateTime base = tz.TZDateTime.now(tz.local).add(
      Duration(seconds: initialDelaySeconds),
    );
    for (int i = 0; i < alerts.length; i++) {
      final tz.TZDateTime at = base.add(Duration(seconds: i * gapSeconds));
      await _plugin.zonedSchedule(
        2000 + i,
        'Pregnancy alert',
        alerts[i],
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

  Future<void> showAlertsListNow({
    required List<String> alerts,
  }) async {
    final String title = "This week's alerts (${alerts.length})";
    final String bigText = alerts.isNotEmpty
        ? alerts.map((a) => '• ' + a).join('\n')
        : 'No alerts for this week.';

    final androidDetails = AndroidNotificationDetails(
      'pregnancy_alerts',
      'Pregnancy Alerts',
      channelDescription: 'Daily alerts for the current pregnancy week',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(
        bigText,
        contentTitle: title,
        summaryText: 'Pregnancy Alerts',
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
}
