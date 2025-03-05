import 'package:customerapp/core/di/app_module.dart';
import 'package:customerapp/core/localization/app_localization.dart';
import 'package:customerapp/firebase_options.dart';
import 'package:customerapp/presentation/my_job_screen/controller/mybooking_controller.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/themes.dart';
import 'core/utils/initial_bindings.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'PendingNotification') {
      showScheduledPendingNotification(
        'Reminder: Pending Job',
        'You have a pending job, please confirm the address.',
        'pending_jobs',
      );
    } else if (task == 'PaymentPendingNotification') {
      showScheduledPendingNotification(
        'Payment Due',
        'Hi there! Just a quick reminder about your balance service payment, please click here when you can. Thanks!',
        'pending_payment',
      );
    }

    return Future.value(true);
  });
}

void handleNotificationClick(String? payload) {
  if (payload != null) {
    Future.delayed(Duration(seconds: 3), () {
      if (payload == 'pending_jobs') {
        Get.toNamed(
          AppRoutes.bookingListingScreen,
          arguments: {"title": MyBookingStatus.pending.name},
        );
      } else if (payload == 'pending_payment') {
        Get.toNamed(
          AppRoutes.bookingListingScreen,
          arguments: {"title": MyBookingStatus.completed.name},
        );
      }
    });
  }
}

Future<void> showScheduledPendingNotification(
  String title,
  String message,
  String payload,
) async {
  try {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'scheduled_pending',
      'Schedule Notification',
      priority: Priority.high,
      importance: Importance.max,
      enableLights: true,
      enableVibration: true,
      playSound: true,
      icon: '@drawable/ic_notification',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      payload == 'pending_jobs' ? 303 : 304,
      title,
      message,
      platformChannelSpecifics,
      payload: payload,
    );
  } catch (e) {
    debugPrint('Failed to show scheduled pending notification: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    // set observer
    FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);
  } catch (e) {
    debugPrint("Failed to initialize Firebase: $e");
  }

  final appModule = AppModule();
  await appModule.init();

  await initNotificationSection();

  runApp(const MyApp());
}

Future<void> initNotificationSection() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/ic_notification');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {
      if (notificationResponse.payload != null) {
        if (notificationResponse.payload == 'pending_jobs') {
          Get.toNamed(AppRoutes.bookingListingScreen,
              arguments: {"title": MyBookingStatus.pending.name});
        } else if (notificationResponse.payload == 'pending_payment') {
          Get.toNamed(AppRoutes.bookingListingScreen,
              arguments: {"title": MyBookingStatus.completed.name});
        }
      }
    },
  );

  // Check if the app was opened from a notification when killed
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    final String? payload =
        notificationAppLaunchDetails?.notificationResponse?.payload;
    if (payload != null) {
      Future.delayed(Duration(seconds: 5), () {
        handleNotificationClick(payload);
      });
    }
  }

  // Initialize WorkManager
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemesData.theme,
      darkTheme: ThemesData.theme,
      title: 'Nook & Corner',
      translations: AppLocalization(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      initialBinding: InitialBindings(),
      initialRoute: AppRoutes.initialRoute,
      getPages: AppRoutes.pages,
    );
  }
}
