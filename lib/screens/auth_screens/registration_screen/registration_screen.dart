import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';

import '../../../constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/button_widget/button_widget.dart';
import '../../../widgets/checkbox_widget/checkbox_widget.dart';
import '../../../widgets/gradient_text_widget/gradient_text_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_field_widget/text_field_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import 'controllers/registration_controller.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.grey100,
        body: SafeArea(
          child: SingleChildScrollView(
            child: GetBuilder<RegistrationController>(
                builder: (controller) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SpaceWidget(spaceHeight: 80),
                      const Center(
                        child: TextWidget(
                          text: 'Create Account',
                          fontColor: AppColors.black500,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SpaceWidget(spaceHeight: 12),
                      const Center(
                        child: TextWidget(
                          text:
                              'Choose your role before creating\nyour account.',
                          fontColor: AppColors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          maxLines: 2,
                        ),
                      ),
                      const SpaceWidget(spaceHeight: 24),
                      // Role Selection Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => controller.toggleRole(false),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            child: Container(
                              height: MediaQuery.sizeOf(context).height /
                                  (MediaQuery.sizeOf(context).height / 48),
                              width: MediaQuery.sizeOf(context).width /
                                  (MediaQuery.sizeOf(context).width / 165),
                              decoration: BoxDecoration(
                                gradient: !controller.isCreator
                                    ? const LinearGradient(
                                        colors: [
                                          AppColors.blue500,
                                          AppColors.blue
                                        ],
                                      )
                                    : const LinearGradient(
                                        colors: [
                                          AppColors.blue200,
                                          AppColors.blue200
                                        ],
                                      ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Center(
                                child: Text(
                                  'User',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        (MediaQuery.sizeOf(context).width /
                                            (MediaQuery.sizeOf(context).width /
                                                16)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SpaceWidget(spaceWidth: 16),
                          InkWell(
                            onTap: () => controller.toggleRole(true),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            child: Container(
                              height: MediaQuery.sizeOf(context).height /
                                  (MediaQuery.sizeOf(context).height / 48),
                              width: MediaQuery.sizeOf(context).width /
                                  (MediaQuery.sizeOf(context).width / 165),
                              decoration: BoxDecoration(
                                gradient: controller.isCreator
                                    ? const LinearGradient(
                                        colors: [
                                          AppColors.blue500,
                                          AppColors.blue
                                        ],
                                      )
                                    : const LinearGradient(
                                        colors: [
                                          AppColors.blue200,
                                          AppColors.blue200
                                        ],
                                      ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Center(
                                child: Text(
                                  'Creator',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        (MediaQuery.sizeOf(context).width /
                                            (MediaQuery.sizeOf(context).width /
                                                16)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SpaceWidget(spaceHeight: 24),

                      // Registration Form
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.sizeOf(context).width /
                                (MediaQuery.sizeOf(context).width / 24)),
                        child: Form(
                          key: controller.isCreator
                              ? controller.creatorFormKey
                              : controller.userFormKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFieldWidget(
                                controller: controller.isCreator
                                    ? controller.creatorNameController
                                    : controller.userNameController,
                                hintText: 'Name',
                                maxLines: 1,
                                validator: (value) =>
                                    value!.isEmpty ? "Enter Name" : null,
                              ),
                              const SpaceWidget(spaceHeight: 12),
                              TextFieldWidget(
                                controller: controller.isCreator
                                    ? controller.creatorEmailController
                                    : controller.userEmailController,
                                hintText: 'Email',
                                maxLines: 1,
                                validator: (value) {
                                  bool emailValid =
                                      RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$")
                                          .hasMatch(value!);
                                  if (value.isEmpty) return "Enter Email";
                                  if (!emailValid) return "Enter valid Email";
                                  return null;
                                },
                              ),
                              const SpaceWidget(spaceHeight: 12),


                                  // CountryCodePicker(
                                  //   onChanged: (country) {
                                  //     if (controller.isCreator) {
                                  //       controller.creatorCountryCode = country.dialCode ?? '+1';
                                  //     } else {
                                  //       controller.userCountryCode = country.dialCode ?? '+1';
                                  //     }
                                  //   },
                                  //   initialSelection: controller.isCreator
                                  //       ? controller.creatorCountryCode
                                  //       : controller.userCountryCode,
                                  //   favorite: const ['+1', 'US', '+91', 'IN'],
                                  //   showCountryOnly: false,
                                  //   showOnlyCountryWhenClosed: false,
                                  //   alignLeft: false,
                                  // ),

                                  // const SizedBox(width: 8),
                                  //
                                  // Row(
                                  //   children: [
                                  //     Expanded(
                                  //       child: TextFieldWidget(
                                  //         controller: controller.isCreator
                                  //             ? controller.creatorPhoneController
                                  //             : controller.userPhoneController,
                                  //         keyboardType: TextInputType.phone,
                                  //         validator: (value) {
                                  //           if (value == null || value.isEmpty) {
                                  //             return 'Enter phone number';
                                  //           }
                                  //           return null;
                                  //         }, hintText: 'Phone Number',
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),



                                  // Expanded(
                                  //   child: TextFormField(
                                  //     controller: controller.isCreator
                                  //         ? controller.creatorPhoneController
                                  //         : controller.userPhoneController,
                                  //     keyboardType: TextInputType.phone,
                                  //     decoration: const InputDecoration(
                                  //       hintText: 'Phone Number',
                                  //       border: OutlineInputBorder(),
                                  //       contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                  //     ),
                                  //     validator: (value) {
                                  //       if (value == null || value.isEmpty) {
                                  //         return 'Enter phone number';
                                  //       }
                                  //       return null;
                                  //     },
                                  //   ),
                                  // ),

                              const SpaceWidget(spaceHeight: 12),

                              TextFieldWidget(
                                controller: controller.isCreator
                                    ? controller.creatorPasswordController
                                    : controller.userPasswordController,
                                hintText: 'Password',
                                maxLines: 1,
                                validator: (value) => value!.length < 6
                                    ? "Password length should be more than 6 characters"
                                    : null,
                                suffixIcon: Icons.visibility_off_outlined,
                              ),
                              const SpaceWidget(spaceHeight: 12),
                              TextFieldWidget(
                                controller: controller.isCreator
                                    ? controller
                                        .creatorConfirmPasswordController
                                    : controller.userConfirmPasswordController,
                                hintText: 'Confirm Password',
                                maxLines: 1,
                                validator: (value) => value!.length < 6
                                    ? "Password length should be more than 6 characters"
                                    : null,
                                suffixIcon: Icons.visibility_off_outlined,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CheckboxWidget(
                                    value: controller.isCreator
                                        ? controller.isCreatorChecked
                                        : controller.isUserChecked,
                                    onChanged: (value) {
                                      if (controller.isCreator) {
                                        controller.toggleCreatorChecked(
                                            value ?? false);
                                      } else {
                                        controller
                                            .toggleUserChecked(value ?? false);
                                      }
                                    },
                                    activeColor: controller.isCreator
                                        ? AppColors.blue500
                                        : AppColors.blue500,
                                    unselectedColor: Colors.grey,
                                  ),
                                  const SpaceWidget(spaceWidth: 8),
                                  const TextWidget(
                                    text: 'I agree with',
                                    fontColor: AppColors.black400,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    maxLines: 2,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.toNamed(AppRoutes.termsConditionScreen);
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(50, 30),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      alignment: Alignment.center,
                                    ),
                                    child: GradientTextWidget(

                                      text: 'terms',
                                      fontWeight: FontWeight.w400,
                                      textSize: (MediaQuery.sizeOf(context)
                                              .width /
                                          (MediaQuery.sizeOf(context).width /
                                              14)),
                                    ),
                                  ),
                                  const TextWidget(
                                    text: 'of service',
                                    fontColor: AppColors.black400,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    maxLines: 2,
                                  ),
                                  // TextButton(
                                  //   onPressed: () {
                                  //     Get.toNamed(AppRoutes.termsConditionScreen);
                                  //   },
                                  //   style: TextButton.styleFrom(
                                  //     padding: EdgeInsets.zero,
                                  //     minimumSize: const Size(50, 30),
                                  //     tapTargetSize:
                                  //         MaterialTapTargetSize.shrinkWrap,
                                  //     alignment: Alignment.center,
                                  //   ),
                                  //   // child: GradientTextWidget(
                                  //   //   text: 'policy',
                                  //   //   fontWeight: FontWeight.w400,
                                  //   //   textSize: (MediaQuery.sizeOf(context)
                                  //   //           .width /
                                  //   //       (MediaQuery.sizeOf(context).width /
                                  //   //           14)),
                                  //   // ),
                                  // ),
                                ],
                              ),
                              const SpaceWidget(spaceHeight: 50),
                             Obx(()=> ButtonWidget(
                               onPressed: controller.submitForm,
                               label: 'Create Account',
                               buttonWidth: double.infinity,
                               buttonHeight: 56,
                               isLoading: controller.isLoading.value,
                             ),),
                              const SpaceWidget(spaceHeight: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const TextWidget(
                                    text: 'Already have an account?',
                                    fontColor: AppColors.grey900,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    maxLines: 2,
                                  ),
                                  const SpaceWidget(spaceWidth: 8),
                                  TextButton(
                                    onPressed: () {
                                      // Use Get.offAllNamed to navigate and let GetX handle controller lifecycle
                                      Get.offAllNamed(AppRoutes.loginScreen);
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(50, 30),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      alignment: Alignment.center,
                                    ),
                                    child: GradientTextWidget(
                                      text: 'Sign in',
                                      fontWeight: FontWeight.w500,
                                      textSize: (MediaQuery.sizeOf(context)
                                              .width /
                                          (MediaQuery.sizeOf(context).width /
                                              14)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SpaceWidget(spaceHeight: 24),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
