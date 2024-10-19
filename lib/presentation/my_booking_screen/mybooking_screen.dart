import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/presentation/account_screen/account_screen.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:customerapp/presentation/my_booking_screen/controller/mybooking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';

class MyBookingScreen extends GetView<MyBookingController> {
  const MyBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: mobileView(),
      ),
    );
  }

  Widget mobileView() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16, top: 60, bottom: 10),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TitleBarWidget(title: "My Booking"),
              const SizedBox(
                height: 30,
              ),
              MoveClickItemsWidget(
                  iconData: Icons.schedule_sharp,
                  label: "Scheduled Booking",
                  subTile: "Check your scheduled booking",
                  onTap: () {
                    Get.toNamed(AppRoutes.bookingListingScreen, arguments: {
                      "title": "Scheduled Booking",
                    });
                  }),
              const Divider(
                color: AppColors.lightGray,
                thickness: 0.3,
                indent: 15,
                endIndent: 25,
              ),
              MoveClickItemsWidget(
                iconData: Icons.done_outline_sharp,
                label: "Completed Booking",
                subTile: "Check your completed booking",
                onTap: () {},
              ),
              const Divider(
                color: AppColors.lightGray,
                thickness: 0.3,
                indent: 15,
                endIndent: 25,
              ),
              MoveClickItemsWidget(
                iconData: Icons.pending_actions_outlined,
                label: "Pending Booking",
                subTile: "Check your pending booking",
                onTap: () {},
              ),
              const Divider(
                color: AppColors.lightGray,
                thickness: 0.3,
                indent: 15,
                endIndent: 25,
              ),
              MoveClickItemsWidget(
                iconData: Icons.cancel_outlined,
                label: "Cancelled Booking",
                subTile: "Check your cancelled booking",
                onTap: () {},
              ),
            ]),
      ),
    );
  }
}

/// Navigates to the previous screen.
onTapArrowLeft() {
  Get.back();
}

onTapLoginNavigation() {
  Get.toNamed(
    AppRoutes.loginScreen,
  );
}
