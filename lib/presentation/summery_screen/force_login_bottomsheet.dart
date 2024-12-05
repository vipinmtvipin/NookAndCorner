import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_text_field.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:customerapp/presentation/services_screen/controller/service_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForceLoginBottomSheet extends GetView<ServiceController> {
  final Function(bool) onLoggedIn;

  const ForceLoginBottomSheet({
    super.key,
    required this.onLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ResponsiveText(
            text: 'Hi, Let us know who you are',
            textAlign: TextAlign.center,
            style: AppTextStyle.txtBold18,
          ),
          const SizedBox(height: 30),
          NookCornerTextField(
            textInputAction: TextInputAction.next,
            controller: controller.phoneController,
            textStyle: AppTextStyle.txt16,
            title: LocalizationKeys.phoneNumber.tr,
            type: NookCornerTextFieldType.mobile,
            isFormField: true,
            validator: (value) {
              return null;
            },
            autoValidate: true,
          ),
          const SizedBox(height: 5),
          NookCornerTextField(
            textInputAction: TextInputAction.done,
            controller: controller.emailController,
            title: LocalizationKeys.email.tr,
            textStyle: AppTextStyle.txt16,
            type: NookCornerTextFieldType.email,
            isFormField: true,
            validator: (value) {
              return null;
            },
            autoValidate: true,
          ),
          const SizedBox(height: 10),
          NookCornerButton(
            height: 55,
            outlinedColor: AppColors.primaryColor,
            textStyle: AppTextStyle.txtBoldWhite14,
            text: 'Continue',
            backGroundColor: AppColors.primaryColor,
            onPressed: () {
              onLoggedIn(true);
            },
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
