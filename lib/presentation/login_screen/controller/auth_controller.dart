import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/network/connectivity_service.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:customerapp/domain/model/login/login_request.dart';
import 'package:customerapp/domain/model/login/login_responds.dart';
import 'package:customerapp/domain/usecases/forget_password/forget_password_use_case.dart';
import 'package:customerapp/domain/usecases/login/email_login_use_case.dart';
import 'package:customerapp/domain/usecases/login/login_use_case.dart';
import 'package:customerapp/domain/usecases/login/mobile_login_use_case.dart';
import 'package:customerapp/domain/usecases/signup/email_signup_use_case.dart';
import 'package:customerapp/domain/usecases/signup/mobile_signup_use_case.dart';
import 'package:customerapp/domain/usecases/signup/signup_use_case.dart';
import 'package:customerapp/presentation/base_controller.dart';
import 'package:customerapp/presentation/main_screen/controller/main_controller.dart';
import 'package:customerapp/presentation/services_screen/controller/service_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_autofill/otp_autofill.dart';

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

  final SignupUseCase _signupUseCase;
  final MobileSignupUseCase _mobileSignupUseCase;
  final EmailSignupUseCase _emailSignupUseCase;

  final ForgetPasswordUseCase _forgetPasswordUseCase;

  AuthController(
    this._loginUseCase,
    this._mobileLoginUseCase,
    this._emailLoginUseCase,
    this._signupUseCase,
    this._mobileSignupUseCase,
    this._emailSignupUseCase,
    this._forgetPasswordUseCase,
  );

  var authStatus = AuthStatus.unknown.obs;
  late final _connectivityService = getIt<ConnectivityService>();
  final sessionStorage = GetStorage();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Rx<OTPTextEditController> otpController =
      OTPTextEditController(codeLength: 4).obs;
  Rx<String> phone = "".obs;
  Rx<String> email = Rx("");

  var isValidEmail = false.obs;
  var isValidPhone = false.obs;
  var isPhoneLogin = true.obs;

  var navigateFrom = "";
  @override
  void onInit() {
    super.onInit();
    try {
      final arguments = Get.arguments as Map<String, dynamic>;

      navigateFrom = arguments['from'] ?? '';
    } catch (e) {
      e.printInfo();
    }
  }

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    otpController.value.dispose();
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
          if (!onEmailChanged()) {
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
          showToast(responds.message ?? "Invalid mobile access");
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
          showToast(responds.message ?? "Invalid email access");
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
        if (responds.success == true) {
          _handleLoginSuccessData(responds.data?.accessToken);
          _onOnTapLogInSuccess(responds.data);
        } else {
          showToast(responds.message ?? "Invalid login");
        }
      }
    } catch (e) {
      hideLoadingDialog();
      showSnackBar("Error", e.toString(), Colors.black54);
    }
  }

  void _onOnTapLogInSuccess(LoginData? responds) {
    sessionStorage.write(StorageKeys.username, responds?.user?.username ?? "");
    sessionStorage.write(StorageKeys.userId, responds?.user?.userId ?? "");
    sessionStorage.write(StorageKeys.email, responds?.user?.email ?? "");
    sessionStorage.write(StorageKeys.mobile, responds?.user?.phone ?? "");
    sessionStorage.write(
        StorageKeys.address, responds?.user?.primaryAddressId ?? "");

    if (navigateFrom == AppRoutes.summeryScreen) {
      Get.offAndToNamed(AppRoutes.summeryScreen);
    } else {
      Get.offAndToNamed(AppRoutes.mainScreen);
    }
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

    try {
      Get.find<MainScreenController>().loggedIn.value = true;
      Get.find<ServiceController>().isLogin = true;
    } catch (e) {
      Logger.e("Error in controller", e);
    }
  }

  callSignUp() async {
    if (await _connectivityService.isConnected()) {
      if (authStatus.value == AuthStatus.validMobile ||
          authStatus.value == AuthStatus.validEmail) {
        showLoadingDialog();
        signup();
      } else {
        if (isPhoneLogin.value) {
          if (onPhoneChanged()) {
            showToast('Please enter valid phone number');
            return;
          }
          showLoadingDialog();
          signupMobile(false);
        } else {
          if (!onEmailChanged()) {
            showToast('Please enter valid email address');
            return;
          }
          showLoadingDialog();
          signupEmail();
        }
      }
    } else {
      showToast(LocalizationKeys.noNetwork.tr);
    }
  }

  signupMobile(bool isResendOTP) async {
    try {
      if (isResendOTP) {
        showLoadingDialog();
      }
      var responds = await _mobileSignupUseCase.execute(phoneController.text);
      if (responds != null) {
        hideLoadingDialog();
        if (responds.success == true) {
          if (isResendOTP) {
            showToast("OTP has been sent to phone number");
          } else {
            authStatus.value = AuthStatus.validMobile;
          }
        } else {
          showToast(responds.message ?? "Invalid mobile access");
        }
      }
    } catch (e) {
      hideLoadingDialog();
      showSnackBar("Error", e.toString(), Colors.black54);
    }
  }

  signupEmail() async {
    try {
      var responds = await _emailSignupUseCase.execute(emailController.text);
      if (responds != null) {
        hideLoadingDialog();
        if (responds.success == true) {
          _handleLoginSuccessData(responds.data?.accessToken);
          _onOnTapLogInSuccess(responds.data);
        } else {
          showToast(responds.message ?? "Invalid email access");
        }
      }
    } catch (e) {
      hideLoadingDialog();
      showSnackBar("Error", e.toString(), Colors.black54);
    }
  }

  signup() async {
    var username =
        isPhoneLogin.value ? phoneController.text : emailController.text;
    var password =
        isPhoneLogin.value ? otpController.value.text : passwordController.text;
    LoginRequest postLoginRequest =
        LoginRequest(username: username, password: password);

    try {
      var responds = await _signupUseCase.execute(postLoginRequest);

      if (responds != null) {
        hideLoadingDialog();
        if (responds.success == true) {
          _handleLoginSuccessData(responds.data?.accessToken);
          _onOnTapLogInSuccess(responds.data);
        } else {
          showToast(responds.message ?? "Invalid signup");
        }
      }
    } catch (e) {
      hideLoadingDialog();
      showSnackBar("Error", e.toString(), Colors.black54);
    }
  }

  void callForgetPassword() async {
    if (await _connectivityService.isConnected()) {
      try {
        if (!onEmailChanged()) {
          showToast('Please enter valid email address');
          return;
        }
        showLoadingDialog();

        var responds =
            await _forgetPasswordUseCase.execute(emailController.text);
        if (responds != null) {
          hideLoadingDialog();
          if (responds.success == true) {
            showToast("Password has been sent to the email address");
            clearState();
            Get.back();
          } else {
            showToast(responds.message ?? "Invalid email access");
          }
        }
      } catch (e) {
        hideLoadingDialog();
        showSnackBar("Error", e.toString(), Colors.black54);
      }
    } else {
      showToast(LocalizationKeys.noNetwork.tr);
    }
  }

  void clearState() {
    authStatus.value = AuthStatus.unknown;
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    otpController.value.clear();
  }
}
