import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/network/connectivity_service.dart';
import 'package:customerapp/domain/model/address/address_request.dart';
import 'package:customerapp/domain/model/address/address_responds.dart';
import 'package:customerapp/domain/model/home/city_responds.dart';
import 'package:customerapp/domain/usecases/address/get_address_use_case.dart';
import 'package:customerapp/domain/usecases/address/save_addrress_use_case.dart';
import 'package:customerapp/presentation/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum AddressStatus {
  unknown,
  loaded,
  saved,
  updated,
}

class AddressController extends BaseController {
  final SaveAddressUseCase _saveAddressUseCase;
  final GetAddressUseCase _getAddressUseCase;

  AddressController(this._getAddressUseCase, this._saveAddressUseCase);

  late final _connectivityService = getIt<ConnectivityService>();
  Rx<List<AddressData>> addressList = Rx([]);

  var addressStatus = AddressStatus.unknown.obs;

  final sessionStorage = GetStorage();
  GoogleMapController? mapController;
  Rx<LatLng> currentLocation = Rx(const LatLng(19.0760, 72.8777));
  Rx<LatLng> selectedLocation = Rx(const LatLng(19.0760, 72.8777));
  Rx<String> addressType = Rx('Home');
  Rx<bool> hideToolTip = Rx(false);
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController houseFlatController = TextEditingController();

  Rx<BitmapDescriptor> customMarkerIcon = Rx(BitmapDescriptor.defaultMarker);

  @override
  void onInit() {
    super.onInit();
    _loadCustomMarkerIcon();
    getAddress();
  }

  @override
  void onClose() {
    super.onClose();
    streetController.dispose();
    cityController.dispose();
    houseFlatController.dispose();
  }

  Future<void> getAddress() async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        CityData selectedCity = CityData();
        final value = sessionStorage.read(StorageKeys.selectedCity);
        if (value != null) {
          selectedCity = CityData.fromJson(value);
        }

        GetAddressRequest request = GetAddressRequest(
          userId: sessionStorage.read(StorageKeys.userId).toString(),
          cityId: selectedCity.cityId.toString(),
        );

        var addresses = await _getAddressUseCase.execute(request);

        addressList.value = addresses?.data ?? [];

        addressStatus.value = AddressStatus.loaded;

        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
        e.printInfo();
      }
    } else {
      showToast(LocalizationKeys.noNetwork.tr);
    }
  }

  Future<void> saveAddress() async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        CityData selectedCity = CityData();
        final value = sessionStorage.read(StorageKeys.selectedCity);
        if (value != null) {
          selectedCity = CityData.fromJson(value);
        }

        AddressRequest request = AddressRequest(
          addresslineOne: streetController.text,
          addresslineTwo: houseFlatController.text,
          location: cityController.text,
          addressType: addressType.value,
          lat: selectedLocation.value.longitude.toString(),
          lng: selectedLocation.value.latitude.toString(),
          cityId: selectedCity.cityId.toString(),
          userId: sessionStorage.read(StorageKeys.userId).toString(),
        );

        var services = await _saveAddressUseCase.execute(request);

        if (services != null && services.success == true) {
          clearAddressInfo();
          showToast('Address added successfully');
          addressStatus.value = AddressStatus.saved;
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

  void clearAddressInfo() {
    streetController.clear();
    cityController.clear();
    houseFlatController.clear();
  }

  void _loadCustomMarkerIcon() async {}
}
