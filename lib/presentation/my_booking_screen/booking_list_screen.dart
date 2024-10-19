import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:customerapp/presentation/my_booking_screen/controller/mybooking_controller.dart';
import 'package:customerapp/presentation/my_booking_screen/widgets/my_booking_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/size_utils.dart';

class BookingListingScreen extends GetView<MyBookingController> {
  const BookingListingScreen({super.key});

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
    return Container(
        padding: getPadding(left: 16, top: 50, right: 16),
        child: RefreshIndicator(
          color: Colors.black,
          backgroundColor: Colors.white,
          strokeWidth: 2,
          onRefresh: () {
            return Future<void>.value();
          },
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitleBarWidget(title: controller.screenTitle),
                Flexible(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return MyBookingCard(
                        label: '${index + 1}',
                        orderType: MyBookingStatus.scheduled,
                        onTap: () {},
                      );
                    },
                  ),
                ),
              ]),
        ));
  }
}
