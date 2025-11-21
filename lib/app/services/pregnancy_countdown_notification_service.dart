import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class PregnancyCountdownNotificationService {
  static final PregnancyCountdownNotificationService instance =
      PregnancyCountdownNotificationService._internal();
  PregnancyCountdownNotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'pregnancy_countdown';
  static const int _notificationId = 9000;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    tz.initializeTimeZones();
    final String localTz = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTz));
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit);
    await _plugin.initialize(initSettings);
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            'Pregnancy Countdown',
            description: 'Daily countdown notifications until due date',
            importance: Importance.high,
          ),
        );
    _initialized = true;
  }

  Future<void> scheduleCountdownNotification(
      {required DateTime dueDate, int hour = 4, int minute = 25}) async {
    await initialize();
    await _plugin.cancel(_notificationId);
    final now = DateTime.now();
    final durationLeft = dueDate.difference(now);
    final int daysLeft = durationLeft.inDays;
    if (daysLeft < 0) return; // Don't schedule if overdue

    // Compose notification using translation key
    final String message = 'pregnancy_countdown_notification'
        .trParams({'days': daysLeft.toString()});

    // Calculate the next notification time (for tomorrow morning if already past time today)
    tz.TZDateTime scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    await _plugin.zonedSchedule(
      _notificationId,
      'Pregnancy Countdown',
      message,
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Pregnancy Countdown',
          channelDescription: 'Daily countdown notifications until due date',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '/track_pregnancy',
    );
  }

  Future<void> cancelCountdownNotification() async {
    await initialize();
    await _plugin.cancel(_notificationId);
  }
}

// Usage:
// - Call PregnancyCountdownNotificationService.instance.scheduleCountdownNotification(dueDate: ...)
// - To cancel: PregnancyCountdownNotificationService.instance.cancelCountdownNotification()
