import 'dart:async';

import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/presentation/base_controller.dart';
import 'package:flutter/material.dart';
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
      Permission.location,
    ].request();

    var isPermanentlyDenied =
        statuses.values.any((status) => status.isPermanentlyDenied);
    if (isPermanentlyDenied) {
      _showPermissionDialogWithSettings(
        'Permissions Required',
        'Please allow the required permissions to continue using the app.',
      );
    }
  }

  void _showPermissionDialogWithSettings(String title, String message) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Get.back();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
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
