import 'dart:async';
import 'dart:io';

import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/notifications/notification_msg_util.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:customerapp/presentation/my_job_screen/controller/mybooking_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

class NotificationManager {
  Future init() async {
    try {
      await _initializeNotifications();
      await _initiateFirebase();
      await getPushToken();
    } catch (e, s) {
      Logger.e(
        'Error initializing FirebaseMessaging',
        e.toString(),
      );
    }
  }

  Future<void> _initializeNotifications() async {
    final bool? result = await GetIt.I<FlutterLocalNotificationsPlugin>()
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // iOS Notification Settings
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    // Android Notification Settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      '@drawable/ic_notification',
    );
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      requestCriticalPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: iosSettings);

    await GetIt.I<FlutterLocalNotificationsPlugin>().initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        if (notificationResponse.payload != null) {
          if (notificationResponse.payload == 'pending_jobs') {
            Get.toNamed(AppRoutes.bookingListingScreen,
                arguments: {"title": MyBookingStatus.pending.name});
          }
        }
      },
    );

    // Set up Android notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'nook_corner_id',
      'nook_corner_channel',
      importance: Importance.max,
      enableLights: true,
      enableVibration: true,
      showBadge: true,
      playSound: true,
    );

    await GetIt.I<FlutterLocalNotificationsPlugin>()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _initiateFirebase() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logPushNotification(
          'Message :onMessage : ${message.toMap().toString() ?? ''}');
      logPushNotification(
          'Data :onMessage :  ${message.data.toString() ?? ''}');

      if (message.notification != null) {
        NotificationMsgUtil.parse(
          message.notification,
        );
      }
      if (message.data.isNotEmpty) {
        NotificationMsgUtil.parseSilentPush(
          message.data,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logPushNotification(
          'Message :onMessageOpenedApp : ${message.toMap().toString() ?? ''}');
      logPushNotification(
          'Data :onMessageOpenedApp :  ${message.data.toString() ?? ''}');
      if (message.notification != null) {
        NotificationMsgUtil.parse(message.notification);
      }
      if (message.data.isNotEmpty) {
        NotificationMsgUtil.parseSilentPush(
          message.data,
        );
      }
    });

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      Future.delayed(const Duration(seconds: 1), () {
        logPushNotification(
            'Message :initialMessage : ${initialMessage.toMap().toString() ?? ''}');
        logPushNotification(
            'Data :initialMessage :  ${initialMessage.data.toString() ?? ''}');
        if (initialMessage.notification != null) {
          NotificationMsgUtil.parse(initialMessage.notification);
        }
        if (initialMessage.data.isNotEmpty) {
          NotificationMsgUtil.parseSilentPush(
            initialMessage.data,
          );
        }
      });
    }
  }
}

Future<void> getPushToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  final sessionStorage = GetStorage();
  if (token != null) {
    sessionStorage.write(StorageKeys.pushToken, token);
  }

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    if (newToken.isNotNullOrEmpty) {
      sessionStorage.write(StorageKeys.pushToken, newToken);
    }
  });
}

Future<void> _firebaseBackgroundMessage(RemoteMessage message) async {
  debugPrint('FirebaseMessaging -Some notification Received in background..');
  try {
    logPushNotification(
        'Message :_firebaseBackgroundMessage : ${message.toMap().toString() ?? ''}');
    logPushNotification(
        'Data :_firebaseBackgroundMessage :  ${message.data.toString() ?? ''}');

    if (message.data.isNotEmpty) {
      NotificationMsgUtil.parseSilentPush(
        message.data,
      );
    }
  } catch (e) {
    Logger.e(
      'Error in background message',
      e.toString(),
    );
  }
}

Future<void> logPushNotification(String message) async {
  try {
    final dir = await getApplicationDocumentsDirectory(); // Internal storage
    final file = File('${dir.path}/pushnotification.txt');

    final now = DateTime.now().toIso8601String();
    final logEntry = '[$now]   --  $message\n';

    await file.writeAsString(logEntry, mode: FileMode.append);
    print('Logged notification to file');
  } catch (e) {
    print('Error logging notification: $e');
  }
}
