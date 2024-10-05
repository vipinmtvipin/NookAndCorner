import 'package:customerapp/presentation/account_screen/account_screen.dart';
import 'package:customerapp/presentation/account_screen/binding/account_binding.dart';
import 'package:customerapp/presentation/forget_password_screen/forget_password_screen.dart';
import 'package:customerapp/presentation/main_screen/binding/main_binding.dart';
import 'package:customerapp/presentation/main_screen/main_screen.dart';
import 'package:customerapp/presentation/settings_screen/binding/settings_binding.dart';
import 'package:customerapp/presentation/settings_screen/settings_screen.dart';
import 'package:customerapp/presentation/signup_screen/signup_screen.dart';
import 'package:get/get.dart';

import '../../presentation/login_screen/binding/auth_binding.dart';
import '../../presentation/login_screen/login_screen.dart';
import '../../presentation/splash_screen/binding/splash_binding.dart';
import '../../presentation/splash_screen/splash_screen.dart';

class AppRoutes {
  static const String initialRoute = '/initialRoute';
  static const String loginScreen = '/login_screen';
  static const String signupScreen = '/signup_screen';
  static const String mainScreen = '/main-screen';
  static const String forgotPasswordScreen = '/forgot_password_screen';
  static const String accountScreen = '/account-screen';
  static const String settingsScreen = '/settings-screen';

  static List<GetPage> pages = [
    GetPage(
      name: initialRoute,
      page: () => const SplashScreen(),
      bindings: [
        SplashBinding(),
      ],
    ),
    GetPage(
      name: loginScreen,
      page: () => const LoginScreen(),
      bindings: [
        AuthBinding(),
      ],
    ),
    GetPage(
      name: signupScreen,
      page: () => const SignupScreen(),
      bindings: [
        AuthBinding(),
      ],
    ),
    GetPage(
      name: forgotPasswordScreen,
      page: () => const ForgetPasswordScreen(),
      bindings: [
        AuthBinding(),
      ],
    ),
    GetPage(
      name: mainScreen,
      page: () => const MainScreen(),
      bindings: [
        MainScreenBinding(),
      ],
    ),
    GetPage(
      name: accountScreen,
      page: () => const AccountScreen(),
      bindings: [
        AccountBinding(),
      ],
    ),
    GetPage(
      name: settingsScreen,
      page: () => const SettingsScreen(),
      bindings: [
        SettingsBinding(),
      ],
    ),
  ];
}
