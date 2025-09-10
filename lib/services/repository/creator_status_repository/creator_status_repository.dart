import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../constants/app_api_url.dart';
import '../../../models/creator_analytics_status_model.dart';
import '../../../models/creator_status_model.dart';
import '../../../models/earning_status_model.dart';
import '../../../models/get_event_status_model.dart';
import '../../../models/get_job_status_model.dart';
import '../../../models/my_product_model.dart';
import '../../../utils/app_all_log/error_log.dart';
import '../../../widgets/app_snack_bar/app_snack_bar.dart';
import '../../api/api_get_services.dart';

class CreatorStatusRepository {
  final ApiGetServices _apiGetServices = ApiGetServices();

  Future<CreatorStatus?> fetchCreatorStatus() async {
    try {
      final response =
          await _apiGetServices.apiGetServices(AppApiUrl.getCreatorStatus);
      if (response != null && response['success'] == true) {
        return CreatorStatus.fromJson(response['data']);
      } else {
        print('API call failed with status: ${response['status']}');
        print('Response body: ${response['message']}');
        return null;
      }
    } catch (e, stackTrace) {
      print('Error fetching creator status: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<CreatorAnalyticsStatus?> fetchAnalyticsStatus() async {
    try {
      final response = await _apiGetServices
          .apiGetServices(AppApiUrl.creatorAnalyticsStatus);
      if (response != null && response['success'] == true) {
        return CreatorAnalyticsStatus.fromJson(response);
      } else {
        print('API call failed with status: ${response['status']}');
        print('Response body: ${response['message']}');
        return null;
      }
    } catch (e, stackTrace) {
      print('Error fetching analytics status: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<List<EarningStatus>?> fetchEarningsByYear(int year) async {
    try {
      final response = await _apiGetServices.apiGetServices(
        AppApiUrl.creatorEarningStatus,
        queryParameters: {'year': year},
      );
      if (response != null && response['success'] == true) {
        return (response['data'] as List)
            .map((e) => EarningStatus.fromJson(e))
            .toList();
      } else {
        print('API call failed with status: ${response['status']}');
        print('Response body: ${response['message']}');
        return null;
      }
    } catch (e, stackTrace) {
      print('Error fetching earnings by year: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<List<EventStatus>?> fetchAllEventStatus() async {
    try {
      final response =
          await _apiGetServices.apiGetServices(AppApiUrl.getAllEventStatus);
      if (response != null && response['success'] == true) {
        return (response['data'] as List)
            .map((e) => EventStatus.fromJson(e))
            .toList();
      } else {
        print('API call failed with status: ${response['status']}');
        print('Response body: ${response['message']}');
        return null;
      }
    } catch (e, stackTrace) {
      print('Error fetching all event status: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<List<JobStatus>?> fetchAllJobStatus() async {
    try {
      final response =
          await _apiGetServices.apiGetServices(AppApiUrl.getAllJobStatus);
      if (response != null && response['success'] == true) {
        return (response['data'] as List)
            .map((e) => JobStatus.fromJson(e))
            .toList();
      } else {
        print('API call failed with status: ${response['status']}');
        print('Response body: ${response['message']}');
        return null;
      }
    } catch (e, stackTrace) {
      print('Error fetching all job status: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<List<MyProduct>?> fetchMyProducts() async {
    try {
      final response =
          await _apiGetServices.apiGetServices(AppApiUrl.creatorMyProduct);
      if (response != null && response['success'] == true) {
        return (response['data'] as List)
            .map((e) => MyProduct.fromJson(e))
            .toList();
      } else {
        AppSnackBar.error(response?['message'] ?? 'Failed to fetch products');
        return null;
      }
    } catch (e) {
      errorLog('Error fetching products', e);
      AppSnackBar.error('Something went wrong while fetching products');
      return null;
    }
  }

  Future<bool> updateJob({
    required String jobId,
    required String companyName,
    required String role,
    required String description,
    required String address,
    required String level,
    required String jobType,
    required String salary,
    required List<String> requirements,
    required List<String> experience,
    required List<String> additionalRequirement,
    required List<String> questions,
    File? image,
  }) async {
    try {
      final uri = Uri.parse(AppApiUrl.serverDomain + AppApiUrl.updateJob(jobId));
      http.Response response;
      if (image != null) {
        var request = http.MultipartRequest('POST', uri);
        request.fields['companyName'] = companyName;
        request.fields['role'] = role;
        request.fields['description'] = description;
        request.fields['address'] = address;
        request.fields['level'] = level;
        request.fields['jobType'] = jobType;
        request.fields['salary'] = salary;
        request.fields['requirements'] = requirements.join(',');
        request.fields['experience'] = experience.join(',');
        request.fields['additionalRequirement'] =
            additionalRequirement.join(',');
        request.fields['questions'] = questions.join(',');
        request.files.add(
            await http.MultipartFile.fromPath('image', image.path));
        var streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        final body = {
          'companyName': companyName,
          'role': role,
          'description': description,
          'address': address,
          'level': level,
          'jobType': jobType,
          'salary': salary,
          'requirements': requirements,
          'experience': experience,
          'additionalRequirement': additionalRequirement,
          'questions': questions,
        };
        response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );
      }
      if (response.statusCode == 200) {
        final res = response.body;
        // You may want to parse and check for success in the response body
        return true;
      } else {
        print('Failed to update job: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e, stackTrace) {
      print('Error updating job: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }
}
