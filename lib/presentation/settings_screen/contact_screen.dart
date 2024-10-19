import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/generated/assets.gen.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_text_field.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:customerapp/presentation/settings_screen/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_text_style.dart';
import '../../core/utils/common_util.dart';
import '../../core/utils/size_utils.dart';

class ContactScreen extends GetView<SettingsController> {
  const ContactScreen({super.key});

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
                      const TitleBarWidget(title: "Contact Us"),
                      const SizedBox(
                        height: 30,
                      ),
                      Card(
                        elevation: 6,
                        color: AppColors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Assets.images.nookCornerRound
                                  .image(width: 60, height: 60),
                              const SizedBox(height: 10),
                              NookCornerTextField(
                                textInputAction: TextInputAction.next,
                                //  controller: controller.phoneController,
                                textStyle: AppTextStyle.txt14,
                                title: 'Name',
                                type: NookCornerTextFieldType.text,
                                isFormField: true,
                                validator: (value) {
                                  return null;
                                },
                                autoValidate: true,
                              ),
                              const SizedBox(height: 5),
                              NookCornerTextField(
                                textInputAction: TextInputAction.next,
                                // controller: controller.emailController,
                                title: 'Mobile Number',
                                textStyle: AppTextStyle.txt14,
                                type: NookCornerTextFieldType.mobile,
                                isFormField: true,
                                validator: (value) {
                                  return null;
                                },
                                autoValidate: true,
                              ),
                              const SizedBox(height: 5),
                              NookCornerTextField(
                                textInputAction: TextInputAction.next,
                                // controller: controller.emailController,
                                title: 'Email',
                                textStyle: AppTextStyle.txt14,
                                type: NookCornerTextFieldType.email,
                                isFormField: true,
                                validator: (value) {
                                  return null;
                                },
                                autoValidate: true,
                              ),
                              const SizedBox(height: 5),
                              NookCornerTextField(
                                textInputAction: TextInputAction.done,
                                maxLines: 6,
                                minLines: 3,
                                // controller: controller.emailController,
                                title: 'Leave a message',
                                textStyle: AppTextStyle.txt14,
                                type: NookCornerTextFieldType.text,
                                isFormField: true,
                                validator: (value) {
                                  return null;
                                },
                                autoValidate: true,
                              ),
                              const SizedBox(height: 10),
                              NookCornerButton(
                                outlinedColor: AppColors.primaryColor,
                                textStyle: AppTextStyle.txtBoldWhite14,
                                text: 'Send Message',
                                backGroundColor: AppColors.primaryColor,
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        ),
                      )
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
