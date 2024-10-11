import 'package:customerapp/core/extensions/sheet_extension.dart';
import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const TitleBarWidget(title: "Services"),
              const SizedBox(height: 25),
              Text('Deep Cleaning', style: AppTextStyle.txtBold18),
              const SizedBox(height: 8),
              Text(
                  'Deep cleaning is a thorough and detailed cleaning of your entire home. It includes all the standard cleaning tasks, plus an additional focus on areas typically not covered in a regular cleaning, such as cleaning under appliances, inside the oven and fridge, washing baseboards, and more.',
                  style: AppTextStyle.txt14),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  itemCount: 3,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return const BuildCategoryChip(
                        label: 'All', isSelected: false);
                  },
                ),
              ),
              const SizedBox(height: 5),
              const Divider(
                color: Colors.grey,
                thickness: 0.3,
                indent: 15,
                endIndent: 25,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        context.showBottomSheet(
                          body: ServiceBookingDateBottomSheet(
                            dates: [],
                            onDateSelected: (city) {},
                          ),
                        );
                      },
                      child: ServiceCardWidget(
                        iconData: Icons.info,
                        label: "About us",
                        onTap: () {},
                      ),
                    );
                  },
                ),
              ),
            ],
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
  final String label;
  final bool isSelected;

  const BuildCategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ChoiceChip(
        side: BorderSide(
          color: isSelected ? Colors.white : Colors.grey,
          width: 0.1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        label: Text(label),
        selected: isSelected,
        onSelected: (value) {},
        selectedColor: Colors.orange[300],
        backgroundColor: Colors.grey[200],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[800],
        ),
      ),
    );
  }
}

class ServiceCardWidget extends StatelessWidget {
  final IconData iconData;
  final String label;
  final Function() onTap;

  const ServiceCardWidget({
    super.key,
    required this.iconData,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                          text: '1 BHK Furnished',
                          style: AppTextStyle.txtBold16),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          ResponsiveText(
                              text: 'Rs 3500', style: AppTextStyle.txtBold12),
                          const SizedBox(
                            width: 10,
                          ),
                          ResponsiveText(
                            text: '•  6 Hours',
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
                    child: Container(
                      height: 60,
                      width: 65,
                      color: Colors.grey,
                      child: Icon(
                        iconData,
                        size: 50,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                'At Nook & Corner, we provide tailored apartment cleaning services including general tasks like dusting, vacuuming, sweeping, and mopping. Our deep cleaning service utilizes advanced machinery for a thorough cleanse. We use eco-friendly, pet-free, and child-free cleaning solutions to ensure a safe environment.',
                style: AppTextStyle.txt12.copyWith(
                  color: AppColors.darkGray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
