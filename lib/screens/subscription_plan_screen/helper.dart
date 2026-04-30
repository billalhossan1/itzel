import 'package:in_app_purchase/in_app_purchase.dart';

String getSafeTransactionDate(PurchaseDetails purchase) {
  final rawDate = purchase.transactionDate;

  if (rawDate == null) {
    return DateTime.now().toIso8601String();
  }

  // If numeric (Android case)
  final millis = int.tryParse(rawDate);
  if (millis != null) {
    return DateTime.fromMillisecondsSinceEpoch(millis).toIso8601String();
  }

  // If already a date string (iOS case)
  try {
    return DateTime.parse(rawDate).toIso8601String();
  } catch (_) {
    return DateTime.now().toIso8601String();
  }
}
