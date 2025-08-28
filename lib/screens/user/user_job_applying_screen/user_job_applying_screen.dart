import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:itzel/screens/user/user_job_applying_screen/widgets/SubmitButtonWidget.dart';
import 'package:itzel/screens/user/user_job_applying_screen/widgets/job_applying_text_field_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/appbar_widget/appbar_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import 'controllers/user_job_applying_controller.dart';

class UserJobApplyingScreen extends StatelessWidget {
  final UserJobApplyingController _controller =
      Get.put(UserJobApplyingController());

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  UserJobApplyingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.whiteBg,
        appBar: const AppbarWidget(text: AppStrings.applying),
        body: Obx(() {
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final job = _controller.jobDetails.value;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSize.width(value: 16)),
                    margin: EdgeInsets.only(
                      left: size.width / (size.width / 20),
                      right: size.width / (size.width / 20),
                      bottom: size.width / (size.width / 20),
                      top: size.width / (size.width / 12),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.grey500,
                          spreadRadius: 1,
                          blurRadius: 3,
                        )
                      ],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: AppImage(
                                url: job.image,
                                height: size.width / (size.width / 40),
                                width: size.width / (size.width / 40),
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SpaceWidget(spaceWidth: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: capitalize(job.role),
                                  fontColor: AppColors.black500,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                const SpaceWidget(spaceHeight: 4),
                                Row(
                                  children: [
                                    TextWidget(
                                      text: capitalize(job.companyName),
                                      fontColor: AppColors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    const SpaceWidget(spaceWidth: 4),
                                    TextWidget(
                                      text: DateFormat('dd.MM.yyyy, hh:mm a')
                                          .format(job.createdAt),
                                      fontColor: AppColors.grey700,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        const SpaceWidget(spaceHeight: 20),
                        TextWidget(
                          text: capitalize(job.description),
                          fontColor: AppColors.grey700,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          textAlignment: TextAlign.justify,
                        ),
                        const SpaceWidget(spaceHeight: 12),
                        const TextWidget(
                          text: AppStrings.requirements,
                          fontColor: AppColors.grey900,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        const SpaceWidget(spaceHeight: 12),
                        ...job.requirements.map((requirement) => TextWidget(
                              text: capitalize("• $requirement"),
                              fontColor: AppColors.grey700,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              textAlignment: TextAlign.justify,
                            )),
                        const SpaceWidget(spaceHeight: 12),
                        const TextWidget(
                          text: AppStrings.experience,
                          fontColor: AppColors.grey900,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        const SpaceWidget(spaceHeight: 12),
                        ...job.experience.map((exp) => TextWidget(
                              text: capitalize("• $exp"),
                              fontColor: AppColors.grey700,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              textAlignment: TextAlign.justify,
                            )),
                        const SpaceWidget(spaceHeight: 12),
                        const TextWidget(
                          text: AppStrings.additionalRequirements,
                          fontColor: AppColors.grey900,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        const SpaceWidget(spaceHeight: 12),
                        ...job.additionalRequirement
                            .map((additionalReq) => TextWidget(
                                  text: capitalize("• $additionalReq"),
                                  fontColor: AppColors.grey700,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  textAlignment: TextAlign.justify,
                                )),
                        const SpaceWidget(spaceHeight: 16),
                        ...job.questions.map((question) {
                          print(job.questions);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: capitalize(question),
                                fontColor: AppColors.black400,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              const SpaceWidget(spaceHeight: 4),
                              JobApplyingTextFieldWidget(
                                controller: _controller.answers[question]!,
                                maxLines: 1,
                                validator: (value) =>
                                    value!.isEmpty ? "Enter answer" : null,
                              ),
                              const SpaceWidget(spaceHeight: 8),
                            ],
                          );
                        }),
                        const SpaceWidget(spaceHeight: 24),
                        SubmitButtonWidget(
                          onPressed: _controller.applyForJob,
                          label: AppStrings.submit,
                          buttonWidth: double.infinity,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
