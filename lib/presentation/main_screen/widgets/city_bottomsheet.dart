import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/domain/model/home/city_responds.dart';
import 'package:customerapp/presentation/common_widgets/network_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CityBottomSheet extends StatelessWidget {
  final Function(CityResponds city) onCitySelected;
  final List<CityResponds> city;

  const CityBottomSheet({
    super.key,
    required this.city,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Choose Your City',
            textAlign: TextAlign.center,
            style: AppTextStyle.txtBold18,
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.8,
            ),
            itemCount: city.length,
            itemBuilder: (context, index) {
              final item = city[index];
              return GestureDetector(
                onTap: () {
                  Get.back();
                  onCitySelected(city[index]);
                },
                child: CityCard(
                  image: item.image,
                  label: item.cityName,
                ),
              );
            },
          ),
        ],
      ),
    );
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
