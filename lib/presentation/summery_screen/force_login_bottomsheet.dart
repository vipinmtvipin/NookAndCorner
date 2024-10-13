import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/presentation/common_widgets/network_image_view.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_text_field.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:customerapp/presentation/services_screen/controller/service_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForceLoginBottomSheet extends GetView<ServiceController> {
  final Function(bool) onloggedIn;

  const ForceLoginBottomSheet({
    super.key,
    required this.onloggedIn,
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
            textInputAction: TextInputAction.done,
            //  controller: controller.phoneController,
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
            // controller: controller.emailController,
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
            onPressed: () {},
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

class CityCard extends StatelessWidget {
  final String? image;
  final String? label;

  const CityCard({super.key, required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NetworkImageView(
              url: image,
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            Text(
              label ?? '',
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.txt12,
            ),
          ],
        ),
      ),
    );
  }
}
