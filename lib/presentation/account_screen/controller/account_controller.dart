import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/network/connectivity_service.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/domain/model/account/profile_request.dart';
import 'package:customerapp/domain/model/account/profile_response.dart';
import 'package:customerapp/domain/model/login/login_request.dart';
import 'package:customerapp/domain/usecases/account/delete_account_use_case.dart';
import 'package:customerapp/domain/usecases/account/get_account_use_case.dart';
import 'package:customerapp/domain/usecases/account/update_account_use_case.dart';
import 'package:customerapp/domain/usecases/account/verify_account_use_case.dart';
import 'package:customerapp/domain/usecases/account/verify_emailmobile_use_case.dart';
import 'package:customerapp/presentation/base_controller.dart';
import 'package:customerapp/presentation/main_screen/controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_autofill/otp_autofill.dart';

enum AccountStatus {
  unknown,
  accountVerified,
  mobileChanged,
  emailChanged,
  validMobile,
  validEmail,
}

class AccountController extends BaseController {
  final GetAccountUseCase _accountUseCase;
  final UpdateAccountUseCase _updateAccountUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;

  final VerifyAccountUseCase _verifyAccountUseCase;
  final VerifyEmailMobileUseCase _verifyEmailMobileUseCase;

  AccountController(
      this._accountUseCase,
      this._updateAccountUseCase,
      this._deleteAccountUseCase,
      this._verifyAccountUseCase,
      this._verifyEmailMobileUseCase);
  final sessionStorage = GetStorage();

  var name = "".obs;
  var mobile = "".obs;
  var email = "".obs;

  var mobileStatus = AccountStatus.unknown.obs;
  var emailStatus = AccountStatus.unknown.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  Rx<OTPTextEditController> otpController =
      OTPTextEditController(codeLength: 4).obs;

  Rx<ProfileData> accountData = Rx(ProfileData.empty());

  Rx<PrimaryAddress> primaryAddress = Rx(PrimaryAddress.empty());

  String updatedAddressId = "";

  var navigateFrom = "";

  var updateMobile = "";
  var updateEmail = "";
  late final _connectivityService = getIt<ConnectivityService>();

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    phoneController.dispose();
    nameController.dispose();
  }

  @override
  void onInit() {
    name.value = sessionStorage.read(StorageKeys.username) ?? "";
    mobile.value = sessionStorage.read(StorageKeys.mobile) ?? "";
    email.value = sessionStorage.read(StorageKeys.email) ?? "";

    emailController.text = email.value.trim();
    phoneController.text = mobile.value.trim();
    nameController.text = name.value.trim();
    super.onInit();
  }

  void clearStateData() {
    emailController.text = '';
    phoneController.text = '';
    nameController.text = '';
    mobileStatus.value = AccountStatus.unknown;
    emailStatus.value = AccountStatus.unknown;
  }

  Future<void> getAccount() async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        var account = await _accountUseCase
            .execute(sessionStorage.read(StorageKeys.userId).toString());

        accountData.value = account?.data ?? ProfileData.empty();
        primaryAddress.value =
            accountData.value.primaryAddress ?? PrimaryAddress.empty();

        if (account?.data?.email != null) {
          var emails = account?.data?.email ?? '';
          if (emails.isNotNullOrEmpty && emails != 'null') {
            emailController.text = emails.trim();
            email.value = emails;
          }
        }
        if (account?.data?.phone != null) {
          var phones = account?.data?.phone ?? '';
          if (phones.isNotNullOrEmpty && phones != 'null') {
            phoneController.text = phones;
            mobile.value = phones;
          }
        }
        if (account?.data?.username != null) {
          var username = account?.data?.username.toString().trim() ?? '';
          if (username.isNotNullOrEmpty && username != 'null') {
            nameController.text = username;
            name.value = username;
          }
        }

        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
        e.printInfo();
      }
    } else {
      showToast(LocalizationKeys.noNetwork.tr);
    }
  }

  Future<void> updateAccount() async {
    if (await _connectivityService.isConnected()) {
      try {
        if (mobileStatus.value == AccountStatus.mobileChanged) {
          showToast('Please verify the mobile number before proceed');
          return;
        } else if (emailStatus.value == AccountStatus.emailChanged) {
          showToast('Please verify the email before proceed');
          return;
        }

        showLoadingDialog();

        ProfileRequest request = ProfileRequest(
          userId: sessionStorage.read(StorageKeys.userId).toString(),
          email: emailController.text,
          phone: phoneController.text,
          username: nameController.text,
          primaryAddressId: updatedAddressId.isNotNullOrEmpty
              ? updatedAddressId
              : accountData.value.primaryAddressId.toString(),
        );

        var account = await _updateAccountUseCase.execute(request);

        if (account != null && account.success == true) {
          showToast('Account updated successfully');
          sessionStorage.write(StorageKeys.username, nameController.text);
          sessionStorage.write(StorageKeys.mobile, phoneController.text);
          sessionStorage.write(StorageKeys.email, emailController.text);

          name.value = nameController.text.trim();
          mobile.value = phoneController.text.trim();
          email.value = emailController.text.trim();
          Get.back(result: true);
        }

        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
        showSnackBar("Warning", "${e.toString()}", Colors.black54);
      }
    } else {
      showToast(LocalizationKeys.noNetwork.tr);
    }
  }

  Future<void> deleteAccount() async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        var account = await _deleteAccountUseCase
            .execute(sessionStorage.read(StorageKeys.userId).toString());
        if (account != null && account == true) {
          showToast(
            'Account deleted successfully',
          );
          sessionStorage.erase();
          MainScreenController mainController =
              Get.find<MainScreenController>();
          mainController.loggedIn.value = false;
          Get.offAllNamed(AppRoutes.mainScreen);
        }

        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
        e.printInfo();
      }
    } else {
      showToast(LocalizationKeys.noNetwork.tr);
    }
  }

  verifyAccount(bool isResendOTP, String whereIs) async {
    try {
      if (isResendOTP) {
        showLoadingDialog();
      }

      var from = 'mobile';
      var userName = '';

      if (whereIs == "initial") {
        if (phoneController.text.isNotNullOrEmpty) {
          userName = phoneController.text;
          from = 'mobile';
        } else {
          userName = emailController.text;
          from = 'email';
        }
      } else {
        if (whereIs == 'mobile') {
          userName = phoneController.text;
          from = 'mobile';
        } else {
          userName = emailController.text;
          from = 'email';
        }
      }

      LoginRequest request =
          LoginRequest(username: userName, password: '', from: from);

      var responds = await _verifyAccountUseCase.execute(request);
      if (responds != null) {
        hideLoadingDialog();
        if (responds.success == true) {
          if (isResendOTP) {
            showToast("OTP has been sent to your device");
          }
        } else {
          showToast(responds.message ?? "Invalid access");
        }
      }
    } catch (e) {
      hideLoadingDialog();
      showSnackBar("Error", e.toString(), Colors.black54);
    }
  }

  verifyMobileEmailAccount(
    String whereIs,
  ) async {
    try {
      showLoadingDialog();

      var userName = '';
      var from = 'mobile';
      if (whereIs == "initial") {
        if (phoneController.text.isNotNullOrEmpty) {
          userName = phoneController.text;
          from = 'mobile';
        } else {
          userName = emailController.text;
          from = 'email';
        }
      } else {
        if (whereIs == 'mobile') {
          userName = phoneController.text;
          from = 'mobile';
        } else {
          userName = emailController.text;
          from = 'email';
        }
      }

      LoginRequest request = LoginRequest(
          username: userName, password: otpController.value.text, from: from);

      var responds = await _verifyEmailMobileUseCase.execute(request);
      hideLoadingDialog();
      if (responds != null) {
        if (responds.success == true) {
          if (whereIs == "initial") {
            Get.offNamed(AppRoutes.editAccountScreen);
          } else {
            if (whereIs == 'mobile') {
              mobileStatus.value = AccountStatus.validMobile;
            } else if (whereIs == "email") {
              emailStatus.value = AccountStatus.validEmail;
            }
            Get.back();
          }
        } else {
          showToast(responds.message ?? "Verification failed");
        }
      }
    } catch (e) {
      hideLoadingDialog();
      showSnackBar("Error", e.toString(), Colors.black54);
    }
  }
}
