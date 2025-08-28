import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../services/connectivity_service/connectivity_service.dart';

class ErrorScreenController extends GetxController {
  RxString errorMessage =
      "Something went wrong. Please try refreshing the page or check your internet connection."
          .obs;
  RxBool internetProblem = false.obs;

  findInitialMessage() {
    try {
      internetProblem.value = false;
      var argData = Get.arguments;
      ConnectivityService connectivityService = ConnectivityService();
      if (argData.runtimeType != Null) {
        errorMessage.value = argData.toString();
      } else if (connectivityService.connectionStatus
          .contains(ConnectivityResult.none)) {
        errorMessage.value =
            "Please check your internet connection and try again later";
        internetProblem.value = true;
      }
    } catch (e) {
      errorMessage.value = "Something went wrong!";
    }
  }

  clickButton() {
    try {
      Get.offAllNamed(AppRoutes.splashScreen);
    } catch (e) {
      log("error form error click button :$e");
    }
  }

  @override
  void onInit() {
    findInitialMessage();
    super.onInit();
  }
}
