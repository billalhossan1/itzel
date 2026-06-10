import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
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

  // Backward compatibility with existing UI
  List<ProductDetails> get products => storeProducts.values.toList();

  @override
  void onInit() async {
    super.onInit();

    if (Get.arguments != null) {
      role = Get.arguments['role'] ?? '';
    }

    final bool isAvailable = await _iap.isAvailable();
    if (isAvailable) {
      Logger().i("Store is available");

      _purchaseSubscription = _iap.purchaseStream.listen(
        (purchaseDetailsList) {
          if (purchaseDetailsList.isNotEmpty) {
            _listenToPurchaseUpdated(purchaseDetailsList);
          } else if (!isRestoreChecked) {
            isRestoreChecked = true;
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

      await onRestore(showLoader: false);
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
      queryParameters: {'platform': Platform.isAndroid ? 'apple' : 'apple'},
    );

    if (response != null && response['data'] != null) {
      List data = response['data'] ?? [];
      subscriptionPlan.value = List<SubscriptionItem>.from(
        data.map((x) => SubscriptionItem.fromJson(x)).where((plan) => (plan.price ?? 0) > 0),
      );

      final productIds = subscriptionPlan
          .where(
              (e) => (e.price ?? 0) > 0 && (e.productId?.isNotEmpty ?? false))
          .map((e) => e.productId!)
          .toSet();

      if (productIds.isNotEmpty) {
        Logger().i("Packages to search on IAP: $productIds");
        final ProductDetailsResponse productResponse =
            await _iap.queryProductDetails(
          productIds,
        );

        if (productResponse.error != null) {
          Logger().e("IAP Error: ${productResponse.error}");
          isLoading.value = false;
          update();
          return;
        }

        for (var product in productResponse.productDetails) {
          storeProducts[product.id] = product;
        }

        // Only show plans available in Google or Apple Store
        final availableProductIds =
            productResponse.productDetails.map((p) => p.id).toSet();

        subscriptionPlan.value = subscriptionPlan.where((plan) {
          return availableProductIds.contains(plan.productId);
        }).toList();
        // subscriptionPlan.value = List<SubscriptionItem>.from(
        //   data
        //       .map((x) => SubscriptionItem.fromJson(x))
        //       .where((item) => (item.price ?? 0) != 0),
        // );
      }
    }
    isLoading.value = false;
    update();
  }

  Future<void> onRestore({bool showLoader = true}) async {
    if (showLoader) isPurchaseLoading.value = true;
    try {
      await _iap.restorePurchases();
      Logger().i("Restore completed");
    } catch (e) {
      if (showLoader) {
        AppSnackBar.error('Failed to restore purchases: $e');
      }
      Logger().e("Restore error: $e");
    } finally {
      if (showLoader) isPurchaseLoading.value = false;
    }
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
          isPurchaseLoading.value = true;
          final PurchaseParam purchaseParam = PurchaseParam(
            productDetails: product,
          );
          _iap.buyNonConsumable(purchaseParam: purchaseParam);
        } else {
          AppSnackBar.error('Product not available in store');
        }
      }
    } catch (e) {
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
      return plan.type ?? "Lifetime";
    }
    final product = storeProducts[plan.productId];
    if (product == null) {
      return plan.type ?? "Month";
    }
    final durationStr = getDuration(product);
    return durationStr.isEmpty ? (plan.type ?? "Month") : durationStr;
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        isPurchaseLoading.value = true;
      } else {
        isPurchaseLoading.value = false;
        if (purchaseDetails.status == PurchaseStatus.error) {
          AppSnackBar.error(
            purchaseDetails.error?.message ?? 'Purchase failed',
          );
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final isSuccess = await _sendVerifyRequest(
            packageId: getPlanId(purchaseDetails) ?? '',
            purchaseDetails: purchaseDetails,
          );

          if (isSuccess) {
            _onSuccess();
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        }
      }
    });
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
    AppSnackBar.success('Subscription successful!');
    Get.offAllNamed(AppRoutes.bottomNavScreen, arguments: role);
  }
}
