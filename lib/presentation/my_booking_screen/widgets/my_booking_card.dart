import 'package:customerapp/core/extensions/sheet_extension.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:customerapp/presentation/my_booking_screen/controller/mybooking_controller.dart';
import 'package:customerapp/presentation/my_booking_screen/widgets/review_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class MyBookingCard extends GetView<MyBookingController> {
  final String label;
  final Function() onTap;
  final MyBookingStatus orderType;

  const MyBookingCard({
    super.key,
    required this.label,
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
                      Text("Job ID: $label",
                          style: AppTextStyle.txtBold14
                              .copyWith(color: AppColors.secondaryColor)),
                      Card(
                        elevation: 6,
                        color: Colors.green[300],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3),
                          child: Text(
                            'Status',
                            style: AppTextStyle.txt10
                                .copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text("Job Service name", style: AppTextStyle.txt14),
                  Text("Service name",
                      style:
                          AppTextStyle.txt14.copyWith(color: AppColors.gray)),
                  const SizedBox(height: 3),
                  Divider(
                    color: AppColors.gray,
                    thickness: 0.5,
                  ),
                  const SizedBox(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          subtitle:
                              Text("02/02/2024", style: AppTextStyle.txt14),
                        ),
                      ),
                      Flexible(
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
                          subtitle: Text("125 Rs",
                              style: AppTextStyle.txt14
                                  .copyWith(color: AppColors.green)),
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    title: Text("Rate the service now",
                        style:
                            AppTextStyle.txt14.copyWith(color: AppColors.gray)),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 0.5,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 25,
                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) =>
                              Icon(Icons.star, color: AppColors.secondaryColor),
                          onRatingUpdate: (rating) {
                            // trigger rating api
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            context.showBottomSheet(body: ReviewBottomSheet());
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
                  SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    color: AppColors.whiteGray,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ResponsiveText(
                                text: "OTP to start the service",
                                style: AppTextStyle.txt16
                                    .copyWith(color: AppColors.black)),
                          ),
                          Card(
                            elevation: 8,
                            color: AppColors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5),
                              child: Text("1234",
                                  style: AppTextStyle.txt14
                                      .copyWith(color: AppColors.success)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 3.0),
                          child: BookingButton(
                            text: 'Pay Now',
                            onTap: () {},
                            color: AppColors.tinyGray,
                            icon: Icons.payment,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: BookingButton(
                            text: 'View Details',
                            onTap: () {
                              Get.toNamed(AppRoutes.bookingDetailsScreen);
                            },
                            color: AppColors.tinyGray,
                            icon: Icons.grid_3x3,
                          ),
                        ),
                      ),
                    ],
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
                            onTap: () {},
                            color: AppColors.tinyGray,
                            icon: Icons.chat,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: BookingButton(
                            text: 'Confirm Address',
                            onTap: () {},
                            color: AppColors.tinyGray,
                            icon: Icons.location_on,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  BookingButton(
                    text: 'Manage Booking',
                    onTap: () {},
                    color: AppColors.tinyGray,
                    icon: Icons.manage_history_outlined,
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
  final IconData icon;

  const BookingButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
    this.icon = Icons.info,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 1.5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: Colors.black,
            ),
            SizedBox(width: 8),
            Flexible(
              child: ResponsiveText(
                text: text,
                maxLines: 1,
                style: AppTextStyle.txtBold12.copyWith(color: AppColors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
