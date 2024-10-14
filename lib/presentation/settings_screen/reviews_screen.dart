import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/presentation/common_widgets/conditional_widget.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:customerapp/presentation/main_screen/main_screen.dart';
import 'package:customerapp/presentation/settings_screen/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../core/theme/app_text_style.dart';
import '../../core/utils/size_utils.dart';

class ReviewsScreen extends GetView<SettingsController> {
  const ReviewsScreen({super.key});

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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TitleBarWidget(title: "Reviews"),
              Flexible(
                child: ConditionalWidget(
                  condition: false,
                  onFalse: NotDataFound(
                    message: "No Reviews yet, be the first to review.",
                    size: 150,
                    style: AppTextStyle.txtBold16,
                  ),
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return ReviewCardWidget(
                          label: 'Address $index', onTap: () {});
                    },
                  ),
                ),
              ),
            ]));
  }
}

class ReviewCardWidget extends StatelessWidget {
  final String label;
  final Function() onTap;

  const ReviewCardWidget({
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
                    Expanded(
                      child: ResponsiveText(
                          text: "User Name",
                          style: AppTextStyle.txtBold14
                              .copyWith(color: AppColors.secondaryColor)),
                    ),
                    RatingBarIndicator(
                      rating: 3.5,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      itemCount: 5,
                      itemSize: 12.0,
                      unratedColor: Colors.grey,
                      direction: Axis.horizontal,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                    "User added review details we can show here, the top items.",
                    style: AppTextStyle.txt14
                        .copyWith(color: AppColors.lightGray)),
              ],
            ),
          ),
        ));
  }
}
