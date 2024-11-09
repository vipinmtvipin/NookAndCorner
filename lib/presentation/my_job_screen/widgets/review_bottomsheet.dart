import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/presentation/common_widgets/network_image_view.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewBottomSheet extends StatelessWidget {
  const ReviewBottomSheet({
    super.key,
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
          Text(
            'Add your review',
            textAlign: TextAlign.center,
            style: AppTextStyle.txtBold18,
          ),
          const SizedBox(height: 20),
          NookCornerTextField(
            textInputAction: TextInputAction.done,
            maxLines: 6,
            minLines: 3,
            // controller: controller.emailController,
            hint: 'Write your review here',
            textStyle: AppTextStyle.txt14,
            type: NookCornerTextFieldType.text,
            isFormField: true,
            validator: (value) {
              return null;
            },
            autoValidate: true,
          ),
          const SizedBox(height: 10),
          NookCornerButton(
            outlinedColor: AppColors.primaryColor,
            textStyle: AppTextStyle.txtBoldWhite14,
            text: 'Save',
            backGroundColor: AppColors.primaryColor,
            onPressed: () {
              Get.back();
            },
          ),
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
