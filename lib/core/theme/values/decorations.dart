import 'package:flutter/material.dart';

import '../../utils/size_utils.dart';
import '../color_constant.dart';

class Decorations {
  static const BoxDecoration secondarySideCurved10 = BoxDecoration(
    color: AppColors.secondaryColor,
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );

  static const BoxDecoration grayRoundCurved20 = BoxDecoration(
    color: AppColors.gray,
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );
  static const BoxDecoration whiteSideCurved8 = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  static final RoundedRectangleBorder cardRectShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  );

  static final RoundedRectangleBorder cardRectBorder = RoundedRectangleBorder(
    side: const BorderSide(
      color: Colors.black,
      width: 0.3,
    ),
    borderRadius: BorderRadius.circular(25.0),
  );

  static const BoxDecoration redRoundCurved = BoxDecoration(
    color: AppColors.red,
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );

  static const BoxDecoration whiteRoundCurved20 = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );

  static BoxDecoration get outlineLightBlue => BoxDecoration(
        color: AppColors.white,
        border: Border.all(
          color: AppColors.blueGray,
          width: getHorizontalSize(
            1,
          ),
        ),
      );

  static BoxDecoration get txtOutlineBlue => BoxDecoration(
        border: Border.all(
          color: AppColors.blueGray,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
}

class BorderRadiusStyle {
  static BorderRadius roundedBorder8 = BorderRadius.circular(
    getHorizontalSize(
      8,
    ),
  );

  static BorderRadius circleBorder24 = BorderRadius.circular(
    getHorizontalSize(
      24,
    ),
  );

  static BorderRadius roundedBorder5 = BorderRadius.circular(
    getHorizontalSize(
      5,
    ),
  );

  static BorderRadius circleBorder36 = BorderRadius.circular(
    getHorizontalSize(
      36,
    ),
  );

  static BorderRadius txtRoundedBorder5 = BorderRadius.circular(
    getHorizontalSize(
      5,
    ),
  );

  static BorderRadius txtCircleBorder24 = BorderRadius.circular(
    getHorizontalSize(
      24,
    ),
  );
}
