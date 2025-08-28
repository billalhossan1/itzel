import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final int maxLines; // Add maxLines as a parameter
  final VoidCallback? onTapSuffix;


  const TextFieldWidget({
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
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    // Initialize obscureText based on suffixIcon being a password toggle
    obscureText = widget.suffixIcon != null;
  }

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
        style: const TextStyle(
          color: AppColors.black500,
        ),
        decoration: InputDecoration(
          fillColor: AppColors.white,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: AppColors.greyLight,
            fontWeight: FontWeight.w300,
            fontSize: (MediaQuery.sizeOf(context).width /
                (MediaQuery.sizeOf(context).width / 14)),
          ),
          suffixIcon: widget.suffixIcon != null
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  child: Icon(
                    obscureText
                        ? Icons.visibility_off
                        : Icons.visibility_outlined,
                    color: AppColors.greyLight,
                    size: 22,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.all(MediaQuery.sizeOf(context).width /
              (MediaQuery.sizeOf(context).width / 18)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.grey700,
              width: MediaQuery.sizeOf(context).width /
                  (MediaQuery.sizeOf(context).width / 0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.grey700,
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
