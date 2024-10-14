import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/network/connectivity_service.dart';
import 'package:customerapp/domain/model/address/address_request.dart';
import 'package:customerapp/domain/model/service/service_details_responds.dart';
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
  Rx<List<ServiceData>> serviceInfo = Rx([]);

  var addressStatus = AddressStatus.unknown.obs;

  final sessionStorage = GetStorage();
  GoogleMapController? mapController;
  Rx<LatLng> currentLocation = Rx(const LatLng(19.0760, 72.8777));
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
  }

  @override
  void onClose() {
    super.onClose();
    streetController.dispose();
    cityController.dispose();
    houseFlatController.dispose();
  }

  Future<void> getAddress(
    String categoryId,
  ) async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        var services = await _getAddressUseCase.execute(categoryId);
        //  serviceInfo.value = services?.data ?? [];

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

  Future<void> saveAddress(
    String categoryId,
  ) async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        AddressRequest request = AddressRequest(
            hoseFlat: houseFlatController.text,
            street: streetController.text,
            city: cityController.text,
            addressType: addressType.value,
            latitude: currentLocation.value.longitude.toString(),
            longitude: currentLocation.value.latitude.toString());

        var services = await _saveAddressUseCase.execute(request);
        //  serviceInfo.value = services?.data ?? [];

        addressStatus.value = AddressStatus.saved;

        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
        e.printInfo();
      }
    } else {
      showToast(LocalizationKeys.noNetwork.tr);
    }
  }

  void _loadCustomMarkerIcon() async {}
}
