import 'dart:async';

import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/presentation/base_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashController extends BaseController {
  final sessionStorage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    sessionStorage.write(StorageKeys.pendingJobCount, 1);
    sessionStorage.write(StorageKeys.pendingPaymentCount, 1);
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
