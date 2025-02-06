import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/generated/assets.gen.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_text_field.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:customerapp/presentation/settings_screen/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
                                controller: controller.nameController,
                                textStyle: AppTextStyle.txt14,
                                title: 'Name',
                                type: NookCornerTextFieldType.text,
                                isFormField: true,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              const SizedBox(height: 5),
                              NookCornerTextField(
                                textInputAction: TextInputAction.next,
                                controller: controller.phoneController,
                                title: 'Mobile Number',
                                textStyle: AppTextStyle.txt14,
                                type: NookCornerTextFieldType.mobile,
                                isFormField: true,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              const SizedBox(height: 5),
                              NookCornerTextField(
                                textInputAction: TextInputAction.next,
                                controller: controller.emailController,
                                title: 'Email',
                                textStyle: AppTextStyle.txt14,
                                type: NookCornerTextFieldType.email,
                                isFormField: true,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              const SizedBox(height: 5),
                              NookCornerTextField(
                                textInputAction: TextInputAction.done,
                                maxLines: 6,
                                minLines: 3,
                                controller: controller.messageController,
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
                                  controller.postContactInfo();
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        color: Colors.white,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.all(2),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Text('Stay Connected with Us',
                                  style: AppTextStyle.txtBold16
                                      .copyWith(color: AppColors.black)),
                              const SizedBox(height: 10),
                              Text(
                                  'Follow us on social media for updates, offers, and tips to make your home shine. We’re here to inspire and engage with you every step of the way!',
                                  style: AppTextStyle.txt14
                                      .copyWith(color: AppColors.darkGray)),
                              const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final Uri url = Uri.parse(
                                          'https://www.instagram.com/nookandcorner_real/');

                                      await launchUrl(url,
                                          mode: LaunchMode.externalApplication);
                                    },
                                    child: Assets.images.insta
                                        .image(width: 20, height: 20),
                                  ),
                                  const SizedBox(width: 30),
                                  GestureDetector(
                                    onTap: () async {
                                      final Uri url = Uri.parse(
                                          'https://www.facebook.com/people/Nook-And-Corner/61563969806129/');

                                      await launchUrl(url,
                                          mode: LaunchMode.externalApplication);
                                    },
                                    child: Assets.images.fb
                                        .image(width: 22, height: 22),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ])),
          ),
        );
      },
    ));
  }
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
