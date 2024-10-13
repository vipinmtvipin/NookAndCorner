import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/core/utils/size_utils.dart';
import 'package:customerapp/presentation/common_widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TitleBarWidget extends StatelessWidget {
  final String title;
  final Function()? onBack;
  const TitleBarWidget({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomIconButton(
            height: 30,
            width: 30,
            onTap: () {
              Get.back();
              onBack?.call();
            },
            alignment: Alignment.topLeft,
            shape: IconButtonShape.CircleBorder35,
            child: const Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: AppColors.white,
              ),
            )),
        Expanded(
          child: Text(title,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyle.txtBold18.copyWith(
                  letterSpacing: getHorizontalSize(
                    5,
                  ),
                  color: AppColors.black)),
        ),
      ],
    );
  }
}
