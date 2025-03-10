import 'package:app_settings/app_settings.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class BaseController extends GetxController {
  @protected
  final GetIt getIt = GetIt.I;

  var isLoading = false.obs;

  void showLoadingDialog() {
    Future.delayed(Duration.zero, () {
      if (!isLoading.value) {
        Get.dialog(
          progressLoader,
          barrierDismissible: false,
        );
      }
      isLoading(true);
    });
  }

  void hideLoadingDialog() {
    if (isLoading.value) {
      Get.back();
    }
    isLoading.value = false;
  }

  static final progressLoader = WillPopScope(
    // device back arrow press time did not hide the dialog
    onWillPop: () async => false,
    child: spinKitLoader,
  );

  static const spinKitLoader = Center(
    child: SpinKitFadingCube(
      color: AppColors.white,
      size: 60,
    ),
  );

  // common toast bar
  void showToast(String msg, {int? duration}) {
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: duration ?? 2);
  }

  // common snack bar
  showSnackBar(String title, String message, Color backgroundColor) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 10, left: 8, right: 8),
        padding: const EdgeInsets.all(10),
        backgroundColor: backgroundColor,
        icon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Assets.images.nookCornerRound.image(
            width: 50,
            height: 50,
          ),
        ),
        colorText: Colors.white);
  }

  void showOpenSettings() {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: Text('No Network'),
        content: Text('Please enable network to continue using the app.'),
        actions: [
          TextButton(
            onPressed: () async {
              AppSettings.openAppSettingsPanel(
                  AppSettingsPanelType.internetConnectivity);
              Get.back();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void showServerErrorAlert(Function() reTry) {
    Get.dialog(
      AlertDialog(
        title: Text('Warning'),
        content: Text('Something went wrong, Please try again.'),
        actions: [
          TextButton(
            onPressed: () async {
              reTry();
              Get.back();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
