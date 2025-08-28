import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/button_widget/button_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_field_widget/text_field_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import 'controllers/create_new_passoword_controller.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  CreateNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width /
                (MediaQuery.sizeOf(context).width / 24)),
        child: GetBuilder<CreateNewPasswordController>(
            init: CreateNewPasswordController(),
            builder: (controller) {
              return Form(
                key: controller.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: TextWidget(
                        text: 'Create New Password',
                        fontColor: AppColors.black500,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SpaceWidget(spaceHeight: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.sizeOf(context).width /
                              (MediaQuery.sizeOf(context).width / 32)),
                      child: const Center(
                        child: TextWidget(
                          text:
                              "Your new password must be different from previous passwords.",
                          fontColor: AppColors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    const SpaceWidget(spaceHeight: 24),
                    TextFieldWidget(
                      controller: controller.newPasswordController,
                      hintText: 'New password',
                      maxLines: 1,
                      validator: controller.validatePassword,
                    ),
                    const SpaceWidget(spaceHeight: 12),
                    TextFieldWidget(
                      controller: controller.confirmNewPasswordController,
                      hintText: 'Confirm password',
                      maxLines: 1,
                      validator: controller.validatePassword,
                    ),
                    const SpaceWidget(spaceHeight: 12),
                    const TextWidget(
                      text: 'Both passwords must match.',
                      fontColor: AppColors.black400,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      maxLines: 2,
                    ),
                    const SpaceWidget(spaceHeight: 24),
                    ButtonWidget(
                      onPressed: controller.resetPassword,
                      label: 'Reset Password',
                      buttonWidth: double.infinity,
                      buttonHeight: 56,
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
