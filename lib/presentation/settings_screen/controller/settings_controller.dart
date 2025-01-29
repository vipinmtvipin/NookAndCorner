import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/network/connectivity_service.dart';
import 'package:customerapp/domain/model/common_responds.dart';
import 'package:customerapp/domain/model/settings/address_request.dart';
import 'package:customerapp/domain/model/settings/review_request.dart';
import 'package:customerapp/domain/model/settings/reviews_responds.dart';
import 'package:customerapp/domain/usecases/settings/contact_use_case.dart';
import 'package:customerapp/domain/usecases/settings/reviews_use_case.dart';
import 'package:customerapp/presentation/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum SettingsStatus {
  unknown,
  success,
  error,
}

class SettingsController extends BaseController {
  final ContactUseCase _contactUseCase;
  final ReviewsUseCase _reviewsUseCase;
  SettingsController(
    this._contactUseCase,
    this._reviewsUseCase,
  );

  final ScrollController scrollController = ScrollController();

  var settingStatus = SettingsStatus.unknown.obs;
  late final _connectivityService = getIt<ConnectivityService>();
  final sessionStorage = GetStorage();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  Rx<List<ReviewData>> reviewList = Rx<List<ReviewData>>([]);

  @override
  void onInit() {
    super.onInit();
    _setupScrollListener();
    getReviews('10', '0', '');

    nameController.text = sessionStorage.read(StorageKeys.username) ?? "";
    phoneController.text = sessionStorage.read(StorageKeys.mobile) ?? "";
    emailController.text = sessionStorage.read(StorageKeys.email) ?? "";
  }

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    phoneController.dispose();
    nameController.dispose();
    messageController.dispose();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  postContactInfo() async {
    if (await _connectivityService.isConnected()) {
      try {
        if (emailController.text.isEmpty || !emailController.text.isEmail) {
          "Please enter a valid email".showToast();
          return;
        }
        if (phoneController.text.isEmpty ||
            !phoneController.text.isPhoneNumber) {
          "Please enter a valid phone".showToast();
          return;
        }
        if (nameController.text.isEmpty) {
          "Please enter name".showToast();
          return;
        }
        if (messageController.text.isEmpty) {
          "Please enter message".showToast();
          return;
        }
        showLoadingDialog();

        var userId = sessionStorage.read(StorageKeys.userId);
        var request = ContactRequest(
          email: emailController.text,
          phone: phoneController.text,
          name: nameController.text,
          message: messageController.text,
        );
        CommonResponds? responds = await _contactUseCase.execute(request);

        if (responds?.success == true) {
          "Contact info posted successfully".showToast();
          clearState();
          Get.back();
          settingStatus.value = SettingsStatus.success;
        } else {
          settingStatus.value = SettingsStatus.error;
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

  getReviews(String limit, String offset, String search) async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        ReviewRequest request =
            ReviewRequest(limit: limit, offset: offset, search: search);
        ReviewListResponds? responds = await _reviewsUseCase.execute(request);

        if (responds?.success == true) {
          var list = reviewList.value;
          list.addAll(responds?.data?.rows ?? []);
          reviewList.value = [
            ...reviewList.value,
            ...responds?.data?.rows ?? []
          ];
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

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        getReviews('10', reviewList.value.length.toString(), '');
      }
    });
  }

  void clearState() {
    phoneController.clear();
    emailController.clear();
    nameController.clear();
    messageController.clear();
  }
}
