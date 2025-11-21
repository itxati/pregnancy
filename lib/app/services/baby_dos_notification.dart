import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TrackMyBabyDos {
  TrackMyBabyDos._internal();
  static final TrackMyBabyDos instance = TrackMyBabyDos._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  static const String _trackRoute = '/track_my_baby';
  String? _pendingRoute;
  bool _appReady = false;

  /// Initialize notifications
  Future<void> initialize() async {
    if (_initialized) return;

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit);

    // Check if app was launched from a notification
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

  /// Schedule daily baby tip notification (all tips in one)
  Future<void> scheduleDaily830Notifications({
    required List<String> tipKeys,
    required Map<String, String> translations,
    required String titleKey,
  }) async {
    // Cancel any existing notifications
    await cancelDaily830Notifications();

    // Combine all tips into one string
    final String body = tipKeys
        .map((tipKey) => _translateWithFallback(
              translations,
              tipKey,
              fallback: tipKey,
            ))
        .join('\n');

    final tz.TZDateTime scheduledTime =
        _nextInstanceOfTime(hour: 2, minute: 20);
    final String title = _translateWithFallback(
      translations,
      titleKey,
      fallback: 'BabyCare Tips',
    );

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'baby_tips_dos',
      'Baby Tips Dos',
      channelDescription: 'Daily notifications for baby care tips',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(body),
    );

    await _plugin.zonedSchedule(
      1000,
      title,
      body,
      scheduledTime,
      NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: _trackRoute,
    );
  }

  /// Cancel previously scheduled notifications
  Future<void> cancelDaily830Notifications() async {
    await _plugin.cancel(1000);
  }

  /// Schedule annual date-specific notifications
  /// October 15 - Cold danger (Namunia)
  /// March 15 - Heat & Diarrhea (Diaria)
  Future<void> scheduleAnnualDateNotifications({
    required Map<String, String> translations,
  }) async {
    // Cancel any existing annual notifications
    await _plugin.cancel(2001); // October 15 notification ID
    await _plugin.cancel(2002); // March 15 notification ID

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final int currentYear = now.year;

    // Schedule October 15 - Cold Danger (Namunia)
    tz.TZDateTime october15 = tz.TZDateTime(
      tz.local,
      currentYear,
      10, // October
      15,
      9, // 9 AM
      0,
    );

    // If October 15 has passed this year, schedule for next year
    if (october15.isBefore(now)) {
      october15 = tz.TZDateTime(
        tz.local,
        currentYear + 1,
        10,
        15,
        9,
        0,
      );
    }

    final String octoberTitle = _translateWithFallback(
      translations,
      'october_15_cold_danger_title',
      fallback: 'Cold Danger Alert',
    );
    final String octoberBody = _translateWithFallback(
      translations,
      'october_15_cold_danger_body',
      fallback:
          'Namunia: Cold weather alert! Keep your baby warm and protected from cold weather.',
    );

    final AndroidNotificationDetails octoberDetails =
        AndroidNotificationDetails(
      'baby_seasonal_alerts',
      'Baby Seasonal Alerts',
      channelDescription: 'Seasonal health alerts for babies',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(octoberBody),
    );

    await _plugin.zonedSchedule(
      2001,
      octoberTitle,
      octoberBody,
      october15,
      NotificationDetails(android: octoberDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      payload: _trackRoute,
    );

    // Schedule March 15 - Heat & Diarrhea (Diaria)
    tz.TZDateTime march15 = tz.TZDateTime(
      tz.local,
      currentYear,
      3, // March
      15,
      9, // 9 AM
      3,
    );

    // If March 15 has passed this year, schedule for next year
    if (march15.isBefore(now)) {
      march15 = tz.TZDateTime(
        tz.local,
        currentYear + 1,
        3,
        15,
        9,
        3,
      );
    }

    final String marchTitle = _translateWithFallback(
      translations,
      'march_15_heat_diarrhea_title',
      fallback: 'Heat & Diarrhea Alert',
    );
    final String marchBody = _translateWithFallback(
      translations,
      'march_15_heat_diarrhea_body',
      fallback:
          'Diaria: Hot weather can cause dehydration and diarrhea in babies.',
    );

    final AndroidNotificationDetails marchDetails = AndroidNotificationDetails(
      'baby_seasonal_alerts',
      'Baby Seasonal Alerts',
      channelDescription: 'Seasonal health alerts for babies',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(marchBody),
    );

    await _plugin.zonedSchedule(
      2002,
      marchTitle,
      marchBody,
      march15,
      NotificationDetails(android: marchDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      payload: _trackRoute,
    );
  }

  /// Get the next instance of a specific time
  tz.TZDateTime _nextInstanceOfTime({
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
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  String _translateWithFallback(
    Map<String, String> translations,
    String key, {
    required String fallback,
  }) {
    final translated = translations[key]?.trim();
    if (translated != null && translated.isNotEmpty) {
      return translated;
    }
    return fallback;
  }

  /// Show instant test notification
  Future<void> showTestNow({String? body}) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'baby_tips_dos',
      'Baby Tips Dos',
      channelDescription: 'Daily notifications for baby care tips',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation:
          BigTextStyleInformation(body ?? 'This is a test notification'),
    );

    await _plugin.show(
      9999,
      'BabyCare Tip (Test)',
      body ?? 'This is a test notification',
      NotificationDetails(android: androidDetails),
      payload: _trackRoute,
    );
  }
}
