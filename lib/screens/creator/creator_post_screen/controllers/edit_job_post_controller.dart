// Controller for editing job post
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:itzel/services/storage_services/app_auth_storage.dart';
import '../../../../models/get_job_status_model.dart';
import '../../../../services/repository/creator_status_repository/creator_status_repository.dart';
import '../../creator_dashboard_screen/controllers/creator_dashboard_controller.dart';

class EditJobPostController extends GetxController {
  var isLoading = false.obs;
  late JobStatus job;
  final CreatorStatusRepository _repository = CreatorStatusRepository();

  // Image picker
  Rx<File?> image = Rx<File?>(null);

  // Text controllers for all fields
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController jobTypeController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController requirementsController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController additionalRequirementController = TextEditingController();
  final TextEditingController questionsController = TextEditingController();

  void loadJobData(JobStatus jobStatus) {
    job = jobStatus;
    companyNameController.text = job.companyName;
    roleController.text = job.role;
    descriptionController.text = job.description;
    addressController.text = job.address;
    levelController.text = job.level;
    jobTypeController.text = job.jobType;
    salaryController.text = job.salary;
    requirementsController.text = job.requirements.join(' ');
    experienceController.text = job.experience.join(' ');
    additionalRequirementController.text = job.additionalRequirement.join(' ');
    questionsController.text = job.questions.join(' ');
    image.value = null; // Show existing image by URL, allow picking new
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
      print("Image selected: ${pickedFile.path}");
    } else {
      Get.snackbar('No image selected', 'Please select an image.');
    }
  }

  Future<void> updateJob() async {
    isLoading.value = true;
    print("try");
    try {
      // Parse lists
      List<String> requirements = requirementsController.text.trim().isEmpty ? [] : requirementsController.text.trim().split(RegExp(r'[ ,]+')).where((tag) => tag.isNotEmpty).toList();
      List<String> experience = experienceController.text.trim().isEmpty ? [] : experienceController.text.trim().split(RegExp(r'[ ,]+')).where((tag) => tag.isNotEmpty).toList();
      List<String> additionalRequirement = additionalRequirementController.text.trim().isEmpty ? [] : additionalRequirementController.text.trim().split(RegExp(r'[ ,]+')).where((tag) => tag.isNotEmpty).toList();
      List<String> questions = questionsController.text.trim().isEmpty ? [] : questionsController.text.trim().split(RegExp(r'[ ,]+')).where((tag) => tag.isNotEmpty).toList();
      // Call repo
      String? token = AppAuthStorage().getToken();
      bool success = await _repository.updateJob(
        jobId: job.id,
        companyName: companyNameController.text.trim(),
        role: roleController.text.trim(),
        description: descriptionController.text.trim(),
        address: addressController.text.trim(),
        level: levelController.text.trim(),
        jobType: jobTypeController.text.trim(),
        salary: salaryController.text.trim(),
        requirements: requirements,
        experience: experience,
        additionalRequirement: additionalRequirement,
        questions: questions,
        image: image.value, token: token??'',
      );
      if (success) {
        Get.back();
        Get.snackbar('Success', 'Event updated successfully');
      } else {
        Get.snackbar('Error', 'Failed to update job post');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while updating job post');
    } finally {
      isLoading.value = false;
    }
  }
}
