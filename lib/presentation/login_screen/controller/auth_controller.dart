import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/network/connectivity_service.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:customerapp/domain/model/login/login_request.dart';
import 'package:customerapp/domain/model/login/login_responds.dart';
import 'package:customerapp/domain/usecases/login/email_login_use_case.dart';
import 'package:customerapp/domain/usecases/login/login_use_case.dart';
import 'package:customerapp/domain/usecases/login/mobile_login_use_case.dart';
import 'package:customerapp/presentation/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum AuthStatus {
  unknown,
  loginSuccess,
  validMobile,
  validEmail,
}

class AuthController extends BaseController {
  final LoginUseCase _loginUseCase;
  final MobileLoginUseCase _mobileLoginUseCase;
  final EmailLoginUseCase _emailLoginUseCase;
  AuthController(
      this._loginUseCase, this._mobileLoginUseCase, this._emailLoginUseCase);

  var authStatus = AuthStatus.unknown.obs;
  late final _connectivityService = getIt<ConnectivityService>();
  final sessionStorage = GetStorage();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Rx<TextEditingController> otpController = TextEditingController().obs;
  Rx<String> phone = "".obs;
  Rx<String> email = Rx("");

  var isValidEmail = false.obs;
  var isValidPhone = false.obs;
  var isPhoneLogin = true.obs;

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
  }

  callLogin() async {
    if (await _connectivityService.isConnected()) {
      if (authStatus.value == AuthStatus.validMobile ||
          authStatus.value == AuthStatus.validEmail) {
        showLoadingDialog();
        login();
      } else {
        if (isPhoneLogin.value) {
          if (onPhoneChanged()) {
            showToast('Please enter valid phone number');
            return;
          }
          showLoadingDialog();
          loginMobile(false);
        } else {
          if (onEmailChanged()) {
            showToast('Please enter valid email address');
            return;
          }
          showLoadingDialog();
          loginEmail();
        }
      }
    } else {
      showToast(LocalizationKeys.noNetwork.tr);
    }
  }

  loginMobile(bool isResendOTP) async {
    try {
      if (isResendOTP) {
        showLoadingDialog();
      }
      var responds = await _mobileLoginUseCase.execute(phoneController.text);
      if (responds != null) {
        hideLoadingDialog();
        if (responds.success == true) {
          if (isResendOTP) {
            showToast("OTP sent successfully");
          } else {
            authStatus.value = AuthStatus.validMobile;
          }
        } else {
          showToast(responds.message ?? "Invalid Mobile");
        }
      }
    } catch (e) {
      hideLoadingDialog();
      showSnackBar("Error", e.toString(), Colors.black54);
    }
  }

  loginEmail() async {
    try {
      var responds = await _emailLoginUseCase.execute(emailController.text);
      if (responds != null) {
        hideLoadingDialog();
        if (responds.success == true) {
          authStatus.value = AuthStatus.validEmail;
        } else {
          showToast(responds.message ?? "Invalid Email");
        }
      }
    } catch (e) {
      hideLoadingDialog();
      showSnackBar("Error", e.toString(), Colors.black54);
    }
  }

  login() async {
    var username =
        isPhoneLogin.value ? phoneController.text : emailController.text;
    var password =
        isPhoneLogin.value ? otpController.value.text : passwordController.text;
    LoginRequest postLoginRequest =
        LoginRequest(username: username, password: password);

    try {
      var responds = await _loginUseCase.execute(postLoginRequest);
      if (responds != null) {
        hideLoadingDialog();
        _handleLoginSuccessData(responds.accessToken);
        _onOnTapLogInSuccess(responds);
      }
    } catch (e) {
      hideLoadingDialog();
      showSnackBar("Error", e.toString(), Colors.black54);
    }
  }

  void _onOnTapLogInSuccess(LoginResponds responds) {
    Get.offAndToNamed(AppRoutes.mainScreen);
  }

  bool onPhoneChanged() {
    return isValidPhone.value = GetUtils.isNullOrBlank(phoneController.text)! ||
        phoneController.text.length < 10;
  }

  bool onEmailChanged() {
    return isValidEmail.value = GetUtils.isEmail(emailController.text);
  }

  void _handleLoginSuccessData(String? token) {
    sessionStorage.write(StorageKeys.loggedIn, true);
    sessionStorage.write(StorageKeys.token, token);
    var data = sessionStorage.read(StorageKeys.token);
    Logger.e("LOGIN", 'Logged token is :--- $data');
  }
}
