import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/app_colors.dart';

class ReviewSearchTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final int maxLines; // Add maxLines as a parameter
  final ValueChanged<String>? onChanged;

  const ReviewSearchTextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    this.maxLines = 1, // Default value is 1
    this.onChanged,
  });

  @override
  State<ReviewSearchTextFieldWidget> createState() =>
      _ReviewSearchTextFieldWidgetState();
}

class _ReviewSearchTextFieldWidgetState
    extends State<ReviewSearchTextFieldWidget> {
  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        obscureText: obscureText,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        onChanged: widget.onChanged,
        style: const TextStyle(
          color: AppColors.black500,
        ),
        decoration: InputDecoration(
          fillColor: AppColors.white,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: AppColors.black700,
            fontWeight: FontWeight.w400,
            fontSize: (MediaQuery.sizeOf(context).width /
                (MediaQuery.sizeOf(context).width / 14)),
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.all(
              MediaQuery.sizeOf(context).width /
                  (MediaQuery.sizeOf(context).width / 16),
            ),
            child: SvgPicture.asset(
              'assets/icons/userSearchIcon.svg',
              color: AppColors.black700,
              width: MediaQuery.sizeOf(context).width /
                  (MediaQuery.sizeOf(context).width / 22),
              height: MediaQuery.sizeOf(context).height /
                  (MediaQuery.sizeOf(context).height / 22),
            ),
          ),
          contentPadding: EdgeInsets.all(MediaQuery.sizeOf(context).width /
              (MediaQuery.sizeOf(context).width / 18)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.black700,
              width: MediaQuery.sizeOf(context).width /
                  (MediaQuery.sizeOf(context).width / 0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.black700,
              width: MediaQuery.sizeOf(context).width /
                  (MediaQuery.sizeOf(context).width / 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
