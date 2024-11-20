import 'package:customerapp/core/extensions/date_time_extensions.dart';
import 'package:customerapp/core/extensions/sheet_extension.dart';
import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/domain/model/my_jobs/my_job_responds.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:customerapp/presentation/my_job_screen/controller/mybooking_controller.dart';
import 'package:customerapp/presentation/my_job_screen/widgets/review_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class MyBookingCard extends GetView<MyBookingController> {
  final MyJobData item;
  final Function() onTap;
  final MyBookingStatus orderType;

  const MyBookingCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.orderType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Card(
          elevation: 6,
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: const Border(
                top: BorderSide(
                  color: AppColors.success, // Set the color of the border
                  width: 2.0, // Set the width of the border
                ),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: ResponsiveText(
                            text: item.servicePrice?.service?.name ?? '',
                            style: AppTextStyle.txtBold14
                                .copyWith(color: AppColors.secondaryColor)),
                      ),
                      Card(
                        elevation: 6,
                        color: controller.screenType ==
                                MyBookingStatus.cancelled
                            ? Colors.red[300]
                            : controller.screenType == MyBookingStatus.completed
                                ? Colors.green[300]
                                : controller.screenType ==
                                        MyBookingStatus.pending
                                    ? Colors.blue[300]
                                    : AppColors.gray,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3),
                          child: Text(
                            item.status.toCapitalized ?? '',
                            style: AppTextStyle.txt10
                                .copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ResponsiveText(
                      text: "Booking ID: ${item.jobId}",
                      style: AppTextStyle.txt14),
                  const SizedBox(height: 5),
                  ResponsiveText(
                      text:
                          "Main Service: ${item.servicePrice?.service?.category?.name ?? ''}",
                      style: AppTextStyle.txt14
                          .copyWith(color: AppColors.darkGray)),
                  const SizedBox(height: 5),
                  Divider(
                    color: AppColors.gray,
                    thickness: 0.5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: ListTile(
                          title: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                              ),
                              const SizedBox(width: 5),
                              Text("Date",
                                  style: AppTextStyle.txt12
                                      .copyWith(color: AppColors.gray)),
                            ],
                          ),
                          subtitle: ResponsiveText(
                              maxLines: 1,
                              text: item.jobDate.convertUtcToIst(),
                              style: AppTextStyle.txt14.copyWith(
                                color: AppColors.darkGray,
                              )),
                        ),
                      ),
                      Visibility(
                        visible: (controller.screenType !=
                                MyBookingStatus.cancelled &&
                            item.paymentStatus != 'completed'),
                        child: Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: ListTile(
                            title: Row(
                              children: [
                                Icon(
                                  Icons.payment_rounded,
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                Text("Payable",
                                    style: AppTextStyle.txt12
                                        .copyWith(color: AppColors.gray)),
                              ],
                            ),
                            subtitle: ResponsiveText(
                                text:
                                    "${double.parse((item.price! - item.advanceAmount!).toStringAsFixed(2))} Rs",
                                maxLines: 1,
                                style: AppTextStyle.txt14.copyWith(
                                  color: AppColors.green,
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                  Visibility(
                    visible:
                        (controller.screenType == MyBookingStatus.completed &&
                            item.paymentStatus == 'completed'),
                    child: ListTile(
                      title: Text("Rate the service now",
                          style: AppTextStyle.txt14
                              .copyWith(color: AppColors.gray)),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RatingBar.builder(
                            initialRating: item.rating?.rating
                                        ?.trim()
                                        .isNotNullOrEmpty ??
                                    false
                                ? double.tryParse(item.rating?.rating ?? '0')!
                                : 0,
                            minRating: 0.5,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 25,
                            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => Icon(Icons.star,
                                color: AppColors.secondaryColor),
                            onRatingUpdate: (rating) {
                              controller.selectedJob.value = item;
                              controller.ratingJob(rating.toString());
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.selectedJob.value = item;
                              context.showBottomSheet(
                                  body: ReviewBottomSheet());
                            },
                            child: Text('Write a review',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.screenType == MyBookingStatus.scheduled,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Card(
                        elevation: 2,
                        color: AppColors.whiteGray,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ResponsiveText(
                                    text: item.status == 'started'
                                        ? "OTP to complete the service"
                                        : "OTP to start the service",
                                    style: AppTextStyle.txt14
                                        .copyWith(color: AppColors.black)),
                              ),
                              Card(
                                color: AppColors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5),
                                  child: Text(
                                      item.status == 'started'
                                          ? item.otp ?? ''
                                          : item.startOtp ?? '',
                                      style: AppTextStyle.txt14
                                          .copyWith(color: AppColors.success)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.screenType == MyBookingStatus.pending,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: BookingButton(
                        text: 'Confirm Address',
                        onTap: () {
                          controller.selectedJob.value = item;
                          Get.toNamed(AppRoutes.confirmAddressScreen,
                              arguments: {
                                'jobId': item.jobId.toString(),
                                'from': 'MyBooking'
                              });
                        },
                        color: AppColors.red,
                        icon: Icons.add_business,
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        (controller.screenType == MyBookingStatus.completed &&
                            item.paymentStatus != 'completed'),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: BookingButton(
                        text: 'Pay Now',
                        onTap: () {
                          controller.selectedJob.value = item;
                          controller.completeJob('list');
                        },
                        color: AppColors.skyBlue,
                        icon: Icons.add_business,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.screenType == MyBookingStatus.cancelled,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                      child: Text(
                          "Refund Status: ${item.refundStatus.toCapitalized}",
                          style: AppTextStyle.txt14.copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 3.0),
                          child: BookingButton(
                            text: 'Chat with us',
                            onTap: () {
                              controller.selectedJob.value = item;
                              Get.toNamed(AppRoutes.chatScreen);
                            },
                            color: AppColors.black,
                            icon: Icons.chat,
                            textColor: AppColors.white,
                            fillColor: AppColors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: BookingButton(
                            text: (controller.screenType ==
                                        MyBookingStatus.cancelled ||
                                    controller.screenType ==
                                        MyBookingStatus.completed)
                                ? 'View Details'
                                : 'Manage Booking',
                            onTap: () {
                              onTap.call();
                            },
                            color: AppColors.black,
                            icon: Icons.bookmark,
                            textColor: AppColors.white,
                            fillColor: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          )),
    );
  }
}

class BookingButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final Color color;
  final Color? fillColor;
  final Color? textColor;
  final IconData icon;

  const BookingButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
    this.textColor = Colors.black,
    this.fillColor = Colors.transparent,
    this.icon = Icons.info,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 0.8),
          borderRadius: BorderRadius.circular(6),
          color: fillColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: textColor,
            ),
            SizedBox(width: 5),
            Flexible(
              child: ResponsiveText(
                text: text,
                maxLines: 1,
                style: AppTextStyle.txtBold12.copyWith(color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
