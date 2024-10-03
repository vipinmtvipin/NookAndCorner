import 'package:flutter/material.dart';

import '../../core/theme/color_constant.dart';
import '../../core/utils/size_utils.dart';

class CustomIconButton extends StatelessWidget {
  CustomIconButton(
      {super.key,
      this.shape,
      this.padding,
      this.variant,
      this.alignment,
      this.margin,
      this.width,
      this.height,
      this.child,
      this.onTap});

  IconButtonShape? shape;

  IconButtonPadding? padding;

  IconButtonVariant? variant;

  Alignment? alignment;

  EdgeInsetsGeometry? margin;

  double? width;

  double? height;

  Widget? child;

  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildIconButtonWidget(),
          )
        : _buildIconButtonWidget();
  }

  _buildIconButtonWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: IconButton(
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
        iconSize: getSize(height ?? 0),
        padding: const EdgeInsets.all(0),
        icon: Container(
          alignment: Alignment.center,
          width: getSize(width ?? 0),
          height: getSize(height ?? 0),
          padding: _setPadding(),
          decoration: _buildDecoration(),
          child: child,
        ),
        onPressed: onTap,
      ),
    );
  }

  _buildDecoration() {
    return BoxDecoration(
      color: _setColor(),
      border: _setBorder(),
      borderRadius: _setBorderRadius(),
      boxShadow: _setBoxShadow(),
    );
  }

  _setPadding() {
    switch (padding) {
      case IconButtonPadding.PaddingAll20:
        return getPadding(
          all: 20,
        );
      case IconButtonPadding.PaddingAll28:
        return getPadding(
          all: 28,
        );
      case IconButtonPadding.PaddingAll8:
        return getPadding(
          all: 8,
        );
      default:
        return getPadding(
          all: 0,
        );
    }
  }

  _setColor() {
    switch (variant) {
      case IconButtonVariant.FillLightblueA200:
        return AppColors.examCardLight;
      case IconButtonVariant.OutlineLightblueA2003d:
        return AppColors.examCardLight;
      case IconButtonVariant.OutlineBlue50:
        return AppColors.black;
      default:
        return AppColors.examCardLight;
    }
  }

  _setBorder() {
    switch (variant) {
      case IconButtonVariant.FillLightblueA200:
      case IconButtonVariant.OutlineLightblueA2003d:
        return null;
      default:
        return Border.all(
          color: AppColors.secondaryColor,
          width: getHorizontalSize(
            0.5,
          ),
        );
    }
  }

  _setBorderRadius() {
    switch (shape) {
      case IconButtonShape.RoundedBorder16:
        return BorderRadius.circular(
          getHorizontalSize(
            16.00,
          ),
        );
      case IconButtonShape.CircleBorder12:
        return BorderRadius.circular(
          getHorizontalSize(
            12.00,
          ),
        );
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            35.00,
          ),
        );
    }
  }

  _setBoxShadow() {
    switch (variant) {
      case IconButtonVariant.OutlineLightblueA2003d:
        return [
          BoxShadow(
            color: AppColors.examCardLight,
            spreadRadius: getHorizontalSize(
              2.00,
            ),
            blurRadius: getHorizontalSize(
              2.00,
            ),
            offset: const Offset(
              0,
              10,
            ),
          ),
        ];
      case IconButtonVariant.OutlineBlue50:
      case IconButtonVariant.FillLightblueA200:
        return null;
      default:
        return [
          BoxShadow(
            color: AppColors.accentColorLight,
            spreadRadius: getHorizontalSize(
              1.00,
            ),
            blurRadius: getHorizontalSize(
              1.00,
            ),
            offset: const Offset(
              0,
              0,
            ),
          ),
        ];
    }
  }
}

enum IconButtonShape {
  CircleBorder35,
  RoundedBorder16,
  CircleBorder12,
}

enum IconButtonPadding {
  PaddingAll23,
  PaddingAll20,
  PaddingAll28,
  PaddingAll8,
}

enum IconButtonVariant {
  OutlineBlue50,
  FillLightblueA200,
  OutlineLightblueA2003d,
}
