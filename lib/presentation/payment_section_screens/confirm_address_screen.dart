import 'package:customerapp/core/extensions/date_time_extensions.dart';
import 'package:customerapp/core/extensions/list_extensions.dart';
import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/domain/model/account/profile_response.dart';
import 'package:customerapp/domain/model/address/address_responds.dart';
import 'package:customerapp/presentation/account_screen/controller/account_controller.dart';
import 'package:customerapp/presentation/address_screen/controller/address_controller.dart';
import 'package:customerapp/presentation/common_widgets/conditional_widget.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:customerapp/presentation/main_screen/main_screen.dart';
import 'package:customerapp/presentation/my_job_screen/controller/mybooking_controller.dart';
import 'package:customerapp/presentation/services_screen/controller/service_controller.dart';
import 'package:customerapp/presentation/summery_screen/summery_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/theme/app_text_style.dart';
import '../../core/utils/size_utils.dart';

class ConfirmAddressScreen extends GetView<AddressController> {
  const ConfirmAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;
    controller.confirmFrom.value = arguments['from'] ?? '';
    controller.jobId = arguments['jobId'] ?? '';
    var serviceName = '';
    double advanceAmount = 0.0;
    var serviceDate = '';
    var isFromService = false;

    if (controller.confirmFrom.value == 'payment') {
      ServiceController mController = Get.find<ServiceController>();
      serviceName = mController.selectedService.value.name ?? '';
      advanceAmount = mController.advanceAmount.value ?? 0.0;
      serviceDate =
          "${mController.selectedDateValue.value} ${mController.selectedTime.value}";
    } else if (controller.confirmFrom.value == 'profile') {
    } else {
      MyBookingController mController = Get.find<MyBookingController>();
      serviceName =
          mController.selectedJob.value.servicePrice?.service?.category?.name ??
              '';
      advanceAmount = mController.advanceAmount.value ?? 0.0;
      advanceAmount = mController.advanceAmount.value ?? 0.0;
      serviceDate =
          mController.selectedJob.value.jobDate?.convertUtcToIst() ?? '';
    }
    if (controller.addressList.value.isNullOrEmpty) {
      controller.getAddress();
    }
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Container(
            padding: getPadding(left: 16, top: 50, right: 16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TitleBarWidget(
                      onBack: () {
                        if (controller.confirmFrom.value == 'payment') {
                          Get.offAndToNamed(AppRoutes.mainScreen);
                        }
                      },
                      title: controller.confirmFrom.value == 'profile'
                          ? 'Update Address'
                          : "Confirm Address"),
                  SizedBox(height: 5),
                  Obx(
                    () => Flexible(
                      child: ConditionalWidget(
                        condition:
                            controller.addressList.value.isNotNullOrEmpty,
                        onFalse: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            NotDataFound(
                              message: "No address yet, please add one.",
                              size: 150,
                              style: AppTextStyle.txtBold16,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: NookCornerButton(
                                type: NookCornerButtonType.outlined,
                                text: 'Add Address',
                                onPressed: () {
                                  controller.selectedAddress.value =
                                      AddressData.empty();
                                  navigateAndFetchAddress();
                                },
                              ),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          itemCount: controller.addressList.value.length,
                          itemBuilder: (context, index) {
                            var address = controller.addressList.value[index];
                            return GestureDetector(
                              onTap: () {
                                controller.selectedAddress.value = address;
                                controller.selectedAddressIndex.value = index;

                                if (controller.confirmFrom.value == 'profile') {
                                  AccountController mController =
                                      Get.find<AccountController>();
                                  mController.updatedAddressId =
                                      address.addressId.toString();
                                  mController.primaryAddress.value =
                                      PrimaryAddress(
                                    addressId: address.addressId,
                                    addressType: address.addressType,
                                    addresslineOne: address.addresslineOne,
                                    addresslineTwo: address.addresslineTwo,
                                    location: address.location,
                                    lat: address.lat,
                                    lng: address.lng,
                                    name: address.name,
                                    userId: address.userId,
                                    delete: address.delete,
                                    addressName: address.addressName,
                                    address: address.address,
                                    cityId: address.cityId,
                                    createdAt: address.createdAt,
                                    updatedAt: address.updatedAt,
                                  );
                                  Get.back(result: true);
                                }
                              },
                              child: AddressCardWidget(
                                  index: index,
                                  data: address,
                                  onTap: (type) {
                                    controller.selectedAddress.value = address;
                                    if (type == 'Edit') {
                                      controller.cityController.text =
                                          address.location.toCapitalized;
                                      controller.streetController.text =
                                          address.addresslineOne.toCapitalized;
                                      controller.houseFlatController.text =
                                          address.addresslineTwo.toCapitalized;
                                      controller.addressType.value =
                                          address.addressType.toCapitalized;
                                      controller.selectedLocation.value =
                                          LatLng(
                                        double.tryParse(address.lat ?? '0.0') ??
                                            0.0,
                                        double.tryParse(address.lng ?? '0.0') ??
                                            0.0,
                                      );
                                      controller.currentLocation.value = LatLng(
                                        double.tryParse(address.lat ?? '0.0') ??
                                            0.0,
                                        double.tryParse(address.lng ?? '0.0') ??
                                            0.0,
                                      );
                                      navigateAndFetchAddress();
                                    } else {
                                      //  controller.deleteAddress();
                                    }
                                  }),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  // Payment Summary Section
                  const SizedBox(height: 20),
                  Visibility(
                    visible: controller.confirmFrom.value != 'profile',
                    child: Column(
                      children: [
                        Text(
                          serviceName,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.txtBold16.copyWith(
                            letterSpacing: getHorizontalSize(
                              3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        PaymentSummaryRow(
                          title: 'Advance Amount',
                          value: advanceAmount.toString(),
                          isBold: false,
                          valueColor: AppColors.black,
                        ),
                        PaymentSummaryRow(
                            title: 'Service On', value: serviceDate),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ])),
        bottomNavigationBar: controller.confirmFrom.value != 'profile'
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: NookCornerButton(
                  text: 'Confirm Address',
                  onPressed: () {
                    if (controller.addressList.value.isNotNullOrEmpty) {
                      controller.confirmAddress();
                    } else {
                      "Please choose address".showToast();
                    }
                  },
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  void navigateAndFetchAddress() async {
    var result = await Get.toNamed(AppRoutes.addAddressScreen);
    controller.selectedAddress.value = AddressData.empty();
    controller.getAddress();
  }
}

class AddressCardWidget extends StatelessWidget {
  final AddressData data;
  final Function(String type) onTap;
  final int index;

  const AddressCardWidget({
    super.key,
    required this.data,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final AddressController controller = Get.find<AddressController>();
    return Obx(
      () => Card(
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
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
                          visible:
                              index == controller.selectedAddressIndex.value,
                          child: SizedBox(
                            height: 30,
                            child: Checkbox(
                              checkColor: AppColors.white,
                              fillColor: WidgetStateProperty.resolveWith(
                                  (states) => AppColors.success),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    color: AppColors.success, width: 1),
                              ),
                              value: true,
                              onChanged: (selected) {},
                              activeColor: AppColors.primaryColor,
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 2),
                  ResponsiveText(
                      text:
                          "${data.addresslineOne.toCapitalized}, ${data.addresslineTwo.toCapitalized}",
                      style: AppTextStyle.txt14),
                  const SizedBox(height: 3),
                  Text(data.location.toCapitalized,
                      style: AppTextStyle.txt14
                          .copyWith(color: AppColors.darkGray)),
                  const SizedBox(height: 5),
                  Divider(
                    color: AppColors.tinyGray,
                    thickness: 0.3,
                  ),
                  const SizedBox(height: 5),
                  InkWell(
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
                ],
              ),
            ),
          )),
    );
  }
}
