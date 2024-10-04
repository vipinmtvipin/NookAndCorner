import 'package:customerapp/core/extensions/sheet_extension.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/core/utils/size_utils.dart';
import 'package:customerapp/generated/assets.gen.dart';
import 'package:customerapp/presentation/common_widgets/carousel_with_indicator.dart';
import 'package:customerapp/presentation/common_widgets/network_image_view.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:customerapp/presentation/main_screen/controller/main_controller.dart';
import 'package:customerapp/presentation/main_screen/widgets/city_bottomsheet.dart';
import 'package:customerapp/presentation/main_screen/widgets/map_screen_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class MainScreen extends GetView<MainScreenController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: getSize(70),
        backgroundColor: Colors.white,
        leadingWidth: getHorizontalSize(170),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14),
          child: GestureDetector(
            onTap: () {
              context.showBottomSheet(
                body: CityBottomSheet(
                  city: controller.cityInfo.value,
                  onCitySelected: (city) {
                    controller.onCitySelected(city);
                  },
                ),
              );
            },
            child: Obx(() {
              return controller.selectedCity.value.cityId != null
                  ? Card(
                      elevation: 6,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(
                            color: AppColors.black, width: 0.3),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.location_on,
                              color: AppColors.secondaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            SizedBox(
                              width: 80,
                              child: ResponsiveText(
                                textAlign: TextAlign.center,
                                text: controller.selectedCity.value.cityName!,
                                style: AppTextStyle.txt12,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 3),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                              size: 25,
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    )
                  : const CityShimmerWidget();
            }),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
              size: getSize(23),
            ),
            onPressed: () {},
          ),
          Obx(() {
            return controller.loggedIn.value == true
                ? Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.account_circle_rounded,
                      color: Colors.black,
                      size: getSize(25),
                    ),
                  )
                : Padding(
                    padding:
                        const EdgeInsets.only(right: 10, top: 18, bottom: 18),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.loginScreen);
                      },
                      child: Container(
                        width: getSize(60),
                        alignment: Alignment.center,
                        height: getSize(40),
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.black),
                        ),
                        child: Text('Login', style: AppTextStyle.txtWhite12),
                      ),
                    ),
                  );
          }),
        ],
      ),
      body: Obx(() => controller.homeStatus.value == HomeStatus.loaded
          ? _buildMainScreen()
          : _buildShimmerMainScreen()),
    );
  }
}

Widget _buildMainScreen() {
  var controller = Get.find<MainScreenController>();

  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselWithIndicator(
                height: 150,
                carouselSliderItems: controller.activeBanners.value
                    .map((e) => CarouselItem(
                          navigationPath: e.routePath,
                          image: NetworkImageView(
                            borderRadius: 25,
                            url: e.image,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(
                height: getSize(15),
              ),
              Text(
                'Home services at your door',
                style: AppTextStyle.txtBold18,
              ),
              const SizedBox(height: 8),
              const Text(
                'Pick your Service',
                style: TextStyle(color: AppColors.secondaryColor),
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (controller.cityServices.value.isEmpty) {
                  return const NotDataFound(message: 'No Service Available');
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: controller.cityServices.value.length,
                  itemBuilder: (context, index) {
                    final item = controller.cityServices.value[index];
                    return GestureDetector(
                      onTap: () {
                        //     Get.toNamed(AppRoutes.serviceDetailScreen);
                      },
                      child: ServiceCard(
                        image: item.logo,
                        label: item.name,
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 20),
              CarouselWithIndicator(
                height: 80,
                isIndicatorVisible: false,
                carouselSliderItems: controller.midBanners.value
                    .map((e) => CarouselItem(
                          navigationPath: e.routePath,
                          image: NetworkImageView(
                            borderRadius: 12,
                            url: e.image,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const BottomSectionWidget(),
      ],
    ),
  );
}

Widget _buildShimmerMainScreen() {
  return const MainShimmerWidget();
}

class BottomSectionWidget extends StatelessWidget {
  const BottomSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      width: double.infinity,
      color: AppColors.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Transform your home into a worry-free haven th our comprehensive services',
            style: AppTextStyle.txtSemiBoldWhite16,
          ),
          const SizedBox(height: 10),
          Text(
            'Our expert team offers a range of services to alleviate the stress of hom maintenance,'
            ' from repairs to  deep cleaning to regular upkeep. Enjoy a worry-free home with our comprehensive solution,'
            'tailored to handle everything from leaks to HVAC maintenance.',
            style: AppTextStyle.txtGray14,
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String? image;
  final String? label;

  const ServiceCard({super.key, required this.image, required this.label});

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

class NotDataFound extends StatelessWidget {
  final String message;

  const NotDataFound({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            Assets.lottie.nodata,
            alignment: Alignment.center,
            fit: BoxFit.contain,
            height: 90,
            width: 90,
            repeat: true,
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            message,
            style: AppTextStyle.txtGray12,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
