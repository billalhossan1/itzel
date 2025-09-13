// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
//
// import '../../constants/app_api_url.dart';
// import '../../models/privacy_policy_model.dart';
//
// class PrivacyPolicyController extends GetxController {
//   var privacyPolicy = PrivacyPolicyModel(content: '').obs;
//   var isLoading = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchPrivacyPolicy();
//   }
//
//   Future<void> fetchPrivacyPolicy() async {
//     try {
//       isLoading(true);
//       final response = await Dio().get('${AppApiUrl.baseUrl}${AppApiUrl.privacyAndPolicy}');
//       if (response.statusCode == 200) {
//         privacyPolicy(PrivacyPolicyModel.fromJson(response.data));
//       } else {
//         // Handle error
//         privacyPolicy(PrivacyPolicyModel(content: 'Failed to load privacy policy.'));
//       }
//     } catch (e) {
//       // Handle exception
//       privacyPolicy(PrivacyPolicyModel(content: 'Failed to load privacy policy.'));
//     } finally {
//       isLoading(false);
//     }
//   }
// }
