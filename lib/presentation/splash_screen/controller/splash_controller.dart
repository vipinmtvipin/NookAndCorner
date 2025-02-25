import 'dart:async';

import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/presentation/base_controller.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashController extends BaseController {
  @override
  void onInit() {
    super.onInit();
    _requestMultiplePermissions();
  }

  Future<void> _requestMultiplePermissions() async {
    // List of permissions to request
    final Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
    ].request();
  }

  @override
  void onReady() {
    super.onReady();

    Future.delayed(const Duration(milliseconds: 3000), () {
      Get.offAllNamed(
        AppRoutes.mainScreen,
      );
    });
  }
}
