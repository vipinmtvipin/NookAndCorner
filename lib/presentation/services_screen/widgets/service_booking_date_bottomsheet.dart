import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/domain/model/service/service_details_responds.dart';
import 'package:customerapp/domain/model/service/time_slote_responds.dart';
import 'package:customerapp/presentation/common_widgets/conditional_widget.dart';
import 'package:customerapp/presentation/common_widgets/custom_icon_button.dart';
import 'package:customerapp/presentation/common_widgets/network_image_view.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:customerapp/presentation/services_screen/controller/service_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ServiceBookingDateBottomSheet extends GetView<ServiceController> {
  final Function(TimeSlotData date) onDateSelected;
  final ServiceData service;

  const ServiceBookingDateBottomSheet({
    super.key,
    required this.service,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        height:
            (controller.serviceStatus.value == ServiceStatus.dateDataLoaded &&
                    controller.timeSlots.value.isNotEmpty)
                ? 460.0
                : 200.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Choose your booking date',
              textAlign: TextAlign.center,
              style: AppTextStyle.txtBold18,
            ),
            const SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(color: AppColors.darkGray),
                          hintText: controller.selectedDateValue.value,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: AppColors.black,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    CustomIconButton(
                        height: 40,
                        width: 40,
                        onTap: () {
                          Get.back();
                        },
                        alignment: Alignment.topLeft,
                        shape: IconButtonShape.CircleBorder35,
                        child: const Icon(
                          Icons.refresh,
                          size: 25,
                          color: AppColors.white,
                        )),
                  ],
                ),
                const SizedBox(height: 16),
                ConditionalWidget(
                  condition: (controller.serviceStatus.value ==
                          ServiceStatus.dateDataLoaded &&
                      controller.timeSlots.value.isNotEmpty),
                  onFalse: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 20),
                      child: ResponsiveText(
                        text: 'No slots available for the selected date',
                        style: AppTextStyle.txtBold12.copyWith(
                          color: Colors.grey,
                        ),
                      )),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              mainAxisExtent: 35,
                            ),
                            itemCount: controller.timeSlots.value.length,
                            itemBuilder: (context, index) {
                              var item = controller.timeSlots.value[index];
                              return GestureDetector(
                                onTap: () {
                                  onDateSelected(item);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    DateFormat('hh:mm aa')
                                        .format(item.slotStart!),
                                    style: AppTextStyle.txt14,
                                  ),
                                ),
                              );
                            }),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Golden Hour may incur an additional service cost. See details before proceeding.',
                        style: TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      NookCornerButton(
                        outlinedColor: AppColors.primaryColor,
                        textStyle: AppTextStyle.txtBoldWhite14,
                        text: 'Confirm and Proceed',
                        backGroundColor: AppColors.primaryColor,
                        onPressed: () {},
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      );
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != controller.selectedDate.value) {
      controller.dateSelected(service, picked);
    }
  }
}

class CityCard extends StatelessWidget {
  final String? image;
  final String? label;

  const CityCard({super.key, required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NetworkImageView(
              url: image,
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            Text(
              label ?? '',
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.txt12,
            ),
          ],
        ),
      ),
    );
  }
}
