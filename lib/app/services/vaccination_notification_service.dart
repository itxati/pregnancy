import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class VaccinationNotificationService {
  VaccinationNotificationService._internal();
  static final VaccinationNotificationService instance =
      VaccinationNotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  static const String _trackRoute = '/track_my_baby';
  static const String _completedVaccinationsKey = 'completed_vaccinations';

  /// Initialize notifications
  Future<void> initialize() async {
    if (_initialized) return;

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final String route = (response.payload?.isNotEmpty ?? false)
            ? response.payload!
            : _trackRoute;
        try {
          Get.toNamed(route);
        } catch (e) {
          print('Error navigating from notification: $e');
        }
      },
    );

    // Timezone setup
    tz.initializeTimeZones();
    final String localTz = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTz));

    _initialized = true;
  }

  /// Get completed vaccinations for a child
  Future<Set<String>> getCompletedVaccinations(String childId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_completedVaccinationsKey}_$childId';
      final completedStr = prefs.getString(key);
      if (completedStr != null && completedStr.isNotEmpty) {
        final List<dynamic> list = jsonDecode(completedStr);
        return list.map((e) => e.toString()).toSet();
      }
    } catch (e) {
      print('Error loading completed vaccinations: $e');
    }
    return <String>{};
  }

  /// Mark vaccination as completed for a child
  Future<void> markVaccinationCompleted(
      String childId, String vaccinationStage) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_completedVaccinationsKey}_$childId';
      final completed = await getCompletedVaccinations(childId);
      completed.add(vaccinationStage);
      await prefs.setString(key, jsonEncode(completed.toList()));
      // Reschedule notifications after marking as completed
      await scheduleVaccinationNotificationsForChild(childId);
    } catch (e) {
      print('Error marking vaccination as completed: $e');
    }
  }

  /// Parse age from translation string (e.g., "6 weeks", "9 months", "At birth")
  Map<String, dynamic>? _parseAge(String ageStr) {
    ageStr = ageStr.toLowerCase().trim();

    if (ageStr.contains('at birth') ||
        ageStr.contains('پیدائش') ||
        ageStr.contains('پیدائش دے ویلے')) {
      return {'type': 'birth', 'value': 0};
    }

    // Extract number and unit
    final RegExp weekRegex =
        RegExp(r'(\d+)\s*(week|ہفتے|ہفتہ)', caseSensitive: false);
    final RegExp monthRegex =
        RegExp(r'(\d+)\s*(month|ماہ|مہینے|مہینہ)', caseSensitive: false);

    final weekMatch = weekRegex.firstMatch(ageStr);
    if (weekMatch != null) {
      final weeks = int.tryParse(weekMatch.group(1) ?? '0') ?? 0;
      return {'type': 'weeks', 'value': weeks};
    }

    final monthMatch = monthRegex.firstMatch(ageStr);
    if (monthMatch != null) {
      final months = int.tryParse(monthMatch.group(1) ?? '0') ?? 0;
      return {'type': 'months', 'value': months};
    }

    return null;
  }

  /// Calculate days from birth date for vaccination
  int _calculateDaysForVaccination(
      DateTime birthDate, Map<String, dynamic> ageInfo) {
    if (ageInfo['type'] == 'birth') return 0;
    if (ageInfo['type'] == 'weeks') {
      return ageInfo['value'] * 7;
    }
    if (ageInfo['type'] == 'months') {
      // Approximate: 30 days per month
      return ageInfo['value'] * 30;
    }
    return 0;
  }

  /// Schedule vaccination notifications for a specific child
  Future<void> scheduleVaccinationNotificationsForChild(String childId) async {
    try {
      // Cancel existing notifications for this child
      await cancelVaccinationNotificationsForChild(childId);

      final prefs = await SharedPreferences.getInstance();
      final childrenDataStr = prefs.getString('all_children_data');
      if (childrenDataStr == null || childrenDataStr.isEmpty) return;

      final List<dynamic> childrenList = jsonDecode(childrenDataStr);

      // Find child by ID or by index/name
      Map<String, dynamic>? childData;
      if (childId.startsWith('child_')) {
        // Extract index from childId like "child_0"
        final index = int.tryParse(childId.split('_').last);
        if (index != null && index < childrenList.length) {
          childData = childrenList[index];
        }
      } else {
        // Try to find by name or use first child
        childData = childrenList.firstWhere(
          (child) => child['name'] == childId,
          orElse: () => childrenList.isNotEmpty ? childrenList[0] : null,
        );
      }

      if (childData == null) return;

      final birthDateStr = childData['dob'];
      if (birthDateStr == null) return;

      final birthDate = DateTime.parse(birthDateStr);
      final completed = await getCompletedVaccinations(childId);

      // Schedule notifications for each vaccination stage (1-7)
      for (int stage = 1; stage <= 7; stage++) {
        final stageKey = 'vaccination_table_stage_$stage';
        final ageKey = 'vaccination_table_age_$stage';
        final vaccinesKey = 'vaccination_table_vaccines_$stage';

        // Skip if already completed
        if (completed.contains('stage_$stage')) continue;

        final ageStr = ageKey.tr;
        final ageInfo = _parseAge(ageStr);
        if (ageInfo == null) continue;

        final daysFromBirth = _calculateDaysForVaccination(birthDate, ageInfo);
        final vaccinationDate = birthDate.add(Duration(days: daysFromBirth));
        final now = DateTime.now();

        // Only schedule if vaccination date is in the future or within notification period
        if (vaccinationDate.isBefore(now.subtract(Duration(days: 7)))) continue;

        // Determine notification period
        int notificationDays = 7; // Default: 1 week
        if (ageInfo['type'] == 'months') {
          notificationDays = 30; // 1 month
        } else if (ageInfo['type'] == 'weeks') {
          notificationDays = 7; // 1 week
        } else if (ageInfo['type'] == 'birth') {
          notificationDays = 7; // 1 week from birth
        }

        // Schedule daily notifications for the period
        final startDate = vaccinationDate.subtract(Duration(days: 1));
        final endDate =
            vaccinationDate.add(Duration(days: notificationDays - 1));

        if (endDate.isBefore(now)) continue;

        final actualStartDate = startDate.isBefore(now) ? now : startDate;
        final daysToSchedule = endDate.difference(actualStartDate).inDays + 1;

        for (int dayOffset = 0;
            dayOffset < daysToSchedule && dayOffset < notificationDays;
            dayOffset++) {
          final notificationDate =
              actualStartDate.add(Duration(days: dayOffset));
          if (notificationDate.isBefore(now)) continue;

          final tz.TZDateTime scheduledTime = tz.TZDateTime(
            tz.local,
            notificationDate.year,
            notificationDate.month,
            notificationDate.day,
            3, // 9 AM
            58,
          );

          final stageName = stageKey.tr;
          final vaccines = vaccinesKey.tr;
          final title = 'vaccination_reminder_title'.tr;
          final body = 'vaccination_reminder_body'
              .tr
              .replaceAll('{stage}', stageName)
              .replaceAll('{vaccines}', vaccines)
              .replaceAll('{age}', ageStr);

          final AndroidNotificationDetails androidDetails =
              AndroidNotificationDetails(
            'vaccination_reminders',
            'Vaccination Reminders',
            channelDescription: 'Reminders for baby vaccination schedule',
            importance: Importance.high,
            priority: Priority.high,
            styleInformation: BigTextStyleInformation(body),
          );

          // Use unique ID: childId hash + stage + dayOffset
          final notificationId =
              _generateNotificationId(childId, stage, dayOffset);

          await _plugin.zonedSchedule(
            notificationId,
            title,
            body,
            scheduledTime,
            NotificationDetails(android: androidDetails),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.dateAndTime,
            payload: '$_trackRoute?childId=$childId&stage=$stage',
          );
        }
      }
    } catch (e) {
      print('Error scheduling vaccination notifications: $e');
    }
  }

  /// Generate unique notification ID
  int _generateNotificationId(String childId, int stage, int dayOffset) {
    // Use a combination that ensures uniqueness
    final hash = childId.hashCode.abs();
    return 3000 + (hash % 1000) + (stage * 100) + dayOffset;
  }

  /// Schedule notifications for all children
  Future<void> scheduleVaccinationNotificationsForAllChildren() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final childrenDataStr = prefs.getString('all_children_data');
      if (childrenDataStr == null || childrenDataStr.isEmpty) return;

      final List<dynamic> childrenList = jsonDecode(childrenDataStr);
      for (int i = 0; i < childrenList.length; i++) {
        final childId = 'child_$i';
        await scheduleVaccinationNotificationsForChild(childId);
      }
    } catch (e) {
      print('Error scheduling notifications for all children: $e');
    }
  }

  /// Cancel vaccination notifications for a specific child
  Future<void> cancelVaccinationNotificationsForChild(String childId) async {
    try {
      // Cancel all possible notification IDs for this child
      for (int stage = 1; stage <= 7; stage++) {
        for (int dayOffset = 0; dayOffset < 30; dayOffset++) {
          final notificationId =
              _generateNotificationId(childId, stage, dayOffset);
          await _plugin.cancel(notificationId);
        }
      }
    } catch (e) {
      print('Error canceling vaccination notifications: $e');
    }
  }

  /// Cancel all vaccination notifications
  Future<void> cancelAllVaccinationNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final childrenDataStr = prefs.getString('all_children_data');
      if (childrenDataStr != null && childrenDataStr.isNotEmpty) {
        final List<dynamic> childrenList = jsonDecode(childrenDataStr);
        for (int i = 0; i < childrenList.length; i++) {
          final childId = 'child_$i';
          await cancelVaccinationNotificationsForChild(childId);
        }
      }
    } catch (e) {
      print('Error canceling all vaccination notifications: $e');
    }
  }
}
