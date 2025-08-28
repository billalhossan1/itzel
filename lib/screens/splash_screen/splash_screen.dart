import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../widgets/icon_widget/icon_widget.dart';
import 'controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) {
        return AnnotatedRegion(
          value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
          ),
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.blue500,
                    AppColors.blue,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: IconWidget(
                  icon: 'assets/icons/splashLogo.svg',
                  height: 180,
                  width: 180,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
