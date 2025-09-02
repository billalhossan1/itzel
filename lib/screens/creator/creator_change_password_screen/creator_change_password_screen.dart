import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itzel/services/repository/auth_repository/auth_repository.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/app_snack_bar/app_snack_bar.dart';
import '../../../widgets/appbar_widget/appbar_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_field_widget/text_field_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class CreatorChangePasswordScreen extends StatefulWidget {
  const CreatorChangePasswordScreen({super.key});

  @override
  State<CreatorChangePasswordScreen> createState() =>
      _CreatorChangePasswordScreenState();
}

class _CreatorChangePasswordScreenState
    extends State<CreatorChangePasswordScreen> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final retypeNewPasswordController = TextEditingController();

  void toggleObscurePassword(ValueNotifier<bool> obscureNotifier) {
    obscureNotifier.value = !obscureNotifier.value;
  }

  RxBool isLoading = false.obs;

  Future<void> handleChangePassword() async {
    final currentPassword = currentPasswordController.text;
    final newPassword = newPasswordController.text;
    final retypeNewPassword = retypeNewPasswordController.text;

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        retypeNewPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill up all the fields')),
      );
      return;
    } else if (newPassword != retypeNewPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('New password and retype password do not match')),
      );
      return;
    } else {
      isLoading.value = true;
      bool success = await AuthRepository().changePassword(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        confirmPassword: retypeNewPasswordController.text,
      );
      isLoading.value = false;
      if (success) {
        AppSnackBar.success("Password changed successfully!");
        Future.delayed(const Duration(seconds: 1), () {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          } else if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });
      } else {
        AppSnackBar.error("Failed to change password. Please try again.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
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
            TextFieldWidget(
              hintText: 'Current Password',
              controller: currentPasswordController,
              maxLines: 1,
              suffixIcon: Icons.visibility_off_outlined,
            ),
            const SpaceWidget(spaceHeight: 12),
            TextFieldWidget(
              hintText: 'New Password',
              controller: newPasswordController,
              maxLines: 1,
              suffixIcon: Icons.visibility_off_outlined,
            ),
            const SpaceWidget(spaceHeight: 12),
            TextFieldWidget(
              hintText: 'Re-type new Password',
              controller: retypeNewPasswordController,
              maxLines: 1,
              suffixIcon: Icons.visibility_off_outlined,
            ),
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
                child: Obx(
                  () => isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(color: Colors.white,),
                        )
                      : MaterialButton(
                          onPressed: handleChangePassword,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          child: Text(
                            AppStrings.changePassword,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: (size.width / (size.width / 16)),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                )),
          ],
        ),
      ),
    );
  }
}
