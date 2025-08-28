import 'package:get/get.dart';
import 'package:itzel/screens/bottom_nav_screen/bottom_nav_screen.dart';

import '../../../routes/app_routes.dart';
import '../../../services/repository/auth_repository/auth_repository.dart';
import '../../../services/storage_services/app_auth_storage.dart';
import '../../../utils/app_all_log/error_log.dart';

class SplashController extends GetxController {
  AppAuthStorage appAuthStorage = AppAuthStorage();

  Future<void> initialDataLoad() async {
    try {
      var token = appAuthStorage.getToken();
      if (token != null && token.isNotEmpty) {
        String? userRole = extractRoleFromToken(token);

        await Future.delayed(
          const Duration(seconds: 2),
          () {
            if (userRole != null) {
              Get.offAll(const BottomNavScreen());
            } else {
              Get.offAllNamed(AppRoutes.loginScreen);
            }
          },
        );
      } else {
        await Future.delayed(
          const Duration(seconds: 2),
          () {
            Get.offAllNamed(AppRoutes.loginScreen);
          },
        );
      }
    } catch (e) {
      errorLog("initial data load function", e);
      Get.offAllNamed(AppRoutes.errorScreen);
    }
  }

  @override
  void onInit() {
    super.onInit();
    initialDataLoad();
  }
}
