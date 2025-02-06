import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationMsgUtil {
  static Future<void> parse(RemoteNotification? notification) async {
    if (notification != null) {
      AndroidNotificationDetails androidPlatformChannelSpecifics;
      if (notification.android?.imageUrl != null) {
        final String imageUrl = notification.android?.imageUrl ?? '';
        // Use big picture style for image notifications
        final BigPictureStyleInformation bigPictureStyleInformation =
            BigPictureStyleInformation(
          FilePathAndroidBitmap(imageUrl),
          contentTitle: notification.title ?? '',
          summaryText: notification.body ?? '',
        );
        androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'nook_corner_id',
          'nook_corner_channel',
          channelDescription: 'Nook and Corner',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          enableLights: true,
          enableVibration: true,
          playSound: true,
          icon: '@mipmap/ic_launcher',
          styleInformation: bigPictureStyleInformation,
        );
      } else {
        androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'nook_corner_id',
          'nook_corner_channel',
          channelDescription: 'Nook and Corner',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          enableLights: true,
          enableVibration: true,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        );
      }

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await GetIt.I<FlutterLocalNotificationsPlugin>().show(
        0,
        notification.title ?? '',
        notification.body ?? '',
        platformChannelSpecifics,
      );
    }
  }

  static Future<void> scheduleRepeatingNotification() async {
    await GetIt.I<FlutterLocalNotificationsPlugin>().periodicallyShow(
      11,
      'Remainder: Pending Job',
      'You have a pending job, please confirm the address.',
      RepeatInterval.everyMinute,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'periodic_channel',
          'Periodic Notifications',
          channelDescription: 'Shows notifications every minutes',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: false,
          enableLights: true,
          enableVibration: true,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }

  static Future<void> showPeriodicNotification() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        GetIt.I<FlutterLocalNotificationsPlugin>();

    // Initialize timezone data
    tz.initializeTimeZones();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'nook_corner_ids',
      'nook_corner_channels',
      channelDescription: 'Nook and Corner',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
      enableLights: true,
      enableVibration: true,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Schedule the first notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      501,
      'Pending Job',
      'You have a pending job, please confirm the address.',
      _nextInstanceIn30Minutes(),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceIn30Minutes() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    return now.add(const Duration(seconds: 5));
  }

  static cancelPeriodicNotification() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        GetIt.I<FlutterLocalNotificationsPlugin>();

    await flutterLocalNotificationsPlugin.cancel(11);
  }
}
