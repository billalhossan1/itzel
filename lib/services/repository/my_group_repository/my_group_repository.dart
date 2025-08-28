import '../../../constants/app_api_url.dart';
import '../../../models/my_group_model.dart';
import '../../../utils/app_all_log/error_log.dart';
import '../../api/api_get_services.dart';
import '../../api/api_post_services.dart';

class MyGroupRepository {
  final ApiGetServices _apiGetServices = ApiGetServices();
  final ApiPostServices _apiPostServices = ApiPostServices();

  Future<Welcome?> fetchUserGroups() async {
    try {
      final response = await _apiGetServices.apiGetServices(AppApiUrl.myGroup);
      if (response != null && response['success'] == true) {
        return Welcome.fromJson(response);
      } else {
        print('API call failed with status: ${response['status']}');
        print('Response body: ${response['message']}');
        return null;
      }
    } catch (e, stackTrace) {
      print('Error fetching user groups: $e');
      print('Stack trace: $stackTrace');
      errorLog('Error fetching user groups', e);
      return null;
    }
  }

  Future<List<MyGroup>?> fetchMessagesByGroupId(String groupId) async {
    try {
      final response = await _apiGetServices
          .apiGetServices('${AppApiUrl.allMessage}?group=$groupId');
      if (response != null && response['success'] == true) {
        return List<MyGroup>.from(
            response['data'].map((x) => MyGroup.fromJson(x)));
      } else {
        print('API call failed with status: ${response['status']}');
        print('Response body: ${response['message']}');
        return null;
      }
    } catch (e, stackTrace) {
      print('Error fetching messages: $e');
      print('Stack trace: $stackTrace');
      errorLog('Error fetching messages', e);
      return null;
    }
  }

  Future<bool> postMessage(String groupId, String content) async {
    try {
      final response = await _apiPostServices.apiPostServices(
        url: AppApiUrl.createMessage,
        body: {
          'group': groupId,
          'message': content,
        },
      );
      if (response != null && response['success'] == true) {
        return true;
      } else {
        print('API call failed with status: ${response['status']}');
        print('Response body: ${response['message']}');
        return false;
      }
    } catch (e, stackTrace) {
      print('Error posting message: $e');
      print('Stack trace: $stackTrace');
      errorLog('Error posting message', e);
      return false;
    }
  }
}
