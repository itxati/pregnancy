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

  // Breastfeeding notification constants
  static const int _breastfeedingNotificationId = 5000;
  static const int _breastfeedingPrefetchCount =
      4; // number of future notifications to pre-schedule
  static const String _breastfeedingChannelId = 'breastfeeding_reminders';
  static const String _breastfeedingLastTimeKey = 'breastfeeding_last_time';
  static const String _breastfeedingIntervalHoursKey =
      'breastfeeding_interval_hours';
  static const String _breastfeedingIntervalMinutesKey =
      'breastfeeding_interval_minutes';
  static const String _breastfeedingEnabledKey = 'breastfeeding_enabled';

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

        // Handle breastfeeding notification response
        if (response.id == _breastfeedingNotificationId) {
          await _handleBreastfeedingNotificationResponse();
        }

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

    // Create notification channels
    await _createBreastfeedingNotificationChannel();

    // Request exact alarm permissions (Android 12+)
    // await _requestExactAlarmPermissions();

    // Resume breastfeeding notifications if they were enabled
    await _resumeBreastfeedingNotifications();
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

  // =================
  // BREASTFEEDING NOTIFICATIONS
  // =================

  /// Create breastfeeding notification channel
  Future<void> _createBreastfeedingNotificationChannel() async {
    try {
      const androidChannel = AndroidNotificationChannel(
        _breastfeedingChannelId,
        'Breastfeeding Reminders',
        description: 'Reminders for breastfeeding sessions',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);
    } catch (e) {
      print('Error creating breastfeeding notification channel: $e');
    }
  }

  /// Enable breastfeeding notifications with custom interval
  Future<void> enableBreastfeedingNotifications({
    required int hours,
    required int minutes,
  }) async {
    try {
      print(
          '🔔 Enabling breastfeeding notifications: ${hours}h ${minutes}m interval');

      final prefs = await SharedPreferences.getInstance();

      // Save settings
      await prefs.setBool(_breastfeedingEnabledKey, true);
      await prefs.setInt(_breastfeedingIntervalHoursKey, hours);
      await prefs.setInt(_breastfeedingIntervalMinutesKey, minutes);

      // Set initial start time to now
      final now = DateTime.now();
      await prefs.setInt(_breastfeedingLastTimeKey, now.millisecondsSinceEpoch);
      print('📅 Set initial feeding time to: $now');

      // Schedule the first notification
      await _scheduleNextBreastfeedingNotification(hours, minutes);

      print(
          '✅ Breastfeeding notifications enabled: ${hours}h ${minutes}m interval');
    } catch (e) {
      print('❌ Error enabling breastfeeding notifications: $e');
    }
  }

  /// Disable breastfeeding notifications
  Future<void> disableBreastfeedingNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Cancel existing notification
      await _plugin.cancel(_breastfeedingNotificationId);

      // Clear settings
      await prefs.setBool(_breastfeedingEnabledKey, false);
      await prefs.remove(_breastfeedingLastTimeKey);

      print('Breastfeeding notifications disabled');
    } catch (e) {
      print('Error disabling breastfeeding notifications: $e');
    }
  }

  /// Check if breastfeeding notifications are enabled
  Future<bool> areBreastfeedingNotificationsEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_breastfeedingEnabledKey) ?? false;
    } catch (e) {
      print('Error checking breastfeeding notifications status: $e');
      return false;
    }
  }

  /// Get current breastfeeding interval
  Future<Map<String, int>> getBreastfeedingInterval() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'hours': prefs.getInt(_breastfeedingIntervalHoursKey) ?? 2,
        'minutes': prefs.getInt(_breastfeedingIntervalMinutesKey) ?? 0,
      };
    } catch (e) {
      print('Error getting breastfeeding interval: $e');
      return {'hours': 2, 'minutes': 0};
    }
  }

  /// Get last breastfeeding time
  Future<DateTime?> getLastBreastfeedingTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_breastfeedingLastTimeKey);
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
      return null;
    } catch (e) {
      print('Error getting last breastfeeding time: $e');
      return null;
    }
  }

  /// Update breastfeeding interval
  Future<void> updateBreastfeedingInterval({
    required int hours,
    required int minutes,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isEnabled = prefs.getBool(_breastfeedingEnabledKey) ?? false;

      if (isEnabled) {
        // Update interval settings
        await prefs.setInt(_breastfeedingIntervalHoursKey, hours);
        await prefs.setInt(_breastfeedingIntervalMinutesKey, minutes);

        // Cancel existing notification and reschedule with new interval
        await _plugin.cancel(_breastfeedingNotificationId);
        await _scheduleNextBreastfeedingNotification(hours, minutes);

        print('Breastfeeding interval updated: ${hours}h ${minutes}m');
      }
    } catch (e) {
      print('Error updating breastfeeding interval: $e');
    }
  }

  /// Schedule the next breastfeeding notification
  Future<void> _scheduleNextBreastfeedingNotification(
      int hours, int minutes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastTimeTimestamp = prefs.getInt(_breastfeedingLastTimeKey);
      final now = tz.TZDateTime.now(tz.local);

      tz.TZDateTime scheduledTime;

      if (lastTimeTimestamp != null) {
        // Schedule from the last feeding time
        final lastTime = DateTime.fromMillisecondsSinceEpoch(lastTimeTimestamp);
        final lastTimeTz = tz.TZDateTime.from(lastTime, tz.local);
        scheduledTime =
            lastTimeTz.add(Duration(hours: hours, minutes: minutes));

        print('Last feeding time: $lastTimeTz');
        print('Calculated next time: $scheduledTime');
        print('Current time: $now');

        // If the scheduled time is in the past, schedule for now + interval
        if (scheduledTime.isBefore(now)) {
          print('Scheduled time is in the past, rescheduling from now');
          scheduledTime = now.add(Duration(hours: hours, minutes: minutes));
        }
      } else {
        // No last time recorded, schedule from now
        print('No last feeding time, scheduling from now');
        scheduledTime = now.add(Duration(hours: hours, minutes: minutes));
      }

      print('Final scheduled time: $scheduledTime');
      print(
          'Time until notification: ${scheduledTime.difference(now).inMinutes} minutes');

      // Create notification channel first
      await _createBreastfeedingNotificationChannel();

      // Cancel any existing notifications in our range first
      for (int i = 0; i < _breastfeedingPrefetchCount; i++) {
        await _plugin.cancel(_breastfeedingNotificationId + i);
      }

      // Schedule a small series so reminders keep firing even if user ignores
      for (int i = 0; i < _breastfeedingPrefetchCount; i++) {
        final tz.TZDateTime at = scheduledTime.add(
          Duration(hours: hours * i, minutes: minutes * i),
        );
        await _plugin.zonedSchedule(
          _breastfeedingNotificationId + i,
          'Breastfeeding Reminder',
          'Time to breastfeed your baby! 🍼',
          at,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              _breastfeedingChannelId,
              'Breastfeeding Reminders',
              channelDescription: 'Reminders for breastfeeding sessions',
              importance: Importance.high,
              priority: Priority.high,
              enableVibration: true,
              playSound: true,
            ),
          ),
          payload: '/breastfeeding_log',
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }

      print(
          '✅ Breastfeeding notifications scheduled starting: $scheduledTime (x$_breastfeedingPrefetchCount)');
    } catch (e) {
      print('❌ Error scheduling breastfeeding notification: $e');
    }
  }

  /// Handle breastfeeding notification response (when user taps the notification)
  Future<void> _handleBreastfeedingNotificationResponse() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Update last feeding time to current time
      await prefs.setInt(
          _breastfeedingLastTimeKey, DateTime.now().millisecondsSinceEpoch);

      // Cancel the current series and reschedule from now
      for (int i = 0; i < _breastfeedingPrefetchCount; i++) {
        await _plugin.cancel(_breastfeedingNotificationId + i);
      }

      // Get current interval settings
      final hours = prefs.getInt(_breastfeedingIntervalHoursKey) ?? 2;
      final minutes = prefs.getInt(_breastfeedingIntervalMinutesKey) ?? 0;

      // Schedule the next notification
      await _scheduleNextBreastfeedingNotification(hours, minutes);

      print('Breastfeeding notification handled, next notification scheduled');
    } catch (e) {
      print('Error handling breastfeeding notification response: $e');
    }
  }

  /// Resume breastfeeding notifications on app startup (if they were enabled)
  Future<void> _resumeBreastfeedingNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isEnabled = prefs.getBool(_breastfeedingEnabledKey) ?? false;

      if (isEnabled) {
        final hours = prefs.getInt(_breastfeedingIntervalHoursKey) ?? 2;
        final minutes = prefs.getInt(_breastfeedingIntervalMinutesKey) ?? 0;
        final lastTimeTimestamp = prefs.getInt(_breastfeedingLastTimeKey);

        // Always cancel any existing series first
        for (int i = 0; i < _breastfeedingPrefetchCount; i++) {
          await _plugin.cancel(_breastfeedingNotificationId + i);
        }

        if (lastTimeTimestamp != null) {
          final lastTime =
              DateTime.fromMillisecondsSinceEpoch(lastTimeTimestamp);
          final now = DateTime.now();
          final nextScheduledTime =
              lastTime.add(Duration(hours: hours, minutes: minutes));

          // If the next scheduled time has passed, it's overdue - schedule immediately
          if (now.isAfter(nextScheduledTime)) {
            print(
                'Breastfeeding notification is overdue, scheduling immediately');
            await _scheduleNextBreastfeedingNotification(hours, minutes);
          } else {
            // Schedule for the remaining time
            final remainingDuration = nextScheduledTime.difference(now);
            print(
                'Breastfeeding notification scheduled in ${remainingDuration.inMinutes} minutes');
            await _scheduleNextBreastfeedingNotification(hours, minutes);
          }
        } else {
          // No last time recorded, schedule from now
          print('No last breastfeeding time found, scheduling from now');
          await _scheduleNextBreastfeedingNotification(hours, minutes);
        }

        print('Breastfeeding notifications resumed');
      }
    } catch (e) {
      print('Error resuming breastfeeding notifications: $e');
    }
  }

  /// Manual trigger for when user manually logs a breastfeeding session
  Future<void> logBreastfeedingSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isEnabled = prefs.getBool(_breastfeedingEnabledKey) ?? false;

      if (isEnabled) {
        // Update last feeding time
        await prefs.setInt(
            _breastfeedingLastTimeKey, DateTime.now().millisecondsSinceEpoch);

        // Cancel current series and reschedule
        for (int i = 0; i < _breastfeedingPrefetchCount; i++) {
          await _plugin.cancel(_breastfeedingNotificationId + i);
        }

        final hours = prefs.getInt(_breastfeedingIntervalHoursKey) ?? 2;
        final minutes = prefs.getInt(_breastfeedingIntervalMinutesKey) ?? 0;

        await _scheduleNextBreastfeedingNotification(hours, minutes);

        print('Breastfeeding session logged, next notification rescheduled');
      } else {
        print('Breastfeeding notifications are disabled, not scheduling');
      }
    } catch (e) {
      print('Error logging breastfeeding session: $e');
    }
  }

  /// Get time remaining until next breastfeeding notification
  Future<Duration?> getTimeUntilNextBreastfeeding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isEnabled = prefs.getBool(_breastfeedingEnabledKey) ?? false;

      if (!isEnabled) return null;

      final lastTimeTimestamp = prefs.getInt(_breastfeedingLastTimeKey);
      if (lastTimeTimestamp == null) return null;

      final lastTime = DateTime.fromMillisecondsSinceEpoch(lastTimeTimestamp);
      final hours = prefs.getInt(_breastfeedingIntervalHoursKey) ?? 2;
      final minutes = prefs.getInt(_breastfeedingIntervalMinutesKey) ?? 0;

      final nextTime = lastTime.add(Duration(hours: hours, minutes: minutes));
      final now = DateTime.now();

      if (nextTime.isAfter(now)) {
        return nextTime.difference(now);
      } else {
        return Duration.zero; // Overdue
      }
    } catch (e) {
      print('Error calculating time until next breastfeeding: $e');
      return null;
    }
  }

  /// Test breastfeeding notification (for debugging)
  Future<void> testBreastfeedingNotification() async {
    try {
      await _createBreastfeedingNotificationChannel();

      await _plugin.show(
        _breastfeedingNotificationId + 1, // Use different ID for test
        'Test Breastfeeding Reminder',
        'This is a test notification for breastfeeding reminders! 🍼',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _breastfeedingChannelId,
            'Breastfeeding Reminders',
            channelDescription: 'Reminders for breastfeeding sessions',
            importance: Importance.high,
            priority: Priority.high,
            enableVibration: true,
            playSound: true,
          ),
        ),
        payload: '/breastfeeding_log',
      );

      print('✅ Test breastfeeding notification sent');
    } catch (e) {
      print('❌ Error sending test breastfeeding notification: $e');
    }
  }

  /// Check pending notifications (for debugging)
  Future<void> checkPendingNotifications() async {
    try {
      final pendingNotifications = await _plugin.pendingNotificationRequests();
      print('📋 Pending notifications count: ${pendingNotifications.length}');

      for (final notification in pendingNotifications) {
        print(
            '📌 Notification ID: ${notification.id}, Title: ${notification.title}');
      }

      // Check if our breastfeeding notification is scheduled
      final breastfeedingNotification = pendingNotifications
          .where((n) => n.id == _breastfeedingNotificationId)
          .firstOrNull;

      if (breastfeedingNotification != null) {
        print('✅ Breastfeeding notification is scheduled');
      } else {
        print('❌ Breastfeeding notification is NOT scheduled');
      }
    } catch (e) {
      print('❌ Error checking pending notifications: $e');
    }
  }

  /// Force reschedule breastfeeding notification (for debugging)
  Future<void> forceRescheduleBreastfeedingNotification() async {
    try {
      print('🔄 Force rescheduling breastfeeding notification...');

      final prefs = await SharedPreferences.getInstance();
      final isEnabled = prefs.getBool(_breastfeedingEnabledKey) ?? false;

      if (!isEnabled) {
        print('❌ Breastfeeding notifications are disabled');
        return;
      }

      final hours = prefs.getInt(_breastfeedingIntervalHoursKey) ?? 2;
      final minutes = prefs.getInt(_breastfeedingIntervalMinutesKey) ?? 0;

      // Cancel any existing notification
      await _plugin.cancel(_breastfeedingNotificationId);

      // Schedule new notification
      await _scheduleNextBreastfeedingNotification(hours, minutes);

      // Check if it was scheduled
      await checkPendingNotifications();

      print('✅ Force reschedule completed');
    } catch (e) {
      print('❌ Error force rescheduling: $e');
    }
  }
}
