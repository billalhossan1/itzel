import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

class StrokeButtonWidget extends StatelessWidget {
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

  const StrokeButtonWidget({
    super.key,
    required this.label,
    this.icon,
    this.iconHeight,
    this.iconWidth,
    this.gradient,
    this.textColor = AppColors.blueNormal,
    this.fontSize = 18.0,
    this.onPressed,
    this.buttonHeight = 50.0,
    this.buttonWidth = 200.0,
    this.padding,
    this.buttonRadius = const BorderRadius.all(Radius.circular(16)),
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
        color: backgroundColor ?? AppColors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 2,
          ),
        ],
        border: Border.all(
          color: AppColors.blueNormal,
          width: (MediaQuery.sizeOf(context).width /
              (MediaQuery.sizeOf(context).width / 2)),
        ),
        borderRadius: BorderRadius.circular(16),
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
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
