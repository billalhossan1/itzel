import 'package:get/get.dart';

import '../../screens/user/user_account_screen/controllers/user_account_controller.dart';
import '../../screens/user/user_change_password_screen/controllers/user_change_password_controller.dart';
import '../../screens/user/user_chat_receiver_info_screen/controller/user_chat_receiver_info_controller.dart';
import '../../screens/user/user_delete_account_screen/controllers/user_delete_account_controller.dart';
import '../../screens/user/user_drawer_screen/controller/user_drawer_controller.dart';
import '../../screens/user/user_event_screen/controllers/user_event_controller.dart';
import '../../screens/user/user_home_screen/controllers/user_home_controller.dart';
import '../../screens/user/user_notification_screen/controllers/user_notification_controller.dart';
import '../../screens/user/user_search_screen/controllers/user_search_controller.dart';

class UserBindings extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => UserAllChatController());
    Get.lazyPut(() => UserDrawerController());
    Get.lazyPut(() => UserHomeController());
    Get.lazyPut(() => UserSearchController());
    // Get.lazyPut(() => UserJobApplyingController());
    //Get.lazyPut(() => UserChatController());
    Get.lazyPut(() => UserChatReceiverInfoController());
    Get.lazyPut(() => UserEventController());
    Get.lazyPut(() => UserAccountController());
    Get.lazyPut(() => UserNotificationController());
    // Get.lazyPut(() => UserProfileController());
    //Get.lazyPut(() => UserFaqController());
    //Get.lazyPut(() => UserTermsConditionController());
    Get.lazyPut(() => UserChangePasswordController());
    Get.lazyPut(() => UserDeleteAccountController());
  }
}
