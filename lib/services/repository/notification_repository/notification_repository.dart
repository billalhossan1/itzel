import 'package:itzel/constants/app_api_url.dart';
import 'package:itzel/models/notification_model.dart';
import 'package:itzel/services/api/api_get_services.dart';

import '../../../constants/unread_notification_model.dart';

class NotificationRepository {
  final ApiGetServices _apiGetServices = ApiGetServices();

  Future<List<Notification>?> fetchNotifications() async {
    try {
      final response = await _apiGetServices.apiGetServices(
        '${AppApiUrl.baseUrl}${AppApiUrl.notification}',
      );
      if (response != null) {
        final welcome = Welcome.fromJson(response);
        return welcome.data;
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
    return null;
  }

  Future<int?> fetchUnreadNotificationCount() async {
    try {
      print("Calling unread notification API...");
      final response = await _apiGetServices.apiGetServices(
        '${AppApiUrl.baseUrl}${AppApiUrl.unreadNotification}',
      );
      print("Raw API response: $response");

      if (response != null) {
        final unreadNotification = UnreadNotification.fromJson(response);
        print("Parsed unread count: ${unreadNotification.data}");
        return unreadNotification.data;
      } else {
        print("Response was null from unread notification API");
      }
    } catch (e) {
      print('Error fetching unread notification count: $e');
    }
    return null;
  }
}
