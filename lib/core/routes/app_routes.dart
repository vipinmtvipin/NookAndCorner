import 'package:customerapp/presentation/main_screen/binding/main_binding.dart';
import 'package:customerapp/presentation/main_screen/main_screen.dart';
import 'package:customerapp/presentation/otp_screen/binding/otp_binding.dart';
import 'package:customerapp/presentation/otp_screen/otp_screen.dart';
import 'package:get/get.dart';

import '../../presentation/login_screen/binding/auth_binding.dart';
import '../../presentation/login_screen/login_screen.dart';
import '../../presentation/splash_screen/binding/splash_binding.dart';
import '../../presentation/splash_screen/splash_screen.dart';

class AppRoutes {
  static const String initialRoute = '/initialRoute';
  static const String loginScreen = '/login_screen';
  static const String otpScreen = '/otp_screen';
  static const String changeScreen = '/change_password_screen';
  static const String mainScreen = '/main-screen';
  static const String forgotPasswordScreen = '/forgot_password_screen';

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
      name: otpScreen,
      page: () => const OTPScreen(),
      bindings: [
        OTPBinding(),
      ],
    ),
    GetPage(
      name: mainScreen,
      page: () => const MainScreen(),
      bindings: [
        MainScreenBinding(),
      ],
    ),
  ];
}
