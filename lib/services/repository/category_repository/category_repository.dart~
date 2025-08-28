import 'package:itzel/constants/app_api_url.dart';
import 'package:itzel/models/category_model.dart';
import 'package:itzel/services/api/api_get_services.dart';
import 'package:itzel/utils/app_all_log/error_log.dart';

import '../../../models/all_organizations_model.dart';

class CategoryRepository {
  final ApiGetServices _apiGetServices = ApiGetServices();

  Future<List<CategoryModel>?> fetchAllCategories() async {
    try {
      final response =
          await _apiGetServices.apiGetServices(AppApiUrl.allCategory);
      if (response != null && response['success'] == true) {
        final List<CategoryModel> categories = (response['data'] as List)
            .map((category) => CategoryModel.fromJson(category))
            .toList();
        return categories;
      } else {
        print('API call failed with status: ${response['status']}');
        print('Response body: ${response['message']}');
        return null;
      }
    } catch (e, stackTrace) {
      print('Error fetching categories: $e');
      print('Stack trace: $stackTrace');
      errorLog('Error fetching categories', e);
      return null;
    }
  }

  Future<List<AllOrganizations>?> fetchOrganizationsByCategory(
      String categoryId, String searchQuery) async {
    try {
      final response = await _apiGetServices.apiGetServices(
        '${AppApiUrl.baseUrl}/organizations',
        queryParameters: {
          'category': categoryId,
          'search': searchQuery,
        },
      );
      if (response != null && response['success'] == true) {
        final List<AllOrganizations> organizations = (response['data'] as List)
            .map((org) => AllOrganizations.fromJson(org))
            .toList();
        return organizations;
      } else {
        print('API call failed with status: ${response['status']}');
        print('Response body: ${response['message']}');
        return null;
      }
    } catch (e, stackTrace) {
      print('Error fetching organizations: $e');
      print('Stack trace: $stackTrace');
      errorLog('Error fetching organizations', e);
      return null;
    }
  }
}
