import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/extensions/list_extensions.dart';
import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/network/connectivity_service.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/domain/model/address/address_request.dart';
import 'package:customerapp/domain/model/address/address_responds.dart';
import 'package:customerapp/domain/model/home/city_responds.dart';
import 'package:customerapp/domain/usecases/address/confirm_address_use_case.dart';
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
  final ConfirmAddressUseCase _confirmAddressUseCase;

  AddressController(this._getAddressUseCase, this._saveAddressUseCase,
      this._confirmAddressUseCase);

  late final _connectivityService = getIt<ConnectivityService>();
  Rx<List<AddressData>> addressList = Rx([]);

  var addressStatus = AddressStatus.unknown.obs;

  final sessionStorage = GetStorage();
  GoogleMapController? mapController;
  Rx<LatLng> currentLocation = Rx(const LatLng(19.0760, 72.8777));
  Rx<LatLng> selectedLocation = Rx(const LatLng(19.0760, 72.8777));

  Rx<AddressData> selectedAddress = Rx(AddressData.empty());
  Rx<int> selectedAddressIndex = Rx(0);

  var jobId = "";
  var confirmFrom = "payment".obs;
  Rx<String> addressType = Rx('Home');
  Rx<bool> hideToolTip = Rx(false);
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController houseFlatController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  Rx<BitmapDescriptor> customMarkerIcon = Rx(BitmapDescriptor.defaultMarker);

  CityData selectedCity = CityData();
  LatLngBounds? cityBounds;

  @override
  void onInit() {
    super.onInit();
    _loadCustomMarkerIcon();
    getAddress();

    final value = sessionStorage.read(StorageKeys.selectedCity);
    if (value != null) {
      selectedCity = CityData.fromJson(value);
    }

    cityBounds = LatLngBounds(
      southwest: LatLng(
        double.tryParse(selectedCity.south ?? '0.0') ?? 0.0,
        double.tryParse(selectedCity.west ?? '0.0') ?? 0.0,
      ),
      northeast: LatLng(
        double.tryParse(selectedCity.north ?? '0.0') ?? 0.0,
        double.tryParse(selectedCity.east ?? '0.0') ?? 0.0,
      ), // Southwest corner of the city
    );

    currentLocation.value = getCityCenter(cityBounds!);
    selectedLocation.value = currentLocation.value;
  }

  LatLng getCityCenter(LatLngBounds cityBounds) {
    double centerLatitude =
        (cityBounds.northeast.latitude + cityBounds.southwest.latitude) / 2;
    double centerLongitude =
        (cityBounds.northeast.longitude + cityBounds.southwest.longitude) / 2;

    return LatLng(centerLatitude, centerLongitude);
  }

  @override
  void onClose() {
    super.onClose();
    streetController.dispose();
    cityController.dispose();
    searchController.dispose();
    houseFlatController.dispose();
  }

  Future<void> getAddress() async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        GetAddressRequest request = GetAddressRequest(
          userId: sessionStorage.read(StorageKeys.userId).toString(),
          cityId: selectedCity.cityId.toString(),
        );

        var addresses = await _getAddressUseCase.execute(request);

        addressList.value = addresses?.data ?? [];
        if (addressList.value.isNotNullOrEmpty) {
          selectedAddress.value = addressList.value.first;
          selectedAddressIndex.value = 0;
        }

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

  Future<void> deleteAddress() async {
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

        if (addresses?.success == true) {
          showToast('Address deleted successfully');
          //  getAddress();
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

  Future<void> confirmAddress() async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        ConfirmAddressRequest request = ConfirmAddressRequest(
          userId: sessionStorage.read(StorageKeys.userId).toString(),
          addressId: selectedAddress.value.addressId.toString(),
          jobId: jobId,
          status: 'confirmed',
        );

        var addresses = await _confirmAddressUseCase.execute(request);

        if (addresses?.success == true) {
          showToast('Address confirmed successfully');
          if (confirmFrom.value == 'payment') {
            Get.offAndToNamed(AppRoutes.mainScreen);
          } else {
            Get.back(result: true);
          }
        }

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

        AddressRequest request;

        if (selectedAddress.value.location.isNotNullOrEmpty) {
          request = AddressRequest(
            addressId: selectedAddress.value.addressId.toString(),
            addresslineOne: streetController.text,
            addresslineTwo: houseFlatController.text,
            location: cityController.text,
            addressType: addressType.value,
            lat: selectedLocation.value.longitude.toString(),
            lng: selectedLocation.value.latitude.toString(),
            cityId: selectedCity.cityId.toString(),
            userId: sessionStorage.read(StorageKeys.userId).toString(),
          );
        } else {
          request = AddressRequest(
            addresslineOne: streetController.text,
            addresslineTwo: houseFlatController.text,
            location: cityController.text,
            addressType: addressType.value,
            lat: selectedLocation.value.longitude.toString(),
            lng: selectedLocation.value.latitude.toString(),
            cityId: selectedCity.cityId.toString(),
            userId: sessionStorage.read(StorageKeys.userId).toString(),
          );
        }

        var services = await _saveAddressUseCase.execute(request);

        if (services != null && services.success == true) {
          clearAddressInfo();
          if (selectedAddress.value.location.isNotNullOrEmpty) {
            showToast('Address updated successfully');
            addressStatus.value = AddressStatus.updated;
          } else {
            showToast('Address added successfully');
            addressStatus.value = AddressStatus.saved;
          }

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
    searchController.clear();
    selectedAddress.value = AddressData.empty();
  }

  void _loadCustomMarkerIcon() async {}
}
