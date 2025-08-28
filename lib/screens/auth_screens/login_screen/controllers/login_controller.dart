import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../../services/repository/auth_repository/auth_repository.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isChecked = false;
  final AuthRepository authRepository = AuthRepository();

  void toggleRememberMe(bool? value) {
    isChecked = value ?? false;
    update(); // Notify listeners
  }

  void onSignIn() async {
    if (formKey.currentState!.validate()) {
      String? role = await authRepository.signIn(
        email: emailController.text,
        password: passwordController.text,
      );

      if (role != null) {
        emailController.clear();
        passwordController.clear();
        Get.offAllNamed(AppRoutes.bottomNavScreen, arguments: role);
      } else {
        Get.snackbar(
          'Error',
          'Invalid email or password. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
