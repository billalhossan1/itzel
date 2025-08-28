import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

class JobApplyingTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final int maxLines; // Add maxLines as a parameter

  const JobApplyingTextFieldWidget({
    super.key,
    required this.controller,
    this.hintText,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    this.maxLines = 1, // Default value is 1
  });

  @override
  State<JobApplyingTextFieldWidget> createState() =>
      _JobApplyingTextFieldWidgetState();
}

class _JobApplyingTextFieldWidgetState
    extends State<JobApplyingTextFieldWidget> {
  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.sizeOf(context).height /
          (MediaQuery.sizeOf(context).height / 40)),
      decoration: BoxDecoration(
        color: AppColors.greyLightest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        obscureText: obscureText,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        style: TextStyle(
          color: AppColors.black500,
          fontSize: (MediaQuery.sizeOf(context).width /
              (MediaQuery.sizeOf(context).width / 12)),
        ),
        decoration: InputDecoration(
          fillColor: AppColors.white,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: AppColors.black700,
            fontWeight: FontWeight.w400,
            fontSize: (MediaQuery.sizeOf(context).width /
                (MediaQuery.sizeOf(context).width / 12)),
          ),
          contentPadding: EdgeInsets.all(MediaQuery.sizeOf(context).width /
              (MediaQuery.sizeOf(context).width / 8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.grey600,
              width: MediaQuery.sizeOf(context).width /
                  (MediaQuery.sizeOf(context).width / 0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.grey600,
              width: MediaQuery.sizeOf(context).width /
                  (MediaQuery.sizeOf(context).width / 0.5),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.red,
              width: MediaQuery.sizeOf(context).width /
                  (MediaQuery.sizeOf(context).width / 0.5),
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
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
