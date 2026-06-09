import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
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
        data.map((x) => SubscriptionItem.fromJson(x)),
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

  void buyProduct(String productId) {
    if (isPurchaseLoading.value) return;

    final product = storeProducts[productId];
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
          "purchaseId": purchaseDetails?.purchaseID,
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
