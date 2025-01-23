import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/core/utils/common_util.dart';
import 'package:customerapp/core/utils/size_utils.dart';
import 'package:customerapp/presentation/account_screen/controller/account_controller.dart';
import 'package:customerapp/presentation/common_widgets/custom_icon_button.dart';
import 'package:customerapp/presentation/common_widgets/custom_pin_code_text_field.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_autofill/otp_autofill.dart';

class VerifyAccountScreen extends GetView<AccountController> {
  const VerifyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;

    var navigateFrom = arguments['from'] ?? '';

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Container(
          child: otpView(navigateFrom),
        ),
      ),
    );
  }

  Widget otpView(String from) {
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
                            Get.back();
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: ResponsiveText(
                            text: 'Verify your account',
                            maxLines: 1,
                            style: AppTextStyle.txtBold20,
                          ),
                        ),
                        const SizedBox(height: 25),
                        OTPWidget(from: from),
                        const SizedBox(height: 20),
                        NookCornerButton(
                            outlinedColor: AppColors.primaryColor,
                            textStyle: AppTextStyle.txtBoldWhite14,
                            text: 'Verify',
                            backGroundColor: AppColors.primaryColor,
                            onPressed: () => onTapVerify(from)),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ]),
          ),
        );
      },
    ));
  }

  void onTapVerify(String from) {
    controller.verifyMobileEmailAccount(from);
  }
}

class OTPWidget extends StatefulWidget {
  final String from;
  const OTPWidget({
    super.key,
    required this.from,
  });

  @override
  State<OTPWidget> createState() => _OTPWidgetState();
}

class _OTPWidgetState extends State<OTPWidget> {
  AccountController accountController = Get.find<AccountController>();
  late OTPInteractor? _otpInteractor;
  final _otpFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _otpInteractor = OTPInteractor();
    accountController.otpController.value = OTPTextEditController(
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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: ResponsiveText(
            text: 'Please enter the OTP to verify your account',
            textAlign: TextAlign.center,
            style: AppTextStyle.txt14,
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: CustomPinCodeTextField(
            context: Get.context!,
            textStyle: AppTextStyle.txt16,
            controller: accountController.otpController.value,
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
            onPressed: () {
              accountController.verifyAccount(
                true,
                widget.from,
              );
            },
            child: Text(LocalizationKeys.resendOtp.tr,
                style:
                    AppTextStyle.txtBold16.copyWith(color: AppColors.black))),
      ],
    );
  }
}
