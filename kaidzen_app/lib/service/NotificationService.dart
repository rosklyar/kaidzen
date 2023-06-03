import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:timezone/timezone.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool initialized = false;

  static Future initState() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onSelectNotification);
    initialized = true;
  }

  static Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  }

  static Future<void> onSelectNotification(NotificationResponse details) async {
    if (details.payload != null) {
      debugPrint('notification payload: ' + details.payload.toString());
    }

    // do something with the payload
  }

  static Future<bool> permissionGranted() async {
    return await NotificationPermissions.getNotificationPermissionStatus() ==
        PermissionStatus.granted;
  }

  static Future<PermissionStatus> getPermissionStatus() async {
    return await NotificationPermissions.getNotificationPermissionStatus();
  }

  static Future<void> scheduleNotification(int id, String title, String body,
      DateTime startDate, TimeOfDay timeOfDay, RepeatType repeatType) async {
    if (!initialized) {
      await initState();
    }
    if (!await permissionGranted()) {
      NotificationPermissions.requestNotificationPermissions();
      return;
    }

    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    initializeTimeZones();
    setLocalLocation(getLocation(DateTimeZone.local.id));

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        nextInstanceOfReminder(startDate, timeOfDay, repeatType),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: repeatType == RepeatType.WEEKLY
            ? DateTimeComponents.dayOfWeekAndTime
            : DateTimeComponents.time);
  }

  static Future<void> cancelNotification(int id) async {
    if (!initialized) {
      await initState();
    }
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static TZDateTime nextInstanceOfReminder(
      DateTime startDate, TimeOfDay timeOfDay, RepeatType repeatType) {
    final TZDateTime now = TZDateTime.now(local);

    TZDateTime scheduledDate = TZDateTime(local, startDate.year,
        startDate.month, startDate.day, timeOfDay.hour, timeOfDay.minute, 0);

    if (repeatType == RepeatType.WEEKLY) {
      while (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 7));
      }
    } else {
      while (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    }

    debugPrint(scheduledDate.toString());
    return scheduledDate;
  }
}
