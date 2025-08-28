import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:itzel/constants/app_colors.dart';
import 'package:itzel/constants/app_strings.dart';
import 'package:itzel/widgets/appbar_widget/appbar_widget.dart';
import 'package:itzel/widgets/text_widget/text_widgets.dart';

import 'controllers/user_notification_controller.dart';

class UserNotificationScreen extends StatelessWidget {
  final UserNotificationController _controller =
      Get.put(UserNotificationController());

  UserNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    _controller.fetchNotifications();
    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      appBar: const AppbarWidget(text: AppStrings.notification),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (_controller.notifications.isEmpty) {
          return const Center(child: Text('No notifications available'));
        } else {
          return ListView.builder(
            itemCount: _controller.notifications.length,
            padding: EdgeInsets.only(top: size.width / (size.width / 12)),
            itemBuilder: (BuildContext context, int index) {
              final notification = _controller.notifications[index];
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(size.width / (size.width / 12)),
                margin: EdgeInsets.only(
                  left: size.width / (size.width / 20),
                  right: size.width / (size.width / 20),
                  bottom: size.width / (size.width / 12),
                ),
                decoration: BoxDecoration(
                  color: AppColors.blueNormal,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: notification.title ?? '',
                      fontColor: AppColors.whiteBg,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      maxLines: 2,
                    ),
                    TextWidget(
                      text: notification.description ?? '',
                      fontColor: AppColors.whiteBg,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      maxLines: 2,
                    ),
                    TextWidget(
                      text: notification.createdAt != null
                          ? DateFormat('dd.MM.yyyy, hh:mm a')
                              .format(notification.createdAt!)
                          : '',
                      // text: notification.createdAt?.toString() ?? '',
                      fontColor: AppColors.whiteLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              );
            },
          );
        }
      }),
    );
  }
}
