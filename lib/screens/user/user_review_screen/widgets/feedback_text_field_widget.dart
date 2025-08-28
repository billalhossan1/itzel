import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

class FeedbackTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final int maxLines; // Add maxLines as a parameter

  const FeedbackTextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  State<FeedbackTextFieldWidget> createState() =>
      _FeedbackTextFieldWidgetState();
}

class _FeedbackTextFieldWidgetState extends State<FeedbackTextFieldWidget> {
  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        obscureText: obscureText,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        style: const TextStyle(
          color: AppColors.black500,
        ),

        decoration: InputDecoration(
          fillColor: AppColors.grey100,
          hintText: widget.hintText,
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: AppColors.black700,
            fontWeight: FontWeight.w400,
            fontSize: (MediaQuery.sizeOf(context).width /
                (MediaQuery.sizeOf(context).width / 14)),
          ),
          contentPadding: EdgeInsets.all(MediaQuery.sizeOf(context).width /
              (MediaQuery.sizeOf(context).width / 18)),
        ),
      ),
    );
  }
}
