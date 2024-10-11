import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/generated/assets.gen.dart';
import 'package:customerapp/presentation/account_screen/controller/account_controller.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_text_style.dart';
import '../../core/utils/common_util.dart';
import '../../core/utils/size_utils.dart';
import '../common_widgets/custom_image_view.dart';

class AccountScreen extends GetView<AccountController> {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: mobileView(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: NookCornerButton(
              outlinedColor: AppColors.primaryColor,
              textStyle: AppTextStyle.txtBoldWhite14,
              text: 'Logout',
              backGroundColor: AppColors.primaryColor,
              onPressed: onTapLoginNavigation),
        ),
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
                      const TitleBarWidget(title: "My Account"),
                      const SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          CustomImageView(
                            svgPath: Assets.images.profileBg.path,
                            fit: BoxFit.fill,
                            height: 210,
                            width: double.infinity,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 10),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                const Icon(
                                  Icons.account_circle,
                                  size: 60,
                                  color: AppColors.white,
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                ResponsiveText(
                                    text: 'Hi, ${controller.name}',
                                    textAlign: TextAlign.left,
                                    style: AppTextStyle.txtBold12.copyWith(
                                        letterSpacing: getHorizontalSize(
                                          3,
                                        ),
                                        color: AppColors.white)),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.email_outlined,
                                          size: 18,
                                          color: AppColors.white,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        ResponsiveText(
                                            text: controller.email,
                                            textAlign: TextAlign.left,
                                            style: AppTextStyle.txtBold10
                                                .copyWith(
                                                    color: AppColors.white)),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.phone_android,
                                          size: 18,
                                          color: AppColors.white,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        ResponsiveText(
                                            text: '+91 ${controller.mobile}',
                                            textAlign: TextAlign.left,
                                            style: AppTextStyle.txtBold10
                                                .copyWith(
                                                    color: AppColors.white)),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ProfileItemsWidget(
                        iconData: Icons.edit_location,
                        label: "Edit Profile",
                        onTap: () {
                          //  Get.toNamed(AppRoutes.resultPage);
                        },
                      ),
                      const Divider(
                        color: AppColors.lightGray,
                        thickness: 0.3,
                        indent: 15,
                        endIndent: 25,
                      ),
                      ProfileItemsWidget(
                        iconData: Icons.home,
                        label: "Address",
                        onTap: () {
                          Get.back();
                        },
                      ),
                      const Divider(
                        color: AppColors.lightGray,
                        thickness: 0.3,
                        indent: 15,
                        endIndent: 25,
                      ),
                      ProfileItemsWidget(
                        iconData: Icons.note_alt,
                        label: "My Bookings",
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ])),
          ),
        );
      },
    ));
  }
}

onTapArrowLeft() {
  Get.back();
}

onTapLoginNavigation() {
  Get.offAndToNamed(
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
