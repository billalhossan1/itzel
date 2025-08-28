import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart'; // For MediaType
import 'package:itzel/services/api/api_post_services.dart';
import 'package:itzel/utils/app_all_log/error_log.dart';
import 'package:itzel/widgets/app_snack_bar/app_snack_bar.dart';
import 'package:mime/mime.dart';

import '../../../constants/app_api_url.dart';
import '../../../models/get_all_product_model.dart';
import '../../../models/single_product_model.dart';
import '../../api/api_delete_services.dart';
import '../../api/api_get_services.dart';
import '../../api/api_patch_services.dart';

class ProductRepository {
  Future<dynamic> sellProduct({
    required File? imageFile,
    required Map<String, dynamic> productData,
  }) async {
    try {
      // Prepare form data
      FormData formData = FormData.fromMap(productData);

      // Add image if exists
      if (imageFile != null) {
        String originalFileName = imageFile.path.split('/').last;
        String? mimeType = lookupMimeType(imageFile.path);

        // Validate file extension before sending
        String fileExtension = originalFileName.split('.').last.toLowerCase();
        if (!['jpeg', 'png', 'jpg'].contains(fileExtension)) {
          throw Exception(
              'Invalid file type. Only .jpeg, .png, .jpg are supported.');
        }

        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(
            imageFile.path,
            filename: originalFileName,
            contentType: mimeType != null ? MediaType.parse(mimeType) : null,
          ),
        ));
      }

      final response = await ApiPostServices().apiPostServices(
        url: AppApiUrl.creatorSellProduct,
        body: formData,
        statusCode: 200,
      );

      return response;
    } catch (e) {
      if (e is DioException) {
        final errorMessage =
            e.response?.data['message'] ?? 'Something went wrong';
        errorLog('Product posting error: ${e.response?.data}', e);
        AppSnackBar.error("Error: $errorMessage");
      } else {
        errorLog('Unexpected error: ${e.toString()}', e);
        AppSnackBar.error(
            "Something went wrong while posting product: ${e.toString()}");
      }
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchAllProducts({
    required int page,
    required int limit,
    required Map<String, dynamic> filters,
  }) async {
    try {
      Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (filters.containsKey('searchTerm')) {
        queryParams['searchTerm'] = filters['searchTerm'] as String;
      }
      if (filters.containsKey('state')) {
        queryParams['state'] = filters['state'] as String;
      }
      if (filters.containsKey('city')) {
        queryParams['city'] = filters['city'] as String;
      }
      if (filters.containsKey('minPrice')) {
        queryParams['minPrice'] = (filters['minPrice'] as double).toString();
      }
      if (filters.containsKey('maxPrice')) {
        queryParams['maxPrice'] = (filters['maxPrice'] as double).toString();
      }

      String queryString = queryParams.entries
          .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
          .join('&');

      final response = await ApiGetServices().apiGetServices(
        '${AppApiUrl.baseUrl}${AppApiUrl.getAllProduct}?$queryString',
      );

      errorLog('API Response:', response);

      if (response != null && response['success'] == true) {
        final productList = response['data']?['data'] as List<dynamic>?;
        final meta = response['data']?['meta'] as Map<String, dynamic>?;

        if (productList != null && meta != null) {
          return {
            'products': productList
                .map((product) =>
                    AllProduct.fromJson(product as Map<String, dynamic>))
                .toList(),
            'totalPages': meta['totalPage'] as int? ?? 1,
          };
        } else {
          AppSnackBar.error('No products found');
          return null;
        }
      } else {
        final errorMessage = response?['message'] ?? 'Failed to fetch products';
        errorLog('Error Message:', errorMessage);
        AppSnackBar.error(errorMessage);
        return null;
      }
    } catch (e) {
      errorLog('Exception while fetching products:', e);
      AppSnackBar.error('Something went wrong while fetching products');
      return null;
    }
  }

  Future<SingleProduct?> fetchProductDetails(String productId) async {
    try {
      final response = await ApiGetServices().apiGetServices(
        '${AppApiUrl.baseUrl}${AppApiUrl.getAllProduct}$productId',
      );

      // Log the response for debugging
      errorLog('Product Details API Response:', response);

      if (response != null && response['success'] == true) {
        return SingleProduct.fromJson(response['data']);
      } else {
        final errorMessage =
            response?['message'] ?? 'Failed to fetch product details';
        errorLog('Error Message:', errorMessage);
        AppSnackBar.error(errorMessage);
        return null;
      }
    } catch (e) {
      errorLog('Exception while fetching product details:', e);
      AppSnackBar.error('Something went wrong while fetching product details');
      return null;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      final response = await ApiDeleteServices().apiDeleteServices(
        '${AppApiUrl.baseUrl}/sell/$productId',
        statusCode: 200,
      );
      return response != null; // Return true if the response is not null
    } catch (e) {
      errorLog('Error deleting product:', e);
      return false; // Return false if an error occurs
    }
  }

  Future<dynamic> updateProduct({
    required String productId,
    required File? imageFile,
    required Map<String, dynamic> productData,
  }) async {
    try {
      // Prepare form data
      FormData formData = FormData.fromMap(productData);

      // Add image if exists
      if (imageFile != null) {
        String originalFileName = imageFile.path.split('/').last;
        String? mimeType = lookupMimeType(imageFile.path);

        // Validate file extension before sending
        String fileExtension = originalFileName.split('.').last.toLowerCase();
        if (!['jpeg', 'png', 'jpg'].contains(fileExtension)) {
          throw Exception(
              'Invalid file type. Only .jpeg, .png, .jpg are supported.');
        }

        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(
            imageFile.path,
            filename: originalFileName,
            contentType: mimeType != null ? MediaType.parse(mimeType) : null,
          ),
        ));
      }

      final response = await ApiPatchServices().apiPatchServices(
        url: '${AppApiUrl.baseUrl}/sell/$productId',
        body: formData,
        statusCode: 200,
      );

      return response;
    } catch (e) {
      if (e is DioException) {
        final errorMessage =
            e.response?.data['message'] ?? 'Something went wrong';
        errorLog('Product update error: ${e.response?.data}', e);
        AppSnackBar.error("Error: $errorMessage");
      } else {
        errorLog('Unexpected error: ${e.toString()}', e);
        AppSnackBar.error(
            "Something went wrong while updating product: ${e.toString()}");
      }
      return null;
    }
  }
}
