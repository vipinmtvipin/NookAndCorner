import 'package:customerapp/core/extensions/list_extensions.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/presentation/common_widgets/conditional_widget.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:customerapp/presentation/main_screen/main_screen.dart';
import 'package:customerapp/presentation/my_job_screen/controller/mybooking_controller.dart';
import 'package:customerapp/presentation/my_job_screen/widgets/my_booking_card.dart';
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
            controller.getJobs();
            return Future<void>.value();
          },
          child: Obx(
            () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TitleBarWidget(title: controller.screenTitle.value),
                  Flexible(
                    child: ConditionalWidget(
                      condition: controller.jobList.value.isNotNullOrEmpty,
                      onFalse: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.only(top: Get.height * 0.25),
                          child: NotDataFound(
                            message: "No Services yet, be the first to book.",
                            size: 150,
                            style: AppTextStyle.txtBold16,
                          ),
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: controller.jobList.value.length,
                        itemBuilder: (context, index) {
                          var job = controller.jobList.value[index];
                          return MyBookingCard(
                            item: job,
                            orderType: controller.screenType,
                            onTap: () {
                              controller.selectedJob.value = job;
                              if ((controller.screenType !=
                                      MyBookingStatus.completed ||
                                  job.paymentStatus != 'completed')) {
                                controller.getBasicInfo();
                              }
                              navigateAndFetchJobs();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ]),
          ),
        ));
  }

  void navigateAndFetchJobs() async {
    var result = await Get.toNamed(AppRoutes.bookingDetailsScreen);
    controller.jobApiStarted = true;
    controller.getJobs();
  }
}
