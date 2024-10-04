import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/generated/assets.gen.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_text_field.dart';
import 'package:customerapp/presentation/login_screen/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/common_util.dart';
import '../../core/utils/size_utils.dart';

class ForgetPasswordScreen extends GetView<AuthController> {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Container(
          child: passwordView(),
        ),
      ),
    );
  }

  Widget passwordView() {
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
                            .image(fit: BoxFit.contain, height: 60, width: 60),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Row(
                            children: [
                              Text(LocalizationKeys.close.tr,
                                  style: AppTextStyle.txt14),
                              const SizedBox(width: 10),
                              Assets.icons.close.svg(height: 15, width: 15),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: getPadding(left: 16, top: 30, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Reset Password', style: AppTextStyle.txt16),
                        const SizedBox(height: 5),
                        Text('Please add your email',
                            style: AppTextStyle.txtBold24),
                        const SizedBox(height: 25),
                        NookCornerTextField(
                          textInputAction: TextInputAction.done,
                          controller: controller.emailController,
                          title: LocalizationKeys.email.tr,
                          textStyle: AppTextStyle.txt16,
                          type: NookCornerTextFieldType.email,
                          isFormField: true,
                          validator: (value) {
                            if (controller.onEmailChanged() == false) {
                              return null; //'Please enter valid email address';
                            }
                            return null;
                          },
                          autoValidate: true,
                        ),
                        const SizedBox(height: 20),
                        NookCornerButton(
                            outlinedColor: AppColors.primaryColor,
                            textStyle: AppTextStyle.txtBoldWhite14,
                            text: 'Send Password',
                            backGroundColor: AppColors.primaryColor,
                            onPressed: onTapSignIn),
                        const SizedBox(height: 20),
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
    controller.callForgetPassword();
  }
}
