import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/extensions/bool_extension.dart';
import 'package:customerapp/core/extensions/list_extensions.dart';
import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/network/connectivity_service.dart';
import 'package:customerapp/domain/model/home/active_banner_responds.dart';
import 'package:customerapp/domain/model/home/city_responds.dart';
import 'package:customerapp/domain/model/home/city_service_responds.dart';
import 'package:customerapp/domain/model/home/mid_banner_responds.dart';
import 'package:customerapp/domain/model/home/push_request.dart';
import 'package:customerapp/domain/model/settings/review_request.dart';
import 'package:customerapp/domain/model/settings/reviews_responds.dart';
import 'package:customerapp/domain/usecases/home/city_service_use_case.dart';
import 'package:customerapp/domain/usecases/home/home_use_case.dart';
import 'package:customerapp/domain/usecases/home/push_token_use_case.dart';
import 'package:customerapp/domain/usecases/home/reviews_list_use_case.dart';
import 'package:customerapp/presentation/base_controller.dart';
import 'package:customerapp/presentation/main_screen/widgets/city_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

enum HomeStatus {
  unknown,
  loaded,
  initiated,
}

class MainScreenController extends BaseController {
  final HomeUseCase _homeUseCase;
  final CityServiceUseCase _cityServiceUseCase;
  final PushTokenUseCase _pushTokenUseCase;

  final ReviewsListUseCase _reviewsUseCase;

  MainScreenController(
    this._homeUseCase,
    this._cityServiceUseCase,
    this._pushTokenUseCase,
    this._reviewsUseCase,
  );
  final sessionStorage = GetStorage();
  late final _connectivityService = getIt<ConnectivityService>();

  var homeStatus = HomeStatus.unknown.obs;
  Rx<List<CityData>> cityInfo = Rx([]);

  Rx<CityData> selectedCity = Rx(CityData());
  Rx<List<ActiveBannerData>> activeBanners = Rx([]);
  Rx<List<MidBannerData>> midBanners = Rx([]);
  Rx<List<CityServiceData>> cityServices = Rx([]);
  Rx<bool> loggedIn = Rx(false);
  Rx<int> reviewCount = Rx(0);

  Rx<List<ReviewData>> reviewList = Rx<List<ReviewData>>([]);
  final ScrollController scrollController = ScrollController();
  @override
  void onInit() {
    loggedIn.value = sessionStorage.read(StorageKeys.loggedIn) ?? false;
    final value = sessionStorage.read(StorageKeys.selectedCity);
    if (value != null) {
      selectedCity.value = CityData.fromJson(value);
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

    _requestMultiplePermissions();

    getCity();
    getReviews('5', '0', "", false);
    updatePushToken();
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }

  getCity() async {
    homeStatus.value = HomeStatus.initiated;
    if (await _connectivityService.isConnected()) {
      try {
        final responds = await _homeUseCase.execute();

        cityInfo.value = responds.item1.data?.rows ?? [];
        activeBanners.value = responds.item2.data ?? [];
        midBanners.value = responds.item3.data ?? [];

        if (selectedCity.value.cityId != null &&
            selectedCity.value.cityId.toString().isNotEmpty) {
          var services = await _cityServiceUseCase
              .execute(selectedCity.value.cityId.toString());
          cityServices.value = services?.data ?? [];
        } else if (cityInfo.value.isNotNullOrEmpty) {
          await Get.bottomSheet(
            isDismissible: false,
            backgroundColor: Colors.white,
            elevation: 6,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            CityBottomSheet(
              city: cityInfo.value,
              height: cityInfo.value.length > 3
                  ? (cityInfo.value.length > 6 ? 800 : 500)
                  : 280,
              padding: const EdgeInsets.only(
                  top: 40, left: 12, right: 12, bottom: 5),
              onCitySelected: (city) {
                Get.back();
                onCitySelected(city);
              },
            ),
          );
        }

        homeStatus.value = HomeStatus.loaded;
      } catch (e) {
        homeStatus.value = HomeStatus.loaded;
      }
    } else {
      showToast(LocalizationKeys.noNetwork.tr);
    }
  }

  Future<void> onCitySelected(CityData city) async {
    selectedCity.value = city;
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        sessionStorage.write(StorageKeys.selectedCity, city.toJson());

        var services = await _cityServiceUseCase
            .execute(selectedCity.value.cityId.toString());
        cityServices.value = services?.data ?? [];
        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
        e.printInfo();
      }
    } else {
      showToast(LocalizationKeys.noNetwork.tr);
    }
  }

  Future<void> updatePushToken() async {
    if (await _connectivityService.isConnected()) {
      try {
        var userId = sessionStorage.read(StorageKeys.userId).toString();
        var userType = '';
        if (userId.isNotEmpty) {
          userType = 'user';
        } else {
          userType = '';
          userId = '';
        }

        var request = PushRequest(
          userId: userId.toString(),
          userType: userType,
          deviceToken: sessionStorage.read(StorageKeys.pushToken) ?? '',
        );
        await _pushTokenUseCase.execute(request);
      } catch (e) {
        e.printInfo();
      }
    }
  }

  getReviews(String limit, String offset, String search, bool loadMore) async {
    if (await _connectivityService.isConnected()) {
      try {
        if (loadMore.absolute) {
          showLoadingDialog();
        }

        ReviewRequest request =
            ReviewRequest(limit: limit, offset: offset, search: search);
        ReviewListResponds? responds = await _reviewsUseCase.execute(request);

        if (responds?.success == true) {
          reviewCount.value = responds?.data?.count ?? 0;
          var list = reviewList.value;
          list.addAll(responds?.data?.rows ?? []);
          reviewList.value = List<ReviewData>.from(
              list); // Update the list using the Rx setter
        }
        if (loadMore.absolute) {
          hideLoadingDialog();
        }
      } catch (e) {
        if (loadMore.absolute) {
          hideLoadingDialog();
        }
        e.printInfo();
      }
    }
  }

  Future<void> _requestMultiplePermissions() async {
    // List of permissions to request
    final Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
      Permission.location,
    ].request();

    var isPermanentlyDenied =
        statuses.values.any((status) => status.isPermanentlyDenied);
    if (isPermanentlyDenied) {
      _showPermissionDialogWithSettings(
        'Permissions Required',
        'Please allow the required permissions to continue using the app.',
      );
    }
  }

  void _showPermissionDialogWithSettings(String title, String message) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Get.back();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
