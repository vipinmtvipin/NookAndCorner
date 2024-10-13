import 'package:customerapp/core/extensions/sheet_extension.dart';
import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/core/utils/size_utils.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:customerapp/presentation/services_screen/controller/service_controller.dart';
import 'package:customerapp/presentation/services_screen/widgets/service_booking_date_bottomsheet.dart';
import 'package:customerapp/presentation/summery_screen/force_login_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SummeryScreen extends GetView<ServiceController> {
  const SummeryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const TitleBarWidget(
                title: "Summary",
              ),
              const SizedBox(height: 25),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scheduled Service',
                        style: AppTextStyle.txtBold16.copyWith(
                          letterSpacing: getHorizontalSize(
                            3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: ResponsiveText(
                              text: controller.selectedService.value.name ?? '',
                              style: AppTextStyle.txtBold14
                                  .copyWith(color: AppColors.green[800]),
                            ),
                          ),
                          Flexible(
                            child: ResponsiveText(
                              text:
                                  ' ${controller.selectedService.value.price ?? ''} Rs',
                              style: AppTextStyle.txtBold14
                                  .copyWith(color: AppColors.green),
                            ),
                          ),
                          /*  Card(
                            elevation: 6,
                            color: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5),
                              child: Text('Remove'),
                            ),
                          ),*/
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Service Scheduled Date Section
                      Text(
                        'Service Scheduled on',
                        style: AppTextStyle.txtBold16.copyWith(
                          letterSpacing: getHorizontalSize(
                            3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Card(
                            elevation: 6,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10),
                              child: Obx(() =>
                                  Text(controller.selectedDateValue.value)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              context.showBottomSheet(
                                body: ServiceBookingDateBottomSheet(
                                  isFromSummery: true,
                                  onDateSelected: (timeSlot) {
                                    controller.selectedTime.value = timeSlot;
                                  },
                                  service: controller.selectedService.value,
                                ),
                              );
                            },
                            child: Card(
                              elevation: 1,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Colors.orange,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 6),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.orange,
                                      size: 15,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Edit Date & Time',
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      // Scheduled Slot Section
                      const SizedBox(height: 16),
                      Text(
                        'Scheduled Slot',
                        style: AppTextStyle.txtBold16.copyWith(
                          letterSpacing: getHorizontalSize(
                            3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Card(
                        elevation: 6,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: Obx(
                            () => Text(controller.selectedTime.value),
                          ),
                        ),
                      ),

                      // Add-on Services Section
                      const SizedBox(height: 20),
                      const Divider(
                        height: 1,
                        color: Colors.black26,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Add-on Services',
                        style: AppTextStyle.txtBold16.copyWith(
                          letterSpacing: getHorizontalSize(
                            3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: const [
                            AddOnServiceItem(),
                            AddOnServiceItem(),
                            AddOnServiceItem(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Promo Code Section
                      Card(
                        elevation: 6,
                        color: Colors.grey[200],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Promo Code',
                                style: AppTextStyle.txtBold16.copyWith(
                                  letterSpacing: getHorizontalSize(
                                    3,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintStyle: const TextStyle(
                                            color: AppColors.darkGray),
                                        hintText: "Enter promo code",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: const BorderSide(
                                            color: AppColors.black,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.couponApplied.value = true;
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6.0, right: 6),
                                      child: Obx(
                                        () => Text(
                                            controller.couponApplied.value
                                                ? 'Remove '
                                                : 'Apply'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Enter your promo code to receive a discount on your purchase.',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Payment Summary Section
                      Text(
                        'Payment Summary',
                        style: AppTextStyle.txtBold16.copyWith(
                          letterSpacing: getHorizontalSize(
                            3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const PaymentSummaryRow(
                          title: 'Service total', value: '6000/-'),
                      const PaymentSummaryRow(
                        title: 'Convenience Fee',
                        value: '0/-',
                        hasInfoIcon: true,
                      ),
                      PaymentSummaryRow(
                          title: 'Coupon Discount',
                          value: controller.couponApplied.value
                              ? '0/-'
                              : 'NOT APPLIED'),
                      const SizedBox(height: 16),

                      const Divider(
                        height: 0.2,
                        color: Colors.black26,
                      ),
                      const SizedBox(height: 16),
                      const PaymentSummaryRow(
                        title: 'Grand Total',
                        value: '6000/-',
                        isBold: true,
                      ),
                      const SizedBox(height: 8),
                      const PaymentSummaryRow(
                        title: 'Amount Payable in Advance',
                        value: '600/-',
                        isBold: true,
                        valueColor: AppColors.secondaryColor,
                      ),

                      const SizedBox(height: 20),
                      const Divider(
                        height: 1,
                        color: Colors.grey,
                      ),

                      // Cancellation Policy Section
                      const SizedBox(height: 20),
                      Text(
                        'Cancellation policy',
                        style: AppTextStyle.txtBold16.copyWith(
                          letterSpacing: getHorizontalSize(
                            3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Any cancellation within 24 hours incurs an 80% fee. Refunds are processed within 7 days',
                        style: AppTextStyle.txt12.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {},
                        child: const Text('Know more',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: bottomSectionUI(context),
      ),
    );
  }

  Widget bottomSectionUI(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      height: 130,
      child: Column(
        children: [
          Row(
            children: [
              Obx(
                () => Checkbox(
                    value: controller.termsAndConditionApply.value,
                    onChanged: (value) {
                      controller.termsAndConditionApply.value = value ?? false;
                    }),
              ),
              const ResponsiveText(
                text: 'I agree to the ',
                maxLines: 1,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: const ResponsiveText(
                    maxLines: 1,
                    text: 'Privacy Policy And Terms & Conditions',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          NookCornerButton(
              text: 'Proceed with Advance Payment',
              onPressed: () {
                if (controller.isLogin) {
                  //    Get.toNamed('/payment');
                } else {
                  context.showBottomSheet(
                    body: ForceLoginBottomSheet(
                      onloggedIn: (login) {},
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}

class AddOnServiceItem extends StatelessWidget {
  const AddOnServiceItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: Colors.white,
      child: SizedBox(
        width: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 40),
            const SizedBox(height: 8),
            ResponsiveText(text: 'Test 1', style: AppTextStyle.txt12),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                textStyle: AppTextStyle.txt12,
              ),
              child: const ResponsiveText(text: 'Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentSummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool hasInfoIcon;
  final bool isBold;
  final Color? valueColor;

  const PaymentSummaryRow({
    super.key,
    required this.title,
    required this.value,
    this.hasInfoIcon = false,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: valueColor ?? Colors.black,
                  fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              if (hasInfoIcon)
                const Row(
                  children: [
                    SizedBox(width: 5),
                    Icon(
                      Icons.info,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
