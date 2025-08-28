import 'dart:async';

import 'package:get/get.dart';
import 'package:itzel/models/notification_model.dart';
import 'package:itzel/services/repository/notification_repository/notification_repository.dart';

class CreatorNotificationController extends GetxController {
  final NotificationRepository _notificationRepository =
      NotificationRepository();
  var notifications = <Notification>[].obs;
  var isLoading = true.obs;
  var unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Only fetch the count when controller is initialized
    fetchUnreadNotificationCount();
    Timer.periodic(const Duration(seconds: 30), (_) {
      fetchUnreadNotificationCount();
    });
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final fetchedNotifications =
          await _notificationRepository.fetchNotifications();
      if (fetchedNotifications != null) {
        notifications.value = fetchedNotifications;
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
      // Update the unread count after fetching notifications
      await fetchUnreadNotificationCount();
    }
  }

  Future<void> fetchUnreadNotificationCount() async {
    try {
      final count =
          await _notificationRepository.fetchUnreadNotificationCount();
      if (count != null) {
        unreadCount.value = count;
      }
    } catch (e) {
      print('Error fetching unread notification count: $e');
    }
  }
}
