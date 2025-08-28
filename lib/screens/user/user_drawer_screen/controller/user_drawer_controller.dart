import 'package:get/get.dart';
import 'package:itzel/screens/bottom_nav_screen/controller/bottom_nav_controller.dart';

import '../../../../models/profile_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../../services/repository/profile_repository/profile_repository.dart';
import '../../../../services/storage_services/app_auth_storage.dart';
import '../../../../widgets/app_snack_bar/app_snack_bar.dart';
import '../../../auth_screens/create_new_password_screen/controllers/create_new_passoword_controller.dart';
import '../../../auth_screens/forgot_password_screen/controllers/forgot_password_controller.dart';
import '../../../auth_screens/login_screen/controllers/login_controller.dart';
import '../../../auth_screens/registration_screen/controllers/registration_controller.dart';
import '../../../auth_screens/registration_verify_email_screen/controllers/registration_verify_email_controller.dart';
import '../../../auth_screens/verify_account_screen/controllers/verify_account_controller.dart';
import '../../../user/user_notification_screen/controllers/user_notification_controller.dart';

class UserDrawerController extends GetxController {
  AppAuthStorage appAuthStorage = AppAuthStorage();
  final ProfileRepository _profileRepository = ProfileRepository();
  var eventWishlist = <EventWishList>[].obs;
  var jobWishlist = <JobWishList>[].obs;

  Future<void> fetchEventWishlist() async {
    try {
      final profile = await _profileRepository.fetchProfile();
      if (profile != null) {
        eventWishlist.value = profile.eventWishList;
      }
    } catch (e) {
      AppSnackBar.error("Error fetching event wishlist: $e");
    }
  }

  Future<void> fetchJobWishlist() async {
    try {
      final profile = await _profileRepository.fetchProfile();
      if (profile != null) {
        jobWishlist.value = profile.jobWishList;
      }
    } catch (e) {
      AppSnackBar.error("Error fetching job wishlist: $e");
    }
  }

  Future<void> logout() async {
    try {
      // Delete all auth-related controllers to avoid GlobalKey duplication
      Get.delete<LoginController>(force: true);
      Get.delete<BottomNavController>(force: true);
      Get.delete<RegistrationController>(force: true);
      Get.delete<VerifyAccountController>(force: true);
      Get.delete<RegistrationVerifyEmailController>(force: true);
      Get.delete<ForgotPasswordController>(force: true);
      Get.delete<CreateNewPasswordController>(force: true);
      // Delete notification controller on logout
      if (Get.isRegistered<UserNotificationController>()) {
        Get.delete<UserNotificationController>(force: true);
      }
      await appAuthStorage.storageClear();
      AppSnackBar.success("Logged out successfully!");
      Get.offAllNamed(AppRoutes.loginScreen);
    } catch (e) {
      AppSnackBar.error("Failed to log out. Please try again.");
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchEventWishlist();
    fetchJobWishlist();
  }
}
