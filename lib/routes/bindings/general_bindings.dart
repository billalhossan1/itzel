import 'package:get/get.dart';

import '../../screens/splash_screen/controller/splash_controller.dart';
import '../../screens/user/user_home_details_screen/controllers/user_home_details_controller.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
    Get.lazyPut(() => UserHomeDetailsController());
  }
}
