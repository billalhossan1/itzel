import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

class CreatorPaymentMethodTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final int maxLines; // Add maxLines as a parameter
  final VoidCallback? onTapSuffix;

  const CreatorPaymentMethodTextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    this.maxLines = 1, // Default value is 1
    this.onTapSuffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(
          color: AppColors.black500,
        ),
        decoration: InputDecoration(
          fillColor: AppColors.white,
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.greyLight,
            fontWeight: FontWeight.w300,
            fontSize: (MediaQuery.sizeOf(context).width /
                (MediaQuery.sizeOf(context).width / 14)),
          ),
          contentPadding: EdgeInsets.all(MediaQuery.sizeOf(context).width /
              (MediaQuery.sizeOf(context).width / 18)),
          suffixIcon: suffixIcon != null
              ? GestureDetector(
                  onTap: onTapSuffix,
                  child: Icon(suffixIcon, color: AppColors.greyLight),
                )
              : null,
          border: InputBorder.none,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.red,
              width: MediaQuery.sizeOf(context).width /
                  (MediaQuery.sizeOf(context).width / 0.5),
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.red,
              width: MediaQuery.sizeOf(context).width /
                  (MediaQuery.sizeOf(context).width / 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
