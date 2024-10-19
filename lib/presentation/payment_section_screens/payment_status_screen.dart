import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/generated/assets.gen.dart';
import 'package:customerapp/presentation/address_screen/controller/address_controller.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:customerapp/presentation/summery_screen/summery_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../core/theme/app_text_style.dart';
import '../../core/utils/size_utils.dart';

class PaymentStatusScreen extends GetView<AddressController> {
  const PaymentStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: mobileView(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: NookCornerButton(
            backGroundColor: AppColors.success,
            text: 'Confirm Address',
            onPressed: () {
              Get.toNamed(AppRoutes.confirmAddressScreen);
            },
          ),
        ),
      ),
    );
  }

  Widget mobileView() {
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
                    Assets.lottie.paymentSuccess,
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    height: 200,
                    width: 200,
                    repeat: true,
                  ),
                  SizedBox(height: getVerticalSize(10)),
                  Text(
                    'Payment Success',
                    style: AppTextStyle.txtBold24.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                  SizedBox(height: getVerticalSize(10)),
                  Text(
                    textAlign: TextAlign.center,
                    'A confirmation email has been sent to your email address',
                    style: AppTextStyle.txt14.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ],
              )),
              // Payment Summary Section
              SizedBox(height: getVerticalSize(10)),
              Text(
                'Order Details',
                style: AppTextStyle.txtBold16.copyWith(
                  letterSpacing: getHorizontalSize(
                    3,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const PaymentSummaryRow(title: 'Name', value: 'User name'),
              const PaymentSummaryRow(
                title: 'Service Booked',
                value: 'Service Name',
                hasInfoIcon: false,
              ),
              const PaymentSummaryRow(
                  title: 'Service Date', value: '12th June 2021'),

              const PaymentSummaryRow(
                title: 'Advance Amount',
                value: '600/-',
                isBold: false,
                valueColor: AppColors.black,
              ),
              const PaymentSummaryRow(
                title: 'Status',
                value: 'Completed',
                isBold: false,
              ),
              const SizedBox(height: 5),
            ]));
  }
}

class AddressCardWidget extends StatelessWidget {
  final String label;
  final Function() onTap;

  const AddressCardWidget({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: const Border(
              left: BorderSide(
                color: Colors.green, // Set the color of the border
                width: 2.0, // Set the width of the border
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Home",
                        style: AppTextStyle.txtBold16
                            .copyWith(color: AppColors.secondaryColor)),
                    SizedBox(
                      height: 30,
                      child: Checkbox(
                        value: true,
                        onChanged: (selected) {},
                        activeColor: AppColors.primaryColor,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 2),
                Text("Flat Infos...", style: AppTextStyle.txt14),
                const SizedBox(height: 2),
                Text("Details",
                    style: AppTextStyle.txt14
                        .copyWith(color: AppColors.lightGray)),
              ],
            ),
          ),
        ));
  }
}
