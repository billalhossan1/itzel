import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../constants/app_api_url.dart';
import '../../../models/subscription_model.dart';
import '../../../utils/app_all_log/error_log.dart';
import '../../../widgets/app_snack_bar/app_snack_bar.dart';
import '../../api/api_get_services.dart';
import '../../storage_services/app_auth_storage.dart';

class SubscriptionRepository {
  final ApiGetServices _apiGetServices = ApiGetServices();

  Future<List<Subscription>?> fetchSubscriptions() async {
    try {
      final response =
          await _apiGetServices.apiGetServices(AppApiUrl.subscription);
      if (response != null && response['success'] == true) {
        return List<Subscription>.from(
            response['data'].map((x) => Subscription.fromJson(x)));
      } else {
        print('API call failed with status: ${response['status']}');
        print('Response body: ${response['message']}');
        return null;
      }
    } catch (e, stackTrace) {
      print('Error fetching subscriptions: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<bool> submitBusinessInformation({
    required String birthdate,
    required String name,
    required String phoneNumber,
    required String email,
    required String idNumber,
    required String accountHolderName,
    required String accountHolderType,
    required String accountNumber,
    required String currency,
    required String routingNumber,
    required String lineOne,
    required String state,
    required String city,
    required String postalCode,
    required String country,
    required List<Uint8List> imagesData,
    required List<String> fileNames,
  }) async {
    try {
      // Step 1: Create multipartRequest instance
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${AppApiUrl.baseUrl}${AppApiUrl.paymentAccountSetup}"),
      );
      print('Request URL: ${request.url}');
      // Add form fields
      request.fields.addAll({
        'dateOfBirth': birthdate,
        'name': name,
        'phoneNumber': phoneNumber,
        'email': email,
        'idNumber': idNumber,
        'account_holder_name': accountHolderName,
        'account_holder_type': accountHolderType,
        'account_number': accountNumber, // Add this field
        'currency': currency,
        'routing_number': routingNumber,
        'line1': lineOne,
        'postal_code': postalCode,
        'state': state,
        'city': city,
        'country': country,
      });

      print('Request fields: ${request.fields}');
      // Step 4: Add image if available
      for (var i = 0; i < imagesData.length; i++) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'KYC',
            imagesData[i],
            filename: fileNames[i],
            contentType: MediaType('image', 'jpeg'),
          ),
        );
        print('Adding file: ${fileNames[i]}');
      }

      // Step 5: Add token and send
      String? token = AppAuthStorage().getToken();
      request.headers['Authorization'] = 'Bearer $token';
      print('Token: $token');

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        AppSnackBar.error(response.body);
        return false;
      }
    } catch (e, stackTrace) {
      print('Error in submitBusinessInformation: $e');
      print('Stack trace: $stackTrace');
      errorLog('submitBusinessInformation', e);
      return false;
    }
  }
}
