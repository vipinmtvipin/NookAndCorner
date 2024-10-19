import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/presentation/address_screen/controller/address_controller.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_text_field.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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
        body: mobileView(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: NookCornerButton(
            text: 'Save Address',
            onPressed: () {
              Get.back();
            },
          ),
        ),
      ),
    );
  }

  Widget mobileView() {
    return Obx(
      () => Container(
          padding: getPadding(left: 16, top: 50, right: 16),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const TitleBarWidget(title: "Add Address"),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 280,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: controller.currentLocation.value,
                          zoom: 14.0,
                        ),
                        onMapCreated: (mController) {
                          controller.mapController = mController;
                        },
                        markers: {
                          Marker(
                            markerId: const MarkerId('currentLocation'),
                            icon: controller.customMarkerIcon.value,
                            position: controller.currentLocation.value,
                            draggable: true,
                            infoWindow: !controller.hideToolTip.value
                                ? InfoWindow(
                                    title: 'Click and Drag',
                                    snippet: 'Long press to move',
                                    onTap: () {
                                      controller.hideToolTip.value =
                                          !controller.hideToolTip.value;
                                    },
                                  )
                                : InfoWindow.noText,
                            onDragEnd: (newPosition) {
                              _updateLocation(newPosition);
                            },
                            onTap: () {
                              controller.hideToolTip.value =
                                  !controller.hideToolTip.value;
                            },
                          ),
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  NookCornerTextField(
                    textInputAction: TextInputAction.next,
                    controller: controller.cityController,
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
                ]),
          )),
    );
  }

  void _updateLocation(LatLng newPosition) async {
    controller.currentLocation.value = newPosition;
    // Get the new address based on the location
    List<Placemark> placeMarks = await placemarkFromCoordinates(
        newPosition.latitude, newPosition.longitude);
    if (placeMarks.isNotEmpty) {
      controller.cityController.text = placeMarks.first.locality ?? "";
      controller.streetController.text = placeMarks.first.street ?? "";
    }
  }
}

class AddressCardWidget extends StatelessWidget {
  final String label;
  final Function() onTap;

  const AddressCardWidget({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: const Border(
              left: BorderSide(
                color: Colors.green, // Set the color of the border
                width: 2.0, // Set the width of the border
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Home",
                        style: AppTextStyle.txtBold16
                            .copyWith(color: AppColors.secondaryColor)),
                    SizedBox(
                      height: 30,
                      child: Checkbox(
                        value: true,
                        onChanged: (selected) {},
                        activeColor: AppColors.primaryColor,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 2),
                Text("Flat Infos...", style: AppTextStyle.txt14),
                const SizedBox(height: 2),
                Text("Details",
                    style: AppTextStyle.txt14
                        .copyWith(color: AppColors.lightGray)),
              ],
            ),
          ),
        ));
  }
}
