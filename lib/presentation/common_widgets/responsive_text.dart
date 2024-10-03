import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final int maxLines;
  final bool isLTR;

  const ResponsiveText({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines = 2,
    this.isLTR = false,
  });

  @override
  Widget build(BuildContext context) {
    final textWidget = AutoSizeText(
      text,
      textAlign: textAlign,
      style: style,
      maxLines: maxLines,
      minFontSize: 9,
      overflow: TextOverflow.ellipsis,
    );

    if (isLTR) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: textWidget,
      );
    } else {
      return textWidget;
    }
  }
}
