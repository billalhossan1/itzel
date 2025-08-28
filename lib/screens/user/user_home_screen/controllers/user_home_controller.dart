import 'package:get/get.dart';
import 'package:itzel/models/event_model.dart';
import 'package:itzel/services/repository/event_repository/event_repository.dart';

class UserHomeController extends GetxController {
  final EventRepository _eventRepository = EventRepository();
  final RxList<EventModel> events = <EventModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      isLoading.value = true; // Use .value for direct assignment
      error.value = '';
      print('Fetching events...');
      final fetchedEvents = await _eventRepository.getAllEvents();

      if (fetchedEvents != null && fetchedEvents.isNotEmpty) {
        events.assignAll(fetchedEvents);
        print('Events fetched successfully: ${events.length} events');
      } else {
        error.value = 'No events available';
        events.clear();
        print('No events found');
      }
    } catch (e) {
      error.value = 'Failed to load events: ${e.toString()}';
      events.clear();
      print('Error fetching events: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
