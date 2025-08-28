// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:itzel/constants/app_api_url.dart';
// import 'package:itzel/models/profile_model.dart';
// import 'package:itzel/services/api/api_get_services.dart';
// import 'package:itzel/utils/app_all_log/error_log.dart';
// import 'package:mime/mime.dart';
//
// import '../../api/api_patch_services.dart';
//
// class ProfileRepository {
//   final ApiGetServices _apiGetServices = ApiGetServices();
//   final ApiPatchServices _apiPatchServices = ApiPatchServices();
//
//   Future<Data?> fetchProfile() async {
//     try {
//       final response = await _apiGetServices.apiGetServices(AppApiUrl.profile);
//       if (response != null && response['success'] == true) {
//         final data = Data.fromJson(response['data']);
//         return data;
//       } else {
//         print('API call failed with status: ${response['status']}');
//         print('Response body: ${response['message']}');
//       }
//     } catch (e, stackTrace) {
//       print('Error fetching profile data: $e');
//       print('Stack trace: $stackTrace');
//       errorLog('Error fetching profile data', e);
//     }
//     return null;
//   }
//
//   Future<bool> updateProfile({
//     required String username,
//     required String address,
//     required String contactNumber,
//     File? imageFile,
//   }) async {
//     try {
//       FormData formData = FormData.fromMap({
//         "name": username,
//         "location": address,
//         "contact": contactNumber,
//         if (imageFile != null)
//           "profile": await MultipartFile.fromFile(
//             imageFile.path,
//             filename: imageFile.path.split('/').last,
//             contentType: MediaType.parse(
//                 lookupMimeType(imageFile.path) ?? 'application/octet-stream'),
//           ),
//       });
//
//       final response = await _apiPatchServices.apiPatchServices(
//         url: AppApiUrl.updateProfile,
//         body: formData,
//       );
//
//       if (response != null && response['success'] == true) {
//         return true;
//       } else {
//         print('API call failed with status: ${response['status']}');
//         print('Response body: ${response['message']}');
//         return false;
//       }
//     } catch (e, stackTrace) {
//       print('Error updating profile: $e');
//       print('Stack trace: $stackTrace');
//       errorLog('Error updating profile', e);
//       return false;
//     }
//   }
// }

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:itzel/constants/app_api_url.dart';
import 'package:itzel/models/profile_model.dart';
import 'package:itzel/services/api/api_get_services.dart';
import 'package:itzel/utils/app_all_log/error_log.dart';
import 'package:mime/mime.dart';

import '../../api/api_patch_services.dart';

class ProfileRepository {
  final ApiGetServices _apiGetServices = ApiGetServices();
  final ApiPatchServices _apiPatchServices = ApiPatchServices();

  Future<Data?> fetchProfile() async {
    try {
      final response = await _apiGetServices.apiGetServices(AppApiUrl.profile);
      if (response != null && response['success'] == true) {
        final data = Data.fromJson(response['data']);
        return data;
      } else {
        print('API call failed with status: ${response['status']}');
        print('Response body: ${response['message']}');
      }
    } catch (e, stackTrace) {
      print('Error fetching profile data: $e');
      print('Stack trace: $stackTrace');
      errorLog('Error fetching profile data', e);
    }
    return null;
  }

  // Future<bool> updateProfile({
  //   required String username,
  //   required String address,
  //   required String contactNumber,
  //   File? imageFile,
  // }) async {
  //   try {
  //     FormData formData = FormData.fromMap({
  //       "name": username,
  //       "location": address,
  //       "contact": contactNumber,
  //       if (imageFile != null)
  //         "profile": await MultipartFile.fromFile(
  //           imageFile.path,
  //           filename: imageFile.path.split('/').last,
  //           contentType: MediaType.parse(
  //               lookupMimeType(imageFile.path) ?? 'application/octet-stream'),
  //         ),
  //     });
  //
  //     final response = await _apiPatchServices.apiPatchServices(
  //       url: AppApiUrl.updateProfile,
  //       body: formData,
  //     );
  //
  //     if (response != null && response['success'] == true) {
  //       return true;
  //     } else {
  //       //print('API call failed with status: ${response['status']}');
  //       // print('Response body: ${response['message']}');
  //       return false;
  //     }
  //   } catch (e, stackTrace) {
  //     print('Error updating profile: $e');
  //     print('Stack trace: $stackTrace');
  //     errorLog('Error updating profile', e);
  //     return false;
  //   }
  // }

  Future<bool> updateProfile({
    required String username,
    required String address,
    required String contactNumber,
    File? imageFile,
  }) async {
    try {
      // Prepare FormData
      final formData = FormData.fromMap({
        "name": username,
        "location": address,
        "contact": contactNumber,
        if (imageFile != null)
          "profile": await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
            contentType: MediaType.parse(
              lookupMimeType(imageFile.path) ?? 'application/octet-stream',
            ),
          ),
      });

      // Prepare custom headers
      final headers = {
        "Authorization": "Bearer YOUR_TOKEN_HERE",
        // Replace with actual token logic
        "Accept": "application/json",
        // ❗ Do NOT include Content-Type, Dio will handle it for FormData
      };

      // Call your API patch service
      final response = await _apiPatchServices.apiPatchServices(
        url: AppApiUrl.updateProfile,
        body: formData,
        // ✅ Explicitly pass headers
      );

      if (response != null && response['success'] == true) {
        return true;
      } else {
        print('API call failed with response: $response');
        return false;
      }
    } catch (e, stackTrace) {
      print('Error updating profile: $e');
      print('Stack trace: $stackTrace');
      errorLog('Error updating profile', e);
      return false;
    }
  }
}
