import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/extensions/list_extensions.dart';
import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/network/connectivity_service.dart';
import 'package:customerapp/domain/model/home/active_banner_responds.dart';
import 'package:customerapp/domain/model/home/city_responds.dart';
import 'package:customerapp/domain/model/home/city_service_responds.dart';
import 'package:customerapp/domain/model/home/mid_banner_responds.dart';
import 'package:customerapp/domain/usecases/home/city_service_use_case.dart';
import 'package:customerapp/domain/usecases/home/home_use_case.dart';
import 'package:customerapp/presentation/base_controller.dart';
import 'package:customerapp/presentation/main_screen/widgets/city_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum HomeStatus {
  unknown,
  loaded,
  initiated,
}

class MainScreenController extends BaseController {
  final HomeUseCase _homeUseCase;
  final CityServiceUseCase _cityServiceUseCase;
  MainScreenController(this._homeUseCase, this._cityServiceUseCase);
  final sessionStorage = GetStorage();
  late final _connectivityService = getIt<ConnectivityService>();

  var homeStatus = HomeStatus.unknown.obs;
  Rx<List<CityData>> cityInfo = Rx([]);

  Rx<CityData> selectedCity = Rx(CityData());
  Rx<List<ActiveBannerData>> activeBanners = Rx([]);
  Rx<List<MidBannerData>> midBanners = Rx([]);
  Rx<List<CityServiceData>> cityServices = Rx([]);
  Rx<bool> loggedIn = Rx(false);

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
    getCity();
  }

  getCity() async {
    homeStatus.value = HomeStatus.initiated;
    if (await _connectivityService.isConnected()) {
      try {
        final responds = await _homeUseCase.execute();

        cityInfo.value = responds.item1.data ?? [];
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
              height: cityInfo.value.length > 3 ? 600 : 280,
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
}
