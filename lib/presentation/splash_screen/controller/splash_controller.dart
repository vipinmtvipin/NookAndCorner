import 'dart:async';

import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/presentation/base_controller.dart';
import 'package:get/get.dart';

class SplashController extends BaseController {
  @override
  void onReady() {
    super.onReady();

    Future.delayed(const Duration(milliseconds: 3000), () {
      Get.offAllNamed(
        AppRoutes.loginScreen,
      );
    });
  }
}
