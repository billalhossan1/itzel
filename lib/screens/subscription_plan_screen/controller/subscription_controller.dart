import 'dart:async';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';

import '../../../routes/app_routes.dart';

class SubscriptionController extends GetxController {
  Set<String> productIdsBackend = {'30_days_subscription_itzel'};
  RxBool isLoading = false.obs;
  bool _available = false;
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;
  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;
  Map<String, ProductDetails> _productDetailsMap = {};
  String role = '';

  @override
  void onInit() async {
    super.onInit();
    _available = await _iap.isAvailable();
    if (_available) {
      role = Get.arguments['role']??'';
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

      // Initialize store products
      await _initializeStoreInfo();

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

  /// -------------------------
  /// Initialize Store Products
  /// -------------------------
  Future<void> _initializeStoreInfo() async {
    if (!_available) return;

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

    if (response.notFoundIDs.isNotEmpty) {
      Logger().w("Product IDs not found in store: ${response.notFoundIDs}");
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
      update();
    } else {
      Logger().e(
          "No products loaded from store. Product IDs may not be configured.");
    }
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
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
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

          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }

          Get.offAllNamed(AppRoutes.bottomNavScreen,arguments: role);

          Get.snackbar(
            "Success",
            "Subscription activated successfully!",
          );
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

  /// Get product price for display
  String? getProductPrice(String? productId) {
    if (productId == null || productId.isEmpty) return null;
    return _productDetailsMap[productId]?.price;
  }

  /// Check if there are pending purchases (stubbed for compatibility if needed, though removed from UI)
  Future<bool> hasPendingPurchases() async {
    return false;
  }

  /// Manually retry syncing pending purchases (stubbed)
  Future<void> retryPendingPurchases() async {}
}
