import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class BreastfeedingNotificationService {
  BreastfeedingNotificationService._internal();

  static final BreastfeedingNotificationService instance =
      BreastfeedingNotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool _appReady = false;
  String? _pendingRoute;

  static const String _trackRoute = '/breastfeeding_log';
  static const String _breastfeedingChannelId = 'breastfeeding_reminders';
  static const int _breastfeedingNotificationId = 5000;
  static const int _breastfeedingPrefetchCount = 4;

  static const String _breastfeedingLastTimeKey = 'breastfeeding_last_time';
  static const String _breastfeedingIntervalHoursKey =
      'breastfeeding_interval_hours';
  static const String _breastfeedingIntervalMinutesKey =
      'breastfeeding_interval_minutes';
  static const String _breastfeedingEnabledKey = 'breastfeeding_enabled';

  Future<void> initialize() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

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

        if (response.id != null &&
            response.id! >= _breastfeedingNotificationId &&
            response.id! <
                _breastfeedingNotificationId + _breastfeedingPrefetchCount) {
          await _handleBreastfeedingNotificationResponse();
        }

        _pendingRoute = route;
        if (_appReady) {
          Get.offAllNamed(route);
          _pendingRoute = null;
        }
      },
    );

    tz.initializeTimeZones();
    final String localTz = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTz));

    await _createBreastfeedingNotificationChannel();
    await _resumeBreastfeedingNotifications();

    _initialized = true;
  }

  void markAppReady() {
    _appReady = true;
    if (_pendingRoute != null) {
      Get.offAllNamed(_pendingRoute!);
      _pendingRoute = null;
    }
  }

  Future<void> enableBreastfeedingNotifications({
    required int hours,
    required int minutes,
  }) async {
    await _ensureInitialized();
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool(_breastfeedingEnabledKey, true);
      await prefs.setInt(_breastfeedingIntervalHoursKey, hours);
      await prefs.setInt(_breastfeedingIntervalMinutesKey, minutes);

      final now = DateTime.now();
      await prefs.setInt(_breastfeedingLastTimeKey, now.millisecondsSinceEpoch);

      await _scheduleNextBreastfeedingNotification(hours, minutes);
    } catch (e) {
      print('❌ Error enabling breastfeeding notifications: $e');
      rethrow;
    }
  }

  Future<void> disableBreastfeedingNotifications() async {
    await _ensureInitialized();
    try {
      final prefs = await SharedPreferences.getInstance();

      await _cancelBreastfeedingSeries();
      await prefs.setBool(_breastfeedingEnabledKey, false);
      await prefs.remove(_breastfeedingLastTimeKey);
    } catch (e) {
      print('Error disabling breastfeeding notifications: $e');
      rethrow;
    }
  }

  Future<bool> areBreastfeedingNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_breastfeedingEnabledKey) ?? false;
  }

  Future<Map<String, int>> getBreastfeedingInterval() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'hours': prefs.getInt(_breastfeedingIntervalHoursKey) ?? 2,
      'minutes': prefs.getInt(_breastfeedingIntervalMinutesKey) ?? 0,
    };
  }

  Future<DateTime?> getLastBreastfeedingTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_breastfeedingLastTimeKey);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  Future<void> updateBreastfeedingInterval({
    required int hours,
    required int minutes,
  }) async {
    await _ensureInitialized();
    try {
      final prefs = await SharedPreferences.getInstance();
      final isEnabled = prefs.getBool(_breastfeedingEnabledKey) ?? false;

      if (isEnabled) {
        await prefs.setInt(_breastfeedingIntervalHoursKey, hours);
        await prefs.setInt(_breastfeedingIntervalMinutesKey, minutes);

        await _cancelBreastfeedingSeries();
        await _scheduleNextBreastfeedingNotification(hours, minutes);
      }
    } catch (e) {
      print('Error updating breastfeeding interval: $e');
      rethrow;
    }
  }

  Future<void> logBreastfeedingSession() async {
    await _ensureInitialized();
    try {
      final prefs = await SharedPreferences.getInstance();
      final isEnabled = prefs.getBool(_breastfeedingEnabledKey) ?? false;

      if (isEnabled) {
        await prefs.setInt(
            _breastfeedingLastTimeKey, DateTime.now().millisecondsSinceEpoch);

        await _cancelBreastfeedingSeries();

        final hours = prefs.getInt(_breastfeedingIntervalHoursKey) ?? 2;
        final minutes = prefs.getInt(_breastfeedingIntervalMinutesKey) ?? 0;

        await _scheduleNextBreastfeedingNotification(hours, minutes);
      }
    } catch (e) {
      print('Error logging breastfeeding session: $e');
      rethrow;
    }
  }

  Future<void> testBreastfeedingNotification() async {
    await _ensureInitialized();
    try {
      await _createBreastfeedingNotificationChannel();

      await _plugin.show(
        _breastfeedingNotificationId + 1,
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
        payload: _trackRoute,
      );
    } catch (e) {
      print('❌ Error sending test breastfeeding notification: $e');
      rethrow;
    }
  }

  Future<void> checkPendingNotifications() async {
    await _ensureInitialized();
    try {
      final pendingNotifications = await _plugin.pendingNotificationRequests();
      print('📋 Pending notifications count: ${pendingNotifications.length}');

      for (final notification in pendingNotifications) {
        print(
            '📌 Notification ID: ${notification.id}, Title: ${notification.title}');
      }
    } catch (e) {
      print('❌ Error checking pending notifications: $e');
      rethrow;
    }
  }

  Future<void> forceRescheduleBreastfeedingNotification() async {
    await _ensureInitialized();
    try {
      final prefs = await SharedPreferences.getInstance();
      final isEnabled = prefs.getBool(_breastfeedingEnabledKey) ?? false;

      if (!isEnabled) {
        print('❌ Breastfeeding notifications are disabled');
        return;
      }

      final hours = prefs.getInt(_breastfeedingIntervalHoursKey) ?? 2;
      final minutes = prefs.getInt(_breastfeedingIntervalMinutesKey) ?? 0;

      await _cancelBreastfeedingSeries();
      await _scheduleNextBreastfeedingNotification(hours, minutes);
    } catch (e) {
      print('❌ Error force rescheduling breastfeeding notifications: $e');
      rethrow;
    }
  }

  Future<Duration?> getTimeUntilNextBreastfeeding() async {
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
      return Duration.zero;
    }
  }

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

  Future<void> _scheduleNextBreastfeedingNotification(
      int hours, int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    final lastTimeTimestamp = prefs.getInt(_breastfeedingLastTimeKey);
    final now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledTime;

    if (lastTimeTimestamp != null) {
      final lastTime = DateTime.fromMillisecondsSinceEpoch(lastTimeTimestamp);
      final lastTimeTz = tz.TZDateTime.from(lastTime, tz.local);
      scheduledTime = lastTimeTz.add(Duration(hours: hours, minutes: minutes));

      if (scheduledTime.isBefore(now)) {
        scheduledTime = now.add(Duration(hours: hours, minutes: minutes));
      }
    } else {
      scheduledTime = now.add(Duration(hours: hours, minutes: minutes));
    }

    await _createBreastfeedingNotificationChannel();
    await _cancelBreastfeedingSeries();

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
        payload: _trackRoute,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  Future<void> _handleBreastfeedingNotificationResponse() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
        _breastfeedingLastTimeKey, DateTime.now().millisecondsSinceEpoch);

    final hours = prefs.getInt(_breastfeedingIntervalHoursKey) ?? 2;
    final minutes = prefs.getInt(_breastfeedingIntervalMinutesKey) ?? 0;

    await _cancelBreastfeedingSeries();
    await _scheduleNextBreastfeedingNotification(hours, minutes);
  }

  Future<void> _resumeBreastfeedingNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool(_breastfeedingEnabledKey) ?? false;

    if (isEnabled) {
      final hours = prefs.getInt(_breastfeedingIntervalHoursKey) ?? 2;
      final minutes = prefs.getInt(_breastfeedingIntervalMinutesKey) ?? 0;

      await _cancelBreastfeedingSeries();
      await _scheduleNextBreastfeedingNotification(hours, minutes);
    }
  }

  Future<void> _cancelBreastfeedingSeries() async {
    for (int i = 0; i < _breastfeedingPrefetchCount; i++) {
      await _plugin.cancel(_breastfeedingNotificationId + i);
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await initialize();
    }
  }
}
