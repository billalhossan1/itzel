// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:itzel/screens/user/user_drawer_screen/widgets/drawer_section_widget.dart';
// import 'package:itzel/widgets/button_widget/button_widget.dart';
//
// import '../../../constants/app_colors.dart';
// import '../../../constants/app_icons_path.dart';
// import '../../../constants/app_strings.dart';
// import '../../../routes/app_routes.dart';
// import '../../../widgets/icon_widget/icon_widget.dart';
// import '../../../widgets/space_widget/space_widget.dart';
// import '../../../widgets/text_widget/text_widgets.dart';
// import 'controller/user_drawer_controller.dart';
//
// class UserDrawerScreen extends StatelessWidget {
//   final controller = Get.put(UserDrawerController());
//
//   UserDrawerScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.sizeOf(context);
//     return Scaffold(
//       backgroundColor: AppColors.whiteBg,
//       appBar: AppBar(
//         systemOverlayStyle: SystemUiOverlayStyle.dark,
//         toolbarHeight: size.height / (size.height / 64),
//         flexibleSpace: Container(
//           color: AppColors.white,
//         ),
//         titleSpacing: -1,
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: const IconWidget(
//             icon: 'assets/icons/closeIcon.svg',
//             width: 24,
//             height: 24,
//           ),
//         ),
//         centerTitle: true,
//         title: Image.asset(
//           'assets/images/appLogo.png',
//           height: size.height / (size.height / 45),
//           width: size.width / (size.width / 120),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SpaceWidget(spaceHeight: 12),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: TextWidget(
//                 text: AppStrings.accountSetting,
//                 fontColor: AppColors.black500,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SpaceWidget(spaceHeight: 16),
//             DrawerSectionWidget(
//               onTap: () {
//                 Get.toNamed(
//                   AppRoutes.userSavedEventsScreen,
//                   arguments: controller.eventWishlist,
//                 );
//               },
//               text: AppStrings.savedEvents,
//               icon: AppIconsPath.savedEventsIcon,
//             ),
//             DrawerSectionWidget(
//               onTap: () {
//                 Get.toNamed(
//                   AppRoutes.userSavedJobsScreen,
//                   arguments: controller.jobWishlist,
//                 );
//               },
//               text: AppStrings.savedJobs,
//               icon: AppIconsPath.savedEventsIcon,
//             ),
//             DrawerSectionWidget(
//               onTap: () {
//                 Get.toNamed(AppRoutes.chatGptScreen);
//               },
//               text: AppStrings.askAI,
//               icon: AppIconsPath.aiChatIcon,
//             ),
//             DrawerSectionWidget(
//               onTap: () {
//                 Get.toNamed(AppRoutes.faqScreen);
//               },
//               text: AppStrings.faq,
//               icon: AppIconsPath.faqIcon,
//             ),
//             DrawerSectionWidget(
//               onTap: () {
//                 Get.toNamed(AppRoutes.termsConditionScreen);
//               },
//               text: AppStrings.termsConditions,
//               icon: AppIconsPath.termsConditionIcon,
//             ),
//             DrawerSectionWidget(
//               onTap: () {
//                 Get.toNamed(AppRoutes.userChangePasswordScreen);
//               },
//               text: AppStrings.changePassword,
//               icon: AppIconsPath.changePasswordIcon,
//             ),
//             // DrawerSectionWidget(
//             //   onTap: () {
//             //     Get.toNamed(AppRoutes.userDeleteAccountScreen);
//             //   },
//             //   text: AppStrings.deleteAccount,
//             //   icon: AppIconsPath.deleteAccountIcon,
//             // ),
//             const SpaceWidget(spaceHeight: 80),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: ButtonWidget(
//                 onPressed: () {
//                   controller.logout();
//                 },
//                 label: 'Logout',
//                 buttonWidth: double.infinity,
//               ),
//             ),
//             const SpaceWidget(spaceHeight: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:itzel/screens/user/user_drawer_screen/widgets/drawer_section_widget.dart';
import 'package:itzel/widgets/button_widget/button_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_icons_path.dart';
import '../../../constants/app_strings.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/icon_widget/icon_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import 'controller/user_drawer_controller.dart';

class UserDrawerScreen extends StatelessWidget {
  final controller = Get.put(UserDrawerController());

  UserDrawerScreen({super.key});

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
            DrawerSectionWidget(
              onTap: () {
                Get.toNamed(
                  AppRoutes.userSavedEventsScreen,
                  arguments: controller.eventWishlist,
                );
              },
              text: AppStrings.savedEvents,
              icon: AppIconsPath.savedEventsIcon,
            ),
            DrawerSectionWidget(
              onTap: () {
                Get.toNamed(
                  AppRoutes.userSavedJobsScreen,
                  arguments: controller.jobWishlist,
                );
              },
              text: AppStrings.savedJobs,
              icon: AppIconsPath.savedEventsIcon,
            ),
            DrawerSectionWidget(
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
              //
              //   Get.toNamed(AppRoutes.chatGptScreen);
              // },
              text: AppStrings.askAI,
              icon: AppIconsPath.aiChatIcon,
            ),
            DrawerSectionWidget(
              onTap: () {
                Get.toNamed(AppRoutes.faqScreen);
              },
              text: AppStrings.faq,
              icon: AppIconsPath.faqIcon,
            ),
            DrawerSectionWidget(
              onTap: () {
                Get.toNamed(AppRoutes.termsConditionScreen);
              },
              text: AppStrings.termsConditions,
              icon: AppIconsPath.termsConditionIcon,
            ),
            DrawerSectionWidget(
              onTap: () {
                Get.toNamed(AppRoutes.userChangePasswordScreen);
              },
              text: AppStrings.changePassword,
              icon: AppIconsPath.changePasswordIcon,
            ),
            // DrawerSectionWidget(
            //   onTap: () {
            //     Get.toNamed(AppRoutes.userDeleteAccountScreen);
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
