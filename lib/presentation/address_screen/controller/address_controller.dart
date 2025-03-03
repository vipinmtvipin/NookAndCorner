import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/extensions/bool_extension.dart';
import 'package:customerapp/core/extensions/list_extensions.dart';
import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/network/connectivity_service.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:customerapp/domain/model/address/address_request.dart';
import 'package:customerapp/domain/model/address/address_responds.dart';
import 'package:customerapp/domain/model/home/city_responds.dart';
import 'package:customerapp/domain/usecases/address/confirm_address_use_case.dart';
import 'package:customerapp/domain/usecases/address/delete_address_use_case.dart';
import 'package:customerapp/domain/usecases/address/get_address_use_case.dart';
import 'package:customerapp/domain/usecases/address/primary_address_use_case.dart';
import 'package:customerapp/domain/usecases/address/save_addrress_use_case.dart';
import 'package:customerapp/presentation/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

enum AddressStatus {
  unknown,
  loaded,
  saved,
  updated,
}

class AddressController extends BaseController {
  final SaveAddressUseCase _saveAddressUseCase;
  final GetAddressUseCase _getAddressUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;
  final PrimaryAddressUseCase _primaryAddressUseCase;
  final ConfirmAddressUseCase _confirmAddressUseCase;

  AddressController(
    this._getAddressUseCase,
    this._saveAddressUseCase,
    this._confirmAddressUseCase,
    this._deleteAddressUseCase,
    this._primaryAddressUseCase,
  );

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

  bool searchEnteringTime = true;

  final TextEditingController typeAheadController = TextEditingController();
  Rx<BitmapDescriptor> customMarkerIcon = Rx(BitmapDescriptor.defaultMarker);

  CityData selectedCity = CityData();
  Rx<LatLngBounds> cityBounds = Rx(LatLngBounds(
    southwest: LatLng(19.0760, 72.8777),
    northeast: LatLng(19.1760, 72.9777),
  ));

  @override
  void onInit() {
    super.onInit();
    settingSelectedCityInfo();
    getAddress();
  }

  @override
  void onReady() {
    super.onReady();
    //  _requestMultiplePermissions();
  }

  Future<void> _requestMultiplePermissions() async {
    // List of permissions to request
    final Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();

    /*    var isPermanentlyDenied =
        statuses.values.any((status) => status.isPermanentlyDenied);
    var isDenied = statuses.values.any((status) => status.isDenied);
    if (isPermanentlyDenied || isDenied) {
      _showPermissionDialogWithSettings(
        'Permissions Required',
        'Please allow the required permissions to continue using the app.',
      );
    }*/
  }

  void _showPermissionDialogWithSettings(String title, String message) {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
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
    // cityController.dispose();
    searchController.dispose();
    houseFlatController.dispose();
    typeAheadController.dispose();
  }

  Future<void> getAddress({bool addressUpdate = false}) async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();
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
        if (addressList.value.isNotNullOrEmpty) {
          addressList.value.firstWhere((element) {
            if (addressUpdate.absolute) {
              selectedAddress.value = addressList.value.last;
              selectedAddressIndex.value = addressList.value.length - 1;
              return true;
            } else if (element.isPrimary == true) {
              selectedAddress.value = element;
              selectedAddressIndex.value = addressList.value.indexOf(element);
              return true;
            }
            selectedAddress.value = addressList.value.first;
            selectedAddressIndex.value = 0;
            return false;
          });
        }

        addressStatus.value = AddressStatus.loaded;

        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
        e.printInfo();
      }
    } else {
      showOpenSettings();
    }
  }

  Future<void> deleteAddress() async {
    if (await _connectivityService.isConnected()) {
      try {
        if (selectedAddress.value.isPrimary.absolute) {
          showToast('Primary address cannot be deleted');
          return;
        }
        showLoadingDialog();
        ConfirmAddressRequest request = ConfirmAddressRequest(
          userId: sessionStorage.read(StorageKeys.userId).toString(),
          addressId: selectedAddress.value.addressId.toString(),
          jobId: jobId,
          status: 'delete',
        );

        var addresses = await _deleteAddressUseCase.execute(request);

        if (addresses?.success == true) {
          getAddress();
          showToast('Address deleted successfully');
        }

        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
        showServerErrorAlert(() {
          deleteAddress();
        });
      }
    } else {
      showOpenSettings();
    }
  }

  Future<void> setAsPrimaryAddress() async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        ConfirmAddressRequest request = ConfirmAddressRequest(
          userId: sessionStorage.read(StorageKeys.userId).toString(),
          addressId: selectedAddress.value.addressId.toString(),
          jobId: jobId,
          status: 'primary',
        );

        var addresses = await _primaryAddressUseCase.execute(request);

        if (addresses?.success == true) {
          getAddress();
        }

        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
        showServerErrorAlert(() {
          setAsPrimaryAddress();
        });
      }
    } else {
      showOpenSettings();
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
            Get.offNamedUntil(AppRoutes.myBookingScreen, (route) => false);
            sessionStorage.write(StorageKeys.from, 'payment');
          } else {
            Get.back(result: true);
          }
        }

        addressStatus.value = AddressStatus.loaded;

        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
        showServerErrorAlert(() {
          confirmAddress();
        });
      }
    } else {
      showOpenSettings();
    }
  }

  Future<void> saveAddress() async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        final value = sessionStorage.read(StorageKeys.selectedCity);
        if (value != null) {
          selectedCity = CityData.fromJson(value);
        }

        AddressRequest request;

        if (selectedAddress.value.addressId.toString().isNotNullOrEmpty &&
            selectedAddress.value.addressId != 0 &&
            selectedAddress.value.addressId != null &&
            selectedAddress.value.addressId.toString().toLowerCase() !=
                'null') {
          request = AddressRequest(
            addressId: selectedAddress.value.addressId.toString(),
            addresslineOne: streetController.text,
            addresslineTwo: houseFlatController.text,
            location: typeAheadController.text,
            addressType: addressType.value,
            lat: selectedLocation.value.latitude.toString(),
            lng: selectedLocation.value.longitude.toString(),
            cityId: selectedCity.cityId.toString(),
            userId: sessionStorage.read(StorageKeys.userId).toString(),
          );
        } else {
          request = AddressRequest(
            addresslineOne: streetController.text,
            addresslineTwo: houseFlatController.text,
            location: typeAheadController.text,
            addressType: addressType.value,
            lat: selectedLocation.value.latitude.toString(),
            lng: selectedLocation.value.longitude.toString(),
            cityId: selectedCity.cityId.toString(),
            userId: sessionStorage.read(StorageKeys.userId).toString(),
          );
        }

        var services = await _saveAddressUseCase.execute(request);

        if (services != null && services.success == true) {
          if (selectedAddress.value.addressId.toString().isNotNullOrEmpty &&
              selectedAddress.value.addressId != 0 &&
              selectedAddress.value.addressId != null &&
              selectedAddress.value.addressId.toString().toLowerCase() !=
                  'null') {
            showToast('Address updated successfully');
            addressStatus.value = AddressStatus.updated;
          } else {
            showToast('Address added successfully');
            addressStatus.value = AddressStatus.saved;
          }
          clearAddressInfo();

          Get.back(result: true);
        }

        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
        showServerErrorAlert(() {
          saveAddress();
        });
      }
    } else {
      showOpenSettings();
    }
  }

  void clearAddressInfo() {
    streetController.clear();
    // cityController.clear();
    houseFlatController.clear();
    searchController.clear();
    typeAheadController.clear();
    selectedAddress.value = AddressData.empty();
  }

  void settingSelectedCityInfo() {
    final value = sessionStorage.read(StorageKeys.selectedCity);
    if (value != null) {
      selectedCity = CityData.fromJson(value);

      cityController.text = selectedCity.cityName ?? '';
    }

    var south = double.tryParse(selectedCity.south ?? '0.0') ?? 0.0;
    var west = double.tryParse(selectedCity.west ?? '0.0') ?? 0.0;
    var north = double.tryParse(selectedCity.north ?? '0.0') ?? 0.0;
    var east = double.tryParse(selectedCity.east ?? '0.0') ?? 0.0;

    cityBounds.value = LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east), // Southwest corner of the city
    );

    Logger.e('cityBounds--------', 'cityBounds: $cityBounds');

    currentLocation.value = getCityCenter(cityBounds.value);
    selectedLocation.value = currentLocation.value;
  }
}
