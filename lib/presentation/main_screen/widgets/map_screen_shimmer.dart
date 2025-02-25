import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/presentation/main_screen/controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class MainShimmerWidget extends StatelessWidget {
  const MainShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.black,
      backgroundColor: Colors.white,
      strokeWidth: 2,
      onRefresh: () {
        return refreshData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildShipmentCard(context),
            const SizedBox(height: 1),
            _buildBottomTextView(context),
          ],
        ),
      ),
    );
  }

  Widget _buildShipmentCard(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShimmerBanner(),
        const SizedBox(height: 20),
        const HeadingShimmerWidget(),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(left: 45.0),
          child: BuildShimmerLine(
            height: 10,
            width: 100,
          ),
        ),
        const SizedBox(height: 20),
        _buildGrid(context),
        const SizedBox(height: 20),
        const HeadingShimmerWidget(),
        const SizedBox(height: 20),
        _buildShimmerBanner(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          elevation: 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                direction: ShimmerDirection.ltr,
                baseColor: AppColors.gray.withOpacity(0.6),
                highlightColor: AppColors.gray.withOpacity(0.2),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const BuildShimmerLine(
                height: 16,
              ),
              const SizedBox(height: 5),
              const BuildShimmerLine(
                height: 16,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerBanner() {
    return Card(
      elevation: 6,
      child: Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        baseColor: AppColors.gray.withOpacity(0.6),
        highlightColor: AppColors.gray.withOpacity(0.2),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomTextView(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              3, (index) => _buildShimmerDescriptionSection(context)),
        ),
      ),
    );
  }

  Widget _buildShimmerDescriptionSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: AppColors.gray.withOpacity(0.6),
            highlightColor: AppColors.gray.withOpacity(0.2),
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildShimmerLine(
                  height: 16,
                ),
                SizedBox(height: 4),
                BuildShimmerLine(
                  height: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> refreshData() async {
    var controller = Get.find<MainScreenController>();

    controller.getCity();

    controller.getReviews('5', '0', "refresh", false);
  }
}

class HeadingShimmerWidget extends StatelessWidget {
  const HeadingShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
      child: Row(children: [
        Shimmer.fromColors(
          baseColor: AppColors.gray.withOpacity(0.6),
          highlightColor: AppColors.gray.withOpacity(0.2),
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: BuildShimmerLine(
            height: 16,
          ),
        ),
      ]),
    );
  }
}

class CityShimmerWidget extends StatelessWidget {
  const CityShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(color: AppColors.black, width: 0.3),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
        child: Row(children: [
          Shimmer.fromColors(
            baseColor: AppColors.gray.withOpacity(0.6),
            highlightColor: AppColors.gray.withOpacity(0.2),
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: BuildShimmerLine(
              height: 16,
            ),
          ),
        ]),
      ),
    );
  }
}

class BuildShimmerLine extends StatelessWidget {
  final double height;
  final double width;

  const BuildShimmerLine({
    super.key,
    this.height = 16,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        baseColor: AppColors.gray.withOpacity(0.6),
        highlightColor: AppColors.gray.withOpacity(0.2),
        child: Container(
          height: height,
          width: width,
          color: Colors.white,
        ),
      ),
    );
  }
}
