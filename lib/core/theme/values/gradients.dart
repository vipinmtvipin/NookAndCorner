import 'package:flutter/material.dart';

import '../color_constant.dart';

class Gradients {
  static const Gradient appBackgroundGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.white,
        Colors.white24,
        Colors.white70,
      ]);

  static const Gradient buttonBackgroundGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        AppColors.white,
        AppColors.primaryColor,
        AppColors.white,
      ]);

  static const Gradient secondaryGradient = LinearGradient(
    begin: Alignment(0.9661, 0.5),
    end: Alignment(0, 0.5),
    stops: [
      0,
      1,
    ],
    colors: [
      Color.fromARGB(255, 255, 86, 115),
      Color.fromARGB(255, 255, 140, 72),
    ],
  );

  static const Gradient fullScreenOverGradient = LinearGradient(
    begin: Alignment(0.51436, 1.07565),
    end: Alignment(0.51436, -0.03208),
    stops: [
      0,
      0.25098,
      1,
    ],
    colors: [
      Color.fromARGB(255, 0, 0, 0),
      Color.fromARGB(255, 17, 17, 17),
      Color.fromARGB(105, 45, 45, 45),
    ],
  );
}
