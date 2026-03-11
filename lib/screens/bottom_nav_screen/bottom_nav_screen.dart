import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:itzel/constants/app_colors.dart';
import 'package:itzel/routes/app_routes.dart';
import 'package:itzel/screens/creator/creator_drawer_screen/creator_drawer_screen.dart';
import 'package:itzel/screens/creator/creator_post_screen/creator_post_screen.dart';
import 'package:itzel/screens/user/user_account_screen/user_account_screen.dart';
import 'package:itzel/screens/user/user_all_chat_screen/user_all_chat_screen.dart';
import 'package:itzel/screens/user/user_home_screen/user_home_screen.dart';
import 'package:itzel/screens/user/user_search_screen/user_search_screen.dart';

import '../../services/storage_services/app_auth_storage.dart';
import '../../widgets/icon_widget/icon_widget.dart';
import '../creator/creator_account_screen/creator_account_screen.dart';
import '../creator/creator_all_chat_screen/creator_all_chat_screen.dart';
import '../creator/creator_analytics_screen/creator_analytics_screen.dart';
import '../creator/creator_dashboard_screen/creator_dashboard_screen.dart';
import '../user/user_drawer_screen/user_drawer_screen.dart';
import '../user/user_event_screen/user_event_screen.dart';
import '../user/user_notification_screen/controllers/user_notification_controller.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;
  late List<Widget> tabs;
  late String userRole;

  @override
  void initState() {
    super.initState();



    userRole = Get.put(AppAuthStorage()).getRole() ?? 'USER';
    // Ensure UserNotificationController is registered
    if (!Get.isRegistered<UserNotificationController>()) {
      Get.put(UserNotificationController());
    }
    tabs = [
      (userRole == 'USER') ? UserHomeScreen() : CreatorDashboardScreen(),
      (userRole == 'USER') ? UserSearchScreen() : const CreatorPostScreen(),
      (userRole == 'USER')
          ? const UserAllChatScreen()
          : const CreatorAllChatScreen(),
      (userRole == 'USER')
          ? const UserEventScreen()
          : const CreatorAnalyticsScreen(),
      (userRole == 'USER') ? UserAccountScreen() : CreatorAccountScreen(),
    ];
    print('Tabs: $tabs');
  }

  @override
  Widget build(BuildContext context) {

    String? token= AppAuthStorage().getToken();




    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: size.height / (size.height / 64),
        flexibleSpace: Container(
          color: AppColors.white,
        ),
        titleSpacing: -1,
        leading: IconButton(
          onPressed: () {
            (userRole == 'USER')
                ? Navigator.of(context).push(_createUserDrawerRoute())
                : Navigator.of(context).push(_createCreatorDrawerRoute());
          },
          icon: const IconWidget(
            icon: 'assets/icons/menuIcon.svg',
            width: 24,
            height: 24,
          ),
        ),
        centerTitle: true,
        title: Image.asset(
          'assets/images/appLogo.png',
          height: size.height / (size.height / 45),
          width: size.width / (size.width / 120),
        ),
        actions:[

         if(token!=null && token.isNotEmpty==true)

          IconButton(
              tooltip: "Notifications",
              onPressed: () {
                (userRole == 'USER')
                    ? Get.toNamed(AppRoutes.userNotificationScreen)
                    : Get.toNamed(AppRoutes.creatorNotificationScreen);
              },
              icon: GetBuilder<UserNotificationController>(
                  builder: (controller) => Obx(() => Badge(
                        isLabelVisible: controller.unreadCount.value > 0,
                        label: Text("${controller.unreadCount.value}"),
                        backgroundColor: AppColors.red,
                        child: const IconWidget(
                          icon: 'assets/icons/notificationIcon.svg',
                          width: 24,
                          height: 24,
                        ),
                      )))),
        ],
      ),
      body: tabs[_currentIndex],
      extendBody: true,
      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withValues(alpha: 0.3),
              spreadRadius: 2,
              blurRadius: 3,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            backgroundColor: AppColors.white,
            selectedItemColor: AppColors.black900,
            unselectedItemColor: AppColors.black300,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: MediaQuery.sizeOf(context).width /
                (MediaQuery.sizeOf(context).width / 12),
            unselectedFontSize: MediaQuery.sizeOf(context).width /
                (MediaQuery.sizeOf(context).width / 10),
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  (userRole == 'USER')
                      ? 'assets/icons/homeIcon.png'
                      : 'assets/icons/dashboardIcon.png',
                  height: size.height / (size.height / 22),
                  width: size.width / (size.width / 22),
                  color: _currentIndex == 0
                      ? AppColors.black600
                      : AppColors.black300,
                ),
                label: (userRole == 'USER') ? 'Home' : 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  (userRole == 'USER')
                      ? 'assets/icons/searchIcon.png'
                      : 'assets/icons/postIcon.png',
                  height: size.height / (size.height / 22),
                  width: size.width / (size.width / 22),
                  color: _currentIndex == 1
                      ? AppColors.black600
                      : AppColors.black300,
                ),
                label: (userRole == 'USER') ? 'Search' : 'Post',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/chatIcon.png',
                  height: size.height / (size.height / 22),
                  width: size.width / (size.width / 22),
                  color: _currentIndex == 2
                      ? AppColors.black600
                      : AppColors.black300,
                ),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  (userRole == 'USER')
                      ? 'assets/icons/eventIcon.png'
                      : 'assets/icons/analyticsIcon.png',
                  height: size.height / (size.height / 22),
                  width: size.width / (size.width / 22),
                  color: _currentIndex == 3
                      ? AppColors.black600
                      : AppColors.black300,
                ),
                label: (userRole == 'USER') ? 'Event' : 'Analytics',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/accountIcon.svg',
                  height: size.height / (size.height / 22),
                  width: size.width / (size.width / 22),
                  colorFilter: ColorFilter.mode(
                    _currentIndex == 4 ? AppColors.black600 : AppColors.black300,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Account',
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}

Route _createUserDrawerRoute(){
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => UserDrawerScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
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
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
