import 'dart:convert';

import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

class NotificationMsgUtil {
  static Future<void> parse(String? msg) async {
    if (msg.isNotNullOrEmpty) {
      Map<String, dynamic> data = jsonDecode(msg!);

      AndroidNotificationDetails androidPlatformChannelSpecifics;
      if (data.containsKey('image')) {
        final String? imageUrl = data['image'] ?? '';
        // Use big picture style for image notifications
        final BigPictureStyleInformation bigPictureStyleInformation =
            BigPictureStyleInformation(
          FilePathAndroidBitmap(imageUrl!),
          contentTitle: data['title'] ?? '',
          summaryText: data['body'] ?? '',
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
        );
      }

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await GetIt.I<FlutterLocalNotificationsPlugin>().show(
        0,
        data['title'] ?? '',
        data['body'] ?? '',
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
