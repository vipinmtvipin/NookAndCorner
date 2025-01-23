import 'package:customerapp/core/extensions/bool_extension.dart';
import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/presentation/account_screen/controller/account_controller.dart';
import 'package:customerapp/presentation/common_widgets/conditional_widget.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_text_field.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_text_style.dart';
import '../../core/utils/common_util.dart';
import '../../core/utils/size_utils.dart';

class EditAccountScreen extends GetView<AccountController> {
  const EditAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getAccount();
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
                padding: getPadding(left: 16, top: 50, right: 16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleBarWidget(
                        title: "Edit Account",
                        onBack: () {
                          controller.clearStateData();
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              autoValidate: true,
                            ),
                            const SizedBox(height: 5),
                            Obx(
                              () => NookCornerTextField(
                                textInputAction: TextInputAction.next,
                                controller: controller.phoneController,
                                title: 'Mobile Number',
                                textStyle: AppTextStyle.txt14,
                                type: NookCornerTextFieldType.mobile,
                                isFormField: true,
                                validator: (value) {
                                  return null;
                                },
                                onChanged: (value) {
                                  if (value.length == 10) {
                                    if (controller.mobile.value != value) {
                                      controller.mobileStatus.value =
                                          AccountStatus.mobileChanged;
                                    } else {
                                      controller.mobileStatus.value =
                                          AccountStatus.unknown;
                                    }
                                  }
                                },
                                autoValidate: true,
                                suffix: ConditionalWidget(
                                  condition: controller.mobileStatus.value ==
                                          AccountStatus.mobileChanged &&
                                      controller.mobileStatus.value !=
                                          AccountStatus.validMobile,
                                  onFalse: ConditionalWidget(
                                      condition:
                                          controller.mobileStatus.value ==
                                              AccountStatus.validMobile,
                                      onFalse: SizedBox.shrink(),
                                      child: Icon(
                                        Icons.check_circle,
                                        size: 25,
                                        color: Colors.green,
                                      )),
                                  child: NookCornerButton(
                                    expandedWidth: false,
                                    type: NookCornerButtonType.text,
                                    textStyle: AppTextStyle.txt14Secondary,
                                    text: 'Verify',
                                    backGroundColor: AppColors.primaryColor,
                                    onPressed: () {
                                      Get.toNamed(AppRoutes.verifyAccountScreen,
                                          arguments: {
                                            'from': "mobile",
                                          });

                                      controller.verifyAccount(false, 'mobile');
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Obx(
                              () => NookCornerTextField(
                                textInputAction: TextInputAction.done,
                                controller: controller.emailController,
                                title: 'Email',
                                textStyle: AppTextStyle.txt14,
                                type: NookCornerTextFieldType.email,
                                isFormField: true,
                                validator: (value) {
                                  return null;
                                },
                                onChanged: (value) {
                                  if (value.isNotNullOrEmpty) {
                                    if (GetUtils.isEmail(value.trim())
                                        .absolute) {
                                      if (controller.email.value.trim() !=
                                          value) {
                                        controller.emailStatus.value =
                                            AccountStatus.emailChanged;
                                      } else {
                                        controller.emailStatus.value =
                                            AccountStatus.unknown;
                                      }
                                    }
                                  }
                                },
                                autoValidate: true,
                                suffix: ConditionalWidget(
                                  condition: controller.emailStatus.value ==
                                          AccountStatus.emailChanged &&
                                      controller.emailStatus.value !=
                                          AccountStatus.validEmail,
                                  onFalse: ConditionalWidget(
                                      condition: controller.emailStatus.value ==
                                          AccountStatus.validEmail,
                                      onFalse: SizedBox.shrink(),
                                      child: Icon(
                                        Icons.check_circle,
                                        size: 25,
                                        color: Colors.green,
                                      )),
                                  child: NookCornerButton(
                                    expandedWidth: false,
                                    type: NookCornerButtonType.text,
                                    textStyle: AppTextStyle.txt14Secondary,
                                    text: 'Verify',
                                    backGroundColor: AppColors.primaryColor,
                                    onPressed: () {
                                      Get.toNamed(AppRoutes.verifyAccountScreen,
                                          arguments: {
                                            'from': "email",
                                          });

                                      controller.verifyAccount(false, 'email');
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Obx(
                              () => ConditionalWidget(
                                condition:
                                    controller.primaryAddress.value.addressId !=
                                        0,
                                onFalse: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                        child: ResponsiveText(
                                            text: 'Add primary address')),
                                    NookCornerButton(
                                        expandedWidth: false,
                                        width: 80,
                                        height: 40,
                                        padding: EdgeInsets.zero,
                                        type: NookCornerButtonType.outlined,
                                        outlinedColor: AppColors.secondaryColor,
                                        textStyle: AppTextStyle.txtBold14,
                                        text: 'Add',
                                        backGroundColor: AppColors.primaryColor,
                                        onPressed: () {
                                          Get.toNamed(
                                              AppRoutes.confirmAddressScreen,
                                              arguments: {
                                                'jobId': '0',
                                                'from': 'profile'
                                              });
                                        }),
                                  ],
                                ),
                                child: Card(
                                  elevation: 65,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('Primary Address',
                                            textAlign: TextAlign.left,
                                            style: AppTextStyle.txtBold16
                                                .copyWith(
                                                    color: AppColors.gray)),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                controller.primaryAddress.value
                                                    .addressType.toCapitalized,
                                                textAlign: TextAlign.left,
                                                style: AppTextStyle.txtBold12),
                                            const SizedBox(width: 10),
                                            GestureDetector(
                                              onTap: () {
                                                Get.toNamed(
                                                    AppRoutes
                                                        .confirmAddressScreen,
                                                    arguments: {
                                                      'jobId': '0',
                                                      'from': 'profile'
                                                    });
                                              },
                                              child: Card(
                                                elevation: 1,
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                    color: Colors.orange,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 6),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.edit,
                                                        color: Colors.orange,
                                                        size: 15,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        'Change',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.orange),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Text(
                                          "${controller.primaryAddress.value.addresslineOne}, ${controller.primaryAddress.value.addresslineTwo}",
                                          textAlign: TextAlign.left,
                                          style:
                                              AppTextStyle.txtBold12.copyWith(
                                            color: AppColors.gray,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          controller.primaryAddress.value
                                                  .location ??
                                              '',
                                          textAlign: TextAlign.left,
                                          style:
                                              AppTextStyle.txtBold12.copyWith(
                                            color: AppColors.gray,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            NookCornerButton(
                              outlinedColor: AppColors.primaryColor,
                              textStyle: AppTextStyle.txtBoldWhite14,
                              text: 'Update',
                              backGroundColor: AppColors.primaryColor,
                              onPressed: () {
                                if (controller.nameController.text.isEmpty ||
                                    controller.phoneController.text.isEmpty ||
                                    controller.emailController.text.isEmpty) {
                                  "Please fill all the fields".showToast();
                                  return;
                                }
                                if (!controller.emailController.text.isEmail) {
                                  "Please enter valid email".showToast();
                                  return;
                                }
                                if (!controller
                                    .phoneController.text.isPhoneNumber) {
                                  "Please enter valid phone number".showToast();
                                  return;
                                }
                                controller.updateAccount();
                              },
                            ),
                          ],
                        ),
                      )
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
