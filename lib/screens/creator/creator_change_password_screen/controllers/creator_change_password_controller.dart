import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatorChangePasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final retypeNewPasswordController = TextEditingController();

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
  void handleChangePassword(BuildContext context) {
    if (areFieldsEmpty()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all the fields."),
          backgroundColor: Colors.red,
        ),
      );
    } else if (!doPasswordsMatch()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("New Password and Re-type Password do not match."),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password changed successfully!"),
          backgroundColor: Colors.green,
        ),
      );
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
