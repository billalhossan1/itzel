// lib/screens/creator/creator_analytics_screen/controllers/creator_analytics_controller.dart
import 'package:get/get.dart';

import '../../../../models/creator_analytics_status_model.dart';
import '../../../../models/earning_status_model.dart';
import '../../../../services/repository/creator_status_repository/creator_status_repository.dart';
import '../../../../widgets/app_snack_bar/app_snack_bar.dart';

class CreatorAnalyticsController extends GetxController {
  final CreatorStatusRepository _repository = CreatorStatusRepository();
  var analyticsStatus = CreatorAnalyticsStatus().obs;
  var isLoading = false.obs;

  var earnings = <EarningStatus>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAnalyticsStatus();
  }

  Future<void> fetchAnalyticsStatus() async {
    try {
      isLoading(true);
      var status = await _repository.fetchAnalyticsStatus();
      if (status != null) {
        analyticsStatus(status);
        print('Analytics data fetched successfully: ${status.data}');
      } else {
        AppSnackBar.error('Failed to fetch analytics status');
      }
    } catch (e) {
      AppSnackBar.error('An error occurred while fetching analytics status');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchEarnings(int year) async {
    try {
      isLoading(true);
      final data = await _repository.fetchEarningsByYear(year);
      if (data != null) {
        earnings.value = data;
      } else {
        earnings.clear();
      }
    } catch (e) {
      print('Error in fetchEarnings: $e');
    } finally {
      isLoading(false);
    }
  }
}
