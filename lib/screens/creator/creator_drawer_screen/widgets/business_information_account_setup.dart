import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itzel/constants/app_api_url.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../creator_drawer_screen/controller/creator_drawer_controller.dart';

void bankAccountSetup({required BuildContext context, required String paymentUrl}) {
  final controller = Get.find<CreatorDrawerController>();
  final WebViewController webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) async {
          if (request.url.contains(AppApiUrl.accountSuccessUrl)) {
            await controller.handleAccountSuccess(request.url, context);
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(paymentUrl));

  Get.dialog(
    Scaffold(
      appBar: AppBar(
        title: const Text('Bank Account'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context); // Close WebView screen
          },
        ),
      ),
      body: WebViewWidget(controller: webViewController),
    ),
    barrierDismissible: false,
  );
}
