import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:itzel/screens/creator/creator_drawer_screen/widgets/creator_drawer_section_widget.dart';
import 'package:itzel/widgets/button_widget/button_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_icons_path.dart';
import '../../../constants/app_strings.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/icon_widget/icon_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import 'controller/creator_drawer_controller.dart';

class CreatorDrawerScreen extends StatelessWidget {
  final controller = Get.put(CreatorDrawerController());

  CreatorDrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: size.height / (size.height / 64),
        flexibleSpace: Container(
          color: AppColors.white,
        ),
        titleSpacing: -1,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const IconWidget(
            icon: 'assets/icons/closeIcon.svg',
            width: 24,
            height: 24,
          ),
        ),
        centerTitle: true,
        title: Image.asset(
          'assets/images/appLogo.png',
          height: size.height / (size.height / 45),
          width: size.width / (size.width / 120),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceWidget(spaceHeight: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextWidget(
                text: AppStrings.accountSetting,
                fontColor: AppColors.black500,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SpaceWidget(spaceHeight: 16),
            CreatorDrawerSectionWidget(
              onTap: () {
                Get.toNamed(AppRoutes.creatorBusinessInformationScreen);
              },
              text: AppStrings.businessInformation,
              icon: AppIconsPath.businessInformationIcon,
            ),
            // CreatorDrawerSectionWidget(
            //   onTap: () {
            //     Get.toNamed(AppRoutes.creatorPaymentMethodScreen);
            //   },
            //   text: AppStrings.payment,
            //   icon: AppIconsPath.paymentIcon,
            // ),
            CreatorDrawerSectionWidget(
              onTap: () {
                Get.toNamed(AppRoutes.creatorSubscriptionsScreen);
              },
              text: AppStrings.subscriptions,
              icon: AppIconsPath.subscriptionIcon,
            ),
            CreatorDrawerSectionWidget(
              onTap: () {
                showDialog(
                  context: Get.context!,
                  // or `context` if inside a StatefulWidget
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Warning'),
                      content: const Text(
                          'You are about to use AI services. Responses may not always be accurate. Proceed?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            Get.toNamed(AppRoutes.chatGptScreen); // Navigate
                          },
                          child: const Text('Proceed'),
                        ),
                      ],
                    );
                  },
                );
              },

              // onTap: () {
              //   Get.toNamed(AppRoutes.chatGptScreen);
              // },
              text: AppStrings.askAI,
              icon: AppIconsPath.aiChatIcon,
            ),
            CreatorDrawerSectionWidget(
              onTap: () {
                Get.toNamed(AppRoutes.faqScreen);
              },
              text: AppStrings.faq,
              icon: AppIconsPath.faqIcon,
            ),
            CreatorDrawerSectionWidget(
              onTap: () {
                Get.toNamed(AppRoutes.termsConditionScreen);
              },
              text: AppStrings.termsConditions,
              icon: AppIconsPath.termsConditionIcon,
            ),
            CreatorDrawerSectionWidget(
              onTap: () {
                Get.toNamed(AppRoutes.creatorChangePasswordScreen);
              },
              text: AppStrings.changePassword,
              icon: AppIconsPath.changePasswordIcon,
            ),
            // CreatorDrawerSectionWidget(
            //   onTap: () {
            //     Get.toNamed(AppRoutes.creatorDeleteAccountScreen);
            //   },
            //   text: AppStrings.deleteAccount,
            //   icon: AppIconsPath.deleteAccountIcon,
            // ),
            const SpaceWidget(spaceHeight: 80),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ButtonWidget(
                onPressed: () {
                  controller.logout();
                },
                label: 'Logout',
                buttonWidth: double.infinity,
              ),
            ),

            const Padding(
              padding:
                  EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 25),
              child: Text(
                textAlign: TextAlign.center,
                "Note: This app uses AI to generate responses. Output may be unpredictable.",
                style: TextStyle(fontWeight: FontWeight.bold),
                maxLines: 5,
              ),
            ),

            const SpaceWidget(spaceHeight: 16),
          ],
        ),
      ),
    );
  }
}
