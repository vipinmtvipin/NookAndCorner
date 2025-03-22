import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:customerapp/presentation/main_screen/controller/main_controller.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

class NotificationMsgUtil {
  static Future<void> parse(RemoteNotification? notification,
      {String payload = ''}) async {
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
          icon: '@drawable/ic_notification',
          styleInformation: bigPictureStyleInformation,
        );
      } else {
        androidPlatformChannelSpecifics = AndroidNotificationDetails(
          payload == 'pending_payment'
              ? 'nook_corner_pending'
              : 'nook_corner_ids',
          'nook_corner_channel',
          channelDescription: 'Nook and Corner',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          enableLights: true,
          enableVibration: true,
          playSound: true,
          icon: '@drawable/ic_notification',
        );
      }

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await GetIt.I<FlutterLocalNotificationsPlugin>().show(
        payload == 'pending_payment' ? 1 : 0,
        notification.title ?? '',
        notification.body ?? '',
        platformChannelSpecifics,
        payload: payload,
      );
    }
  }

  static Future<void> scheduleRepeatingNotification() async {
    try {
      await GetIt.I<FlutterLocalNotificationsPlugin>().periodicallyShow(
        11,
        'Reminder: Pending Job',
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
            icon: '@drawable/ic_notification',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exact,
      );
    } catch (_) {}
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
      icon: '@drawable/ic_notification',
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

  static cancelNotification(int id) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        GetIt.I<FlutterLocalNotificationsPlugin>();

    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static void parseSilentPush(Map<String, dynamic> data) {
    if (data.isNotEmpty) {
      try {
        FirebaseCrashlytics.instance
            .log('Silent Push Data:  ${data.toString()}');
      } catch (_) {}
      Logger.e('Silent Push: $data', 'NotificationMsgUtil ${data.toString()}');
      if (data.containsKey('pending_job') ||
          data.containsKey('pending_payment')) {
        var type =
            data.containsKey('pending_job') ? 'pending_job' : 'pending_payment';

        var count = int.tryParse(data['$type'].toString()) ?? 0;
        if (count > 0) {
          if (type == 'pending_job') {
            parse(
                RemoteNotification(
                  title: 'Reminder: Pending Job',
                  body: 'You have a pending job, please confirm the address.',
                ),
                payload: 'pending_jobs');
            Workmanager().registerPeriodicTask(
              'PendingNotification',
              'PendingNotification',
              constraints: Constraints(
                networkType: NetworkType.not_required,
                requiresBatteryNotLow: false,
                requiresCharging: false,
              ),
              existingWorkPolicy: ExistingWorkPolicy.replace,
            );
            try {
              Get.find<MainScreenController>().pendingJobs = true;
            } catch (_) {}
          } else if (type == 'pending_payment') {
            parse(
                RemoteNotification(
                  title: 'Payment Due',
                  body:
                      'Hi there! Just a quick reminder about your balance service payment, please click here when you can. Thanks!',
                ),
                payload: 'pending_payment');

            Workmanager().registerPeriodicTask(
              'PaymentPendingNotification',
              'PaymentPendingNotification',
              constraints: Constraints(
                networkType: NetworkType.not_required,
                requiresBatteryNotLow: false,
                requiresCharging: false,
              ),
              existingWorkPolicy: ExistingWorkPolicy.replace,
            );
            try {
              Get.find<MainScreenController>().pendingPayments = true;
            } catch (_) {}
          }
        } else {
          if (type == 'pending_job') {
            try {
              GetStorage().write(StorageKeys.pendingJobCount, 0);
              Workmanager().cancelByUniqueName('PendingNotification');
              Get.find<MainScreenController>().pendingJobs = false;
            } catch (_) {
              Workmanager().cancelAll();
            }
          } else if (type == 'pending_payment') {
            try {
              GetStorage().write(StorageKeys.pendingPaymentCount, 0);
              Workmanager().cancelByUniqueName('PaymentPendingNotification');
              Get.find<MainScreenController>().pendingPayments = false;
            } catch (_) {
              Workmanager().cancelAll();
            }
          }
        }
      }
    }
  }
}
