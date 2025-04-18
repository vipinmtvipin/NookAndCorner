import 'dart:io';

import 'package:customerapp/core/extensions/list_extensions.dart';
import 'package:customerapp/core/extensions/sheet_extension.dart';
import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/core/utils/size_utils.dart';
import 'package:customerapp/generated/assets.gen.dart';
import 'package:customerapp/presentation/common_widgets/carousel_with_indicator.dart';
import 'package:customerapp/presentation/common_widgets/conditional_widget.dart';
import 'package:customerapp/presentation/common_widgets/custom_icon_button.dart';
import 'package:customerapp/presentation/common_widgets/network_image_view.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:customerapp/presentation/main_screen/controller/main_controller.dart';
import 'package:customerapp/presentation/main_screen/widgets/city_bottomsheet.dart';
import 'package:customerapp/presentation/main_screen/widgets/map_screen_shimmer.dart';
import 'package:customerapp/presentation/settings_screen/reviews_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';

class MainScreen extends GetView<MainScreenController> {
  const MainScreen({super.key});

  Future<void> _logEvent() async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'visit_homepage',
    );
  }

  @override
  Widget build(BuildContext context) {
    _logEvent();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: getSize(70),
        backgroundColor: Colors.white,
        leadingWidth: getHorizontalSize(175),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
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
              return (controller.selectedCity.value.cityId != null &&
                      controller.selectedCity.value.cityId != 0)
                  ? Card(
                      elevation: 1,
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
                              color: AppColors.black,
                              size: 16,
                            ),
                            const SizedBox(width: 3),
                            SizedBox(
                              width: 80,
                              child: ResponsiveText(
                                textAlign: TextAlign.center,
                                text: controller.selectedCity.value.cityName ??
                                    '',
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
          Obx(() {
            return controller.loggedIn.value == true
                ? InkWell(
                    child: Assets.images.bookingIcon.image(
                      color: Colors.black87,
                      width: getSize(26),
                      height: getSize(26),
                    ),
                    onTap: () {
                      if (controller.selectedCity.value.cityId != null &&
                          controller.selectedCity.value.cityId != 0 &&
                          controller.selectedCity.value.cityId
                              .toString()
                              .isNotEmpty) {
                        Get.toNamed(AppRoutes.myBookingScreen);
                      } else {
                        controller.showCityPopup();
                      }
                    },
                  )
                : SizedBox.shrink();
          }),
          Obx(() {
            return controller.loggedIn.value == true
                ? Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.account_circle_rounded,
                        color: Colors.black87,
                        size: getSize(26),
                      ),
                      onPressed: () {
                        if (controller.selectedCity.value.cityId != null &&
                            controller.selectedCity.value.cityId != 0 &&
                            controller.selectedCity.value.cityId
                                .toString()
                                .isNotEmpty) {
                          Get.toNamed(AppRoutes.accountScreen);
                        } else {
                          controller.showCityPopup();
                        }
                      },
                    ),
                  )
                : Padding(
                    padding:
                        const EdgeInsets.only(right: 10, top: 18, bottom: 18),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.loginScreen, arguments: {
                          'from': AppRoutes.mainScreen,
                          "flag": "",
                          "email": '',
                          "phone": '',
                        });
                      },
                      child: Container(
                        width: getSize(60),
                        alignment: Alignment.center,
                        height: getSize(48),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          readAndPrintPushLog();

          Get.toNamed(AppRoutes.contactScreen);
        },
        elevation: 6,
        heroTag: 'contact',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        backgroundColor: AppColors.secondaryColor,
        child: const Icon(
          Icons.mail,
          color: Colors.black,
        ),
      ),
    );
  }
}

Widget _buildMainScreen() {
  final GlobalKey reviewListKey = GlobalKey();
  var controller = Get.find<MainScreenController>();

  Future<void> refreshData() async {
    controller.getCity();

    controller.getReviews('5', '0', "refresh", false);

    controller.updatePushToken();
  }

  return Padding(
    padding: const EdgeInsets.only(
      top: 15,
    ),
    child: RefreshIndicator(
      color: Colors.black,
      backgroundColor: Colors.white,
      strokeWidth: 2,
      onRefresh: () {
        return refreshData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: controller.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ConditionalWidget(
                condition: controller.activeBanners.value.isNotNullOrEmpty,
                onFalse: const SizedBox.shrink(),
                child: CarouselWithIndicator(
                  height: 160,
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
              ),
            ),
            SizedBox(
              height: getSize(20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Home services at your door',
                style: AppTextStyle.txtBold18,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Pick your Service',
                style: AppTextStyle.txtBold12,
              ),
            ),
            const SizedBox(height: 25),
            Obx(() {
              if (controller.cityServices.value.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child:
                      const NotDataFound(message: 'No Service Available Now'),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
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
                        if (controller.selectedCity.value.cityId != null &&
                            controller.selectedCity.value.cityId != 0 &&
                            controller.selectedCity.value.cityId
                                .toString()
                                .isNotEmpty) {
                          Get.toNamed(
                            AppRoutes.serviceScreen,
                            arguments: {
                              'categoryId': item.catid.toString(),
                              'categoryName': item.name,
                              'categoryDescription': item.description,
                              'categoryImage': item.descriptionImageHorizontal,
                            },
                          );
                        } else {
                          controller.showCityPopup();
                        }
                      },
                      child: ServiceCard(
                        image: item.logo,
                        label: item.name,
                      ),
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ConditionalWidget(
                condition: controller.activeBanners.value.isNotNullOrEmpty,
                onFalse: const SizedBox.shrink(),
                child: CarouselWithIndicator(
                  height: 140,
                  isIndicatorVisible: false,
                  carouselSliderItems: controller.midBanners.value
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
              ),
            ),
            const SizedBox(height: 40),
            Visibility(
              visible: controller.reviewList.value.isNotNullOrEmpty,
              child: Obx(
                () => Container(
                  padding: const EdgeInsets.only(top: 30, bottom: 10),
                  color: AppColors.whiteGray,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Trusted by Customers, Loved by All',
                            style: AppTextStyle.txtBold18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Delivering Excellence Every Time!',
                            style: AppTextStyle.txtBold12,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Stack(
                          children: [
                            AnimatedSize(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.bounceInOut,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16, bottom: 70),
                                child: ListView.builder(
                                  key: reviewListKey,
                                  controller: controller.scrollController,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.reviewList.value.length,
                                  itemBuilder: (context, index) {
                                    var item =
                                        controller.reviewList.value[index];
                                    return ReviewCardWidget(
                                        item: item, onTap: () {});
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Container(
                                height: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.gray.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ConditionalWidget(
                                          condition: (controller.reviewList
                                                      .value.length !=
                                                  controller
                                                      .reviewCount.value &&
                                              controller.reviewList.value
                                                      .length >=
                                                  5),
                                          onFalse: SizedBox.shrink(),
                                          child: NookCornerButton(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              expandedWidth: false,
                                              text: 'See More Reviews',
                                              onPressed: () {
                                                controller.getReviews(
                                                    '10',
                                                    controller
                                                        .reviewList.value.length
                                                        .toString(),
                                                    "",
                                                    true);
                                              }),
                                        ),
                                        ConditionalWidget(
                                          condition: (controller.reviewList
                                                      .value.length ==
                                                  controller
                                                      .reviewCount.value &&
                                              controller
                                                      .reviewList.value.length >
                                                  5),
                                          onFalse: SizedBox.shrink(),
                                          child: CustomIconButton(
                                              margin: EdgeInsets.only(
                                                  top: 20, left: 15),
                                              height: 40,
                                              width: 40,
                                              onTap: () {
                                                if (controller.reviewList.value
                                                        .length >=
                                                    5) {
                                                  controller.reviewList.value =
                                                      controller
                                                          .reviewList.value
                                                          .take(5)
                                                          .toList();
                                                } else {
                                                  controller.reviewList.value =
                                                      controller
                                                          .reviewList.value
                                                          .take(controller
                                                              .reviewList
                                                              .value
                                                              .length)
                                                          .toList();
                                                }

                                                final RenderBox renderBox =
                                                    reviewListKey.currentContext
                                                            ?.findRenderObject()
                                                        as RenderBox;
                                                final position = renderBox
                                                    .localToGlobal(Offset.zero);

                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  if (controller
                                                      .scrollController
                                                      .hasClients) {
                                                    controller.scrollController
                                                        .animateTo(
                                                      position.dy,
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      curve: Curves.easeIn,
                                                    );
                                                  }
                                                });
                                              },
                                              alignment: Alignment.topLeft,
                                              shape: IconButtonShape
                                                  .CircleBorder35,
                                              child: Assets.images.upArrow.svg(
                                                color: AppColors.white,
                                                height: 30,
                                                width: 30,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildShimmerMainScreen() {
  return const MainShimmerWidget();
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

  final double? size;

  final TextStyle? style;

  const NotDataFound({super.key, required this.message, this.size, this.style});

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
            height: size ?? 90,
            width: size ?? 90,
            repeat: true,
          ),
          const SizedBox(
            height: 2,
          ),
          ResponsiveText(
            text: message,
            style: style ?? AppTextStyle.txtGray12,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

Future<void> readAndPrintPushLog() async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/pushnotification.txt');

    if (await file.exists()) {
      final contents = await file.readAsString();
      print('=== Push Notification Log ===');
      print(contents);

      contents.showToast();

      print('=== End of Log ===');
    } else {
      print('Log file does not exist.');
    }
  } catch (e) {
    print('Error reading push log: $e');
  }
}
