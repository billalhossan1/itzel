import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../services/repository/user_job_repository/user_job_repository.dart';

class CreatorJobPublishController extends GetxController {
  final companyNameController = TextEditingController();
  final addressController = TextEditingController();
  final roleController = TextEditingController();
  final jobDescriptionController = TextEditingController();
  final requirementController = TextEditingController();
  final additionalRequirementController = TextEditingController();
  final experienceController = TextEditingController();
  final jobTypeController = TextEditingController();
  final levelController = TextEditingController();
  final salaryController = TextEditingController();
  final List<Map<String, TextEditingController>> questions = [];

  final ImagePicker _picker = ImagePicker();
  XFile? image;
  final JobRepository _jobRepository = JobRepository();

  Future<void> getImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    image = pickedImage;
    update(); // Notify the UI
  }

  Future<void> publishJob() async {
    Map<String, dynamic> jobDetails = {
      'companyName': companyNameController.text,
      'address': addressController.text,
      'role': roleController.text,
      'description': jobDescriptionController.text,
      'requirements': [requirementController.text],
      'additionalRequirement': [additionalRequirementController.text],
      // Ensure this is a list
      'experience': [experienceController.text],
      'jobType': jobTypeController.text,
      'level': levelController.text,
      'salary': salaryController.text,
      'questions': questions.map((q) => q['question']!.text).toList(),
    };

    bool success = await _jobRepository.createJob(jobDetails, image);

    if (success) {
      Get.snackbar('Success', 'Job posted successfully!');
    } else {
      Get.snackbar('Error', 'Failed to post job.');
    }
  }

  @override
  void onClose() {
    companyNameController.dispose();
    addressController.dispose();
    roleController.dispose();
    jobDescriptionController.dispose();
    requirementController.dispose();
    additionalRequirementController.dispose();
    experienceController.dispose();
    jobTypeController.dispose();
    levelController.dispose();
    salaryController.dispose();
    for (var question in questions) {
      question['question']?.dispose();
    }
    super.onClose();
  }
}
