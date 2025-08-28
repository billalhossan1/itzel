import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../utils/app_all_log/error_log.dart';
import '../../widgets/app_snack_bar/app_snack_bar.dart';
import '../storage_services/app_auth_storage.dart';
import 'api.dart';

class ApiPatchServices {
  final api = AppApi();

  apiPatchServices({
    required String url,
    Object? body,
    int statusCode = 200,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    try {
      final response = await api.sendRequest.patch(
        url,
        data: body,
        queryParameters: query,
        options: options,
      );

      if (response.statusCode == statusCode) {
        return response.data;
      } else {
        // Handle cases where status code is different
        AppSnackBar.error(
            "Unexpected response: ${response.statusCode} ${response.statusMessage}");
        return null;
      }
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      AppSnackBar.error("Check Your Internet Connection");
      return null;
    } on TimeoutException catch (e) {
      errorLog('api time out exception', e);
      // AppSnackBar.error("Request Timed Out");
      return null;
    } on DioException catch (e) {
      if (e.response.runtimeType != Null) {
        if (e.response?.statusCode == 400) {
          if (e.response?.data["message"].runtimeType != Null) {
            AppSnackBar.error("${e.response?.data["message"]}");
          }
          return null;
        } else if (e.response?.statusCode == 401) {
          // AppSnackBar.error("Your login section has time out ");
          await AppAuthStorage().storageClear();
          Get.offAllNamed(AppRoutes.loginScreen);
          // AppSnackBar.message("Sign-in again with your credential");
        }
      }
      errorLog('api dio exception', e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      // AppSnackBar.error("Something Went Wrong");
      return null;
    }
  }
}
