import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/my_job_screen/controller/mybooking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplyCouponBottomSheet extends StatelessWidget {
  final String from;
  const ApplyCouponBottomSheet({
    super.key,
    required this.from,
  });

  @override
  Widget build(BuildContext context) {
    var comment = '';
    final controller = Get.find<MyBookingController>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Apply Coupon',
            textAlign: TextAlign.center,
            style: AppTextStyle.txtBold18,
          ),
          const SizedBox(height: 20),
          const Text(
            'Enter your promo code to receive a discount on your purchase.',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: controller.promoCodeController,
            decoration: InputDecoration(
              hintStyle: const TextStyle(color: AppColors.darkGray),
              hintText: "Enter promo code",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: AppColors.black,
                  width: 2.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: NookCornerButton(
                  outlinedColor: AppColors.primaryColor,
                  textStyle: AppTextStyle.txtBoldWhite14,
                  text: 'Apply',
                  backGroundColor: AppColors.primaryColor,
                  onPressed: () {
                    if (controller.promoCodeController.text.isEmpty) {
                      'Please enter promo code'.showToast();
                    } else {
                      Get.back();
                      controller.applyCoupon(
                          controller.promoCodeController.text, from);
                    }
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: NookCornerButton(
                  type: NookCornerButtonType.outlined,
                  outlinedColor: AppColors.primaryColor,
                  textStyle: AppTextStyle.txtBoldWhite14,
                  text: 'Skip to pay',
                  onPressed: () {
                    Get.back();
                    controller.completeJob(from);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
