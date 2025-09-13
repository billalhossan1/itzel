import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../../services/repository/auth_repository/auth_repository.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final AuthRepository authRepository = AuthRepository();
  RxBool isLoading = false.obs;

  void validateAndNavigate() async {
    if (formKey.currentState!.validate()) {
      String email = emailController.text;
      isLoading.value = true;
      bool isSuccess = await authRepository.forgotPassword(email: email);
      isLoading.value = false;
      if (isSuccess) {
        emailController.clear();
        Get.toNamed(
          AppRoutes.verifyAccountScreen,
          arguments: {'email': email,"forgot":true},
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to send reset password email. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else if (emailController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
