import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:itzel/utils/app_size.dart';
import 'package:itzel/widgets/space_widget/space_widget.dart';

import '../../constants/app_colors.dart';
import '../text_widget/text_widgets.dart';

class AppSnackBar {
  static error(String parameterValue, {int seconds = 6}) {
    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: AppColors.black300,
        animationDuration: const Duration(seconds: 2),
        duration: Duration(seconds: seconds),
        isDismissible: true,
        onTap: (snack) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Get.closeAllSnackbars();
          });
        },
        messageText: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextWidget(
                text: "Error!",
                fontColor: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
              const SpaceWidget(spaceHeight: 5),
              TextWidget(
                text: parameterValue,
                fontColor: AppColors.white,
                textAlignment: TextAlign.center,
              ),
            ],
          ),
        ),
        borderRadius: _ensureNonNegative(AppSize.width(value: 20.0)),
        padding: EdgeInsets.all(
          _ensureNonNegative(AppSize.width(value: 10.0)),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: _ensureNonNegative(AppSize.width(value: 40.0)),
          vertical: _ensureNonNegative(AppSize.width(value: 30)),
        ),
      ),
    );
  }

  static success(String parameterValue, {int seconds = 6}) {
    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: AppColors.green,
        animationDuration: const Duration(seconds: 2),
        duration: Duration(seconds: seconds),
        isDismissible: true,
        onTap: (snack) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Get.closeAllSnackbars();
          });
        },
        messageText: SingleChildScrollView(
          child: TextWidget(
            text: parameterValue,
            fontColor: AppColors.white,
            textAlignment: TextAlign.center,
          ),
        ),
        borderRadius: _ensureNonNegative(AppSize.width(value: 20.0)),
        padding: EdgeInsets.all(_ensureNonNegative(AppSize.width(value: 10.0))),
        margin: EdgeInsets.symmetric(
          horizontal: _ensureNonNegative(AppSize.width(value: 40.0)),
          vertical: _ensureNonNegative(AppSize.width(value: 30)),
        ),
      ),
    );
  }

  static message(String parameterValue,
      {Color backgroundColor = AppColors.black300,
      Color color = AppColors.white,
      int seconds = 10}) {
    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: backgroundColor,
        animationDuration: const Duration(seconds: 2),
        duration: Duration(seconds: seconds),
        isDismissible: true,
        onTap: (snack) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Get.closeAllSnackbars();
          });
        },
        messageText: SingleChildScrollView(
          child: TextWidget(
            text: parameterValue,
            fontColor: color,
            fontSize: 16,
            textAlignment: TextAlign.center,
            fontWeight: FontWeight.w400,
          ),
        ),
        borderRadius: _ensureNonNegative(AppSize.width(value: 20.0)),
        padding: EdgeInsets.all(_ensureNonNegative(AppSize.width(value: 10.0))),
        margin: EdgeInsets.symmetric(
          horizontal: _ensureNonNegative(AppSize.width(value: 40.0)),
          vertical: _ensureNonNegative(AppSize.width(value: 30)),
        ),
      ),
    );
  }

  // Helper method to ensure non-negative values
  static double _ensureNonNegative(double value) {
    return value < 0 ? 0 : value;
  }
}
