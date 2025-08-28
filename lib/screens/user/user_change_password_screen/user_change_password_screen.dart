import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/appbar_widget/appbar_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_field_widget/text_field_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import 'controllers/user_change_password_controller.dart';

class UserChangePasswordScreen extends StatelessWidget {
  const UserChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final controller = Get.put(UserChangePasswordController());

    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      appBar: const AppbarWidget(text: AppStrings.changePassword),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            const TextWidget(
              text: AppStrings.changePasswordText,
              fontColor: AppColors.blackDark,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              textAlignment: TextAlign.left,
            ),
            const SpaceWidget(spaceHeight: 30),
            Obx(() => TextFieldWidget(
                  hintText: 'Current Password',
                  controller: controller.currentPasswordController,
                  maxLines: 1,
                  suffixIcon: controller.currentPasswordObscure.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                )),
            const SpaceWidget(spaceHeight: 12),
            Obx(() => TextFieldWidget(
                  hintText: 'New Password',
                  controller: controller.newPasswordController,
                  maxLines: 1,
                  suffixIcon: controller.newPasswordObscure.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                )),
            const SpaceWidget(spaceHeight: 12),
            Obx(() => TextFieldWidget(
                  hintText: 'Re-type new Password',
                  controller: controller.retypeNewPasswordController,
                  maxLines: 1,
                  suffixIcon: controller.retypePasswordObscure.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                )),
            const SpaceWidget(spaceHeight: 48),
            Container(
              height: (size.height / (size.height / 54)),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.blue,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 5.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: MaterialButton(
                onPressed: () => controller.handleChangePassword(context),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: Text(
                  AppStrings.changePassword,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: (size.width / (size.width / 16)),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
