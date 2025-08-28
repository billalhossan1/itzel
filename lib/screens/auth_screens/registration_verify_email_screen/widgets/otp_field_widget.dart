import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../constants/app_colors.dart';

class OtpInputFieldWidget extends StatelessWidget {
  const OtpInputFieldWidget({
    super.key,
    this.isLast = false,
    this.textInputAction = TextInputAction.next,
    this.fillColor,
    this.borderColor = AppColors.grey700,
    this.controller,
    this.onFieldSubmitted,
  });
  final bool isLast;
  final TextInputAction? textInputAction;
  final Color? fillColor;
  final Color borderColor;
  final TextEditingController? controller;
  final void Function(String)? onFieldSubmitted;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.sizeOf(context).width /
          (MediaQuery.sizeOf(context).width / 5)),
      height: MediaQuery.sizeOf(context).height /
          (MediaQuery.sizeOf(context).height / 60),
      width: MediaQuery.sizeOf(context).width /
          (MediaQuery.sizeOf(context).width / 50),
      child: TextFormField(
        controller: controller,
        onFieldSubmitted: onFieldSubmitted,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "";
          }
          return null;
        },
        keyboardType: TextInputType.phone,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.top,
        textInputAction: textInputAction,
        onChanged: (value) {
          if (value.isNotEmpty && !isLast) {
            FocusManager.instance.primaryFocus?.nextFocus();
          }
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
            isDense: true,
            constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).width /
                    (MediaQuery.sizeOf(context).width / 70),
                maxWidth: MediaQuery.sizeOf(context).width /
                    (MediaQuery.sizeOf(context).width / 70)),
            filled: true,
            fillColor: fillColor ?? AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  MediaQuery.sizeOf(context).width /
                      (MediaQuery.sizeOf(context).width / 10)),
              borderSide: BorderSide(color: borderColor, width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  MediaQuery.sizeOf(context).width /
                      (MediaQuery.sizeOf(context).width / 10)),
              borderSide: BorderSide(color: borderColor, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  MediaQuery.sizeOf(context).width /
                      (MediaQuery.sizeOf(context).width / 10)),
              borderSide: BorderSide(color: borderColor, width: 0.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  MediaQuery.sizeOf(context).width /
                      (MediaQuery.sizeOf(context).width / 10)),
              borderSide: BorderSide(color: borderColor, width: 0.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  MediaQuery.sizeOf(context).width /
                      (MediaQuery.sizeOf(context).width / 10)),
              borderSide: const BorderSide(color: AppColors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  MediaQuery.sizeOf(context).width /
                      (MediaQuery.sizeOf(context).width / 10)),
              borderSide: const BorderSide(color: AppColors.red, width: 1.5),
            ),
            errorStyle: const TextStyle(height: 0, fontSize: 0)),
      ),
    );
  }
}
