import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itzel/models/get_job_model.dart';
import 'package:itzel/services/repository/user_job_repository/user_job_repository.dart';

import '../../../../widgets/app_snack_bar/app_snack_bar.dart';

class UserJobApplyingController extends GetxController {
  final JobRepository _jobDetailsRepository = JobRepository();
  var jobDetails = Datum(
    id: '',
    image: '',
    companyName: '',
    role: '',
    description: '',
    address: '',
    level: '',
    jobType: '',
    salary: '',
    questions: [],
    postedBy: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    v: 0,
    requirements: [],
    experience: [],
    additionalRequirement: [],
  ).obs;
  var isLoading = true.obs;
  var isSubmitting = false.obs;
  var answers = <String, TextEditingController>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final jobId = Get.arguments['jobId'];
    fetchJobDetails(jobId);
  }

  bool validateForm() {
    for (var controller in answers.values) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  Future<void> fetchJobDetails(String jobId) async {
    try {
      isLoading.value = true;
      final fetchedJobDetails =
          await _jobDetailsRepository.fetchJobDetails(jobId);
      if (fetchedJobDetails != null) {
        jobDetails.value = fetchedJobDetails;
        for (var question in fetchedJobDetails.questions) {
          answers[question] = TextEditingController();
        }
      }
    } catch (e) {
      print('Error fetching job details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> applyForJob() async {
    if (!validateForm()) {
      AppSnackBar.error('Please answer all the questions');
      return;
    }
    try {
      isSubmitting.value = true;
      final qna = answers.entries.map((entry) {
        return {"question": entry.key, "answer": entry.value.text};
      }).toList();
      final success =
          await _jobDetailsRepository.applyForJob(jobDetails.value.id, qna);
      if (success) {
        AppSnackBar.success('Job application submitted successfully');
      } else {
        AppSnackBar.error('Failed to submit job application');
      }
    } catch (e) {
      AppSnackBar.error('Error submitting job application: $e');
    } finally {
      isSubmitting.value = false;
    }
  }
}
