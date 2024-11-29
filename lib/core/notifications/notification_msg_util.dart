import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

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

  static showPeriodicNotification() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        GetIt.I<FlutterLocalNotificationsPlugin>();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
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
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      501,
      'Pending Job',
      'you have a pending job, please confirm the address.',
      RepeatInterval.everyMinute,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
