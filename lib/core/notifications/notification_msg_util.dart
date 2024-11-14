import 'dart:convert';

import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

class NotificationMsgUtil {
  static Future<void> parse(String? msg) async {
    if (msg.isNotNullOrEmpty) {
      Map<String, dynamic> data = jsonDecode(msg!);

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

      await GetIt.I<FlutterLocalNotificationsPlugin>().show(
        0,
        "Title",
        "Body",
        platformChannelSpecifics,
      );
    }
  }
}
