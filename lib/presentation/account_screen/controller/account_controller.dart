import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/network/connectivity_service.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/domain/model/account/profile_request.dart';
import 'package:customerapp/domain/model/account/profile_response.dart';
import 'package:customerapp/domain/usecases/account/delete_account_use_case.dart';
import 'package:customerapp/domain/usecases/account/get_account_use_case.dart';
import 'package:customerapp/domain/usecases/account/update_account_use_case.dart';
import 'package:customerapp/presentation/base_controller.dart';
import 'package:customerapp/presentation/main_screen/controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AccountController extends BaseController {
  final GetAccountUseCase _accountUseCase;
  final UpdateAccountUseCase _updateAccountUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;

  AccountController(
    this._accountUseCase,
    this._updateAccountUseCase,
    this._deleteAccountUseCase,
  );
  final sessionStorage = GetStorage();

  var name = "".obs;
  var mobile = "".obs;
  var email = "".obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  Rx<ProfileData> accountData = Rx(ProfileData.empty());

  Rx<PrimaryAddress> primaryAddress = Rx(PrimaryAddress.empty());

  String updatedAddressId = "";
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

    emailController.text = email.value;
    phoneController.text = mobile.value;
    nameController.text = name.value;
    super.onInit();
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

          name.value = nameController.text;
          mobile.value = phoneController.text;
          email.value = emailController.text;
          Get.back(result: true);
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

  Future<void> deleteAccount() async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        var account = await _deleteAccountUseCase
            .execute(sessionStorage.read(StorageKeys.userId).toString());

        if (account != null && account == true) {
          showToast('Account deleted successfully');
          sessionStorage.erase();
          MainScreenController mainController =
              Get.find<MainScreenController>();
          mainController.loggedIn.value = false;
          Get.offAndToNamed(AppRoutes.loginScreen, arguments: {
            'from': AppRoutes.accountScreen,
          });
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
}
