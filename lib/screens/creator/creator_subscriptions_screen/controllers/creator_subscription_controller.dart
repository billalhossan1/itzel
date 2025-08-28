import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../models/subscription_model.dart';
import '../../../../services/repository/subscription_repository/subscription_repository.dart';
import '../../../../utils/app_all_log/app_log.dart';

class CreatorSubscriptionsController extends GetxController {
  final SubscriptionRepository _subscriptionRepository =
      SubscriptionRepository();
  var subscriptions = <Subscription>[].obs;
  var isLoading = true.obs;
  var selectedPackIndex = 0.obs;
  late final WebViewController webViewController;

  Future<void> fetchSubscriptions() async {
    try {
      isLoading(true);
      final subs = await _subscriptionRepository.fetchSubscriptions();
      if (subs != null) {
        subscriptions.value = subs;
      }
    } catch (e) {
      print("Error in fetchSubscriptions: $e");
    } finally {
      isLoading(false);
    }
  }

  void selectPack(int index) {
    selectedPackIndex.value = index;
  }

  Future<void> launchSubscriptionUrl() async {
    final url = subscriptions[selectedPackIndex.value].url;

    // webViewController = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..setNavigationDelegate(
    //     NavigationDelegate(
    //       onNavigationRequest: (NavigationRequest request) {
    //         if (request.url.contains('stripe.com') &&
    //             (request.url.contains('success') ||
    //                 request.url.contains('completed') ||
    //                 request.url.contains('redirect'))) {
    //           // Close the WebView dialog
    //           Get.back();
    //
    //           // Navigate to main screen
    //           Get.offAll(() => BottomNavScreen());
    //
    //           // Show success message
    //           Get.snackbar(
    //             'Success',
    //             'Payment completed successfully!',
    //             snackPosition: SnackPosition.TOP,
    //             backgroundColor: Colors.green,
    //             colorText: Colors.white,
    //           );
    //
    //           return NavigationDecision.prevent;
    //         }
    //         return NavigationDecision.navigate;
    //       },
    //     ),
    //   )
    //   ..loadRequest(Uri.parse(url));

    // Show WebView in dialog

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(NavigationDelegate(
        onHttpError: (error) {},
        onPageFinished: (url) {},
        onWebResourceError: (error) {},
        onProgress: (progress) {},
        onPageStarted: (url) {},
        onNavigationRequest: (request) {
          appLog(request.url);

          if (request.url.toLowerCase().contains("success")) {
            Get.snackbar(
              'Success',
              'Payment completed successfully!',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            Get.back();
            return NavigationDecision.prevent;
          }

          if (request.url.toLowerCase().contains("error")) {
            Get.snackbar(
              'Error',
              'Payment failed. Please try again.',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(url));
    Get.dialog(
      Dialog(
        child: SizedBox(
          height: Get.height * 0.8,
          width: Get.width * 0.9,
          child: WebViewWidget(controller: webViewController),
        ),
      ),
      barrierDismissible: true,
    );
  }

  @override
  void onInit() {
    fetchSubscriptions();
    super.onInit();
  }
}
