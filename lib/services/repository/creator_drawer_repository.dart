import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/app_api_url.dart';
import '../api/network_response.dart';

class CreatorDrawerRepository {
  Future<NetworkResponse?> connectBank(String token) async {
    final url = Uri.parse(AppApiUrl.connectBank);
    print('[connectBank] Making GET request to: ' + url.toString());
    print('[connectBank] Headers: Authorization: Bearer $token');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print('[connectBank] Response status: \'${response.statusCode}\'');
      print('[connectBank] Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return NetworkResponse(
          isSuccess: true,
          responseData: data, statusCode: response.statusCode,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          responseData: json.decode(response.body), statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('[connectBank] Error: $e');
      return NetworkResponse(
        isSuccess: false,
        responseData: {'error': e.toString()}, statusCode: -1,
      );
    }
  }
}
