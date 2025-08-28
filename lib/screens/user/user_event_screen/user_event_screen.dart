import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:itzel/utils/app_size.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../models/event_schedule_model.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import 'controllers/user_event_controller.dart';

class UserEventScreen extends StatefulWidget {
  const UserEventScreen({super.key});

  @override
  State<UserEventScreen> createState() => _UserEventScreenState();
}

class _UserEventScreenState extends State<UserEventScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final UserEventController _controller = Get.put(UserEventController());

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await _controller.fetchEventSchedule();
  }

  Widget _buildEmptyState(String message) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 100),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.event_busy,
                size: 64,
                color: AppColors.grey700,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Pull down to refresh',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.blueNormal,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Icon(
                Icons.arrow_downward,
                color: AppColors.blueNormal,
                size: 24,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.whiteBg,
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(() {
                    // Get the counts for tabs
                    final upcomingCount = _controller.eventSchedule.value?.data
                            ?.upcommingEvents?.length ??
                        0;
                    final historyCount = _controller
                            .eventSchedule.value?.data?.eventHistory?.length ??
                        0;

                    return TabBar(
                      unselectedLabelColor: AppColors.grey700,
                      labelColor: AppColors.blueNormal,
                      dividerColor: AppColors.blueLighter,
                      indicator: UnderlineTabIndicator(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(
                          color: AppColors.blueNormal,
                          width: AppSize.width(value: 5),
                        ),
                      ),
                      tabs: [
                        Tab(
                          child: Text(
                              "${AppStrings.upcomingEvent} ($upcomingCount)"),
                        ),
                        Tab(
                          child: Text(
                              "${AppStrings.eventHistory} ($historyCount)"),
                        ),
                      ],
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                    );
                  }),
                ),
                const SpaceWidget(spaceHeight: 16),
                Expanded(
                  child: Obx(() {
                    if (_controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final schedule = _controller.eventSchedule.value;
                    if (schedule == null || schedule.data == null) {
                      return RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: _buildEmptyState('No data available'),
                      );
                    }

                    final data = schedule.data!;
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        // Upcoming Events Tab
                        RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: (data.upcommingEvents?.isEmpty ?? true)
                              ? _buildEmptyState('No upcoming events')
                              : ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    Column(
                                      children: (data.upcommingEvents ?? [])
                                          .map((event) {
                                        return EventCard(event: event);
                                      }).toList(),
                                    ),
                                  ],
                                ),
                        ),

                        // Event History Tab
                        RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: (data.eventHistory?.isEmpty ?? true)
                              ? _buildEmptyState('No event history')
                              : ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    Column(
                                      children: (data.eventHistory ?? [])
                                          .map((event) {
                                        return EventCard(event: event);
                                      }).toList(),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    );
                  }),
                ),
                const SpaceWidget(spaceHeight: 80),
              ],
            ),
            Positioned(
              bottom: ResponsiveUtils.height(90),
              right: ResponsiveUtils.width(16),
              child: InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.userCalenderScreen);
                },
                child: Container(
                  height: ResponsiveUtils.width(60),
                  width: ResponsiveUtils.width(60),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        offset: const Offset(0, 3),
                        blurRadius: 3,
                      )
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.calendar_month,
                      color: AppColors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final EventHistory event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: () {
        Get.toNamed(
          AppRoutes.userHomeDetailsScreen,
          arguments: {'id': event.id},
        );
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(size.width / (size.width / 8)),
        margin: EdgeInsets.only(
          left: size.width / (size.width / 20),
          right: size.width / (size.width / 20),
          bottom: size.width / (size.width / 12),
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.greyLighter,
            width: size.width / (size.width / 0.7),
          ),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AppImage(
                url: event.thumbnailImage ?? '',
                height: size.width / (size.width / 192),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SpaceWidget(spaceHeight: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: event.name ?? 'N/A',
                  fontColor: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                TextWidget(
                  text: '\$${event.price?.toString() ?? 'N/A'}',
                  fontColor: AppColors.black500,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
