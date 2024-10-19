import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:customerapp/presentation/my_booking_screen/controller/mybooking_controller.dart';
import 'package:customerapp/presentation/my_booking_screen/widgets/my_booking_card.dart';
import 'package:customerapp/presentation/summery_screen/summery_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/size_utils.dart';

class BookingDetailsScreen extends GetView<MyBookingController> {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Container(
            padding: getPadding(left: 16, top: 50, right: 16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TitleBarWidget(title: 'Booking Details'),
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
                              Text("Job ID: ",
                                  style: AppTextStyle.txtBold14.copyWith(
                                      color: AppColors.secondaryColor)),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Service name",
                                  style: AppTextStyle.txt14
                                      .copyWith(color: AppColors.gray)),
                              Row(
                                children: [
                                  Icon(
                                    Icons.payment_rounded,
                                    size: 18,
                                    color: AppColors.secondaryColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text("125 Rs",
                                      style: AppTextStyle.txt14.copyWith(
                                          color: AppColors.secondaryColor)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          SizedBox(height: 10),
                          Card(
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
                                          style: AppTextStyle.txt14.copyWith(
                                              color: AppColors.success)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ListTile(
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
                          SizedBox(height: 20),
                          Card(
                            elevation: 6,
                            color: AppColors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Additional Services',
                                    style: AppTextStyle.txtBold14.copyWith(
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Payment Summary',
                                      style: AppTextStyle.txtBold12.copyWith(
                                        letterSpacing: getHorizontalSize(
                                          3,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const PaymentSummaryRow(
                                      title: 'Service total', value: '6000/-'),
                                  const PaymentSummaryRow(
                                    title: 'Convenience Fee',
                                    value: '0/-',
                                    hasInfoIcon: true,
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
                                  const PaymentSummaryRow(
                                    title: 'Grand Total',
                                    value: '0/-',
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
                                          padding:
                                              const EdgeInsets.only(right: 5.0),
                                          child: BookingButton(
                                            text: 'Add to Booking',
                                            onTap: () {},
                                            color: AppColors.primaryColor,
                                            icon: Icons.save_outlined,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: BookingButton(
                                            text: 'Cancel',
                                            onTap: () {},
                                            color: AppColors.primaryColor,
                                            icon: Icons.cancel_outlined,
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
                                Text('Add-on Services'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Card(
                            elevation: 6,
                            color: AppColors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  const PaymentSummaryRow(
                                      title: 'Supervisor name:',
                                      value: 'User Demo'),
                                  const PaymentSummaryRow(
                                      title: 'Supervisor  Mobile',
                                      value: '+91 xxxxxxxxxx'),
                                  const PaymentSummaryRow(
                                      title: 'Booking  Amount',
                                      value: '5000/-'),
                                  const PaymentSummaryRow(
                                      title: 'Advance Amount', value: '400/-'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ])),
      ),
    );
  }
}
