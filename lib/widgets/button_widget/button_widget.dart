import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class ButtonWidget extends StatelessWidget {
  final String label;
  final String? icon;
  final double? iconHeight;
  final double? iconWidth;
  final Gradient? gradient;
  final Color textColor;
  final double fontSize;
  final VoidCallback? onPressed;
  final double buttonHeight;
  final double buttonWidth;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry buttonRadius;
  final Color? backgroundColor;

  const ButtonWidget({
    super.key,
    required this.label,
    this.icon,
    this.iconHeight,
    this.iconWidth,
    this.gradient,
    this.textColor = Colors.white,
    this.fontSize = 16.0,
    this.onPressed,
    this.buttonHeight = 56,
    this.buttonWidth = 200.0,
    this.padding,
    this.buttonRadius = const BorderRadius.all(Radius.circular(8)),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.sizeOf(context).height /
          (MediaQuery.sizeOf(context).height / buttonHeight)),
      width: (MediaQuery.sizeOf(context).width /
          (MediaQuery.sizeOf(context).width / buttonWidth)),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.grey200,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 5.0,
          ),
        ],
        gradient: const LinearGradient(
          colors: [AppColors.blue500, AppColors.blue],
        ),
        borderRadius: buttonRadius,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: (MediaQuery.sizeOf(context).width /
                (MediaQuery.sizeOf(context).width / fontSize)),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
