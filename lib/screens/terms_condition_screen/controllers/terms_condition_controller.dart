import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/app_api_url.dart';
import '../../../../models/terms_condition_model.dart';
import '../../../../utils/app_all_log/error_log.dart';

class TermsConditionController extends GetxController {
  var termsList = <Data>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchTermsConditions();
    super.onInit();
  }

  Future<void> fetchTermsConditions() async {
    try {
      isLoading(true);
      final response = await http
          .get(Uri.parse('${AppApiUrl.baseUrl}${AppApiUrl.termsCondition}'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        var termsData = TermsCondition.fromJson(jsonData);
        termsList.assignAll(termsData.data ?? []);
      } else {
        errorLog("fetchTermsConditions", "Failed to load Terms & Conditions");
      }
    } catch (e) {
      errorLog("fetchTermsConditions", e);
    } finally {
      isLoading(false);
    }
  }
}
