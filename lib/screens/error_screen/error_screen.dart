import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itzel/constants/app_colors.dart';
import 'package:itzel/utils/app_size.dart';
import 'package:itzel/widgets/space_widget/space_widget.dart';

import '../../constants/app_images_path.dart';
import '../../widgets/app_image/app_image.dart';
import '../../widgets/text_widget/text_widgets.dart';
import 'controllers/error_screen_controller.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder(
        init: ErrorScreenController(),
        builder: (controller) {
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.all(ResponsiveUtils.width(10.0)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => AppImage(
                        path: controller.internetProblem.value
                            ? AppImagesPath.errorIconNoInternet
                            : AppImagesPath.error,
                        width: AppSize.width(value: 80),
                        height: AppSize.width(value: 80),
                      ),
                    ),
                    const SpaceWidget(spaceHeight: 20),
                    Obx(
                      () => TextWidget(
                        text: controller.internetProblem.value
                            ? "No internet connection"
                            : "Whoops!",
                        fontSize: 24,
                        fontColor: AppColors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SpaceWidget(spaceHeight: 20),
                    Obx(() => TextWidget(
                          text: controller.errorMessage.value,
                          fontColor: AppColors.black,
                          fontWeight: FontWeight.w700,
                        )),
                    const SpaceWidget(spaceHeight: 50),
                    GestureDetector(
                      onTap: () {
                        controller.clickButton();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSize.width(value: 15),
                            vertical: AppSize.width(value: 10.0)),
                        decoration: BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.circular(
                                AppSize.width(value: 10.0))),
                        child: const TextWidget(
                          text: "Try Again",
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
