import 'package:customerapp/core/extensions/sheet_extension.dart';
import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/domain/model/service/service_details_responds.dart';
import 'package:customerapp/domain/model/service/tag_responds.dart';
import 'package:customerapp/presentation/common_widgets/conditional_widget.dart';
import 'package:customerapp/presentation/common_widgets/network_image_view.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:customerapp/presentation/main_screen/main_screen.dart';
import 'package:customerapp/presentation/services_screen/controller/service_controller.dart';
import 'package:customerapp/presentation/services_screen/widgets/service_booking_date_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';

class ServiceScreen extends GetView<ServiceController> {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Obx(
          () => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const TitleBarWidget(title: "Services"),
                const SizedBox(height: 30),
                Text(controller.categoryName.value.toString(),
                    style: AppTextStyle.txtBold16),
                const SizedBox(height: 10),
                Text(controller.categoryDescription.value.toString(),
                    style: AppTextStyle.txt12),
                const SizedBox(height: 20),
                ConditionalWidget(
                  condition: controller.tagData.value.isNotEmpty,
                  onFalse: const SizedBox.shrink(),
                  child: SizedBox(
                    height: 50,
                    child: ListView.builder(
                      itemCount: controller.tagData.value.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var tag = controller.tagData.value[index];
                        return BuildCategoryChip(
                            tag: tag,
                            onTap: (tagId) {
                              controller.getServiceByTagClick(tagId);
                            });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.3,
                  indent: 15,
                  endIndent: 25,
                ),
                ConditionalWidget(
                  condition: controller.serviceInfo.value.isNotEmpty,
                  onFalse: const Expanded(
                      child:
                          NotDataFound(message: 'No services available now')),
                  child: Expanded(
                    child: ListView.builder(
                      itemCount: controller.serviceInfo.value.length,
                      itemBuilder: (context, index) {
                        return ServiceCardWidget(
                            serviceData: controller.serviceInfo.value[index]);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

onTapLoginNavigation() {
  Get.toNamed(
    AppRoutes.serviceScreen,
  );
}

class BuildCategoryChip extends StatelessWidget {
  final TagData tag;

  final Function(String) onTap;

  const BuildCategoryChip({
    super.key,
    required this.tag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ChoiceChip(
        side: BorderSide(
          color: tag.isSelected ? Colors.white : Colors.grey,
          width: 0.5,
          style: BorderStyle.solid,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        elevation: 3,
        checkmarkColor: tag.isSelected ? Colors.white : Colors.grey[800],
        label: Text(tag.categoryTag ?? ''),
        selected: tag.isSelected,
        onSelected: (select) {
          if (select) {
            if (tag.categoryTag == 'All') {
              onTap("All").call();
            } else {
              onTap(tag.catTagId.toString()).call();
            }
          }
        },
        selectedColor: Colors.orange[300],
        backgroundColor: Colors.grey[200],
        labelStyle: TextStyle(
          color: tag.isSelected ? Colors.white : Colors.grey[800],
        ),
      ),
    );
  }
}

class ServiceCardWidget extends StatelessWidget {
  final ServiceData serviceData;

  const ServiceCardWidget({
    super.key,
    required this.serviceData,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceController>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Card(
        color: AppColors.whiteGray,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      ResponsiveText(
                          text: serviceData.name ?? '',
                          style: AppTextStyle.txtBold16),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          ResponsiveText(
                              text: '${serviceData.price ?? ''} Rs',
                              style: AppTextStyle.txtBold12),
                          const SizedBox(
                            width: 10,
                          ),
                          ResponsiveText(
                            text: '•  ${serviceData.maxWorkHours ?? ''} Hours',
                            style: AppTextStyle.txt12.copyWith(
                              color: AppColors.darkGray,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                  const SizedBox(width: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: NetworkImageView(
                      borderRadius: 12,
                      url: serviceData.logo,
                      width: 65,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                serviceData.description ?? '',
                style: AppTextStyle.txt12.copyWith(
                  color: AppColors.darkGray,
                ),
              ),
              const SizedBox(height: 15),
              NookCornerButton(
                outlinedColor: AppColors.primaryColor,
                textStyle: AppTextStyle.txtBoldWhite14,
                text: 'Book Now',
                height: 46,
                backGroundColor: AppColors.primaryColor,
                onPressed: () {
                  controller.timeSlots.value = [];
                  controller.selectedService.value = serviceData;
                  context.showBottomSheet(
                    body: ServiceBookingDateBottomSheet(
                      isFromSummery: false,
                      onDateSelected: (timeSlot) {
                        controller.selectedTime.value = timeSlot;
                      },
                      service: serviceData,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
