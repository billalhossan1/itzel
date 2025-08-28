import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../constants/app_api_url.dart';
import '../../routes/app_routes.dart';

import '../../utils/app_all_log/app_log.dart';
import '../storage_services/app_auth_storage.dart';

class AppApi {
  final Dio _dio = Dio();

  AppApi() {
    _dio.options.baseUrl = AppApiUrl.baseUrl;
    _dio.options.sendTimeout = const Duration(seconds: 120);
    _dio.options.connectTimeout = const Duration(seconds: 120);
    _dio.options.receiveTimeout = const Duration(seconds: 120);
    _dio.options.followRedirects = false;

    _dio.interceptors.addAll({
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.baseUrl = AppApiUrl.baseUrl;
          options.contentType = 'application/json';
          options.headers["Accept"] = "application/json";

          String? token = AppAuthStorage().getToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options); // Continue request
        },
        onError: (error, handler) async {
          appLog("API error occurred:");
          appLog("Status code: ${error.response?.statusCode}");
          appLog("Error message: ${error.message}");

          if (error.response?.statusCode == 401) {
            // Unauthorized error, clear storage and redirect to login
            AppAuthStorage().storageClear();
            Get.offAllNamed(AppRoutes.loginScreen);
          }

          return handler.next(error); // Continue with error
        },
      ),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          request: true,
          compact: true,
          error: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ),
    });
  }

  Dio get sendRequest => _dio;
}
