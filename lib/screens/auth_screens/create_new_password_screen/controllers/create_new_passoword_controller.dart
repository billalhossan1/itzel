import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../../services/repository/auth_repository/auth_repository.dart';

class CreateNewPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();
  final AuthRepository authRepository = AuthRepository();
  final RxBool isLoading = false.obs;

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Password";
    } else if (value.length < 6) {
      return "Password length should be more than 6 characters";
    }
    return null;
  }

  void resetPassword() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      String newPassword = newPasswordController.text;
      String confirmPassword = confirmNewPasswordController.text;
      String token = Get.arguments['token'];

      bool isSuccess = await authRepository.resetPassword(
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        token: token,
      );

      isLoading.value = false;
      if (isSuccess) {
        newPasswordController.clear();
        confirmNewPasswordController.clear();
        Get.offAllNamed(AppRoutes.loginScreen);
        Get.snackbar(
          "Success",
          "Password changed successfully.",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to reset password. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Please fill all fields correctly.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.onClose();
  }
}
