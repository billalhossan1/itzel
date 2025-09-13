// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:itzel/screens/privacy_policy/privacy_policy_controller.dart';
//
// class PrivacyPolicyScreen extends GetView<PrivacyPolicyController> {
//   const PrivacyPolicyScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Privacy Policy'),
//       ),
//       body: Obx(
//         () => controller.isLoading.value
//             ? const Center(child: CircularProgressIndicator())
//             : SingleChildScrollView(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(controller.privacyPolicy.value.content),
//               ),
//       ),
//     );
//   }
// }
