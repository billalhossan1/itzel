
import 'package:get/get.dart';

class CreatorDeleteAccountController extends GetxController {
  // State variable to toggle password visibility
  var isPasswordVisible = false.obs;

  // Method to toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Method to validate and handle delete account action
  void deleteAccount(String password, Function showError) {
    if (password.isEmpty) {
      showError("Enter Password");
    } else if (password.length < 6) {
      showError("Password length should be more than 6 characters");
    } else {
      // Add your delete account logic here
      Get.snackbar("Success", "Account deleted successfully",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

}
