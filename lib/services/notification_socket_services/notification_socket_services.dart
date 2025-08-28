// // lib/services/socket_service/notification_socket_service.dart
// import 'package:get/get.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// import '../../constants/app_api_url.dart';
// import '../../screens/creator/creator_notification_screen/controllers/creator_notification_controller.dart';
// import '../../screens/user/user_notification_screen/controllers/user_notification_controller.dart';
// import '../storage_services/app_auth_storage.dart';
//
// // lib/services/socket_service/notification_socket_services.dart
// class NotificationSocketService extends GetxService {
//   IO.Socket? socket;
//   final String socketUrl = AppApiUrl.domain;
//   final RxBool isConnected = false.obs;
//   final AppAuthStorage _authStorage = Get.find<AppAuthStorage>();
//
//   void initSocket() {
//     try {
//       final token = _authStorage.getToken();
//       final userRole = _authStorage.getRole()?.toLowerCase();
//
//       socket = IO.io(socketUrl, {
//         'transports': ['websocket'],
//         'autoConnect': true,
//         'reconnection': true,
//         'reconnectionDelay': 1000,
//         'reconnectionAttempts': 5,
//         'auth': {'token': token},
//         'extraHeaders': {'Authorization': 'Bearer $token'}
//       });
//
//       socket?.onConnect((_) {
//         print('Socket connected with auth');
//         isConnected.value = true;
//         subscribeToNotifications();
//       });
//
//       socket?.onDisconnect((_) {
//         print('Socket disconnected');
//         isConnected.value = false;
//       });
//
//       socket?.onError((error) => print('Socket error: $error'));
//
//     } catch (e) {
//       print('Socket initialization error: $e');
//     }
//   }
//
//   void subscribeToNotifications() {
//     if (!isConnected.value) return;
//
//     // Listen for unread count updates
//     socket?.on('unreadCount', (data) {
//       try {
//         if (data is Map<String, dynamic> && data['count'] != null) {
//           final controller = _authStorage.getRole() == 'USER'
//               ? Get.find<UserNotificationController>()
//               : Get.find<CreatorNotificationController>();
//           controller.updateUnreadCount(data['count']);
//         }
//       } catch (e) {
//         print('Error handling unread count: $e');
//       }
//     });
//
//     // Listen for new notifications
//     socket?.on('NEW_NOTIFICATION', (data) {
//       try {
//         if (data is Map<String, dynamic>) {
//           final controller = _authStorage.getRole() == 'USER'
//               ? Get.find<UserNotificationController>()
//               : Get.find<CreatorNotificationController>();
//           controller.handleNewNotification(data);
//         }
//       } catch (e) {
//         print('Error handling new notification: $e');
//       }
//     });
//   }
//
//   void disconnect() {
//     socket?.disconnect();
//     socket?.dispose();
//     socket = null;
//     isConnected.value = false;
//   }
// }
