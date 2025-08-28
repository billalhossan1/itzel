import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

class DeleteAccountButtonWidget extends StatelessWidget {
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

  const DeleteAccountButtonWidget({
    super.key,
    required this.label,
    this.icon,
    this.iconHeight,
    this.iconWidth,
    this.gradient,
    this.textColor = Colors.white,
    this.fontSize = 16.0,
    this.onPressed,
    this.buttonHeight = 50.0,
    this.buttonWidth = 200.0,
    this.padding,
    this.buttonRadius = const BorderRadius.all(Radius.circular(8)),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      height: (size.height / (size.height / buttonHeight)),
      width: (size.width / (size.width / buttonWidth)),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.grey200,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 5.0,
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: (size.width / (size.width / fontSize)),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
