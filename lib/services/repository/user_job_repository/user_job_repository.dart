import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:itzel/constants/app_api_url.dart';
import 'package:itzel/models/get_job_model.dart' as jobModel;
import 'package:itzel/services/api/api_get_services.dart';
import 'package:itzel/utils/app_all_log/error_log.dart';
import 'package:mime_type/mime_type.dart';

import '../../../models/get_job_status_model.dart' as jobStatusModel;
import '../../../models/get_job_status_model.dart';
import '../../api/api_delete_services.dart';
import '../../api/api_post_services.dart';

class JobRepository {
  final ApiGetServices _apiGetServices = ApiGetServices();
  final ApiPostServices _apiPostServices = ApiPostServices();
  final ApiDeleteServices _apiDeleteServices = ApiDeleteServices();

  Future<jobModel.Welcome?> fetchAllJobs() async {
    try {
      final response = await _apiGetServices.apiGetServices(AppApiUrl.allJob);
      if (response != null && response['success'] == true) {
        return jobModel.Welcome.fromJson(response);
      } else {
        print('API call failed with status: ${response['status']}');
        print('Response body: ${response['message']}');
        return null;
      }
    } catch (e, stackTrace) {
      print('Error fetching jobs: $e');
      print('Stack trace: $stackTrace');
      errorLog('Error fetching jobs', e);
      return null;
    }
  }

  Future<jobModel.Datum?> fetchJobDetails(String jobId) async {
    try {
      final response =
          await _apiGetServices.apiGetServices('${AppApiUrl.allJob}/$jobId');
      if (response != null && response['success'] == true) {
        return jobModel.Datum.fromJson(response['data']);
      } else {
        print('API call failed with status: ${response['status']}');
        print('Response body: ${response['message']}');
        return null;
      }
    } catch (e, stackTrace) {
      print('Error fetching job details: $e');
      print('Stack trace: $stackTrace');
      errorLog('Error fetching job details', e);
      return null;
    }
  }

  Future<bool> addToJobWishlist(String jobId) async {
    try {
      final response = await _apiPostServices.apiPostServices(
        url: '${AppApiUrl.baseUrl}/user/wishlist/job/add/$jobId',
      );
      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      errorLog("Error adding job to wishlist", e);
      return false;
    }
  }

  Future<bool> removeJobFromWishlist(String jobId) async {
    try {
      final response = await _apiDeleteServices.apiDeleteServices(
        '${AppApiUrl.baseUrl}/user/wishlist/job/remove/$jobId',
      );
      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      errorLog("Error removing job from wishlist", e);
      return false;
    }
  }

  Future<bool> applyForJob(String jobId, List<Map<String, String>> qna) async {
    try {
      final response = await _apiPostServices.apiPostServices(
        url: '${AppApiUrl.baseUrl}/applicant/create',
        body: {
          "job": jobId,
          "QNA": qna,
        },
      );
      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      errorLog("Error applying for job", e);
      return false;
    }
  }

  Future<jobModel.Welcome?> searchJobs(String query) async {
    try {
      final response = await _apiGetServices
          .apiGetServices('${AppApiUrl.allJob}?search=$query');
      if (response != null && response['success'] == true) {
        return jobModel.Welcome.fromJson(response);
      } else {
        print('API call failed with status: ${response['status']}');
        print('Response body: ${response['message']}');
        return null;
      }
    } catch (e, stackTrace) {
      print('Error searching jobs: $e');
      print('Stack trace: $stackTrace');
      errorLog('Error searching jobs', e);
      return null;
    }
  }

  Future<bool> createJob(Map<String, dynamic> jobDetails, XFile? image) async {
    FormData formData = FormData();

    // Add image to FormData
    if (image != null && await File(image.path).exists()) {
      String fileName = image.path.split('/').last;
      String? mimeType = mime(image.path);
      if (mimeType != null) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              image.path,
              filename: fileName,
              contentType: MediaType.parse(mimeType),
            ),
          ),
        );
      }
    }

    // Convert array fields to JSON strings
    List<String> arrayFields = [
      'questions',
      'requirements',
      'experience',
      'additionalRequirement'
    ];

    // Add other job details to FormData
    jobDetails.forEach((key, value) {
      if (arrayFields.contains(key) && value is List) {
        formData.fields.add(MapEntry(key, jsonEncode(value)));
      } else if (value is String) {
        formData.fields.add(MapEntry(key, value));
      }
    });

    // Use ApiPostServices to send the request
    dynamic response = await _apiPostServices.apiPostServices(
        url: '${AppApiUrl.baseUrl}/job/create',
        body: formData,
        statusCode: 200 // You can specify the expected success code if needed
        );

    // Evaluate the response
    return response != null && response['success'];
  }

  Future<jobStatusModel.JobStatus?> getJobStatus() async {
    try {
      final response = await _apiGetServices
          .apiGetServices('${AppApiUrl.baseUrl}${AppApiUrl.getJobStatus}');
      if (response != null) {
        return jobStatusModel.JobStatus.fromJson(response['data']);
      }
    } catch (e) {
      errorLog("Error fetching job status", e);
    }
    return null;
  }

  Future<List<jobStatusModel.JobStatus>?> fetchAllJobStatuses() async {
    try {
      final response =
          await _apiGetServices.apiGetServices(AppApiUrl.getAllJobStatus);
      if (response != null && response['success'] == true) {
        return List<jobStatusModel.JobStatus>.from(
            response['data'].map((x) => JobStatus.fromJson(x)));
      } else {
        print('API call failed with status: ${response['status']}');
        print('Response body: ${response['message']}');
        return null;
      }
    } catch (e, stackTrace) {
      print('Error fetching all job statuses: $e');
      print('Stack trace: $stackTrace');
      errorLog('Error fetching all job statuses', e);
      return null;
    }
  }
}
