import 'package:get/get.dart';

import '../../../../models/get_event_status_model.dart';
import '../../../../services/repository/event_repository/event_repository.dart';
import '../../../../utils/app_all_log/error_log.dart';

class CreatorAllEventStatusController extends GetxController {
  final EventRepository _eventRepository = EventRepository();
  var allEventStatus = <EventStatus>[].obs;
  var isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllEventStatus();
  }

  Future<void> fetchAllEventStatus() async {
    try {
      final statusList = await _eventRepository.getAllEventStatus();
      if (statusList != null) {
        allEventStatus.value = statusList;
      }
    } catch (e) {
      errorLog("Error in fetchAllEventStatus", e);
    }
  }

  Future<void> refreshData() async {
    try {
      isRefreshing.value = true;
      await fetchAllEventStatus();
    } catch (e) {
      errorLog("Error in refreshData", e);
    } finally {
      isRefreshing.value = false;
    }
  }
}
