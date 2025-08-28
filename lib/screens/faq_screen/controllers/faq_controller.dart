import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/app_api_url.dart';
import '../../../../models/faq_model.dart' as faq;
import '../../../../utils/app_all_log/error_log.dart';

class FaqController extends GetxController {
  var faqList = <faq.Data>[].obs; // Explicitly use faq.Data
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchFaqs();
    super.onInit();
  }

  Future<void> fetchFaqs() async {
    try {
      isLoading(true);
      final response =
          await http.get(Uri.parse('${AppApiUrl.baseUrl}${AppApiUrl.faq}'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        var faqData =
            faq.FAQ.fromJson(jsonData); // Use faq.FAQ to avoid confusion
        faqList.assignAll(faqData.data ?? []);
      } else {
        errorLog("fetchFaqs", "Failed to load FAQs");
      }
    } catch (e) {
      errorLog("fetchFaqs", e);
    } finally {
      isLoading(false);
    }
  }
}
