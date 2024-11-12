import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/domain/model/my_jobs/my_job_responds.dart';
import 'package:customerapp/presentation/common_widgets/conditional_widget.dart';
import 'package:customerapp/presentation/common_widgets/custom_icon_button.dart';
import 'package:customerapp/presentation/common_widgets/network_image_view.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:customerapp/presentation/my_job_screen/controller/mybooking_controller.dart';
import 'package:customerapp/presentation/services_screen/controller/service_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RescheduleBookingDateBottomSheet extends GetView<MyBookingController> {
  final Function(String) onDateSelected;
  final MyJobData service;

  const RescheduleBookingDateBottomSheet({
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
                ? 470.0
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
                          controller.selectedDate.value = DateTime.now();
                          controller.selectedDateValue.value = 'Select Date';
                          controller.selectedTime.value = '';
                          controller.timeSlots.value = [];
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
                        height: 210,
                        child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              mainAxisExtent: 36,
                            ),
                            itemCount: controller.timeSlots.value.length,
                            itemBuilder: (context, index) {
                              var item = controller.timeSlots.value[index];
                              return GestureDetector(
                                onTap: () {
                                  var updatedData =
                                      controller.timeSlots.value.map((element) {
                                    if (element.slotStart == item.slotStart) {
                                      return element.copyWith(isSelected: true);
                                    } else {
                                      return element.copyWith(
                                          isSelected: false);
                                    }
                                  }).toList();

                                  controller.timeSlots.value = updatedData;

                                  onDateSelected(
                                    DateFormat('hh:mm aa')
                                        .format(item.slotStart!),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      margin:
                                          controller.isAfter6PM(item.slotStart)
                                              ? const EdgeInsets.only(
                                                  top: 10.0, right: 5)
                                              : const EdgeInsets.all(0),
                                      padding: const EdgeInsets.all(1.0),
                                      decoration: BoxDecoration(
                                        color: controller
                                                .isAfter6PM(item.slotStart)
                                            ? AppColors.secondaryColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: (item.isSelected ?? false)
                                              ? (controller.isAfter6PM(
                                                      item.slotStart)
                                                  ? AppColors.green
                                                  : AppColors.secondaryColor)
                                              : Colors.grey,
                                          width: (item.isSelected ?? false)
                                              ? 2
                                              : 1,
                                        ),
                                      ),
                                      child: Text(
                                        DateFormat('hh:mm aa')
                                            .format(item.slotStart!),
                                        style: controller
                                                .isAfter6PM(item.slotStart)
                                            ? AppTextStyle.txtWhite12
                                            : AppTextStyle.txt12,
                                      ),
                                    ),
                                    ConditionalWidget(
                                      condition:
                                          controller.isAfter6PM(item.slotStart),
                                      onFalse: const SizedBox.shrink(),
                                      child: Positioned(
                                        right: 0,
                                        top: 5,
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 10,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                          child: Text(
                                            'Extra',
                                            style: AppTextStyle.txtWhite6,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
                        text: 'Update',
                        backGroundColor: AppColors.primaryColor,
                        onPressed: () {
                          Get.back();
                          controller.reScheduleJob();
                        },
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
    DateTime firstDate = DateTime.now().add(Duration(days: 1));
    DateTime initialDate = controller.selectedDate.value.isBefore(firstDate)
        ? firstDate
        : controller.selectedDate.value;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2101),
    );
    if (picked != null) {
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
