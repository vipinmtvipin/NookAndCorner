import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/presentation/address_screen/controller/address_controller.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:customerapp/presentation/summery_screen/summery_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_text_style.dart';
import '../../core/utils/size_utils.dart';

class ConfirmAddressScreen extends GetView<AddressController> {
  const ConfirmAddressScreen({super.key});

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
            text: 'Confirm Address',
            onPressed: () {},
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
              const TitleBarWidget(title: "Confirm Address"),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return AddressCardWidget(
                        label: 'Address $index', onTap: () {});
                  },
                ),
              ),
              // Payment Summary Section
              const SizedBox(height: 20),
              Text(
                'Service name Here',
                style: AppTextStyle.txtBold16.copyWith(
                  letterSpacing: getHorizontalSize(
                    3,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const PaymentSummaryRow(title: 'Service total', value: '6000/-'),
              const PaymentSummaryRow(
                title: 'Convenience Fee',
                value: '0/-',
                hasInfoIcon: true,
              ),
              const PaymentSummaryRow(
                  title: 'Coupon Discount', value: 'NOT APPLIED'),
              const SizedBox(height: 8),

              const Divider(
                height: 0.2,
                color: Colors.black26,
              ),
              const SizedBox(height: 8),
              const PaymentSummaryRow(
                title: 'Grand Total',
                value: '6000/-',
                isBold: true,
              ),
              const SizedBox(height: 2),
              const PaymentSummaryRow(
                title: 'Amount Payable in Advance',
                value: '600/-',
                isBold: true,
                valueColor: AppColors.secondaryColor,
              ),
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
