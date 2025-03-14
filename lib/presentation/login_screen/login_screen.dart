import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/presentation/common_widgets/custom_icon_button.dart';
import 'package:customerapp/presentation/common_widgets/custom_pin_code_text_field.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_text_field.dart';
import 'package:customerapp/presentation/login_screen/controller/auth_controller.dart';
import 'package:customerapp/presentation/main_screen/controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:get/get.dart';
import 'package:otp_autofill/otp_autofill.dart';

import '../../core/utils/common_util.dart';
import '../../core/utils/size_utils.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.checkBundle();
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Container(
          child: loginView(),
        ),
      ),
    );
  }

  Widget loginView() {
    return GestureDetector(onTap: () {
      CommonUtil().keyboardHide(Get.context!);
    }, child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: getPadding(left: 16, top: 60, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomIconButton(
                          height: 30,
                          width: 30,
                          onTap: () {
                            if (controller.navigateFrom ==
                                AppRoutes.summeryScreen) {
                              Get.offNamed(AppRoutes.summeryScreen);
                            } else if (controller.authStatus.value ==
                                    AuthStatus.validEmail ||
                                controller.authStatus.value ==
                                    AuthStatus.validMobile) {
                              controller.clearState();
                            } else {
                              Get.back();
                              try {
                                if (Get.find<MainScreenController>()
                                            .selectedCity
                                            .value
                                            .cityId ==
                                        null ||
                                    Get.find<MainScreenController>()
                                            .selectedCity
                                            .value
                                            .cityId ==
                                        0 ||
                                    Get.find<MainScreenController>()
                                        .selectedCity
                                        .value
                                        .cityId
                                        .toString()
                                        .isEmpty) {
                                  Get.find<MainScreenController>()
                                      .forceCitySelection
                                      .value = true;
                                }
                              } catch (_) {}
                            }
                          },
                          alignment: Alignment.topLeft,
                          shape: IconButtonShape.CircleBorder35,
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: getPadding(left: 16, top: 30, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(LocalizationKeys.welcome.tr,
                            style: AppTextStyle.txt16),
                        const SizedBox(height: 5),
                        Text(LocalizationKeys.loginSignInHeading.tr,
                            style: AppTextStyle.txtBold24),
                        const SizedBox(height: 25),
                        Obx(() {
                          switch (controller.authStatus.value) {
                            case AuthStatus.validMobile:
                              return OTPWidget();
                            case AuthStatus.validEmail:
                              return loginPasswordView();
                            default:
                              return loginInitialView();
                          }
                        }),
                        const SizedBox(height: 10),
                        Obx(
                          () => Visibility(
                            visible: (controller.authStatus.value !=
                                    AuthStatus.validEmail &&
                                controller.authStatus.value !=
                                    AuthStatus.validMobile),
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoutes.forgotPasswordScreen);
                              },
                              child: Text("Forget Password?",
                                  style: AppTextStyle.txt14Secondary,
                                  textAlign: TextAlign.end),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        NookCornerButton(
                            outlinedColor: AppColors.primaryColor,
                            textStyle: AppTextStyle.txtBoldWhite14,
                            text: LocalizationKeys.login.tr,
                            backGroundColor: AppColors.primaryColor,
                            onPressed: onTapSignIn),
                        const SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Don't have a account?",
                                  style: AppTextStyle.txtBold14,
                                  textAlign: TextAlign.center),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(AppRoutes.signupScreen);
                                },
                                child: Text("Create One",
                                    style: AppTextStyle.txt14Secondary,
                                    textAlign: TextAlign.center),
                              ),
                            ]),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ]),
          ),
        );
      },
    ));
  }

  Widget loginInitialView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FlutterToggleTab(
          width: 70,
          borderRadius: 30,
          height: 40,
          selectedIndex: controller.isPhoneLogin.value ? 0 : 1,
          selectedBackgroundColors: const [
            Colors.black,
          ],
          selectedTextStyle: AppTextStyle.txtWhite12,
          unSelectedTextStyle: AppTextStyle.txt12,
          labels: [LocalizationKeys.phone.tr, LocalizationKeys.email.tr],
          selectedLabelIndex: (index) {
            CommonUtil().keyboardHide(Get.context!);
            controller.isPhoneLogin.value = index == 0;
          },
          isScroll: false,
        ),
        const SizedBox(height: 30),
        controller.isPhoneLogin.value
            ? NookCornerTextField(
                textInputAction: TextInputAction.done,
                controller: controller.phoneController,
                textStyle: AppTextStyle.txt16,
                title: LocalizationKeys.phoneNumber.tr,
                type: NookCornerTextFieldType.mobile,
                isFormField: true,
                validator: (value) {
                  if (controller.onPhoneChanged() == true) {
                    return null; // 'Please enter valid phone number';
                  }
                  return null;
                },
                autoValidate: true,
              )
            : NookCornerTextField(
                textInputAction: TextInputAction.done,
                controller: controller.emailController,
                title: LocalizationKeys.email.tr,
                textStyle: AppTextStyle.txt16,
                type: NookCornerTextFieldType.email,
                isFormField: true,
                validator: (value) {
                  if (controller.onEmailChanged() == false) {
                    return null; //'Please enter valid email address';
                  }
                  return null;
                },
                autoValidate: true,
              ),
      ],
    );
  }

  Widget loginPasswordView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NookCornerTextField(
          textInputAction: TextInputAction.done,
          controller: controller.passwordController,
          textStyle: AppTextStyle.txt16,
          title: LocalizationKeys.password.tr,
          type: NookCornerTextFieldType.password,
          isFormField: true,
          validator: (value) {
            return null;
          },
          autoValidate: true,
        )
      ],
    );
  }

  void onTapSignIn() {
    controller.callLogin();
  }
}

class OTPWidget extends StatefulWidget {
  const OTPWidget({super.key});

  @override
  State<OTPWidget> createState() => _OTPWidgetState();
}

class _OTPWidgetState extends State<OTPWidget> {
  AuthController authController = Get.find<AuthController>();
  late OTPInteractor? _otpInteractor;
  final _otpFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _otpInteractor = OTPInteractor();
    authController.otpController.value = OTPTextEditController(
      codeLength: 6,
      otpInteractor: _otpInteractor,
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{4})');
          final otp = exp.stringMatch(code ?? '');
          return otp ?? '';
        },
      );
  }

  @override
  void dispose() {
    _otpFocusNode.dispose();
    _otpInteractor?.stopListenForCode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Text(
            'Please enter the OTP to verify your account',
            textAlign: TextAlign.center,
            style: AppTextStyle.txtBold12,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: CustomPinCodeTextField(
            context: Get.context!,
            textStyle: AppTextStyle.txt16,
            controller: authController.otpController.value,
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: TextButton(
              onPressed: () {
                if (authController.navigationFlag == 'mobileJob') {
                  authController.signupMobile(true);
                } else {
                  authController.loginMobile(true);
                }
              },
              child: Text(LocalizationKeys.resendOtp.tr,
                  style:
                      AppTextStyle.txtBold16.copyWith(color: AppColors.black))),
        ),
      ],
    );
  }
}
