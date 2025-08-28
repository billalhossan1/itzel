import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itzel/routes/app_routes.dart';
import 'package:itzel/screens/user/user_account_screen/widgets/profile_info_widget.dart';
import 'package:itzel/widgets/button_widget/button_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import 'controllers/user_account_controller.dart';

class UserAccountScreen extends StatelessWidget {
  final UserAccountController controller = Get.put(UserAccountController());

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  UserAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceWidget(spaceHeight: 16),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: AppImage(
                        url: controller.profileImage.value,
                        height: size.width / (size.width / 150),
                        width: size.width / (size.width / 150),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 10),
                  Center(
                    child: TextWidget(
                      text: capitalize(controller.username.value),
                      fontColor: AppColors.black500,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 12),
                  const TextWidget(
                    text: AppStrings.accountDetails,
                    fontColor: AppColors.black400,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  const SpaceWidget(spaceHeight: 8),
                  ProfileInfoWidget(
                    label: 'Email',
                    value: controller.email.value,
                  ),
                  ProfileInfoWidget(
                    label: 'Contact Number',
                    value: controller.contactNumber.value,
                  ),
                  ProfileInfoWidget(
                    label: 'Address',
                    value: capitalize(controller.address.value),
                  ),
                  const SpaceWidget(spaceHeight: 36),
                  ButtonWidget(
                    onPressed: () {
                      Get.toNamed(
                        AppRoutes.userProfileScreen,
                        arguments: {
                          'username': controller.username.value,
                          'email': controller.email.value,
                          'contactNumber': controller.contactNumber.value,
                          'address': controller.address.value,
                          'profileImage': controller.profileImage.value,
                        },
                      );
                    },
                    label: "Edit Profile",
                    backgroundColor: AppColors.blue500,
                    textColor: AppColors.white,
                    buttonRadius: BorderRadius.circular(16),
                    buttonWidth: double.infinity,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
