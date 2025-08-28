import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../constants/app_colors.dart';

class GradientTextWidget extends StatelessWidget {
  final String text;
  final double textSize;
  final FontWeight fontWeight;
  final List<Color> colors;
  final GradientType gradientType;
  final GradientDirection gradientDirection;

  const GradientTextWidget({
    super.key,
    required this.text,
    required this.textSize,
    required this.fontWeight,
    this.colors = const [AppColors.blue500, AppColors.blue],
    this.gradientType = GradientType.linear,
    this.gradientDirection = GradientDirection.ttb,
  });

  @override
  Widget build(BuildContext context) {
    return GradientText(
      text,
      style: TextStyle(
        fontSize: textSize,
        fontWeight: fontWeight,
      ),
      colors: colors,
      gradientType: gradientType,
      gradientDirection: gradientDirection,
    );
  }
}
