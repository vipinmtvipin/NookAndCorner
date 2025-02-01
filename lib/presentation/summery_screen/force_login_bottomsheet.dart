import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/presentation/common_widgets/conditional_widget.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_text_field.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:customerapp/presentation/services_screen/controller/service_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForceLoginBottomSheet extends GetView<ServiceController> {
  final Function(bool) onLoggedIn;
  final String from;
  const ForceLoginBottomSheet({
    super.key,
    required this.onLoggedIn,
    this.from = 'force-login',
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
            text: from == 'forceLogin'
                ? 'Hi, Let us know who you are'
                : 'Hi, Please update your details',
            textAlign: TextAlign.center,
            style: AppTextStyle.txtBold18,
          ),
          const SizedBox(height: 30),
          ConditionalWidget(
            condition: (from == 'forceLogin' || from == 'mobile'),
            onFalse: SizedBox.shrink(),
            childrenType: ConditionalChildrenType.column,
            children: [
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
                onChanged: (value) {
                  controller.updateMobile = value.trim();
                },
                autoValidate: true,
              ),
              const SizedBox(height: 10),
            ],
          ),
          ConditionalWidget(
            condition: (from == 'forceLogin' || from == 'email'),
            onFalse: SizedBox.shrink(),
            childrenType: ConditionalChildrenType.column,
            children: [
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
                onChanged: (value) {
                  controller.updateEmail = value.trim();
                },
                autoValidate: true,
              ),
              const SizedBox(height: 10),
            ],
          ),
          NookCornerButton(
            height: 55,
            outlinedColor: AppColors.primaryColor,
            textStyle: AppTextStyle.txtBoldWhite14,
            text: 'Continue',
            backGroundColor: AppColors.primaryColor,
            onPressed: () {
              if (from == 'forceLogin') {
                if (controller.onPhoneChanged()) {
                  controller.showToast('Please enter valid phone number');
                  return;
                } else if (!controller.onEmailChanged()) {
                  controller.showToast('Please enter valid email address');
                  return;
                }
              } else if (from == 'forceLogin' || from == 'mobile') {
                if (controller.onPhoneChanged()) {
                  controller.showToast('Please enter valid phone number');
                  return;
                }
              } else if (from == 'forceLogin' || from == 'email') {
                if (!controller.onEmailChanged()) {
                  controller.showToast('Please enter valid email address');
                  return;
                }
              }

              onLoggedIn(true);
            },
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
