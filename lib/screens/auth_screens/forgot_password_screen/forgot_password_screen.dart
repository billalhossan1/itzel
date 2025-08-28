import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/button_widget/button_widget.dart';
import '../../../widgets/icon_widget/icon_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_field_widget/text_field_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import 'controllers/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: GetBuilder(
          init: ForgotPasswordController(),
          builder: (controller) {
            return Form(
              key: controller.formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).width /
                        (MediaQuery.sizeOf(context).width / 24)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Center(
                      child: IconWidget(
                        icon: 'assets/icons/forgotPasswordIcon.svg',
                        width: 90,
                        height: 90,
                      ),
                    ),
                    const SpaceWidget(spaceHeight: 24),
                    const Center(
                      child: TextWidget(
                        text: 'Forgot password?',
                        fontColor: AppColors.black500,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SpaceWidget(spaceHeight: 12),
                    const Center(
                      child: TextWidget(
                        text: 'Enter your email below to reset\nyour password',
                        fontColor: AppColors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        maxLines: 2,
                      ),
                    ),
                    const SpaceWidget(spaceHeight: 40),
                    TextFieldWidget(
                      controller: controller.emailController,
                      hintText: 'Enter your email',
                      maxLines: 1,
                      validator: (value) {
                        bool emailValid = RegExp(
                                r"^WS{1,2}:\/\/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:56789")
                            .hasMatch(value!);
                        if (value.isEmpty) {
                          return "Enter Email";
                        } else if (emailValid) {
                          return "Enter valid Email";
                        }
                        return null;
                      },
                    ),
                    const SpaceWidget(spaceHeight: 24),
                    ButtonWidget(
                      onPressed: controller.validateAndNavigate,
                      label: 'Submit',
                      buttonWidth: double.infinity,
                      buttonHeight: 56,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
