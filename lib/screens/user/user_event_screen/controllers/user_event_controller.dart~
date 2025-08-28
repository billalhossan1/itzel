import 'package:get/get.dart';

// Be explicit about which Welcome class you're using
import '../../../../models/event_model.dart';
import '../../../../models/event_schedule_model.dart' as EventSchedule;
import '../../../../services/repository/event_repository/event_repository.dart';
import '../../../../widgets/app_snack_bar/app_snack_bar.dart';

class UserEventController extends GetxController {
  final EventRepository _repository = EventRepository();

  // Specify which Welcome class you're using
  var eventSchedule = Rxn<EventSchedule.Welcome>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEventSchedule();
  }

  Future<void> fetchEventSchedule() async {
    try {
      isLoading(true);
      final EventSchedule.Welcome? schedule =
          await _repository.getEventSchedule();

      if (schedule != null) {
        eventSchedule.value = schedule;
        print('Event schedule fetched successfully: ${schedule.data}');
      } else {
        eventSchedule.value = null;
        AppSnackBar.error('Failed to fetch event schedule');
      }
    } catch (e) {
      print('Controller error: $e');
      eventSchedule.value = null;
      AppSnackBar.error('An error occurred while fetching event schedule');
    } finally {
      isLoading(false);
    }
  }

  final EventRepository _eventRepository = EventRepository();
  var eventsByDate = <EventModel>[].obs;

  Future<void> fetchEventsByDate(DateTime selectedDay) async {
    try {
      isLoading.value = true;

      // Format the date to ISO 8601 with milliseconds
      final isoDate = selectedDay.toIso8601String();

      print('Fetching events with timestamp: $isoDate');

      final events = await _eventRepository.getEventsByDate(isoDate);

      print('Received events: $events');

      if (events != null && events.isNotEmpty) {
        eventsByDate.value = events;
        print('Events loaded successfully. Count: ${events.length}');
      } else {
        eventsByDate.clear();
        print('No events found for the selected date');
        AppSnackBar.error('No events found for the selected date');
      }
    } catch (e) {
      print('Error in fetchEventsByDate: $e');
      eventsByDate.clear();
      AppSnackBar.error('An error occurred while fetching events');
    } finally {
      isLoading.value = false;
    }
  }
}
