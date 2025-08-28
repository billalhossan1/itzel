import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../creator/creator_account_screen/creator_account_screen.dart';
import '../../creator/creator_all_chat_screen/creator_all_chat_screen.dart';
import '../../creator/creator_analytics_screen/creator_analytics_screen.dart';
import '../../creator/creator_dashboard_screen/creator_dashboard_screen.dart';
import '../../creator/creator_drawer_screen/creator_drawer_screen.dart';
import '../../creator/creator_post_screen/creator_post_screen.dart';
import '../../user/user_account_screen/user_account_screen.dart';
import '../../user/user_all_chat_screen/user_all_chat_screen.dart';
import '../../user/user_drawer_screen/user_drawer_screen.dart';
import '../../user/user_event_screen/user_event_screen.dart';
import '../../user/user_home_screen/user_home_screen.dart';
import '../../user/user_search_screen/user_search_screen.dart';

class BottomNavController extends GetxController {
  final String userRole;
  int currentIndex = 0;
  late List<Widget> tabs;

  BottomNavController({required this.userRole}) {
    initializeTabs();
  }

  void initializeTabs() {
    tabs = [
      (userRole == 'User') ? UserHomeScreen() : CreatorDashboardScreen(),
      (userRole == 'User') ? UserSearchScreen() : const CreatorPostScreen(),
      (userRole == 'User') ? const UserAllChatScreen() : const CreatorAllChatScreen(),
      (userRole == 'User') ? const UserEventScreen() : const CreatorAnalyticsScreen(),
      (userRole == 'User') ? UserAccountScreen() : CreatorAccountScreen(),
    ];
  }

  void changeTab(int index) {
    currentIndex = index;
    update();
  }

  void openDrawer(BuildContext context) {
    if (userRole == 'User') {
      Navigator.of(context).push(_createUserDrawerRoute());
    } else {
      Navigator.of(context).push(_createCreatorDrawerRoute());
    }
  }

  void openNotifications() {
    if (userRole == 'User') {
      Get.toNamed(AppRoutes.userNotificationScreen);
    } else {
      Get.toNamed(AppRoutes.creatorNotificationScreen);
    }
  }

  Route _createUserDrawerRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          UserDrawerScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _createCreatorDrawerRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          CreatorDrawerScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
