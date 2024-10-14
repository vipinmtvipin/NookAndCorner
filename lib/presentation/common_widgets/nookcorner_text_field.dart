import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum NookCornerTextFieldType {
  freeText,
  text,
  password,
  id,
  mobile,
  email,
  otp,
}

class NookCornerTextField extends StatefulWidget {
  final String title;
  final String? note;
  final String? hint;

  @Deprecated('Use [suffix] instead')
  final IconData? suffixIcon;
  final Widget? suffix;
  @Deprecated('Use [prefix] instead')
  final IconData? prefixIcon;
  final Widget? prefix;

  final TextStyle? textStyle;

  final NookCornerTextFieldType type;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  final TextEditingController? controller;

  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final BorderRadius borderRadius;

  final FocusNode? focusNode;
  final bool autofocus;

  final bool isFormField;
  final FormFieldValidator<String>? validator;
  final bool autoValidate;

  final bool enabled;

  final int maxLines;
  final int minLines;

  final Color? fillColor;

  const NookCornerTextField({
    super.key,
    this.title = '',
    this.note,
    this.hint,
    this.suffixIcon,
    this.suffix,
    this.prefixIcon,
    this.prefix,
    this.textStyle,
    this.type = NookCornerTextFieldType.text,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.onTap,
    this.textInputAction,
    this.focusNode,
    this.autofocus = false,
    this.isFormField = false,
    this.validator,
    this.autoValidate = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.enabled = true,
    this.maxLines = 1,
    this.minLines = 1,
    this.fillColor,
  });

  @override
  State<NookCornerTextField> createState() => _DalTextFieldState();
}

class _DalTextFieldState extends State<NookCornerTextField> {
  bool _obscureText = false;

  final textInputFormatters = [
    LengthLimitingTextInputFormatter(500),
  ];

  final idInputFormatters = [
    LengthLimitingTextInputFormatter(10),
    FilteringTextInputFormatter.digitsOnly,
  ];

  final mobileInputFormatters = [
    LengthLimitingTextInputFormatter(10),
    FilteringTextInputFormatter.digitsOnly,
  ];

  final emailInputFormatters = [
    LengthLimitingTextInputFormatter(30),
  ];

  final otpInputFormatters = [
    LengthLimitingTextInputFormatter(1),
    FilteringTextInputFormatter.digitsOnly,
  ];

  @override
  void initState() {
    if (widget.type == NookCornerTextFieldType.password) {
      _obscureText = true;
    }
    super.initState();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: const BorderSide(
        width: 1,
        color: AppColors.otpInactive,
      ),
      borderRadius: widget.borderRadius,
    );

    final activeBorder = OutlineInputBorder(
      borderSide: const BorderSide(
        width: 1,
        color: AppColors.black,
      ),
      borderRadius: widget.borderRadius,
    );

    final Widget? suffixIcon;
    if (widget.type == NookCornerTextFieldType.password) {
      suffixIcon = IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: AppColors.primaryColor,
        ),
        onPressed: _togglePasswordVisibility,
      );
    } else {
      suffixIcon = widget.suffixIcon != null
          ? Icon(
              widget.suffixIcon,
              color: AppColors.primaryColor,
            )
          : widget.suffix;
    }

    final Widget? prefixIcon = widget.prefixIcon != null
        ? Icon(
            widget.prefixIcon,
            color: AppColors.primaryColor,
          )
        : widget.prefix;

    List<TextInputFormatter> inputFormatters;
    TextInputType keyboardType;

    switch (widget.type) {
      case NookCornerTextFieldType.id:
        inputFormatters = idInputFormatters;
        keyboardType = TextInputType.number;
        break;
      case NookCornerTextFieldType.mobile:
        inputFormatters = mobileInputFormatters;
        keyboardType = TextInputType.phone;
        break;
      case NookCornerTextFieldType.email:
        inputFormatters = emailInputFormatters;
        keyboardType = TextInputType.emailAddress;
        break;
      case NookCornerTextFieldType.otp:
        inputFormatters = otpInputFormatters;
        keyboardType = TextInputType.number;
        break;
      case NookCornerTextFieldType.text:
        inputFormatters = textInputFormatters;
        keyboardType = TextInputType.text;
        break;
      case NookCornerTextFieldType.freeText:
        inputFormatters = [];
        keyboardType = TextInputType.text;
        break;
      case NookCornerTextFieldType.password:
        inputFormatters = textInputFormatters;
        keyboardType = TextInputType.text;
        break;
    }

    final addSpaceForError = widget.isFormField && widget.note == null;

    final decoration = InputDecoration(
      helperText: addSpaceForError ? ' ' : widget.note,
      helperMaxLines: 2,
      errorMaxLines: 2,
      hintText: widget.hint,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      fillColor: widget.fillColor,
      filled: widget.fillColor != null,
      suffixIconColor: AppColors.primaryColor,
      enabledBorder: border,
      focusedBorder: activeBorder,
      errorBorder: border,
      focusedErrorBorder: activeBorder,
      disabledBorder: border,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    );

    final textAlign = widget.type == NookCornerTextFieldType.otp
        ? TextAlign.center
        : TextAlign.start;

    final textDirection = (widget.type == NookCornerTextFieldType.mobile)
        ? TextDirection.ltr
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.title.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Text(
              widget.title,
              style: AppTextStyle.txt16,
            ),
          ),
        ),
        const SizedBox(height: 5),
        _buildTextField(
          decoration: decoration,
          textAlign: textAlign,
          textDirection: textDirection,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  _buildTextField({
    required InputDecoration decoration,
    required TextAlign textAlign,
    TextDirection? textDirection,
    required List<TextInputFormatter> inputFormatters,
    required TextInputType keyboardType,
  }) {
    Widget textField;

    if (widget.isFormField) {
      textField = TextFormField(
        onChanged: widget.onChanged,
        validator: widget.validator,
        autovalidateMode: widget.autoValidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        controller: widget.controller,
        obscureText: _obscureText,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        textInputAction: widget.textInputAction,
        onTap: widget.onTap,
        readOnly: widget.onTap != null,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        textAlign: textAlign,
        textDirection: textDirection,
        decoration: decoration,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        style: widget.textStyle,
      );
    } else {
      textField = TextField(
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        controller: widget.controller,
        obscureText: _obscureText,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        textInputAction: widget.textInputAction,
        onTap: widget.onTap,
        readOnly: widget.onTap != null,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        textAlign: textAlign,
        textDirection: textDirection,
        decoration: decoration,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        style: widget.textStyle,
      );
    }

    return textField;
  }
}

class IbanInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(' ', '');
    String formatted = '';
    for (var i = 0; i < newText.length; i++) {
      formatted += newText[i];
      if ((i + 1) % 4 == 0 && i != newText.length - 1) {
        formatted += ' ';
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ShipmentNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (oldValue.text.length == 1 && newValue.text.trim().isEmpty) {
      return newValue;
    }
    return newValue;
  }
}
