import 'package:customerapp/core/theme/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomPinCodeTextField extends StatelessWidget {
  CustomPinCodeTextField({
    super.key,
    required this.context,
    this.onChanged,
    this.alignment,
    this.controller,
    this.textStyle,
    this.hintStyle,
    this.validator,
  });

  final Alignment? alignment;

  final BuildContext context;

  final TextEditingController? controller;

  final TextStyle? textStyle;

  final TextStyle? hintStyle;

  Function(String)? onChanged;

  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: pinCodeTextFieldWidget,
          )
        : pinCodeTextFieldWidget;
  }

  Widget get pinCodeTextFieldWidget => PinCodeTextField(
        appContext: context,
        controller: controller,
        length: 4,
        showCursor: true,
        cursorColor: AppColors.black,
        keyboardType: TextInputType.number,
        textStyle: textStyle,
        hintStyle: hintStyle,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        pinTheme: PinTheme(
          fieldHeight: 53,
          fieldWidth: 50,
          shape: PinCodeFieldShape.box,
          inactiveColor: AppColors.otpInactive,
          activeColor: AppColors.black,
          selectedColor: AppColors.black,
          borderRadius: BorderRadius.circular(4),
          borderWidth: 0.8,
          activeBorderWidth: 0.8,
          selectedBorderWidth: 0.8,
          inactiveBorderWidth: 0.8,
          disabledBorderWidth: 0.8,
          errorBorderWidth: 0.8,
        ),
        onChanged: (value) => onChanged?.call(value),
        validator: validator,
      );
}
