import 'package:get/get.dart';
import 'package:itzel/screens/creator/creator_account_screen/controllers/creator_account_controller.dart';
import 'package:itzel/screens/creator/creator_all_event_status_screen/controllers/create_all_event_status_controller.dart';
import 'package:itzel/screens/creator/creator_all_job_application_screen/controllers/creator_all_job_application_controller.dart';
import 'package:itzel/screens/creator/creator_analytics_screen/controllers/creator_analytics_controller.dart';
import 'package:itzel/screens/creator/creator_business_information_screen/controllers/creator_business_information_controller.dart';
import 'package:itzel/screens/creator/creator_chat_receiver_info_screen/controller/creator_chat_receiver_info_controller.dart';
import 'package:itzel/screens/creator/creator_dashboard_screen/controllers/creator_dashboard_controller.dart';
import 'package:itzel/screens/creator/creator_drawer_screen/controller/creator_drawer_controller.dart';
import 'package:itzel/screens/creator/creator_job_publish_screen/controllers/creator_job_publish_controller.dart';
import 'package:itzel/screens/creator/creator_post_screen/controllers/creator_post_controller.dart';
import 'package:itzel/screens/creator/creator_subscriptions_screen/controllers/creator_subscription_controller.dart';

import '../../screens/creator/creator_change_password_screen/controllers/creator_change_password_controller.dart';
import '../../screens/creator/creator_delete_account_screen/controllers/creator_delete_account_controller.dart';
import '../../screens/creator/creator_notification_screen/controllers/creator_notification_controller.dart';
import '../../screens/creator/creator_payment_method_screen/controllers/creator_payment_method_controller.dart';
import '../../screens/creator/creator_profile_screen/controllers/creator_profile_controller.dart';

class CreatorBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreatorDashboardController());
    Get.lazyPut(() => CreatorPostController());
    Get.lazyPut(() => CreatorDrawerController());
    Get.lazyPut(() => CreatorAllEventStatusController());
    Get.lazyPut(() => CreatorAllJobApplicationController());
    // Get.lazyPut(() => CreatorAllChatController());
    //Get.lazyPut(() => CreatorChatController());
    //Get.lazyPut(() => CreatorEventCreateController());
    Get.lazyPut(() => CreatorJobPublishController());
    Get.lazyPut(() => CreatorNotificationController());
    Get.lazyPut(() => CreatorAccountController());
    Get.lazyPut(() => CreatorProfileController());
    Get.lazyPut(() => CreatorChatReceiverInfoController());
    //Get.lazyPut(() => CreatorFaqController());
    //Get.lazyPut(() => CreatorTermsConditionController());
    Get.lazyPut(() => CreatorChangePasswordController());
    Get.lazyPut(() => CreatorDeleteAccountController());
    Get.lazyPut(() => CreatorAnalyticsController());
    Get.lazyPut(() => CreatorBusinessInformationController());
    Get.lazyPut(() => CreatorPaymentMethodController());
    Get.lazyPut(() => CreatorSubscriptionsController());
  }
}
