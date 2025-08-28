import 'package:get/get.dart';

import '../../screens/auth_screens/create_new_password_screen/controllers/create_new_passoword_controller.dart';
import '../../screens/auth_screens/forgot_password_screen/controllers/forgot_password_controller.dart';
import '../../screens/auth_screens/login_screen/controllers/login_controller.dart';
import '../../screens/auth_screens/registration_screen/controllers/registration_controller.dart';
import '../../screens/auth_screens/verify_account_screen/controllers/verify_account_controller.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotPasswordController());
    Get.lazyPut(() => ForgotPasswordController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => RegistrationController());
    Get.lazyPut(() => VerifyAccountController());
    Get.lazyPut(() => CreateNewPasswordController());
  }
}
