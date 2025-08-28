import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/button_widget/button_widget.dart';
import '../../../widgets/checkbox_widget/checkbox_widget.dart';
import '../../../widgets/gradient_text_widget/gradient_text_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_button_widget/text_button_widget.dart';
import '../../../widgets/text_field_widget/text_field_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import 'controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.grey100,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GetBuilder<LoginController>(
              init: LoginController(),
              builder: (controller) {
                return Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SpaceWidget(spaceHeight: 130),
                      const Center(
                        child: TextWidget(
                          text: AppStrings.loginToAccount,
                          fontColor: AppColors.black500,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SpaceWidget(spaceHeight: 12),
                      const Center(
                        child: TextWidget(
                          text: AppStrings.fillInTheLoginBlanks,
                          fontColor: AppColors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          maxLines: 2,
                        ),
                      ),
                      const SpaceWidget(spaceHeight: 24),
                      TextFieldWidget(
                        controller: controller.emailController,
                        hintText: 'Email',
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
                      const SpaceWidget(spaceHeight: 12),
                      TextFieldWidget(
                        controller: controller.passwordController,
                        hintText: 'Password',
                        maxLines: 1,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Password";
                          } else if (controller.passwordController.text.length <
                              6) {
                            return "Password length should be more than 6 characters";
                          }
                          return null;
                        },
                        suffixIcon: Icons.visibility_off_outlined,
                      ),
                      const SpaceWidget(spaceHeight: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CheckboxWidget(
                                value: controller.isChecked,
                                onChanged: controller.toggleRememberMe,
                                activeColor: AppColors.blue500,
                                unselectedColor: Colors.grey,
                              ),
                              const SpaceWidget(spaceWidth: 8),
                              const TextWidget(
                                text: AppStrings.rememberMe,
                                fontColor: AppColors.grey900,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                          TextButtonWidget(
                            onPressed: () {
                              Get.toNamed(AppRoutes.forgotPasswordScreen);
                            },
                            text: AppStrings.forgotPassword,
                            textColor: AppColors.blueLight,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.blueLight,
                          ),
                        ],
                      ),
                      const SpaceWidget(spaceHeight: 32),
                      ButtonWidget(
                        onPressed: controller.onSignIn,
                        label: AppStrings.signInButtonText,
                        buttonWidth: double.infinity,
                        buttonHeight: 56,
                      ),
                      const SpaceWidget(spaceHeight: 32),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       flex: 1,
                      //       child: Container(
                      //         height: 1,
                      //         width: 250,
                      //         color: AppColors.grey700,
                      //       ),
                      //     ),
                      //     const SpaceWidget(spaceWidth: 8),
                      //     // const Expanded(
                      //     //   flex: 1,
                      //     //   child: TextWidget(
                      //     //     text: AppStrings.orSignInWith,
                      //     //     fontColor: AppColors.black500,
                      //     //     fontSize: 14,
                      //     //     fontWeight: FontWeight.w400,
                      //     //   ),
                      //     // ),
                      //     const SpaceWidget(spaceWidth: 8),
                      //     Expanded(
                      //       flex: 1,
                      //       child: Container(
                      //         height: 1,
                      //         width: 250,
                      //         color: AppColors.grey700,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SpaceWidget(spaceHeight: 24),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     IconButtonWidget(
                      //       onTap: () {},
                      //       icon: AppIconsPath.appleIcon,
                      //     ),
                      //     const SpaceWidget(spaceWidth: 40),
                      //     IconButtonWidget(
                      //       onTap: () {},
                      //       icon: AppIconsPath.googleIcon,
                      //     ),
                      //   ],
                      // ),
                      //const SpaceWidget(spaceHeight: 50),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const TextWidget(
                            text: "Don't have an account?",
                            fontColor: AppColors.grey900,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            maxLines: 2,
                          ),
                          const SpaceWidget(spaceWidth: 8),
                          TextButton(
                            onPressed: () {
                              Get.delete<LoginController>(force: true);
                              Get.toNamed(AppRoutes.registrationScreen);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              alignment: Alignment.center,
                            ),
                            child: GradientTextWidget(
                              text: 'Sign up',
                              fontWeight: FontWeight.w500,
                              textSize: (MediaQuery.sizeOf(context).width /
                                  (MediaQuery.sizeOf(context).width / 14)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
