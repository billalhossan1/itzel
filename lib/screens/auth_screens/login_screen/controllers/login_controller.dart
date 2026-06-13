import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../../services/repository/auth_repository/auth_repository.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isChecked = false;

  final AuthRepository authRepository = AuthRepository();

  @override
  void onInit() {
    initial();
    super.onInit();
  }

  void initial() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  void toggleRememberMe(bool? value) {
    isChecked = value ?? false;
    update(); // Notify listeners
  }

  RxBool isLoading = false.obs;

  void onSignIn() async {
    isLoading.value = true;
    String? role = await authRepository.signIn(
      email: emailController.text,
      password: passwordController.text,
    );
    isLoading.value = false;

    if (role != null) {
      emailController.clear();
      passwordController.clear();
      Get.offAllNamed(AppRoutes.subscriptionScreen, arguments: role);
    } else {
      Get.snackbar(
        'Error',
        'Invalid email or password. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   super.onClose();
  // }
}
