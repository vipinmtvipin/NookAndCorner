import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/utils/common_util.dart';
import 'package:customerapp/presentation/address_screen/controller/address_controller.dart';
import 'package:customerapp/presentation/address_screen/google_place_service.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_text_field.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/theme/app_text_style.dart';
import '../../core/utils/size_utils.dart';

class AddAddressScreen extends GetView<AddressController> {
  const AddAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: mobileView(context),
      ),
    );
  }

  Widget mobileView(BuildContext context) {
    return Obx(
      () => Container(
          padding: getPadding(left: 16, top: 50, right: 16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitleBarWidget(
                  title:
                      controller.selectedAddress.value.location.isNotNullOrEmpty
                          ? 'Address Details'
                          : 'Add Address',
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 280,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GoogleMap(
                          tiltGesturesEnabled: true,
                          rotateGesturesEnabled: true,
                          scrollGesturesEnabled: true,
                          zoomControlsEnabled: true,
                          zoomGesturesEnabled: true,
                          initialCameraPosition: CameraPosition(
                            target: controller.currentLocation.value,
                            zoom: 16.0,
                          ),
                          onMapCreated: (mController) {
                            controller.mapController = mController;
                            // Move the camera to fit the city bounds
                            if (controller
                                .selectedAddress.value.location.isNullOrEmpty) {
                              controller.mapController?.moveCamera(
                                  CameraUpdate.newLatLngBounds(
                                      controller.cityBounds!, 0));
                            } else {
                              controller.mapController?.animateCamera(
                                  CameraUpdate.newLatLngZoom(
                                      controller.currentLocation.value, 15));
                            }
                          },
                          // Restrict the camera movement to the city bounds
                          cameraTargetBounds:
                              CameraTargetBounds(controller.cityBounds),
                          minMaxZoomPreference: MinMaxZoomPreference(10, 20),
                          markers: {
                            Marker(
                              markerId: const MarkerId('currentLocation'),
                              icon: controller.customMarkerIcon.value,
                              position: controller.currentLocation.value,
                              draggable: true,
                              onDrag: (newPosition) {
                                _moveCameraToPosition(newPosition);
                              },
                              onDragEnd: (newPosition) {
                                if (isWithinBounds(
                                    newPosition, controller.cityBounds!)) {
                                  _updateLocation(newPosition);
                                } else {
                                  Get.snackbar(
                                    'Warning',
                                    'Marker must stay within the city bounds.',
                                    backgroundColor: Colors.black,
                                    colorText: Colors.white,
                                    icon: const Icon(Icons.error,
                                        color: Colors.white),
                                  );
                                  controller.mapController?.animateCamera(
                                      CameraUpdate.newLatLng(
                                          controller.currentLocation.value));
                                }
                              },
                              onTap: () {
                                controller.hideToolTip.value =
                                    !controller.hideToolTip.value;
                              },
                            ),
                          },
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        right: 10,
                        child: InkWell(
                          onTap: () {
                            // getPlaceDetails(context);
                          },
                          child: PlaceSearchScreen(),

                          /*     TextField(
                            controller: controller.searchController,
                            decoration: InputDecoration(
                              hintText: 'Search for your location',
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.all(10),
                            ),
                            readOnly: true,
                            enabled: false,
                          ),*/
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        NookCornerTextField(
                          textInputAction: TextInputAction.next,
                          controller: controller.cityController,
                          enabled: false,
                          title: 'City',
                          textStyle: AppTextStyle.txt16,
                          type: NookCornerTextFieldType.email,
                          isFormField: true,
                          validator: (value) {
                            return null;
                          },
                          autoValidate: true,
                        ),
                        NookCornerTextField(
                          textInputAction: TextInputAction.next,
                          controller: controller.streetController,
                          title: 'Street',
                          textStyle: AppTextStyle.txt16,
                          type: NookCornerTextFieldType.email,
                          isFormField: true,
                          validator: (value) {
                            return null;
                          },
                          autoValidate: true,
                        ),
                        NookCornerTextField(
                          textInputAction: TextInputAction.done,
                          controller: controller.houseFlatController,
                          title: 'House/Flat',
                          textStyle: AppTextStyle.txt16,
                          type: NookCornerTextFieldType.email,
                          isFormField: true,
                          validator: (value) {
                            return null;
                          },
                          autoValidate: true,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: RadioListTile<String>(
                                title: const Text('Home'),
                                value: 'Home',
                                groupValue: controller.addressType.value,
                                onChanged: (value) {
                                  controller.addressType.value = value!;
                                },
                              ),
                            ),
                            Flexible(
                              child: RadioListTile<String>(
                                title: const Text('Office'),
                                value: 'Office',
                                groupValue: controller.addressType.value,
                                onChanged: (value) {
                                  controller.addressType.value = value!;
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: NookCornerButton(
                            text: controller.selectedAddress.value.location
                                    .isNotNullOrEmpty
                                ? 'Update Address'
                                : 'Save Address',
                            onPressed: () {
                              if (controller.cityController.text.isEmpty ||
                                  controller.streetController.text.isEmpty ||
                                  controller.houseFlatController.text.isEmpty) {
                                Get.snackbar(
                                    'Error', 'Please fill all the fields',
                                    backgroundColor: Colors.black,
                                    colorText: Colors.white,
                                    icon: const Icon(
                                      Icons.error,
                                      color: Colors.white,
                                    ));
                                return;
                              }
                              controller.saveAddress();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ])),
    );
  }

  void _moveCameraToPosition(LatLng newPosition) {
    controller.mapController?.animateCamera(
      CameraUpdate.newLatLng(newPosition),
    );
  }

  void _updateLocation(LatLng newPosition) async {
    controller.currentLocation.value = newPosition;
    controller.selectedLocation.value = newPosition;
    // Get the new address based on the location
    List<geo.Placemark> placeMarks = await geo.placemarkFromCoordinates(
        newPosition.latitude, newPosition.longitude);
    if (placeMarks.isNotEmpty) {
      controller.cityController.text = placeMarks.first.locality ?? "";
    }
  }

  Future<void> getPlaceDetails(BuildContext context) async {
    LatLng searchCity = controller.getCityCenter(controller.cityBounds!);

    Prediction? prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: "AIzaSyCEpnfYtpqPQ8oWZXBrMdRKJYC0cTn9mH0",
      mode: Mode.overlay,
      language: "en",
      components: [
        Component(Component.country, "IN"),
      ],
    );

    if (prediction != null) {
      GoogleMapsPlaces places =
          GoogleMapsPlaces(apiKey: "AIzaSyCEpnfYtpqPQ8oWZXBrMdRKJYC0cTn9mH0");
      PlacesDetailsResponse detail =
          await places.getDetailsByPlaceId(prediction.placeId!);

      final double lat = detail.result.geometry!.location.lat;
      final double lng = detail.result.geometry!.location.lng;

      LatLng location = LatLng(lat, lng);

      if (isWithinBounds(location, controller.cityBounds!)) {
        controller.searchController.text = prediction.description!;
        controller.searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: prediction.description!.length));

        controller.cityController.text = prediction.description!;
        controller.selectedLocation.value = location;
        controller.currentLocation.value = location;

        controller.mapController
            ?.animateCamera(CameraUpdate.newLatLngZoom(location, 15));
      } else {
        Get.snackbar('Warning', 'Please select location within city bounds',
            backgroundColor: Colors.black,
            colorText: Colors.white,
            icon: const Icon(
              Icons.error,
              color: Colors.white,
            ));
        return;
      }
    }
  }

  bool isWithinBounds(LatLng location, LatLngBounds bounds) {
    return location.latitude >= bounds.southwest.latitude &&
        location.latitude <= bounds.northeast.latitude &&
        location.longitude >= bounds.southwest.longitude &&
        location.longitude <= bounds.northeast.longitude;
  }
}

class PlaceSearchScreen extends StatefulWidget {
  const PlaceSearchScreen({super.key});

  @override
  PlaceSearchScreenState createState() => PlaceSearchScreenState();
}

class PlaceSearchScreenState extends State<PlaceSearchScreen> {
  final TextEditingController _typeAheadController = TextEditingController();
  late GooglePlacesService _placesService;

  AddressController controller = Get.find<AddressController>();

  @override
  void initState() {
    super.initState();
    _placesService =
        GooglePlacesService('AIzaSyCEpnfYtpqPQ8oWZXBrMdRKJYC0cTn9mH0');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 4),
      child: TypeAheadField(
        controller: _typeAheadController,
        builder: (context, controller, focusNode) {
          return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white, // White background
                hintText: 'Search Place',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0), // Curved corners
                  borderSide: BorderSide.none, // No outer border
                ),
              ));
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion.address ?? ''),
          );
        },
        suggestionsCallback: (pattern) async {
          if (pattern.isEmpty) return [];

          return await _placesService.fetchPlaceSuggestions(
              pattern, controller.cityBounds);
        },
        onSelected: (suggestion) async {
          CommonUtil().keyboardHide(Get.context!);

          setState(() {
            _typeAheadController.text = suggestion.address ?? '';
            controller.cityController.text = suggestion.address ?? '';
            LatLng location = LatLng(suggestion.latitude ?? '19.0760',
                suggestion.longitude ?? '72.8777');
            controller.selectedLocation.value = location;
            controller.currentLocation.value = location;

            controller.mapController
                ?.animateCamera(CameraUpdate.newLatLngZoom(location, 15));
          });
        },
      ),
    );
  }
}
