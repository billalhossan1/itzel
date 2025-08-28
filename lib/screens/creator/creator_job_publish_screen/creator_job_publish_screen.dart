import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itzel/screens/creator/creator_job_publish_screen/controllers/creator_job_publish_controller.dart';
import 'package:itzel/screens/creator/creator_job_publish_screen/widgets/creator_job_publish_textfield_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/appbar_widget/appbar_widget.dart';
import '../../../widgets/button_widget/button_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class CreatorJobPublishScreen extends StatelessWidget {
  CreatorJobPublishScreen({super.key});

  final CreatorJobPublishController controller =
      Get.put(CreatorJobPublishController());

  void addQuestion(BuildContext context) {
    TextEditingController questionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Question',
              style: TextStyle(fontWeight: FontWeight.w500)),
          content: TextField(
            controller: questionController,
            decoration: const InputDecoration(
              hintText: 'Type your question',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                if (questionController.text.isNotEmpty) {
                  controller.questions.add({'question': questionController});
                  controller.update();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      appBar: const AppbarWidget(text: 'Publishing Job'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: GetBuilder<CreatorJobPublishController>(
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextWidget(
                  text: 'Upload Picture',
                  fontColor: AppColors.black500,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                const SpaceWidget(spaceHeight: 4),
                DottedBorder(
                  child: InkWell(
                    onTap: controller.getImage,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: SizedBox(
                        height: size.height / (size.height / 143),
                        width: double.infinity,
                        child: controller.image == null
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 32,
                                    color: AppColors.black500,
                                  ),
                                  SpaceWidget(spaceHeight: 12),
                                  TextWidget(
                                    text: 'Upload',
                                    fontColor: AppColors.black500,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              )
                            : Image.file(
                                File(controller.image!.path),
                                height: size.height / (size.height / 143),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
                const SpaceWidget(spaceHeight: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextWidget(
                    text: 'Company Name',
                    fontColor: AppColors.grey900,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SpaceWidget(spaceHeight: 4),
                CreatorJobPublishTextFieldWidget(
                  hintText: '',
                  controller: controller.companyNameController,
                  maxLines: 1,
                ),
                const SpaceWidget(spaceHeight: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextWidget(
                    text: 'Role',
                    fontColor: AppColors.grey900,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SpaceWidget(spaceHeight: 4),
                CreatorJobPublishTextFieldWidget(
                  hintText: '',
                  controller: controller.roleController,
                  maxLines: 1,
                ),
                const SpaceWidget(spaceHeight: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextWidget(
                    text: 'Description',
                    fontColor: AppColors.grey900,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SpaceWidget(spaceHeight: 4),
                CreatorJobPublishTextFieldWidget(
                  hintText: '',
                  controller: controller.jobDescriptionController,
                  maxLines: 4,
                ),
                const SpaceWidget(spaceHeight: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextWidget(
                    text: 'Requirements',
                    fontColor: AppColors.grey900,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SpaceWidget(spaceHeight: 4),
                CreatorJobPublishTextFieldWidget(
                  hintText: '',
                  controller: controller.requirementController,
                  maxLines: 1,
                ),
                const SpaceWidget(spaceHeight: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextWidget(
                    text: 'Additional Requirements',
                    fontColor: AppColors.grey900,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SpaceWidget(spaceHeight: 4),
                CreatorJobPublishTextFieldWidget(
                  hintText: '',
                  controller: controller.additionalRequirementController,
                  maxLines: 1,
                ),
                const SpaceWidget(spaceHeight: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextWidget(
                    text: 'Experience',
                    fontColor: AppColors.grey900,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SpaceWidget(spaceHeight: 4),
                CreatorJobPublishTextFieldWidget(
                  hintText: '',
                  controller: controller.experienceController,
                  maxLines: 1,
                ),
                const SpaceWidget(spaceHeight: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextWidget(
                    text: 'Address',
                    fontColor: AppColors.grey900,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SpaceWidget(spaceHeight: 4),
                CreatorJobPublishTextFieldWidget(
                  hintText: '',
                  controller: controller.addressController,
                  maxLines: 1,
                ),
                const SpaceWidget(spaceHeight: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextWidget(
                    text: 'Expertise Level',
                    fontColor: AppColors.grey900,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SpaceWidget(spaceHeight: 4),
                CreatorJobPublishTextFieldWidget(
                  hintText: '',
                  controller: controller.levelController,
                  maxLines: 1,
                ),
                const SpaceWidget(spaceHeight: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextWidget(
                    text: 'Job Type',
                    fontColor: AppColors.grey900,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SpaceWidget(spaceHeight: 4),
                CreatorJobPublishTextFieldWidget(
                  hintText: '',
                  controller: controller.jobTypeController,
                  maxLines: 1,
                ),
                const SpaceWidget(spaceHeight: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextWidget(
                    text: 'Salary',
                    fontColor: AppColors.grey900,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SpaceWidget(spaceHeight: 4),
                CreatorJobPublishTextFieldWidget(
                  hintText: '',
                  controller: controller.salaryController,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                ),
                const SpaceWidget(spaceHeight: 12),
                ...List.generate(
                  controller.questions.length,
                  (index) {
                    final questionController =
                        controller.questions[index]['question']!;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextWidget(
                          text: questionController.text,
                          fontColor: AppColors.grey900,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  },
                ),
                const SpaceWidget(spaceHeight: 8),
                InkWell(
                  onTap: () => addQuestion(context),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 13,
                        backgroundColor: AppColors.starIconUnselected,
                        child: Icon(
                          Icons.add,
                          size: 20,
                        ),
                      ),
                      SpaceWidget(spaceWidth: 9),
                      TextWidget(
                        text: 'Add Question',
                        fontColor: AppColors.black500,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
                const SpaceWidget(spaceHeight: 48),
                ButtonWidget(
                  onPressed: controller.publishJob,
                  label: 'Publish Job',
                  buttonWidth: double.infinity,
                  buttonHeight: (size.height / (size.height / 56)),
                  buttonRadius: BorderRadius.circular(16),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
