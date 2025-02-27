import 'package:customerapp/presentation/account_screen/account_screen.dart';
import 'package:customerapp/presentation/account_screen/binding/account_binding.dart';
import 'package:customerapp/presentation/account_screen/edit_account_screen.dart';
import 'package:customerapp/presentation/account_screen/verify_account/verify_account_screen.dart';
import 'package:customerapp/presentation/address_screen/add_address_screen.dart';
import 'package:customerapp/presentation/address_screen/address_screen.dart';
import 'package:customerapp/presentation/address_screen/binding/address_binding.dart';
import 'package:customerapp/presentation/chat/chat_screen.dart';
import 'package:customerapp/presentation/chat/full_image_view.dart';
import 'package:customerapp/presentation/chat/preview_screen.dart';
import 'package:customerapp/presentation/chat/preview_url_screen.dart';
import 'package:customerapp/presentation/chat/video_player.dart';
import 'package:customerapp/presentation/forget_password_screen/forget_password_screen.dart';
import 'package:customerapp/presentation/main_screen/binding/main_binding.dart';
import 'package:customerapp/presentation/main_screen/main_screen.dart';
import 'package:customerapp/presentation/my_job_screen/binding/mybooking_binding.dart';
import 'package:customerapp/presentation/my_job_screen/booking_details_screen.dart';
import 'package:customerapp/presentation/my_job_screen/booking_list_screen.dart';
import 'package:customerapp/presentation/my_job_screen/mybooking_screen.dart';
import 'package:customerapp/presentation/payment_section_screens/confirm_address_screen.dart';
import 'package:customerapp/presentation/payment_section_screens/payment_screen.dart';
import 'package:customerapp/presentation/payment_section_screens/payment_status_screen.dart';
import 'package:customerapp/presentation/services_screen/binding/service_binding.dart';
import 'package:customerapp/presentation/services_screen/service_screen.dart';
import 'package:customerapp/presentation/settings_screen/binding/settings_binding.dart';
import 'package:customerapp/presentation/settings_screen/contact_screen.dart';
import 'package:customerapp/presentation/settings_screen/reviews_screen.dart';
import 'package:customerapp/presentation/settings_screen/settings_screen.dart';
import 'package:customerapp/presentation/signup_screen/signup_screen.dart';
import 'package:customerapp/presentation/summery_screen/summery_screen.dart';
import 'package:customerapp/presentation/web_uri_screen/web_screen.dart';
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
  static const String verifyAccountScreen = '/verify-account-screen';
  static const String settingsScreen = '/settings-screen';
  static const String serviceScreen = '/service-screen';
  static const String summeryScreen = '/summery-screen';
  static const String addressScreen = '/address-screen';
  static const String addAddressScreen = '/add-address-screen';
  static const String confirmAddressScreen = '/confirm-address-screen';
  static const String webScreen = '/web-screen';
  static const String myBookingScreen = '/my-booking-screen';
  static const String reviewScreen = '/review-screen';
  static const String contactScreen = '/contact-screen';
  static const String editAccountScreen = '/edit-account-screen';
  static const String bookingListingScreen = '/booking-listing-screen';
  static const String bookingDetailsScreen = '/booking-details-screen';
  static const String paymentStatusScreen = '/payment-status-screen';
  static const String paymentScreen = '/payment-screen';
  static const String chatScreen = '/chat-screen';
  static const String fullScreenImageView = '/full-screen-image-view';
  static const String videoPlayerScreen = '/video-player-screen';

  static const String chatPreviewScreen = '/chat-preview-screen';
  static const String chatPreviewUrlScreen = '/chat-preview-url-screen';

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
      name: verifyAccountScreen,
      page: () => const VerifyAccountScreen(),
      bindings: [],
    ),
    GetPage(
      name: editAccountScreen,
      page: () => const EditAccountScreen(),
    ),
    GetPage(
      name: settingsScreen,
      page: () => const SettingsScreen(),
    ),
    GetPage(
      name: serviceScreen,
      page: () => const ServiceScreen(),
      bindings: [
        ServiceBinding(),
      ],
    ),
    GetPage(
      name: summeryScreen,
      page: () => const SummeryScreen(),
    ),
    GetPage(
      name: paymentStatusScreen,
      page: () => const PaymentStatusScreen(),
      bindings: [
        AddressBinding(),
      ],
    ),
    GetPage(
      name: paymentScreen,
      page: () => const PaymentScreen(),
      bindings: [],
    ),
    GetPage(
      name: addressScreen,
      page: () => const AddressScreen(),
      bindings: [
        AddressBinding(),
      ],
    ),
    GetPage(
      name: addAddressScreen,
      page: () => const AddAddressScreen(),
      bindings: [
        AddressBinding(),
      ],
    ),
    GetPage(
      name: myBookingScreen,
      page: () => const MyBookingScreen(),
    ),
    GetPage(
      name: bookingListingScreen,
      page: () => const BookingListingScreen(),
      bindings: [
        MyBookingBinding(),
      ],
    ),
    GetPage(
      name: bookingDetailsScreen,
      page: () => const BookingDetailsScreen(),
    ),
    GetPage(
      name: confirmAddressScreen,
      page: () => const ConfirmAddressScreen(),
      binding: AddressBinding(),
    ),
    GetPage(
      name: webScreen,
      page: () => const WebScreen(),
    ),
    GetPage(
      name: reviewScreen,
      page: () => const ReviewsScreen(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: contactScreen,
      page: () => const ContactScreen(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: chatScreen,
      page: () => const ChatScreen(),
    ),
    GetPage(
      name: fullScreenImageView,
      page: () => const FullScreenImageView(),
    ),
    GetPage(
      name: videoPlayerScreen,
      page: () => const VideoPlayerScreen(),
    ),
    GetPage(
      name: chatPreviewScreen,
      page: () => const PreviewScreen(),
    ),
    GetPage(
      name: chatPreviewUrlScreen,
      page: () => const PreviewUrlScreen(),
    ),
  ];
}
