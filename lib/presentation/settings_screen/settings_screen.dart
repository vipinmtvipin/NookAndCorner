import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:customerapp/presentation/settings_screen/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_text_style.dart';
import '../../core/utils/common_util.dart';
import '../../core/utils/size_utils.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

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
    return GestureDetector(onTap: () {
      CommonUtil().keyboardHide(Get.context!);
    }, child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Container(
                //  width: double.maxFinite,
                padding: getPadding(left: 16, top: 50, right: 16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const TitleBarWidget(title: "Settings"),
                      const SizedBox(
                        height: 30,
                      ),
                      ProfileItemsWidget(
                        iconData: Icons.info,
                        label: "About us",
                        onTap: () {
                          Get.toNamed(AppRoutes.webScreen, arguments: {
                            "title": "About us",
                            "url": "https://www.nookandcorner.org/aboutus"
                          });
                        },
                      ),
                      const Divider(
                        color: AppColors.lightGray,
                        thickness: 0.3,
                        indent: 15,
                        endIndent: 25,
                      ),
                      ProfileItemsWidget(
                        iconData: Icons.privacy_tip_sharp,
                        label: "Privacy Policy",
                        onTap: () {
                          Get.toNamed(AppRoutes.webScreen, arguments: {
                            "title": "Privacy Policy",
                            "url": "https://www.nookandcorner.org/privacy"
                          });
                        },
                      ),
                      const Divider(
                        color: AppColors.lightGray,
                        thickness: 0.3,
                        indent: 15,
                        endIndent: 25,
                      ),
                      ProfileItemsWidget(
                        iconData: Icons.contact_support,
                        label: "Contact us",
                        onTap: () {
                          Get.toNamed(AppRoutes.contactScreen);
                        },
                      ),
                      const Divider(
                        color: AppColors.lightGray,
                        thickness: 0.3,
                        indent: 15,
                        endIndent: 25,
                      ),
                      ProfileItemsWidget(
                        iconData: Icons.rate_review_sharp,
                        label: "Reviews",
                        onTap: () {
                          Get.toNamed(AppRoutes.reviewScreen);
                        },
                      ),
                    ])),
          ),
        );
      },
    ));
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

class ProfileItemsWidget extends StatelessWidget {
  final IconData iconData;
  final String label;
  final Function() onTap;

  const ProfileItemsWidget({
    super.key,
    required this.iconData,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        iconData,
        size: 20,
        color: AppColors.darkGray,
      ),
      title: Text(label,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: AppTextStyle.txtBold14.copyWith(color: AppColors.black)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 15,
        color: AppColors.darkGray,
      ),
    );
  }
}
