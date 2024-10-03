import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/generated/fonts.gen.dart';
import 'package:flutter/material.dart';

class ThemesData {
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF7F7F7),
      fontFamily: FontFamily.poppins,
      colorSchemeSeed: AppColors.primaryColor,
      useMaterial3: true,
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: AppColors.primaryColor.withOpacity(0.2),
        backgroundColor: const Color(0xFFF7F7F7),
      ),
      brightness: Brightness.light,
      searchBarTheme: SearchBarThemeData(
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ),
      appBarTheme: const AppBarTheme(
        color: AppColors.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: elevatedButtonStyle(),
      ),
      textButtonTheme: TextButtonThemeData(
        style: textButtonStyle(),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: outlinedButtonStyle(),
      ),
      iconTheme: iconTheme,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryColor,
      ),
    );
  }

  static const iconTheme = IconThemeData(
    color: AppColors.primaryColor,
  );

  static elevatedButtonStyle({EdgeInsets? padding, Color? background}) =>
      ElevatedButton.styleFrom(
        disabledBackgroundColor: AppColors.gray,
        backgroundColor: background ?? AppColors.primaryColor,
        foregroundColor: Colors.white,
        padding: padding ?? buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      );

  static textButtonStyle({EdgeInsets? padding}) => TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: padding ?? buttonPadding,
      );

  static outlinedButtonStyle([
    Color? color,
    EdgeInsets? padding,
  ]) {
    return OutlinedButton.styleFrom(
      foregroundColor: color ?? AppColors.primaryColor,
      padding: padding ?? buttonPadding,
      side: BorderSide(
        color: color ?? AppColors.primaryColor,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  static const buttonPadding = EdgeInsets.symmetric(vertical: 13.0);
}
