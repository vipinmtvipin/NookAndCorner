import 'dart:async';

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

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

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
