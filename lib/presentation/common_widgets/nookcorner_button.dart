import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/core/theme/themes.dart';
import 'package:flutter/material.dart';

enum NookCornerButtonType {
  filled,
  text,
  outlined,
}

class NookCornerButton extends StatelessWidget {
  final NookCornerButtonType type;

  final String text;
  final TextStyle? textStyle;

  final Function()? onPressed;

  final bool expandedWidth;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Color? textColor;
  final Color? outlinedColor;
  final Color? backGroundColor;

  const NookCornerButton({
    super.key,
    this.type = NookCornerButtonType.filled,
    required this.text,
    this.textStyle,
    this.textColor,
    this.onPressed,
    this.expandedWidth = true,
    this.width,
    this.height = 50,
    this.padding,
    this.outlinedColor,
    this.backGroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget button;

    TextStyle? buttonTextStyle = textStyle ?? AppTextStyle.txt14;

    switch (type) {
      case NookCornerButtonType.filled:
        button = ElevatedButton(
          style: ThemesData.elevatedButtonStyle(
              padding: padding, background: backGroundColor),
          onPressed: onPressed,
          child: Text(
            text,
            maxLines: 1,
            style: buttonTextStyle.copyWith(
              color: textColor ?? Colors.white,
            ),
          ),
        );
        break;
      case NookCornerButtonType.text:
        button = TextButton(
          style: ThemesData.textButtonStyle(padding: padding),
          onPressed: onPressed,
          child: Text(
            text,
            maxLines: 1,
            style: buttonTextStyle.copyWith(
              color: textColor ?? AppColors.primaryColor,
            ),
          ),
        );
        break;
      case NookCornerButtonType.outlined:
        button = OutlinedButton(
          onPressed: onPressed,
          style: ThemesData.outlinedButtonStyle(
            outlinedColor,
            padding,
          ),
          child: Text(
            text,
            maxLines: 1,
            style: buttonTextStyle.copyWith(
              color: textColor ?? AppColors.primaryColor,
            ),
          ),
        );
    }

    if (expandedWidth || width != null) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: button,
      );
    } else {
      return button;
    }
  }
}
