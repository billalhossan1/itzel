// import 'package:flutter/foundation.dart';
//
// import '../utils/app_all_log/error_log.dart';
//
// String _getDomain() {
//   String serverDomain =
//       "https://www.api.914unplugged.com"; //////////// live server
//   String localDomain = "http://139.59.0.25:3005"; ///////// local server
//   try {
//     if (kReleaseMode) {
//       return serverDomain;
//     } else {
//       return localDomain;
//     }
//   } catch (e) {
//     errorLog("_getDomain", e);
//     return serverDomain;
//   }
// }
//
// class AppApiUrl {
//   AppApiUrl._();
//
//   //////////////////////////////////////  base
//   static const String localDomain =
//       "http://139.59.0.25:3005"; ///////// local server
//   static const String serverDomain =
//       "https://www.api.914unplugged.com"; //////////// live server
//   static final String domain = _getDomain();
//
//   // Auth
//   static const String createCreator = "/user";
//   static const String registrationVerifyEmail = "/auth/verify-email";
//   static const String verifyEmail = "/auth/verify-email";
//   static const String resentOtp = "/auth/resend-verify-email";
//   static const String forgotPassword = "/auth/forget-password";
//   static const String resetPassword = "/auth/reset-password";
//   static const String changePassword = "/auth/change-password";
//   static const String login = "/auth/login";
//
//   // Common Urls
//   static const String faq = "/faq";
//   static const String termsCondition = "/termsandconditions";
//   static const String notification = "/notification";
//   static const String unreadNotification = "/notification/count";
//
//   // User
//   static const String allEvent = "/event";
//   static const String profile = "/user/profile";
//   static const String updateProfile = "/user";
//   static const String allCategory = "/category";
//   static const String allJob = "/job";
//   static const String jobApply = "/applicant/create";
//   static const String myGroup = "/group/my";
//   static const String createPaymentIntent = "/group/join/paymentIntent";
//   static const String eventSchedule = "/user/events";
//   static const String allMessage = "/message";
//   static const String createMessage = "/message/create";
//   static const String createReview = "/review/create";
//   static const String getAllProduct = "/sell/";
//
//   // Creator
//   static const String createEvent = "/event/create";
//   static const String getEventStatus = "/event/status";
//   static const String getAllEventStatus = "/event/status/all";
//   static const String createJob = "/job/create";
//   static const String getJobStatus = "/job/status";
//   static const String getAllJobStatus = "/job/status/all";
//   static const String getCreatorStatus = "/user/status";
//   static const String subscription = "/package";
//   static const String paymentAccountSetup = "/user/payment-account-setup";
//   static const String creatorAnalyticsStatus = "/user/status";
//   static const String creatorEarningStatus = "/user/earnings";
//   static const String creatorMyProduct = "/sell/my-listings";
//   static const String creatorSellProduct = "/sell";
//   static const String creatorUpdateSellProduct = "/sell";
// }

import '../utils/app_all_log/error_log.dart';

/// Returns the appropriate domain based on the build mode.
String _getDomain() {
  const String serverDomain = "https://www.api.914unplugged.com"; // Live server
  const String localDomain = "http://139.59.0.25:3005"; // Local server

  try {
    return serverDomain;
  } catch (e) {
    errorLog("_getDomain", e);
    return serverDomain;
  }
}

class AppApiUrl {
  AppApiUrl._(); // Private constructor for singleton pattern

  // Base Domains
  static const String localDomain = "http://10.10.7.79:5030";

  static const String serverDomain = "https://www.api.914unplugged.com";

  // static const String serverDomain = "http://10.10.7.79:5030";
  static const String accountSuccessUrl =
      "http://10.10.7.79:5030/api/v1/stripe/success-account";
  static final String domain = _getDomain();

  // Base API URL
  static const String baseUrl = "$serverDomain/api/v1";

  // Auth
  static const String createUser = "/user";
  static const String createCreator = "/user";
  static const String registrationVerifyEmail = "/auth/verify-email";
  static const String verifyEmail = "/auth/verify-email";
  static const String resentOtp = "/auth/resend-verify-email";
  static const String forgotPassword = "/auth/forget-password";
  static const String resetPassword = "/auth/reset-password";
  static const String changePassword = "/auth/change-password";
  static const String login = "/auth/login";

  // Common URLs
  static const String faq = "/faq";
  static const String termsCondition = "/termsandconditions";

  // static const String privacyAndPolicy = "/privacyandpolicy";
  static const String notification = "/notification";
  static const String unreadNotification = "/notification/count";
  static const String connectBank =
      "$serverDomain/api/v1/stripe/create-connected-account";

  // User
  static const String allEvent = "/event";
  static const String profile = "/user/profile";
  static const String updateProfile = "/user";
  static const String allCategory = "/category";
  static const String allJob = "/job";
  static const String jobApply = "/applicant/create";
  static const String myGroup = "/group/my";
  static const String createPaymentIntent = "/group/join/paymentIntent";
  static const String eventSchedule = "/user/events";
  static const String allMessage = "/message";
  static const String createMessage = "/message/create";
  static const String createReview = "/review/create";
  static const String getAllProduct = "/sell/";

  // Creator
  static const String createEvent = "/event/create";
  static const String getEventStatus = "/event/status";
  static const String getAllEventStatus = "/event/status/all";
  static const String createJob = "/job/create";
  static const String getJobStatus = "/job/status";
  static const String getAllJobStatus = "/job/status/all";
  static const String getCreatorStatus = "/user/status";
  static const String subscription = "/package";
  static const String paymentAccountSetup = "/user/payment-account-setup";
  static const String creatorAnalyticsStatus = "/user/status";
  static const String creatorEarningStatus = "/user/earnings";
  static const String creatorMyProduct = "/sell/my-listings";
  static const String creatorSellProduct = "/sell";
  static const String creatorUpdateSellProduct = "/sell";

  static String updateJob(var id) => "/api/v1/job/$id";
}
