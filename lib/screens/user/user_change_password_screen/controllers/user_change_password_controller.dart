import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/repository/auth_repository/auth_repository.dart';
import '../../../../utils/app_all_log/error_log.dart';
import '../../../../widgets/app_snack_bar/app_snack_bar.dart';

class UserChangePasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final retypeNewPasswordController = TextEditingController();
  AuthRepository authRepository = AuthRepository();

  var currentPasswordObscure = true.obs;
  var newPasswordObscure = true.obs;
  var retypePasswordObscure = true.obs;

  // Toggle password visibility
  void toggleObscurePassword(String type) {
    if (type == "current") {
      currentPasswordObscure.value = !currentPasswordObscure.value;
    } else if (type == "new") {
      newPasswordObscure.value = !newPasswordObscure.value;
    } else if (type == "retype") {
      retypePasswordObscure.value = !retypePasswordObscure.value;
    }
  }

  // Validate passwords
  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Enter Password";
    } else if (value.length < 6) {
      return "Password length should be more than 6 characters";
    }
    return null;
  }

  // Check if all fields are empty
  bool areFieldsEmpty() {
    return currentPasswordController.text.isEmpty &&
        newPasswordController.text.isEmpty &&
        retypeNewPasswordController.text.isEmpty;
  }

  // Check if new password matches retype password
  bool doPasswordsMatch() {
    return newPasswordController.text == retypeNewPasswordController.text;
  }

  // Handle button press logic
  void handleChangePassword(BuildContext context) async {
    try {
      if (areFieldsEmpty()) {
        AppSnackBar.error("Please fill in all the fields.");
      } else if (!doPasswordsMatch()) {
        AppSnackBar.error("New Password and Re-type Password do not match.");
      } else {
        bool success = await authRepository.changePassword(
          currentPassword: currentPasswordController.text,
          newPassword: newPasswordController.text,
          confirmPassword: retypeNewPasswordController.text,
        );

        if (success) {
          AppSnackBar.success("Password changed successfully!");
          Future.delayed(const Duration(seconds: 1), () {
            if (Get.isDialogOpen ?? false) {
              Get.back();
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          });
        } else {
          AppSnackBar.error("Failed to change password. Please try again.");
        }
      }
    } catch (e) {
      errorLog("handleChangePassword", e);
      AppSnackBar.error("An error occurred. Please try again.");
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    retypeNewPasswordController.dispose();
    super.onClose();
  }
}
