import 'package:customerapp/core/extensions/sheet_extension.dart';
import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/core/utils/size_utils.dart';
import 'package:customerapp/domain/model/summery/addon_service_responds.dart';
import 'package:customerapp/presentation/common_widgets/conditional_widget.dart';
import 'package:customerapp/presentation/common_widgets/network_image_view.dart';
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
        body: PopScope(
          canPop: true,
          onPopInvokedWithResult: (_, __) {
            clearAllControllerData();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                TitleBarWidget(
                  onBack: () {
                    clearAllControllerData();
                  },
                  title: "Summary",
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Scheduled Service',
                            style: AppTextStyle.txtBold16),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: ResponsiveText(
                                text:
                                    controller.selectedService.value.name ?? '',
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
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(
                          height: 1,
                          color: AppColors.whiteGray,
                        ),
                        const SizedBox(height: 15),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Scheduled Service Details',
                                style: AppTextStyle.txtBold16),
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
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 5),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.date_range_outlined,
                                        color: Colors.orange,
                                        size: 15,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Edit',
                                        style: TextStyle(color: Colors.orange),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text('Scheduled on',
                                    style: AppTextStyle.txt12
                                        .copyWith(color: AppColors.gray)),
                                subtitle: Obx(() => Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                          controller.selectedDateValue.value,
                                          style: AppTextStyle.txt14),
                                    )),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text('Scheduled Slot',
                                    style: AppTextStyle.txt12
                                        .copyWith(color: AppColors.gray)),
                                subtitle: Obx(() => Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(controller.selectedTime.value,
                                          style: AppTextStyle.txt14),
                                    )),
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 10),

                        Card(
                          elevation: 1,
                          color: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: AppColors.lightGray,
                              width: 0.5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Service Booked',
                                    style: AppTextStyle.txtBold14.copyWith(
                                      letterSpacing: getHorizontalSize(
                                        3,
                                      ),
                                    )),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: ResponsiveText(
                                        text: controller
                                                .selectedService.value.name ??
                                            '',
                                        style: AppTextStyle.txtBold14.copyWith(
                                            color: AppColors.green[800]),
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
                                    GestureDetector(
                                      onTap: () {
                                        Get.offAndToNamed(AppRoutes.mainScreen);
                                      },
                                      child: Card(
                                        elevation: 6,
                                        color: Colors.grey[200],
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 5),
                                          child: Text('Remove'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Obx(
                                  () => controller.addOns.value.isEmpty
                                      ? SizedBox.shrink()
                                      : ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              controller.addOns.value.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final addon =
                                                controller.addOns.value[index];
                                            return AddOnItem(
                                              addon: addon,
                                            );
                                          }),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Text('Add-on Services', style: AppTextStyle.txtBold16),
                        const SizedBox(height: 20),

                        Obx(
                          () => controller.addOnList.value.isEmpty
                              ? const Text(
                                  'No Add-on services',
                                  textAlign: TextAlign.center,
                                )
                              : SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount:
                                          controller.addOnList.value.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final addon =
                                            controller.addOnList.value[index];
                                        return AddOnServiceItem(
                                          addon: addon,
                                        );
                                      }),
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
                                      2,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller:
                                            controller.promoCodeController,
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
                                        if (controller
                                            .promoCodeController.text.isEmpty) {
                                          'Please enter promo code'.showToast();
                                        } else {
                                          controller.applyCoupon(controller
                                              .promoCodeController.text);
                                        }
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

                        Text('Payment Summary', style: AppTextStyle.txtBold16),
                        const SizedBox(height: 15),
                        PaymentSummaryRow(
                          title: 'Service total',
                          value: controller.selectedService.value.price ?? '',
                        ),
                        Obx(
                          () => PaymentSummaryRow(
                            title: 'Convenience Fee',
                            value: controller.convenienceFee.value.toString(),
                            hasInfoIcon: true,
                          ),
                        ),
                        Obx(
                          () => PaymentSummaryRow(
                              title: 'Coupon Discount',
                              value: controller.couponApplied.value
                                  ? '- ${controller.couponData.value.first.discountOfferPrice}' ??
                                      '0'
                                  : 'NOT APPLIED'),
                        ),

                        Obx(
                          () => ConditionalWidget(
                              condition: controller.goldenHourAmount.value > 0,
                              onFalse: SizedBox(
                                height: 2,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 16,
                                ),
                                child: PaymentSummaryRow(
                                    title: 'Golden Hour Fee',
                                    value: controller.addOnsTotal.value
                                        .toString()),
                              )),
                        ),

                        Obx(
                          () => ConditionalWidget(
                              condition: controller.addOnsTotal.value > 0,
                              onFalse: SizedBox(
                                height: 10,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 16,
                                ),
                                child: PaymentSummaryRow(
                                    title: 'Add-On Service',
                                    value: controller.addOnsTotal.value
                                        .toString()),
                              )),
                        ),

                        const Divider(
                          height: 0.2,
                          color: Colors.black26,
                        ),
                        const SizedBox(height: 16),
                        Obx(
                          () => PaymentSummaryRow(
                            title: 'Grand Total',
                            value: controller.grandTotal.value.toString(),
                            isBold: true,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => PaymentSummaryRow(
                            title: 'Advance Amount',
                            value: controller.advanceAmount.value.toString(),
                            isBold: true,
                            valueColor: AppColors.secondaryColor,
                          ),
                        ),

                        const SizedBox(height: 20),
                        const Divider(
                          height: 0.2,
                          color: Colors.black26,
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
                          style:
                              AppTextStyle.txt12.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.webScreen, arguments: {
                              "title": "Cancellation Policy",
                              "url": "https://www.google.com"
                            });
                          },
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
                  onTap: () {
                    Get.toNamed(AppRoutes.webScreen, arguments: {
                      "title": "Privacy Policy",
                      "url": "https://www.nookandcorner.org/privacy"
                    });
                  },
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
                if (controller.termsAndConditionApply.value) {
                  if (controller.isLogin) {
                    controller.createJob();
                  } else {
                    context.showBottomSheet(
                      body: ForceLoginBottomSheet(
                        onLoggedIn: (login) {
                          controller.createJob();
                        },
                      ),
                    );
                  }
                } else {
                  'Please agree to the terms and conditions'.showToast();
                }
              }),
        ],
      ),
    );
  }

  void clearAllControllerData() {
    controller.addOns.value = [];
    controller.addOnList.value = [];
    controller.addOnsTotal.value = 0;
    controller.couponApplied.value = false;
    controller.advanceAmount.value = 0;
    controller.convenienceFee.value = 0;
    controller.grandTotal.value = 0;
    controller.goldenHourAmount.value = 0;
    controller.couponData.value = [];
    controller.promoCodeController.clear();
    controller.phoneController.clear();
    controller.emailController.clear();
  }
}

class AddOnServiceItem extends StatelessWidget {
  final AddOnData addon;
  const AddOnServiceItem({super.key, required this.addon});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ServiceController>();
    return Card(
      elevation: 6,
      color: Colors.white,
      child: SizedBox(
        width: 120,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: NetworkImageView(
                  borderRadius: 10,
                  url: addon.logo ?? '',
                  width: 60,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 5),
              ResponsiveText(
                text: addon.titile ?? '',
                style: AppTextStyle.txt12,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  controller.addAddOn(addon);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  textStyle: AppTextStyle.txt12,
                ),
                child: const ResponsiveText(text: 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddOnItem extends StatelessWidget {
  final AddOnData addon;
  const AddOnItem({super.key, required this.addon});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ServiceController>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ResponsiveText(
              text: addon.titile ?? '',
              style: AppTextStyle.txtBold12,
              textAlign: TextAlign.start,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ResponsiveText(
                text: addon.price.toString(),
                style: AppTextStyle.txt12,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                width: 40,
              ),
              GestureDetector(
                onTap: () {
                  controller.updateAddOnQuantity(addon, -1);
                },
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(5),
                    shape: BoxShape.rectangle,
                  ),
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                alignment: Alignment.center,
                width: 30,
                height: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                  border: Border.all(color: AppColors.gray),
                ),
                child: Text(
                  addon.quantity.toString(),
                  style: AppTextStyle.txt12,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  controller.updateAddOnQuantity(addon, 1);
                },
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(5),
                    shape: BoxShape.rectangle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
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
    final GlobalKey toolTipKey = GlobalKey();

    void showTooltip() {
      final dynamic tooltip = toolTipKey.currentState;
      tooltip.ensureTooltipVisible();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                ResponsiveText(
                  text: title,
                  style: TextStyle(
                    fontSize: 14,
                    color: valueColor ?? Colors.black,
                    fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                if (hasInfoIcon)
                  GestureDetector(
                    onTap: showTooltip,
                    child: Row(
                      children: [
                        SizedBox(width: 5),
                        Tooltip(
                          key: toolTipKey,
                          enableTapToDismiss: true,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          message:
                              'Includes transaction charges and service tax',
                          child: const Icon(
                            Icons.info,
                            size: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
          Expanded(
            child: ResponsiveText(
              textAlign: TextAlign.end,
              text: value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
                color: valueColor ?? Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
