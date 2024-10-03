import 'package:customerapp/core/theme/values/gradients.dart';
import 'package:customerapp/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/size_utils.dart';
import '../common_widgets/custom_image_view.dart';
import 'controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: Gradients.appBackgroundGradient,
          ),
          child: splashView(),
        ),
      ),
    );
  }

  Widget splashView() {
    return Center(
      child: CustomImageView(
        radius: BorderRadius.circular(40),
        imagePath: Assets.images.nookCornerLogo.path,
        width: 200,
        height: 200,
        margin: getMargin(
          top: 50,
          left: 50,
          right: 50,
          bottom: 50,
        ),
      ),
    );
  }
}
