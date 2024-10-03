import 'package:flutter/material.dart';
import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/values/gradients.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: Gradients.buttonBackgroundGradient, // Gradient color
          borderRadius: BorderRadius.circular(4.0), // Rounded corners
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, // Shadow color
              offset: Offset(0, 4), // Shadow position
              blurRadius: 5.0, // Shadow blur
            ),
          ],
        ),
        child: Center(
          child: Text(text, style: AppTextStyle.txtBoldWhite14),
        ),
      ),
    );
  }
}
