import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../routes/app_routes.dart';
import '../../../../services/storage_services/app_auth_storage.dart';
import '../../../../widgets/app_snack_bar/app_snack_bar.dart';
import '../../../user/user_notification_screen/controllers/user_notification_controller.dart';
import '../widgets/business_information_account_setup.dart';
import '../../../../services/repository/creator_drawer_repository.dart';

class CreatorDrawerController extends GetxController {
  AppAuthStorage appAuthStorage = AppAuthStorage();
  final CreatorDrawerRepository _repository = CreatorDrawerRepository();

  RxBool isLoading=false.obs;
  RxBool isLogoutLoading=false.obs;

  Future<void> logout() async {
    isLogoutLoading.value = true;
    try {
      // Delete notification controller on logout
      if (Get.isRegistered<UserNotificationController>()) {
        Get.delete<UserNotificationController>(force: true);
      }
      await appAuthStorage.storageClear();
      AppSnackBar.success("Logged out successfully!");
      Get.offAllNamed(AppRoutes.loginScreen);
    } catch (e) {
      AppSnackBar.error("Failed to log out. Please try again.");
    } finally {
      isLogoutLoading.value = false;
    }
  }

  Future<void> onTapBusinessInformation() async {
    isLoading(true);
    try {
      String? token = AppAuthStorage().getToken();
      print("object");
      final response = await _repository.connectBank(token ?? "");
      if (response != null && response.isSuccess) {
        String paymentLink = response.responseData['data']['url'];
        if (paymentLink.isNotEmpty) {
          bankAccountSetup(context: Get.context!, paymentUrl: paymentLink);
        }
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> handleAccountSuccess(String url, BuildContext context) async {
    isLoading.value = true;
    try {
      String? token = AppAuthStorage().getToken();
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Account Created Successful'),
            content: const Text('Your subscription payment was successful.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to create account. (${response.statusCode})'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
