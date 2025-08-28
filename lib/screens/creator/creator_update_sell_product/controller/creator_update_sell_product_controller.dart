import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:itzel/services/repository/creator_product_repository/creator_product_repository.dart';
import 'package:itzel/utils/app_all_log/error_log.dart';
import 'package:itzel/widgets/app_snack_bar/app_snack_bar.dart';

import '../../../../models/my_product_model.dart';

class CreatorUpdateSellProductController extends GetxController {
  final companyNameController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final jobDescriptionController = TextEditingController();
  final priceController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final whatsAppController = TextEditingController();

  final selectedImage = Rx<XFile?>(null);
  final remoteImageUrl = Rx<String?>(null); // Store remote image URL
  final productRepository = ProductRepository();
  String? productId;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      selectedImage.value = pickedImage; // Update with new local image
    }
  }

  Future<void> updateProduct() async {
    try {
      if (productId == null) {
        AppSnackBar.error("Product ID is missing");
        return;
      }

      // Prepare product data with only non-empty fields
      final productData = <String, dynamic>{};
      if (companyNameController.text.isNotEmpty) {
        productData['name'] = companyNameController.text;
      }
      if (jobDescriptionController.text.isNotEmpty) {
        productData['description'] = jobDescriptionController.text;
      }
      if (priceController.text.isNotEmpty) {
        productData['price'] = double.tryParse(priceController.text) ?? 0.0;
      }
      if (countryController.text.isNotEmpty) {
        productData['country'] = countryController.text;
      }
      if (stateController.text.isNotEmpty) {
        productData['state'] = stateController.text;
      }
      if (cityController.text.isNotEmpty) {
        productData['city'] = cityController.text;
      }
      if (phoneNumberController.text.isNotEmpty) {
        productData['phone'] = phoneNumberController.text;
      }
      if (whatsAppController.text.isNotEmpty) {
        productData['whatsapp'] = whatsAppController.text;
      }

      // Get image file if a new image was selected
      File? imageFile;
      if (selectedImage.value != null) {
        imageFile = File(selectedImage.value!.path);
      }

      // Call repository to update product
      final response = await productRepository.updateProduct(
        productId: productId!,
        imageFile: imageFile,
        productData: productData,
      );

      if (response != null) {
        errorLog('Update successful, showing success snackbar', response);
        AppSnackBar.success("Product updated successfully");
        // Delay navigation to allow snackbar to display
        await Future.delayed(const Duration(seconds: 6));
        Get.back(); // Navigate back after successful update
      } else {
        AppSnackBar.error("Failed to update product");
      }
    } catch (e) {
      AppSnackBar.error("Error updating product: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();

    // Retrieve the passed product data
    final MyProduct? product = Get.arguments as MyProduct?;

    if (product != null) {
      productId = product.id;
      companyNameController.text = product.name ?? '';
      jobDescriptionController.text = product.description ?? '';
      priceController.text = product.price?.toString() ?? '';
      countryController.text = product.country ?? '';
      stateController.text = product.state ?? '';
      cityController.text = product.city ?? '';
      phoneNumberController.text = product.phone ?? '';
      whatsAppController.text = product.whatsapp ?? '';

      // Set the remote image URL instead of creating an XFile
      if (product.image != null) {
        remoteImageUrl.value = product.image;
      }
    }
  }

  @override
  void onClose() {
    companyNameController.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    jobDescriptionController.dispose();
    priceController.dispose();
    phoneNumberController.dispose();
    whatsAppController.dispose();
    super.onClose();
  }
}
