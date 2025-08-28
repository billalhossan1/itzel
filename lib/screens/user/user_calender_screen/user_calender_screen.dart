import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:itzel/utils/app_size.dart';
import 'package:itzel/widgets/appbar_widget/appbar_widget.dart';
import 'package:itzel/widgets/space_widget/space_widget.dart';
import 'package:itzel/widgets/text_button_widget/text_button_widget.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import '../user_event_screen/controllers/user_event_controller.dart';

class UserCalenderScreen extends StatefulWidget {
  const UserCalenderScreen({super.key});

  @override
  _UserCalenderScreenState createState() => _UserCalenderScreenState();
}

class _UserCalenderScreenState extends State<UserCalenderScreen> {
  DateTime _focusedDate = DateTime.now();
  DateTime? _selectedDate;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  final UserEventController _controller = Get.put(UserEventController());

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  void _toggleCalendarFormat() {
    setState(() {
      _calendarFormat = _calendarFormat == CalendarFormat.week
          ? CalendarFormat.month
          : CalendarFormat.week;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
      _focusedDate = focusedDay;
    });
    _controller.fetchEventsByDate(selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      appBar: const AppbarWidget(
        text: 'Events',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDate,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDate, day);
              },
              onDaySelected: _onDaySelected,
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: AppColors.starIcon,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.blue500,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
            const SpaceWidget(spaceHeight: 8),
            TextButtonWidget(
              onPressed: _toggleCalendarFormat,
              text: (_calendarFormat == CalendarFormat.week
                  ? 'Tap to expand Month'
                  : 'Tap to see Week'),
              fontSize: 13,
              textColor: AppColors.blue500,
              fontWeight: FontWeight.w500,
            ),
            const SpaceWidget(spaceHeight: 16),
            const Divider(
              thickness: 1,
              color: AppColors.grey200,
            ),
            const SpaceWidget(spaceHeight: 16),
            Obx(() {
              if (_controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final events = _controller.eventsByDate.value;
              if (events.isEmpty) {
                return const Center(
                  child: TextWidget(
                    text: 'No event found',
                    fontColor: AppColors.black500,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }

              return Column(
                children: events.map((event) {
                  return InkWell(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.userHomeDetailsScreen,
                        arguments: {'id': event.id},
                      );
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: _buildClassItem(
                      DateFormat('hh:mm a')
                          .format(event.time ?? DateTime.now()),
                      // Fallback for null time
                      event.name ?? 'Unnamed Event', // Fallback for null name
                      event.address ?? 'No address available', // Use address
                      event.type ?? 'Unknown', // Fallback for null type
                      event.price ?? 0, // Fallback for null price
                    ),
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildClassItem(
    String time,
    String title,
    String address, // Changed to address
    String type,
    int price,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: time,
              fontColor: AppColors.black500,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            const SpaceWidget(spaceWidth: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: ResponsiveUtils.width(220),
                    child: TextWidget(
                      text: capitalize(title),
                      fontColor: AppColors.blue500,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textAlignment: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 4),
                  TextWidget(
                    text: capitalize(address),
                    fontColor: AppColors.black500,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    textAlignment: TextAlign.left,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextWidget(
                  text: capitalize(type),
                  fontColor: AppColors.black500,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  textAlignment: TextAlign.left,
                ),
                const SpaceWidget(spaceHeight: 4),
                TextWidget(
                  text: "\$$price",
                  fontColor: AppColors.black300,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textAlignment: TextAlign.left,
                ),
              ],
            ),
          ],
        ),
        const Divider(
          thickness: 1,
          color: AppColors.grey200,
        ),
      ],
    );
  }
}
