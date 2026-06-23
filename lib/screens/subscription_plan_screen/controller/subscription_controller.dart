import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:itzel/models/profile_model.dart';
import 'package:itzel/screens/user/user_profile_screen/controllers/user_profile_controller.dart';
import 'package:logger/logger.dart';

import '../../../constants/app_api_url.dart';
import '../../../routes/app_routes.dart';
import '../../../services/api/api_get_services.dart';
import '../../../services/api/api_post_services.dart';
import '../../../widgets/app_snack_bar/app_snack_bar.dart';
import '../model/subscription_plan_model.dart';

class SubscriptionController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool isPurchaseLoading = false.obs;
  RxBool isVerifying = false.obs;

  final RxList<SubscriptionItem> subscriptionPlan = RxList<SubscriptionItem>();
  final RxMap<String, ProductDetails> storeProducts =
      <String, ProductDetails>{}.obs;

  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;
  bool isRestoreChecked = false;
  String role = '';

  UserProfileController _userProfileController =
      Get.find<UserProfileController>();
  Rxn<ProfileModel> profileModel = Rxn();

  bool routeFromDrawer = false;
  bool _restoreDone = false;
  bool _isPurchasing = false;

  // Backward compatibility with existing UI
  List<ProductDetails> get products => storeProducts.values.toList();

  @override
  void onInit() async {
    super.onInit();

    bool performRestoreCheck = false;

    if (Get.arguments != null) {
      if (Get.arguments is Map) {
        routeFromDrawer = Get.arguments['route_from'] == "drawer";
        performRestoreCheck = Get.arguments['perform_restore_check'] == true;
        role = Get.arguments['role'] ?? '';
      } else if (Get.arguments is String) {
        role = Get.arguments;
      }
    }

    final bool isAvailable = await _iap.isAvailable();
    if (isAvailable) {
      Logger().i("Store is available");

      _purchaseSubscription = _iap.purchaseStream.listen(
        (purchaseDetailsList) {
          if (purchaseDetailsList.isNotEmpty) {
            _listenToPurchaseUpdated(purchaseDetailsList);
          } else if (!isRestoreChecked && !_isPurchasing) {
            isRestoreChecked = true;
            isPurchaseLoading.value = false;
            _fetchSubscriptionPlan();
          }
        },
        onDone: () {
          _purchaseSubscription.cancel();
        },
        onError: (error) {
          isPurchaseLoading.value = false;
          Logger().e("Purchase stream error: $error");
        },
      );
      profileModel.value = await _userProfileController.fetchProfileData();

      // If the user already has an active subscription package, let them in.
      // Only auto-route when the screen is acting as a gate. When opened from
      // a drawer, the user intentionally came to view the plans, so don't pop.
      final packageId = profileModel.value?.subscriptionPackageId;
      if (!routeFromDrawer && packageId != null && packageId.isNotEmpty) {
        isLoading.value = false;
        _onSuccess();
        return;
      }

      if (performRestoreCheck || !routeFromDrawer) {
        await onRestore(showLoader: false);
      }
      _fetchSubscriptionPlan();
    } else {
      isLoading.value = false;
      AppSnackBar.error("In-App Purchases are not available on this device.");
    }
  }

  @override
  void onClose() {
    _purchaseSubscription.cancel();
    super.onClose();
  }

  Future<void> _fetchSubscriptionPlan() async {
    isLoading.value = true;
    update();

    final response = await ApiGetServices().apiGetServices(
      AppApiUrl.getAllSubscription,
      queryParameters: {'platform': Platform.isAndroid ? 'google' : 'apple'},
    );

    if (response != null && response['data'] != null) {
      List data = response['data'] ?? [];

      subscriptionPlan.value = List<SubscriptionItem>.from(
        data
            .map((x) => SubscriptionItem.fromJson(x))
            .where((plan) => (plan.price ?? 0) > 0),
      );

      // Filter out any free plan (where price <= 0 or null, or name is 'free' case-insensitive)
      // and ensure a product ID exists
      final paidPlansFromApi = List<SubscriptionItem>.from(
        data.map((x) => SubscriptionItem.fromJson(x)),
      ).where((plan) {
        final hasPrice = plan.price != null && plan.price! > 0;
        final hasProductId =
            plan.productId != null && plan.productId!.isNotEmpty;
        final isFreeName = plan.name?.toLowerCase() == 'free';
        return hasPrice && hasProductId && !isFreeName;
      }).toList();

      final productIds = paidPlansFromApi.map((e) => e.productId!).toSet();

      if (productIds.isNotEmpty) {
        Logger().i("Packages to search on IAP: $productIds");
        final ProductDetailsResponse productResponse =
            await _iap.queryProductDetails(
          productIds,
        );

        if (productResponse.error != null) {
          Logger().e("IAP Error: ${productResponse.error}");
          subscriptionPlan.clear();
          isLoading.value = false;
          update();
          return;
        }

        for (var product in productResponse.productDetails) {
          storeProducts[product.id] = product;
        }

        // Only show plans available in Google or Apple Store and matched with API product id
        final availableProductIds =
            productResponse.productDetails.map((p) => p.id).toSet();

        subscriptionPlan.value = paidPlansFromApi.where((plan) {
          return availableProductIds.contains(plan.productId);
        }).toList();
      } else {
        // If there are no premium product IDs, clear the list so no free plans are shown
        subscriptionPlan.clear();
      }
    } else {
      subscriptionPlan.clear();
    }
    isLoading.value = false;
    update();
  }

  Future<void> onRestore({bool showLoader = true}) async {
    // Guard: restore can only run once per controller lifecycle
    if (_restoreDone) return;
    _restoreDone = true;

    if (showLoader) isPurchaseLoading.value = true;
    try {
      await _iap.restorePurchases();
      Logger().i("Restore completed");
    } catch (e) {
      if (showLoader) isPurchaseLoading.value = false;
      AppSnackBar.error('Failed to restore purchases: $e');
      Logger().e("Restore error: $e");
    }
    // Note: Do NOT set isPurchaseLoading = false here on success.
    // The restore results are delivered asynchronously via purchaseStream.
    // The loader will be hidden in _listenToPurchaseUpdated when processing is done.
  }

  Future<void> onSubscribe(int index) async {
    if (isPurchaseLoading.value) return;
    final plan = subscriptionPlan[index];

    try {
      if ((plan.price ?? 0) == 0) {
        //buy free plan
        isPurchaseLoading.value = true;
        final isSuccess = await _sendVerifyRequest(packageId: plan.sId);
        isPurchaseLoading.value = false;

        if (isSuccess) _onSuccess();
      } else {
        //buy subscription from store
        final product = storeProducts[plan.productId];
        if (product != null) {
          _isPurchasing = true; // mark real purchase in progress
          isPurchaseLoading.value = true;
          final PurchaseParam purchaseParam = PurchaseParam(
            productDetails: product,
          );
          final bool success =
              await _iap.buyNonConsumable(purchaseParam: purchaseParam);
          if (!success) {
            _isPurchasing = false;
            isPurchaseLoading.value = false;
          }
        } else {
          AppSnackBar.error('Product not available in store');
        }
      }
    } catch (e) {
      _isPurchasing = false;
      isPurchaseLoading.value = false;
      Logger().e("Subscribe error: $e");
    }
  }

  ProductDetails? getProduct(String productId) {
    return storeProducts[productId];
  }

  String getDuration(ProductDetails product) {
    if (Platform.isIOS && product is AppStoreProductDetails) {
      final period = product.skProduct.subscriptionPeriod;
      if (period != null) {
        final numberOfUnits = period.numberOfUnits;
        final unitName = period.unit.name.toLowerCase();
        String unitStr = '';
        if (unitName.contains('month')) {
          unitStr = numberOfUnits == 1 ? 'Month' : 'Months';
        } else if (unitName.contains('year')) {
          unitStr = numberOfUnits == 1 ? 'Year' : 'Years';
        } else if (unitName.contains('week')) {
          unitStr = numberOfUnits == 1 ? 'Week' : 'Weeks';
        } else if (unitName.contains('day')) {
          unitStr = numberOfUnits == 1 ? 'Day' : 'Days';
        } else {
          unitStr = period.unit.name;
        }
        return numberOfUnits == 1 ? unitStr : '$numberOfUnits $unitStr';
      }
    }

    if (Platform.isAndroid && product is GooglePlayProductDetails) {
      final phases = product.productDetails.subscriptionOfferDetails;
      if (phases != null && phases.isNotEmpty) {
        final recurringPhase = phases.first.pricingPhases.last;
        final period = recurringPhase.billingPeriod; // e.g. "P1M", "P1Y", "P1W"
        final regExp = RegExp(r'P(\d+)([WMYD])');
        final match = regExp.firstMatch(period);
        if (match != null) {
          final amount = int.tryParse(match.group(1) ?? '1') ?? 1;
          final unit = match.group(2);
          String unitStr = '';
          if (unit == 'M') {
            unitStr = amount == 1 ? 'Month' : 'Months';
          } else if (unit == 'Y') {
            unitStr = amount == 1 ? 'Year' : 'Years';
          } else if (unit == 'W') {
            unitStr = amount == 1 ? 'Week' : 'Weeks';
          } else if (unit == 'D') {
            unitStr = amount == 1 ? 'Day' : 'Days';
          }
          return amount == 1 ? unitStr : '$amount $unitStr';
        }
        return period;
      }
    }

    return '';
  }

  String getPlanDuration(SubscriptionItem plan) {
    if ((plan.price ?? 0) == 0) {
      return "Lifetime";
    }
    final product = storeProducts[plan.productId];
    if (product == null) {
      return "Monthly";
    }
    final durationStr = getDuration(product);
    return durationStr.isEmpty ? "Monthly" : durationStr;
  }

  Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    // 1. Check if anything is still pending
    final hasPending = purchaseDetailsList.any(
      (p) => p.status == PurchaseStatus.pending,
    );

    if (hasPending) {
      isPurchaseLoading.value = true;
      return;
    }

    // Show errors for any failed purchases
    for (final purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.error) {
        AppSnackBar.error(
          purchase.error?.message ?? 'Purchase failed',
        );
      }
    }

    // 2. Filter successful or restored purchases
    final validPurchases = purchaseDetailsList
        .where(
          (p) =>
              p.status == PurchaseStatus.purchased ||
              p.status == PurchaseStatus.restored,
        )
        .toList();

    if (validPurchases.isNotEmpty) {
      // Find the latest purchase based on transactionDate
      PurchaseDetails latestPurchase = validPurchases.first;
      int latestTime = _parseTransactionDate(latestPurchase.transactionDate);

      for (var i = 1; i < validPurchases.length; i++) {
        final currentPurchase = validPurchases[i];
        final currentTime = _parseTransactionDate(
          currentPurchase.transactionDate,
        );
        if (currentTime > latestTime) {
          latestPurchase = currentPurchase;
          latestTime = currentTime;
        }
      }

      // Verify the latest purchase with the backend FIRST
      final isSuccess = await _sendVerifyRequest(
        packageId: getPlanId(latestPurchase) ?? '',
        purchaseDetails: latestPurchase,
      );

      // 3. Only acknowledge purchases to the store AFTER backend verification
      // This prevents the store treating the transaction as "done" if backend failed
      for (final purchase in purchaseDetailsList) {
        if (purchase.pendingCompletePurchase && purchase.purchaseID != null) {
          await _iap.completePurchase(purchase);
        }
      }

      isPurchaseLoading.value = false;
      _isPurchasing = false;

      if (isSuccess) {
        _onSuccess();
      }
    } else {
      // Stream emitted but no valid purchases — hide loader
      isPurchaseLoading.value = false;
      _isPurchasing = false;

      // Complete any remaining pending-complete purchases even with no valid ones
      for (final purchase in purchaseDetailsList) {
        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
      }
    }
  }

  int _parseTransactionDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 0;
    // Try to parse as integer (milliseconds since epoch)
    final ms = int.tryParse(dateStr);
    if (ms != null) return ms;
    // Fallback to DateTime parse (ISO-8601)
    final dt = DateTime.tryParse(dateStr);
    return dt?.millisecondsSinceEpoch ?? 0;
  }

  String? getPlanId(PurchaseDetails purchaseDetails) => subscriptionPlan
      .firstWhereOrNull((e) => e.productId == purchaseDetails.productID)
      ?.sId;

  Future<bool> _sendVerifyRequest({
    String? packageId,
    PurchaseDetails? purchaseDetails,
  }) async {
    if (isVerifying.value) return false;
    isVerifying.value = true;
    try {
      final response = await ApiPostServices().apiPostServices(
        url: AppApiUrl.buySubscription,
        body: {
          "packageId": packageId,
          "productId": purchaseDetails?.productID,
          "purchaseId": purchaseDetails is GooglePlayPurchaseDetails
              ? purchaseDetails.billingClientPurchase.purchaseToken
              : purchaseDetails?.purchaseID,
          "platform": Platform.isAndroid ? "google" : "apple",
          "trasactionDate": purchaseDetails?.transactionDate,
          "status": purchaseDetails?.status.name,
          "isRestore": purchaseDetails?.status == PurchaseStatus.restored,
        },
      );
      if (response != null &&
          (response['success'] == true || response['statusCode'] == 200)) {
        return true;
      }
      return false;
    } catch (e) {
      Logger().e("Verification request error: $e");
      return false;
    } finally {
      isVerifying.value = false;
    }
  }

  void _onSuccess() {
    if (routeFromDrawer) {
      Get.back();
    } else {
      Get.offAllNamed(AppRoutes.bottomNavScreen, arguments: role);
    }
  }
}
