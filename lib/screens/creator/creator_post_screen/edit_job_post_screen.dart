import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itzel/constants/app_api_url.dart';
import 'controllers/edit_job_post_controller.dart';
import '../../../models/get_job_status_model.dart';
import '../../../widgets/button_widget/button_widget.dart';

// Screen for editing job post
class EditJobPostScreen extends StatelessWidget {
  final EditJobPostController controller = Get.put(EditJobPostController());

  @override
  Widget build(BuildContext context) {
    final job = Get.arguments as JobStatus;
    controller.loadJobData(job);
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Job Post')),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller.companyNameController,
                    decoration: const InputDecoration(labelText: 'Company Name'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.roleController,
                    decoration: const InputDecoration(labelText: 'Role'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.levelController,
                    decoration: const InputDecoration(labelText: 'Level'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.jobTypeController,
                    decoration: const InputDecoration(labelText: 'Job Type'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.salaryController,
                    decoration: const InputDecoration(labelText: 'Salary'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.requirementsController,
                    decoration: const InputDecoration(labelText: 'Requirements (space separated)'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.experienceController,
                    decoration: const InputDecoration(labelText: 'Experience (space separated)'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.additionalRequirementController,
                    decoration: const InputDecoration(labelText: 'Additional Requirement (space separated)'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.questionsController,
                    decoration: const InputDecoration(labelText: 'Questions (space separated)'),
                  ),
                  const SizedBox(height: 16),
                  // Image picker and preview
                  Obx(() {
                    final pickedImage = controller.image.value;
                    final hasPickedImage = pickedImage != null;
                    final hasJobImage = controller.job.image.isNotEmpty;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: controller.pickImage,
                              icon: const Icon(Icons.image),
                              label: const Text('Pick Image'),
                            ),
                            const SizedBox(width: 16),
                            if (hasPickedImage)
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: Image.file(pickedImage, fit: BoxFit.cover),
                              )
                            else if (hasJobImage)
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: Image.network("${AppApiUrl.serverDomain}${controller.job.image}", fit: BoxFit.cover),
                              )
                            else
                              const Text('No image selected'),
                          ],
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 32),
                  ButtonWidget(
                    onPressed: controller.updateJob,
                    label: 'Save Changes',
                    buttonWidth: double.infinity,
                    buttonHeight: 48,
                  ),
                ],
              ),
            )),
    );
  }
}
