import 'package:customerapp/core/extensions/list_extensions.dart';
import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/domain/model/address/address_responds.dart';
import 'package:customerapp/presentation/address_screen/controller/address_controller.dart';
import 'package:customerapp/presentation/common_widgets/conditional_widget.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:customerapp/presentation/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/theme/app_text_style.dart';
import '../../core/utils/size_utils.dart';

class AddressScreen extends GetView<AddressController> {
  const AddressScreen({super.key});

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
            text: 'Add Address',
            onPressed: () {
              controller.cityController.text =
                  controller.selectedCity.cityName.toCapitalized;
              navigateAndFetchAddress('add');
            },
          ),
        ),
      ),
    );
  }

  Widget mobileView() {
    return Container(
        padding: getPadding(left: 16, top: 50, right: 16),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TitleBarWidget(title: "Address"),
              Obx(
                () => Flexible(
                  child: ConditionalWidget(
                    condition: controller.addressList.value.isNotNullOrEmpty,
                    onFalse: NotDataFound(
                      message: "No address yet, please add one.",
                      size: 150,
                      style: AppTextStyle.txtBold16,
                    ),
                    child: ListView.builder(
                      itemCount: controller.addressList.value.length,
                      itemBuilder: (context, index) {
                        var address = controller.addressList.value[index];
                        return AddressCardWidget(
                            data: address,
                            onTap: (type) {
                              controller.selectedAddress.value = address;
                              if (type == 'Edit') {
                                controller.cityController.text = controller
                                    .selectedCity.cityName.toCapitalized;

                                controller.typeAheadController.text =
                                    address.location.toCapitalized;
                                controller.streetController.text =
                                    address.addresslineOne.toCapitalized;
                                controller.houseFlatController.text =
                                    address.addresslineTwo.toCapitalized;
                                controller.addressType.value =
                                    address.addressType.toCapitalized;
                                controller.selectedLocation.value = LatLng(
                                  double.tryParse(address.lat ?? '0.0') ?? 0.0,
                                  double.tryParse(address.lng ?? '0.0') ?? 0.0,
                                );
                                controller.currentLocation.value = LatLng(
                                  double.tryParse(address.lat ?? '0.0') ?? 0.0,
                                  double.tryParse(address.lng ?? '0.0') ?? 0.0,
                                );

                                navigateAndFetchAddress('edit');
                              } else if (type == 'Delete') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Address'),
                                      content: Text(
                                          'Are you sure you want to delete this address?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Delete'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            controller.deleteAddress();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                controller.setAsPrimaryAddress();
                              }
                            });
                      },
                    ),
                  ),
                ),
              ),
            ]));
  }

  void navigateAndFetchAddress(String from) async {
    if (from == 'add') {
      controller.clearAddressInfo();
    }
    var result = await Get.toNamed(AppRoutes.addAddressScreen);
    controller.getAddress();
  }
}

class AddressCardWidget extends StatelessWidget {
  final AddressData data;
  final Function(String type) onTap;

  const AddressCardWidget({
    super.key,
    required this.data,
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
                    Text(data.addressType.toCapitalized ?? "",
                        style: AppTextStyle.txtBold16
                            .copyWith(color: AppColors.secondaryColor)),
                    Visibility(
                      visible: data.isPrimary ?? false,
                      child: Card(
                        elevation: 6,
                        color: AppColors.secondaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3),
                          child: Text(
                            "Primary",
                            style: AppTextStyle.txt10
                                .copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                ResponsiveText(
                    text:
                        "${data.addresslineOne.toCapitalized}, ${data.addresslineTwo.toCapitalized}",
                    style: AppTextStyle.txt14),
                const SizedBox(height: 3),
                Text(data.location.toCapitalized,
                    style:
                        AppTextStyle.txt14.copyWith(color: AppColors.darkGray)),
                const SizedBox(height: 5),
                Divider(
                  color: AppColors.tinyGray,
                  thickness: 0.3,
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            onTap('Edit');
                          },
                          child: Text(
                            "Edit",
                            style: AppTextStyle.txtBold14.copyWith(
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            onTap('Delete');
                          },
                          child: Text(
                            "Delete",
                            style: AppTextStyle.txtBold14.copyWith(
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        onTap('Primary');
                      },
                      child: Container(
                        height: 22,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        child: Text(
                          "Set as primary",
                          style: AppTextStyle.txt12
                              .copyWith(color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
