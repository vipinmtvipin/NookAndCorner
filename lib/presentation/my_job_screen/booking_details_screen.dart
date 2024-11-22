import 'package:customerapp/core/extensions/date_time_extensions.dart';
import 'package:customerapp/core/extensions/list_extensions.dart';
import 'package:customerapp/core/extensions/sheet_extension.dart';
import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/domain/model/my_jobs/my_job_responds.dart';
import 'package:customerapp/presentation/common_widgets/conditional_widget.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:customerapp/presentation/my_job_screen/controller/mybooking_controller.dart';
import 'package:customerapp/presentation/my_job_screen/widgets/my_booking_card.dart';
import 'package:customerapp/presentation/my_job_screen/widgets/reschedule_booking_date_bottomsheet.dart';
import 'package:customerapp/presentation/summery_screen/summery_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/size_utils.dart';

class BookingDetailsScreen extends GetView<MyBookingController> {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var selectedJob = controller.selectedJob.value;
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: PopScope(
          canPop: true,
          onPopInvokedWithResult: (_, __) {
            clearAllControllerData();
          },
          child: Container(
              padding: getPadding(left: 16, top: 50, right: 16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TitleBarWidget(
                      title: 'Booking Details',
                      onBack: () {
                        clearAllControllerData();
                      },
                    ),
                    SizedBox(height: 30),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Job ID:  ${selectedJob.jobId}",
                                    style: AppTextStyle.txtBold14.copyWith(
                                        color: AppColors.secondaryColor)),
                                Card(
                                  elevation: 6,
                                  color: controller.screenType ==
                                          MyBookingStatus.cancelled
                                      ? Colors.red[300]
                                      : controller.screenType ==
                                              MyBookingStatus.completed
                                          ? Colors.green[300]
                                          : controller.screenType ==
                                                  MyBookingStatus.pending
                                              ? Colors.blue[300]
                                              : AppColors.gray,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 3),
                                    child: Text(
                                      selectedJob.status.toCapitalized ?? '',
                                      style: AppTextStyle.txt10
                                          .copyWith(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ResponsiveText(
                                text: selectedJob.servicePrice?.service?.name ??
                                    '',
                                style: AppTextStyle.txt14),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: ResponsiveText(
                                      text:
                                          "Main Service : ${selectedJob.servicePrice?.service?.category?.name ?? ''}",
                                      style: AppTextStyle.txt14
                                          .copyWith(color: AppColors.gray)),
                                ),
                                const SizedBox(width: 10),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.payment_rounded,
                                      size: 18,
                                      color: AppColors.secondaryColor,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                        "${selectedJob.servicePrice?.service?.price ?? ''} Rs",
                                        style: AppTextStyle.txt14.copyWith(
                                            color: AppColors.secondaryColor)),
                                  ],
                                ),
                              ],
                            ),
                            Visibility(
                              visible: controller.screenType ==
                                      MyBookingStatus.scheduled ||
                                  controller.screenType ==
                                      MyBookingStatus.pending,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Card(
                                  elevation: 2,
                                  color: AppColors.whiteGray,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: ResponsiveText(
                                              text: controller.screenType ==
                                                      MyBookingStatus.pending
                                                  ? "Confirm your address"
                                                  : selectedJob.status ==
                                                          'started'
                                                      ? "OTP to complete the service"
                                                      : "OTP to start the service",
                                              style: AppTextStyle.txt16
                                                  .copyWith(
                                                      color: controller
                                                                  .screenType ==
                                                              MyBookingStatus
                                                                  .pending
                                                          ? AppColors.red
                                                          : AppColors.black)),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            if (controller.screenType ==
                                                MyBookingStatus.pending) {
                                              await Get.toNamed(
                                                  AppRoutes
                                                      .confirmAddressScreen,
                                                  arguments: {
                                                    'jobId': controller
                                                        .selectedJob.value.jobId
                                                        .toString(),
                                                    'from': 'MyBooking'
                                                  });
                                              Get.back(result: true);
                                            }
                                          },
                                          child: Card(
                                            color: AppColors.white,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 5),
                                              child: Text(
                                                  controller.screenType ==
                                                          MyBookingStatus
                                                              .pending
                                                      ? 'Confirm'
                                                      : selectedJob.status ==
                                                              'started'
                                                          ? selectedJob.otp ??
                                                              ''
                                                          : selectedJob
                                                                  .startOtp ??
                                                              '',
                                                  style: AppTextStyle.txt14
                                                      .copyWith(
                                                          color: AppColors
                                                              .success)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: controller.screenType ==
                                              MyBookingStatus.scheduled ||
                                          controller.screenType ==
                                              MyBookingStatus.pending
                                      ? 20
                                      : 10.0),
                              child: Text(
                                "Booked On",
                                style: AppTextStyle.txtBold14.copyWith(
                                  letterSpacing: getHorizontalSize(
                                    3,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    horizontalTitleGap: 0,
                                    title: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 5),
                                        Text("Date",
                                            style: AppTextStyle.txt12.copyWith(
                                                color: AppColors.gray)),
                                      ],
                                    ),
                                    subtitle: Text(
                                        selectedJob.jobDate.convertUtcToIst(),
                                        style: AppTextStyle.txt14),
                                  ),
                                ),
                                Visibility(
                                  visible: controller.screenType ==
                                          MyBookingStatus.scheduled ||
                                      controller.screenType ==
                                          MyBookingStatus.pending,
                                  child: GestureDetector(
                                    onTap: () {
                                      context.showBottomSheet(
                                        body: RescheduleBookingDateBottomSheet(
                                          onDateSelected: (timeSlot) {
                                            controller.selectedTime.value =
                                                timeSlot;
                                          },
                                          service: controller.selectedJob.value,
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 10),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.date_range_outlined,
                                              color: Colors.orange,
                                              size: 15,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              'Reschedule',
                                              style: TextStyle(
                                                  color: Colors.orange),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Visibility(
                              visible: selectedJob.orders.isNotNullOrEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Added Services",
                                      style: AppTextStyle.txtBold14.copyWith(
                                        letterSpacing: getHorizontalSize(
                                          3,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    ListView.builder(
                                        padding: EdgeInsets.zero,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: selectedJob.orders.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final addon =
                                              selectedJob.orders[index];
                                          return AddOnServiceSeverItem(
                                            addon: addon,
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Obx(
                              () => Visibility(
                                visible:
                                    controller.addOns.value.isNotNullOrEmpty,
                                child: Card(
                                  elevation: 6,
                                  color: AppColors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Additional Services',
                                          style:
                                              AppTextStyle.txtBold14.copyWith(
                                            letterSpacing: getHorizontalSize(
                                              3,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          height: 0.5,
                                          color: AppColors.tinyGray,
                                        ),
                                        ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                                controller.addOns.value.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final addon = controller
                                                  .addOns.value[index];
                                              return AddOnItem(
                                                from: 'Booking',
                                                addon: addon,
                                              );
                                            }),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Center(
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            'Payment Summary',
                                            style:
                                                AppTextStyle.txtBold12.copyWith(
                                              letterSpacing: getHorizontalSize(
                                                3,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          height: 0.5,
                                          color: AppColors.tinyGray,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        PaymentSummaryRow(
                                            title: 'Service total',
                                            value: controller.addOnsTotal.value
                                                .toString()),
                                        PaymentSummaryRow(
                                          title: 'Convenience Fee',
                                          value: controller.convenienceFee.value
                                              .toString(),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          height: 0.5,
                                          color: AppColors.tinyGray,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        PaymentSummaryRow(
                                          title: 'Grand Total',
                                          value: controller.grandTotal.value
                                              .toString(),
                                          hasInfoIcon: true,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5.0),
                                                child: BookingButton(
                                                  text: 'Cancel',
                                                  onTap: () {
                                                    controller.addOns.value =
                                                        [];
                                                  },
                                                  color: AppColors.primaryColor,
                                                  icon: Icons.cancel_outlined,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: BookingButton(
                                                  text: 'Add to Booking',
                                                  onTap: () {
                                                    controller.updateAddOn();
                                                  },
                                                  color: AppColors.primaryColor,
                                                  icon: Icons.save_outlined,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Obx(() => Visibility(
                                  visible: controller
                                          .addOnList.value.isNotNullOrEmpty &&
                                      (controller.screenType !=
                                              MyBookingStatus.cancelled &&
                                          controller.screenType !=
                                              MyBookingStatus.completed),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, bottom: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Add-on Services',
                                          style:
                                              AppTextStyle.txtBold16.copyWith(
                                            letterSpacing: getHorizontalSize(
                                              3,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          height: 150,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemCount: controller
                                                  .addOnList.value.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final addon = controller
                                                    .addOnList.value[index];
                                                return AddOnServiceItem(
                                                  from: 'Booking',
                                                  addon: addon,
                                                );
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                            ConditionalWidget(
                                condition: controller.screenType ==
                                    MyBookingStatus.cancelled,
                                onFalse: SizedBox.shrink(),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: ListTile(
                                            title: Text(
                                              'Refund Status',
                                              style: AppTextStyle.txtBold14
                                                  .copyWith(),
                                            ),
                                            subtitle: Text(
                                              selectedJob.refundStatus
                                                      .toCapitalized ??
                                                  '',
                                              style:
                                                  AppTextStyle.txt14.copyWith(),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: ListTile(
                                            title: Text(
                                              'Refund Amount',
                                              style: AppTextStyle.txtBold14
                                                  .copyWith(),
                                            ),
                                            subtitle: Text(
                                              'Rs ${selectedJob.refundAmount.toString()} /-',
                                              style:
                                                  AppTextStyle.txt14.copyWith(),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Cancelled Date',
                                        style:
                                            AppTextStyle.txtBold14.copyWith(),
                                      ),
                                      subtitle: Text(
                                        selectedJob.cancelledAt
                                            .convertUtcToIst(),
                                        style: AppTextStyle.txt14.copyWith(),
                                      ),
                                    ),
                                  ],
                                )),
                            Visibility(
                              visible: (controller.screenType ==
                                      MyBookingStatus.completed &&
                                  selectedJob.paymentStatus == 'completed' &&
                                  (selectedJob.rating?.comment != null &&
                                      selectedJob.rating?.comment != '')),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  'Your comment',
                                  style: AppTextStyle.txtBold14.copyWith(),
                                ),
                                subtitle: Text(
                                  selectedJob.rating?.comment ?? '',
                                  style: AppTextStyle.txt14.copyWith(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Card(
                                elevation: 6,
                                color: AppColors.white,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: const Border(
                                      top: BorderSide(
                                        color: AppColors
                                            .success, // Set the color of the border
                                        width:
                                            2.0, // Set the width of the border
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        PaymentSummaryRow(
                                            title: 'Booking  Amount',
                                            value:
                                                selectedJob.price.toString() ??
                                                    ''),
                                        PaymentSummaryRow(
                                            title: 'Advance Amount',
                                            value: selectedJob.advanceAmount
                                                    .toString() ??
                                                ''),
                                        Visibility(
                                          visible: controller.screenType !=
                                              MyBookingStatus.cancelled,
                                          child: PaymentSummaryRow(
                                            title: 'Balance Payable',
                                            value:
                                                "${double.parse((selectedJob.price! - selectedJob.advanceAmount!).toStringAsFixed(2))} Rs",
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Divider(
                                            height: 0.5,
                                            color: AppColors.tinyGray,
                                          ),
                                        ),
                                        PaymentSummaryRow(
                                            title: 'Supervisor name:',
                                            value: selectedJob
                                                    .assignedUser?.username ??
                                                ''),
                                        PaymentSummaryRow(
                                            title: 'Supervisor  Mobile',
                                            value: selectedJob
                                                    .assignedUser?.phone ??
                                                ''),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                                visible: controller.screenType ==
                                        MyBookingStatus.scheduled ||
                                    controller.screenType ==
                                        MyBookingStatus.pending ||
                                    (controller.screenType ==
                                            MyBookingStatus.completed &&
                                        selectedJob.paymentStatus !=
                                            'completed'),
                                child: Column(
                                  children: [
                                    SizedBox(height: 30),
                                    NookCornerButton(
                                        text: (controller.screenType ==
                                                    MyBookingStatus.scheduled ||
                                                controller.screenType ==
                                                    MyBookingStatus.pending)
                                            ? 'Cancel Booking'
                                            : 'Pay Now',
                                        onPressed: () {
                                          if (controller.screenType ==
                                                  MyBookingStatus.scheduled ||
                                              controller.screenType ==
                                                  MyBookingStatus.pending) {
                                            controller.cancelJob();
                                          } else if (controller.screenType ==
                                                  MyBookingStatus.completed &&
                                              controller.selectedJob.value
                                                      .paymentStatus !=
                                                  'completed') {
                                            controller.completeJob('details');
                                          } else {
                                            Get.back();
                                          }
                                        }),
                                  ],
                                )),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ])),
        ),
      ),
    );
  }

  void clearAllControllerData() {
    controller.addOns.value = [];
    controller.addOnsTotal.value = 0;
    controller.grandTotal.value = 0;
    controller.goldenHourAmount.value = 0;
  }
}

class AddOnServiceSeverItem extends StatelessWidget {
  final Order addon;
  const AddOnServiceSeverItem({super.key, required this.addon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Row(
              children: [
                Icon(
                  Icons.add_home,
                  color: Colors.grey,
                  size: 18,
                ),
                SizedBox(width: 5),
                ResponsiveText(
                  text: '${addon.addon?.titile ?? ' '} (${addon.quantity})',
                  style: AppTextStyle.txt12,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Flexible(
            child: ResponsiveText(
              maxLines: 1,
              text:
                  "Rs ${double.parse(addon.addonPrice!.toStringAsFixed(2))} /-",
              style: AppTextStyle.txt12,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
