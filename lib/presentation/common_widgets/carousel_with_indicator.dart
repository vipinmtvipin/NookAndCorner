import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
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
    return Stack(
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
            enlargeCenterPage: true,
            viewportFraction: 0.99,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        Positioned(
            bottom: 15,
            left: context.width / 2 - 50,
            height: 3,
            child: Visibility(
                visible: widget.isIndicatorVisible ?? true,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: widget.carouselSliderItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      final isSelected = _currentIndex == index;
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(index),
                        child: Container(
                          alignment: Alignment.center,
                          width: isSelected ? 30 : 30,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: isSelected ? Colors.white : Colors.white70,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      );
                    })))
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
