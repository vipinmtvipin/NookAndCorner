import 'package:carousel_slider/carousel_slider.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CarouselWithIndicator extends StatefulWidget {
  final List<CarouselItem> carouselSliderItems;
  final double? height;
  final bool? isIndicatorVisible;

  const CarouselWithIndicator({
    super.key,
    required this.carouselSliderItems,
    this.height = 200,
    this.isIndicatorVisible = true,
  });

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.carouselSliderItems.length,
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse(
                      widget.carouselSliderItems[index].navigationPath ?? '');

                  await launchUrl(url, mode: LaunchMode.externalApplication);
                },
                child: widget.carouselSliderItems[index].image);
          },
          carouselController: _controller,
          options: CarouselOptions(
            height: widget.height,
            autoPlay: true,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        Visibility(
          visible: widget.carouselSliderItems[_currentIndex].title != null,
          child: Text(
            widget.carouselSliderItems[_currentIndex].title ?? "",
            textAlign: TextAlign.center,
          ),
        ),
        Visibility(
          visible: widget.carouselSliderItems[_currentIndex].subtitle != null,
          child: Text(
            widget.carouselSliderItems[_currentIndex].subtitle ?? "",
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 5),
        Visibility(
          visible: widget.isIndicatorVisible ?? true,
          child: SizedBox(
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: widget.carouselSliderItems.length,
              itemBuilder: (BuildContext context, int index) {
                final isSelected = _currentIndex == index;
                return GestureDetector(
                  onTap: () => _controller.animateToPage(index),
                  child: Container(
                    width: isSelected ? 16 : 6,
                    height: isSelected ? 16 : 6,
                    margin: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 4.0,
                    ),
                    padding: isSelected ? const EdgeInsets.all(3.0) : null,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: isSelected
                          ? Border.all(
                              color: AppColors.secondaryColor,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppColors.red
                            : AppColors.secondaryColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class CarouselItem {
  final String? title;
  final String? subtitle;
  final Widget image;
  final String? navigationPath;

  CarouselItem({
    this.title,
    this.subtitle,
    required this.image,
    this.navigationPath,
  });
}
