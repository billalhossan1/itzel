import 'package:get/get.dart';

import '../../../../models/get_event_status_model.dart';
import '../../../../models/get_job_status_model.dart';
import '../../../../models/my_product_model.dart';
import '../../../../services/repository/creator_status_repository/creator_status_repository.dart';
import '../../../../widgets/app_snack_bar/app_snack_bar.dart';

class CreatorPostController extends GetxController {
  final CreatorStatusRepository _repository = CreatorStatusRepository();

  var isLoading = true.obs;
  var allEvents = <EventStatus>[].obs;
  var allJobs = <JobStatus>[].obs;
  var allProducts = <MyProduct>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllStatuses();
    fetchMyProducts();
  }

  Future<void> fetchAllStatuses() async {
    try {
      isLoading(true);
      final events = await _repository.fetchAllEventStatus();
      final jobs = await _repository.fetchAllJobStatus();
      if (events != null) {
        allEvents.assignAll(events);
      }
      if (jobs != null) {
        allJobs.assignAll(jobs);
      }
    } catch (e) {
      print('Error fetching statuses: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshData() async {
    // Simply call the existing fetchAllStatuses method
    // This will refresh both events and jobs data
    return await fetchAllStatuses();
  }

  Future<void> fetchMyProducts() async {
    try {
      isLoading(true);
      final products = await _repository.fetchMyProducts();
      if (products != null) {
        allProducts.assignAll(products);
      }
    } catch (e) {
      AppSnackBar.error('Failed to load products');
    } finally {
      isLoading(false);
    }
  }
}
