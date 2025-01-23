import 'package:customerapp/core/theme/values/gradients.dart';
import 'package:customerapp/generated/assets.gen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/size_utils.dart';
import '../common_widgets/custom_image_view.dart';
import 'controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  Future<void> _logEvent() async {
    await FirebaseAnalytics.instance
        .logEvent(
      name: 'application_opened',
    )
        .then((_) {
      debugPrint("Event logged: ############## application_opened");
    }).catchError((error) {
      debugPrint("Event logged: ######## Error logging event: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    _logEvent();
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
        imagePath: Assets.images.nookCorner.path,
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
