import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:itzel/screens/subscription_plan_screen/model/subscription_plan_model.dart';
import 'package:itzel/services/api/api_get_services.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/app_api_url.dart';
import '../../../routes/app_routes.dart';
import '../../../services/api/api_post_services.dart';

class SubscriptionController extends GetxController {
  static const String _pendingPurchasesKey = 'pending_purchases';

  var isMonthly = true.obs;
  RxBool unUsed = false.obs;
  var selectedPlanIndex = 0.obs;
  String? argToken;
  List<SubscriptionItem> subscriptionList = [];
  List<SubscriptionItem> monthlySubscriptionList = [];
  List<SubscriptionItem> annualSubscriptionList = [];
  List<SubscriptionItem> validMonthlySubscriptionList = [];
  List<SubscriptionItem> validAnnualSubscriptionList = [];
  Set<String> productIdsBackend = {};
  RxBool isLoading = false.obs;
  String argEmail = '';
  bool _available = false;
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;
  List<ProductDetails> _products = [];
  Map<String, ProductDetails> _productDetailsMap = {};

  void selectPlan(int index) {
    selectedPlanIndex.value = index;
  }

  @override
  void onInit() async {
    super.onInit();
    _available = await _iap.isAvailable();
    // Retrieve token from arguments
    if (_available) {
      argToken = Get.arguments["token"];
      // argEmail = Get.arguments["email"];

      // Initialize purchase stream
      _purchaseSubscription = _iap.purchaseStream.listen(
        _listenToPurchaseUpdated,
        onDone: () {
          _purchaseSubscription.cancel();
        },
        onError: (error) {
          Logger().e('Purchase Stream Error: $error');
        },
      );


      await getSubscriptionsList();
      Logger().i(subscriptionList.length);

      // Initialize store products after fetching subscriptions
      await _initializeStoreInfo();

      // Check for pending purchases that failed to sync
      await _syncPendingPurchases();

      // Restore previous purchases
      await _restorePurchases();
    } else {
      Get.snackbar('Error', "In-App Purchases are not available on this device.");
    }
  }

  @override
  void onClose() {
    _purchaseSubscription.cancel();
    super.onClose();
  }
  ApiGetServices apiGetServices = ApiGetServices();
  ApiPostServices apiPostServices = ApiPostServices();

  // API call wrapped in try-catch for better error handling
  Future<dynamic> apiCall() async {
    try {
      var response = await apiGetServices.apiGetServices(AppApiUrl.getAllSubscription);
      // Ensure this API endpoint is correct for fetching subscriptions
      return response;
    } catch (e) {
      Logger().e("Error during API call: $e");
      throw Exception("Failed to fetch subscription plans.");
    }
  }

  Future<dynamic> subscriptionComplete(
      {required String productId,
      required String purchaseId,
      required String transactionDate,
      required String status,
      required String receipt,
      required String packageId}) async {
    try {
      Map<String, dynamic> body = {
        "product_id": productId,
        "purchase_id": purchaseId,
        "transaction_date": transactionDate, //2025-12-01T10:00:00Z
        "platform": Platform.isAndroid ? 'android' : 'ios', //"ios" | "android";
        "source": Platform.isAndroid ? "google" : "apple", //"apple" | "google";
        "status": status, //"active" | "cancelled";
        "receipt": receipt,
        "package": packageId
      };
      final response = await apiPostServices.apiPostServices(url: AppApiUrl.buySubscription,body: body);
      // Send purchase data to backend for verification
      return response;
    } catch (e) {
      Logger().e("Error during API call: $e");
      throw Exception("Failed to complete subscription.");
    }
  }

  // Method to fetch subscription list with try-catch
  Future<void> getSubscriptionsList() async {
    isLoading.value = true;
    update();
    try {

      final response = await apiCall();
      isLoading.value = false;
      update();

      // Log and check the response before proceeding
      Logger().e("API Response: ${response.responseData}");

      if (response.isSuccess && response.responseData != null) {
        if (response.responseData["data"] != null) {
          // Proceed if the 'data' exists and is not null
          SubscriptionPlanModel subscriptionPlanModel =
              SubscriptionPlanModel.fromJson(response.responseData);
          subscriptionList.addAll(subscriptionPlanModel.data ?? []);

          for (var subscription in subscriptionList) {
            if (subscription.paymentType == "Monthly") {
              monthlySubscriptionList.add(subscription);
              productIdsBackend.addAll({subscription.productId ?? ''});
              // Logger().i("monthly list:${monthlySubscriptionList.length}");
            } else if (subscription.paymentType == "Yearly") {
              annualSubscriptionList.add(subscription);
              productIdsBackend.addAll({subscription.productId ?? ''});
            }
            update();
          }
        } else {
          // Handle case where 'data' is missing
          Get.snackbar('No Subscription', "No subscription data found.",);
          // Logger().e("No subscription data found.");
        }
      } else {
        // Handle failure if response is not successful or responseData is null
      Get.snackbar('Error', "Something went wrong");
        Logger().e("Error: ${response.responseData["message"]}");
      }
    } catch (e) {
      isLoading.value = false;
      update();
      Get.snackbar('Error', e.toString());
      Logger().e("Error fetching subscription list: $e");
    }
  }


  /// -------------------------
  /// Initialize Store Products
  /// -------------------------
  Future<void> _initializeStoreInfo() async {
    if (!_available || productIdsBackend.isEmpty) return;

    isLoading.value = true;
    update();

    Logger().i("Querying IAP for product IDs: $productIdsBackend");

    final ProductDetailsResponse response = await _iap.queryProductDetails(
      productIdsBackend,
    );

    isLoading.value = false;
    update();

    if (response.error != null) {
      Logger().e('Product query error: ${response.error}');
      return;
    }

    // Log products that were not found
    if (response.notFoundIDs.isNotEmpty) {
      Logger().w("Product IDs not found in store: ${response.notFoundIDs}");
      Get.snackbar(
   "Warning",

            "Some products are not configured in the store. Please contact support.",
      );
    }

    if (response.productDetails.isNotEmpty) {
      _products = response.productDetails;

      // Create a map for easy lookup
      _productDetailsMap.clear();
      for (var product in _products) {
        _productDetailsMap[product.id] = product;
        Logger().i("Loaded product: ${product.id} - ${product.price}");
      }

      Logger().i("Loaded ${_products.length} products from store");

      // Filter subscriptions to only show those with valid IAP data
      _filterValidSubscriptions();

      update();
    } else {
      Logger().e(
          "No products loaded from store. Product IDs may not be configured.");
      Get.snackbar(
   "Configuration Error",

            "Subscription products are not available. Please ensure product IDs are configured in the store.",
      );
    }
  }

  /// -------------------------
  /// Filter Valid Subscriptions
  /// -------------------------
  void _filterValidSubscriptions() {
    validMonthlySubscriptionList.clear();
    validAnnualSubscriptionList.clear();

    // Filter monthly subscriptions
    for (var subscription in monthlySubscriptionList) {
      if (subscription.productId != null &&
          subscription.productId!.isNotEmpty &&
          _productDetailsMap.containsKey(subscription.productId)) {
        validMonthlySubscriptionList.add(subscription);
      } else {
        Logger().w(
            "Skipping monthly subscription with invalid product ID: ${subscription.productId}");
      }
    }

    // Filter annual subscriptions
    for (var subscription in annualSubscriptionList) {
      if (subscription.productId != null &&
          subscription.productId!.isNotEmpty &&
          _productDetailsMap.containsKey(subscription.productId)) {
        validAnnualSubscriptionList.add(subscription);
      } else {
        Logger().w(
            "Skipping annual subscription with invalid product ID: ${subscription.productId}");
      }
    }

    Logger().i(
        "Valid monthly subscriptions: ${validMonthlySubscriptionList.length}");
    Logger()
        .i("Valid annual subscriptions: ${validAnnualSubscriptionList.length}");
  }

  /// -------------------------
  /// Purchase Product
  /// -------------------------
  void buyProduct(String productId) {
    final ProductDetails? product = _productDetailsMap[productId];

    if (product == null) {
      Get.snackbar(
   "Error",
   "Product not found",
      );
      return;
    }

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);

    // Used for subscriptions and non-consumables on iOS/Android
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// -------------------------
  /// Save Pending Purchase
  /// -------------------------
  Future<void> _savePendingPurchase(Map<String, dynamic> purchaseData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> pendingPurchases =
          prefs.getStringList(_pendingPurchasesKey) ?? [];

      // Add new pending purchase
      pendingPurchases.add(jsonEncode(purchaseData));
      await prefs.setStringList(_pendingPurchasesKey, pendingPurchases);
      Logger().i("Saved pending purchase: ${purchaseData['productId']}");
    } catch (e) {
      Logger().e("Error saving pending purchase: $e");
    }
  }

  /// -------------------------
  /// Sync Pending Purchases
  /// -------------------------
  bool _isPendingSyncRunning = false;
  Future<void> _syncPendingPurchases() async {
    if (_isPendingSyncRunning) return; // Prevent multiple simultaneous calls
    _isPendingSyncRunning = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> pendingPurchases =
          prefs.getStringList(_pendingPurchasesKey) ?? [];

      if (pendingPurchases.isEmpty) {
        Logger().i("No pending purchases to sync");
        _isPendingSyncRunning = false;
        return;
      }

      Logger()
          .i("Found ${pendingPurchases.length} pending purchase(s) to sync");

      List<String> failedPurchases = [];

      for (String purchaseJson in pendingPurchases) {
        try {
          Map<String, dynamic> purchaseData = jsonDecode(purchaseJson);

          Logger()
              .i("Attempting to sync purchase: ${purchaseData['productId']}");

          final response = await subscriptionComplete(
            productId: purchaseData['productId'],
            purchaseId: purchaseData['purchaseId'],
            transactionDate: purchaseData['transactionDate'],
            status: purchaseData['status'],
            receipt: purchaseData['receipt'],
            packageId: purchaseData['packageId'],
          );

          if (response.isSuccess) {
            Logger().i(
                "Successfully synced purchase: ${purchaseData['productId']}");
            await _removePendingPurchase(purchaseData['productId']);
            //Save token
            // await SaveDataController().saveUserData(argToken ?? '');
          } else {
            Logger().e("Failed to sync purchase: ${response.responseData}");
            failedPurchases.add(purchaseJson);
          }
        } catch (e) {
          Logger().e("Error syncing individual purchase: $e");
          failedPurchases.add(purchaseJson);
        }
      }

      // Save failed purchases only
      if (failedPurchases.isEmpty) {
        await prefs.remove(_pendingPurchasesKey);
        Logger().i("All pending purchases synced successfully");
      } else {
        await prefs.setStringList(_pendingPurchasesKey, failedPurchases);
        Logger().i("${failedPurchases.length} purchase(s) still pending");
      }
    } catch (e) {
      Logger().e("Error in _syncPendingPurchases: $e");
    } finally {
      _isPendingSyncRunning = false;
    }
  }

  /// -------------------------
  /// Remove Pending Purchase
  /// -------------------------
  Future<void> _removePendingPurchase(String productId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> pendingPurchases =
          prefs.getStringList(_pendingPurchasesKey) ?? [];

      pendingPurchases.removeWhere((purchaseJson) {
        try {
          Map<String, dynamic> data = jsonDecode(purchaseJson);
          return data['productId'] == productId;
        } catch (e) {
          return false;
        }
      });

      await prefs.setStringList(_pendingPurchasesKey, pendingPurchases);
      Logger().i("Removed pending purchase: $productId");
    } catch (e) {
      Logger().e("Error removing pending purchase: $e");
    }
  }

  /// -------------------------
  /// Restore Purchases
  /// -------------------------
  Future<void> _restorePurchases() async {
    try {
      Logger().i("Restoring purchases...");
      await _iap.restorePurchases();
    } catch (e) {
      Logger().e("Error restoring purchases: $e");
    }
  }

  /// -------------------------
  /// Handle Purchase Updates
  /// -------------------------
  /// -------------------------
  /// Handle Purchase Updates (Updated)
  /// -------------------------
  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          Logger().i('Purchase pending...');
          Get.snackbar(
            "Processing",
           "Your purchase is being processed...",
          );
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          Logger().i("Purchase successful: ${purchase.productID}");

          // Find the package ID from backend subscription list
          String? packageId;
          for (var sub in subscriptionList) {
            if (sub.productId == purchase.productID) {
              packageId = sub.sId;
              break;
            }
          }

          if (packageId == null) {
            Logger()
                .e("Package ID not found for product: ${purchase.productID}");
            if (purchase.pendingCompletePurchase)
              await _iap.completePurchase(purchase);
            Get.snackbar(
           "Error",
             "Product configuration error. Please contact support.",
            );
            break;
          }

          // Prepare safe transaction date
          String transactionDate;
          if (purchase.transactionDate != null) {
            transactionDate = int.tryParse(purchase.transactionDate!) != null
                ? DateTime.fromMillisecondsSinceEpoch(
                        int.parse(purchase.transactionDate!))
                    .toIso8601String()
                : purchase.transactionDate!;
          } else {
            transactionDate = DateTime.now().toIso8601String();
          }

          // Prepare purchase data
          Map<String, dynamic> purchaseData = {
            'productId': purchase.productID,
            'purchaseId': purchase.purchaseID ?? '',
            'transactionDate': transactionDate,
            'status': purchase.status == PurchaseStatus.purchased
                ? 'active'
                : 'cancelled',
            'receipt': purchase.verificationData.serverVerificationData,
            'packageId': packageId,
          };

          try {
            // Send to backend for verification
            final response = await subscriptionComplete(
              productId: purchaseData['productId'],
              purchaseId: purchaseData['purchaseId'],
              transactionDate: purchaseData['transactionDate'],
              status: purchaseData['status'],
              receipt: purchaseData['receipt'],
              packageId: purchaseData['packageId'],
            );

            if (response.isSuccess) {
              Logger().i("Successfully synced purchase with backend");

              // Remove from pending if exists
              await _removePendingPurchase(purchase.productID);

              // Complete the transaction
              if (purchase.pendingCompletePurchase)
                await _iap.completePurchase(purchase);

              // Save user data and navigate
              //save token
              // await SaveDataController().saveUserData(argToken ?? '');
              Get.offAllNamed(AppRoutes.bottomNavScreen);

              Get.snackbar(
           "Success",
           "Subscription activated successfully!",
              );
            } else {
              throw Exception("Backend sync failed: ${response.responseData}");
            }
          } catch (e) {
            Logger().e("Error syncing purchase with backend: $e");

            // Save to pending for retry
            await _savePendingPurchase(purchaseData);

            // Complete the transaction to avoid issues
            if (purchase.pendingCompletePurchase)
              await _iap.completePurchase(purchase);

            Get.snackbar(
              "Purchase Saved",

                  "Purchase completed but couldn't sync with server. Will retry automatically.",
            );
          }
          break;

        case PurchaseStatus.error:
          Logger().e('Purchase error: ${purchase.error}');
          Get.snackbar(
         'Purchase Failed',
            purchase.error?.message ?? 'Something went wrong',
          );
          break;

        case PurchaseStatus.canceled:
          Logger().i('Purchase canceled');
          Get.snackbar(
            "Canceled",
      "Purchase was canceled",
          );
          break;
      }
    }
  }

  /// Get product price for display (Apple requires using IAP prices)
  String? getProductPrice(String? productId) {
    if (productId == null || productId.isEmpty) return null;
    return _productDetailsMap[productId]?.price;
  }

  /// Get formatted price without currency symbol (for display flexibility)
  String? getProductPriceRaw(String? productId) {
    if (productId == null || productId.isEmpty) return null;
    final product = _productDetailsMap[productId];
    if (product == null) return null;
    // Return the raw price value
    return product.rawPrice.toString();
  }

  /// Get product details for a given product ID
  ProductDetails? getProductDetails(String? productId) {
    if (productId == null || productId.isEmpty) return null;
    return _productDetailsMap[productId];
  }

  /// Check if product is available
  bool isProductAvailable(String? productId) {
    if (productId == null || productId.isEmpty) return false;
    return _productDetailsMap.containsKey(productId);
  }

  /// Check if there are pending purchases
  Future<bool> hasPendingPurchases() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> pendingPurchases =
          prefs.getStringList(_pendingPurchasesKey) ?? [];
      return pendingPurchases.isNotEmpty;
    } catch (e) {
      Logger().e("Error checking pending purchases: $e");
      return false;
    }
  }

  /// Manually retry syncing pending purchases
  Future<void> retryPendingPurchases() async {
    Get.snackbar(
     "Syncing",
  "Attempting to sync pending purchases...",
    );
    await _syncPendingPurchases();
  }
}
