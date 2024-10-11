import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/core/utils/size_utils.dart';
import 'package:customerapp/generated/assets.gen.dart';
import 'package:customerapp/presentation/common_widgets/custom_icon_button.dart';
import 'package:customerapp/presentation/common_widgets/custom_pin_code_text_field.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/login_screen/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../../core/utils/common_util.dart';

class OTPScreen extends GetWidget<AuthController> {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Container(
          child: otpView(),
        ),
      ),
    );
  }

  Widget otpView() {
    return GestureDetector(onTap: () {
      CommonUtil().keyboardHide(Get.context!);
    }, child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: getPadding(left: 16, top: 60, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Assets.images.nookCornerRound
                            .image(fit: BoxFit.contain, height: 50, width: 50),
                        CustomIconButton(
                          height: 30,
                          width: 30,
                          onTap: () {
                            Get.back();
                          },
                          alignment: Alignment.topLeft,
                          shape: IconButtonShape.CircleBorder35,
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: getPadding(left: 16, top: 30, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(LocalizationKeys.welcome.tr,
                            style: AppTextStyle.txtBold16),
                        const SizedBox(height: 5),
                        Text(LocalizationKeys.otpVerification.tr,
                            style: AppTextStyle.txtBold24),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 1, right: 1),
                          child: Obx(
                            () => CustomPinCodeTextField(
                              context: Get.context!,
                              textStyle: AppTextStyle.txt16,
                              controller: controller.otpController.value,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        NookCornerButton(
                            outlinedColor: Colors.black,
                            text: LocalizationKeys.login.tr,
                            textStyle: AppTextStyle.txtBoldWhite14,
                            backGroundColor: AppColors.black,
                            onPressed: onTapSignIn),
                        const SizedBox(height: 15),
                        Center(
                          child: TextButton(
                              onPressed: () {},
                              child: Text(LocalizationKeys.resendOtp.tr,
                                  style: AppTextStyle.txtBold16
                                      .copyWith(color: AppColors.black))),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        );
      },
    ));
  }

  void onTapSignIn() {
    // controller.callLogin();
    Get.toNamed(AppRoutes.mainScreen);
  }
}
