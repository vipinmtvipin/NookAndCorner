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
  Rx<List<CityResponds>> cityInfo = Rx([]);

  Rx<CityResponds> selectedCity = Rx(CityResponds());
  Rx<List<ActiveBannerResponds>> activeBanners = Rx([]);
  Rx<List<MidBannerResponds>> midBanners = Rx([]);
  Rx<List<CityServiceResponds>> cityServices = Rx([]);
  Rx<bool> loggedIn = Rx(false);

  @override
  void onInit() {
    loggedIn.value = sessionStorage.read(StorageKeys.loggedIn) ?? false;
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

        cityInfo.value = responds.item1;
        activeBanners.value = responds.item2;
        midBanners.value = responds.item3;

        if (cityInfo.value.isNotNullOrEmpty) {
          selectedCity.value = cityInfo.value.first;
          var services = await _cityServiceUseCase
              .execute(cityInfo.value.first.cityId.toString());
          cityServices.value = services ?? [];
        }

        homeStatus.value = HomeStatus.loaded;
      } catch (e) {
        homeStatus.value = HomeStatus.loaded;
      }
    } else {
      showToast(LocalizationKeys.noNetwork.tr);
    }
  }

  Future<void> onCitySelected(CityResponds city) async {
    selectedCity.value = city;
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        var services = await _cityServiceUseCase
            .execute(selectedCity.value.cityId.toString());
        cityServices.value = services ?? [];
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
