import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/generated/assets.gen.dart';
import 'package:customerapp/presentation/common_widgets/conditional_widget.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:customerapp/presentation/services_screen/controller/service_controller.dart';
import 'package:customerapp/presentation/summery_screen/summery_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../core/theme/app_text_style.dart';
import '../../core/utils/size_utils.dart';

class PaymentStatusScreen extends GetView<ServiceController> {
  const PaymentStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: paymentView(),
        bottomNavigationBar:
            controller.paymentStatus.value == PaymentStatus.success
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: NookCornerButton(
                      backGroundColor: AppColors.success,
                      text: 'Confirm Address',
                      onPressed: () {
                        Get.toNamed(AppRoutes.confirmAddressScreen, arguments: {
                          'jobId': controller.jobID,
                          'from': 'payment'
                        });
                      },
                    ),
                  )
                : SizedBox.shrink(),
      ),
    );
  }

  Widget paymentView() {
    return Container(
        padding: getPadding(left: 16, top: 50, right: 16),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleBarWidget(
                title: "Payment",
                onBack: () {
                  Get.offAndToNamed(AppRoutes.mainScreen);
                },
              ),
              Flexible(
                  child: Column(
                children: [
                  SizedBox(height: getVerticalSize(10)),
                  Lottie.asset(
                    controller.paymentStatus.value == PaymentStatus.success
                        ? Assets.lottie.paymentSuccess
                        : Assets.lottie.paymentFailed,
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    height: 200,
                    width: 200,
                    repeat: true,
                  ),
                  SizedBox(height: getVerticalSize(10)),
                  Text(
                    controller.paymentStatus.value == PaymentStatus.success
                        ? 'Payment Success'
                        : 'Payment Failed',
                    style: AppTextStyle.txtBold24.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                  SizedBox(height: getVerticalSize(10)),
                  Text(
                    textAlign: TextAlign.center,
                    controller.paymentStatus.value == PaymentStatus.success
                        ? 'A confirmation email has been sent to your email address'
                        : 'Payment failed, please try again',
                    style: AppTextStyle.txt14.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ],
              )),
              // Payment Summary Section
              SizedBox(height: getVerticalSize(10)),

              ConditionalWidget(
                condition:
                    controller.paymentStatus.value == PaymentStatus.success,
                onFalse: SizedBox.shrink(),
                child: Column(
                  children: [
                    Text(
                      'Order Details',
                      style: AppTextStyle.txtBold16.copyWith(
                        letterSpacing: getHorizontalSize(
                          3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    PaymentSummaryRow(
                      title: 'Service Booked',
                      value: controller.selectedService.value.name ?? '',
                      hasInfoIcon: false,
                    ),
                    PaymentSummaryRow(
                        title: 'Service Date',
                        value: controller.selectedDateValue.value),
                    PaymentSummaryRow(
                        title: 'Service Time',
                        value: controller.selectedTime.value),
                    PaymentSummaryRow(
                      title: 'Advance Amount',
                      value: controller.advanceAmount.value.toString(),
                      isBold: false,
                      valueColor: AppColors.black,
                    ),
                    PaymentSummaryRow(
                      title: 'Total Amount',
                      value: controller.grandTotal.value.toString(),
                      isBold: false,
                      valueColor: AppColors.black,
                    ),
                    PaymentSummaryRow(
                      title: 'Status',
                      value: controller.paymentStatus.value ==
                              PaymentStatus.success
                          ? 'Success'
                          : 'Failed',
                      isBold: false,
                      valueColor: controller.paymentStatus.value ==
                              PaymentStatus.success
                          ? AppColors.green
                          : AppColors.red,
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ]));
  }
}
