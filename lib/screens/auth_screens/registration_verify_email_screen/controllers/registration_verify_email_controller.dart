import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../../services/repository/auth_repository/auth_repository.dart';

class RegistrationVerifyEmailController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var otpTextEditingController1 = TextEditingController();
  var otpTextEditingController2 = TextEditingController();
  var otpTextEditingController3 = TextEditingController();
  var otpTextEditingController4 = TextEditingController();

  var remainingSeconds = 180.obs; // 2.5 minutes
  var canResend = false.obs;

  late Timer _timer;
  final AuthRepository authRepository = AuthRepository();

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    _timer.cancel();
    otpTextEditingController1.dispose();
    otpTextEditingController2.dispose();
    otpTextEditingController3.dispose();
    otpTextEditingController4.dispose();
    super.onClose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        canResend.value = true;
        _timer.cancel();
      }
    });
  }

  void resendCode() async {
    final email = Get.arguments['email'];
    bool isSuccess = await authRepository.resentOtp(email: email);
    if (isSuccess) {
      remainingSeconds.value = 180;
      canResend.value = false;
      startTimer();
      Get.snackbar(
        "Code Sent",
        "A new verification code has been sent to your email.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Error",
        "Failed to resend the verification code. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  String formatTime() {
    final minutes = remainingSeconds.value ~/ 60;
    final remainingSec = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSec.toString().padLeft(2, '0')}';
  }

  void verifyOTP() async {
    final email = Get.arguments['email'];
    final otp = otpTextEditingController1.text +
        otpTextEditingController2.text +
        otpTextEditingController3.text +
        otpTextEditingController4.text;

    print('Email: $email');
    print('OTP: $otp');
    print('OTP Length: ${otp.length}');

    if (otp.length == 4) {
      bool isSuccess = await authRepository.registrationVerifyEmail(
        email: email,
        otp: otp,
      );

      print('API Response: $isSuccess');

      if (isSuccess) {
        Get.offAllNamed(AppRoutes.loginScreen);
      } else {
        Get.snackbar('Error', 'Invalid OTP. Please try again.');
      }
    } else {
      Get.snackbar('Error', 'Please enter the complete OTP.');
    }
  }
}
