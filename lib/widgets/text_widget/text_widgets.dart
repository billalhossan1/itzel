import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final FontStyle fontStyle;
  final Color fontColor;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextAlign textAlignment;

  const TextWidget({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.w400,
    this.fontSize = 14,
    this.fontStyle = FontStyle.normal,
    this.fontColor = Colors.transparent,
    this.overflow,
    this.maxLines,
    this.textAlignment = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlignment,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: MediaQuery.sizeOf(context).width /
            (MediaQuery.sizeOf(context).width / fontSize),
        fontStyle: fontStyle,
        color: fontColor,
      ),
    );
  }
}
