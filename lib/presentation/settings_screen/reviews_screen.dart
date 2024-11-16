import 'package:customerapp/core/extensions/list_extensions.dart';
import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/domain/model/settings/reviews_responds.dart';
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
    controller.getReviews();
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
                  condition: controller.reviewList.value.isNotNullOrEmpty,
                  onFalse: NotDataFound(
                    message: "No Reviews yet, be the first to review.",
                    size: 150,
                    style: AppTextStyle.txtBold16,
                  ),
                  child: ListView.builder(
                    itemCount: controller.reviewList.value.length,
                    itemBuilder: (context, index) {
                      var item = controller.reviewList.value[index];
                      return ReviewCardWidget(item: item, onTap: () {});
                    },
                  ),
                ),
              ),
            ]));
  }
}

class ReviewCardWidget extends StatelessWidget {
  final ReviewData item;
  final Function() onTap;

  const ReviewCardWidget({
    super.key,
    required this.item,
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
                          text: item.user?.username.toCapitalized ?? '',
                          style: AppTextStyle.txtBold14
                              .copyWith(color: AppColors.secondaryColor)),
                    ),
                    RatingBarIndicator(
                      rating: double.tryParse(item.rating ?? '0.0') ?? 0.0,
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
                Text(item.comment.toCapitalized,
                    style: AppTextStyle.txt14
                        .copyWith(color: AppColors.lightGray)),
              ],
            ),
          ),
        ));
  }
}
