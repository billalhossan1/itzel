import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:itzel/widgets/app_snack_bar/app_snack_bar.dart';

import '../../../../services/repository/creator_product_repository/creator_product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository _repository = ProductRepository();

  // Observable variables
  final imageFile = Rx<File?>(null);
  final isLoading = false.obs;

  // Text controllers
  final companyNameController = TextEditingController();
  final jobDescriptionController = TextEditingController();
  final priceController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final whatsAppController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  void onClose() {
    companyNameController.dispose();
    jobDescriptionController.dispose();
    priceController.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    phoneNumberController.dispose();
    whatsAppController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        // Validate file extension
        final fileExtension = pickedImage.path.split('.').last.toLowerCase();
        if (fileExtension == 'jpeg' ||
            fileExtension == 'png' ||
            fileExtension == 'jpg') {
          imageFile.value = File(pickedImage.path);
          AppSnackBar.success("Image selected successfully");
        } else {
          AppSnackBar.error("Only .jpeg, .png, .jpg files are supported");
        }
      } else {
        AppSnackBar.error("No image selected");
      }
    } catch (e) {
      AppSnackBar.error("Error picking image: ${e.toString()}");
    }
  }

  Future<void> publishProduct() async {
    try {
      isLoading.value = true;

      final productData = {
        'name': companyNameController.text.trim(),
        'description': jobDescriptionController.text.trim(),
        'price': priceController.text.trim(),
        'country': countryController.text.trim(),
        'state': stateController.text.trim(),
        'city': cityController.text.trim(),
        'phone': phoneNumberController.text.trim(),
        'whatsapp': whatsAppController.text.trim(),
      };

      // Validate required fields
      if (productData['name']!.isEmpty || productData['price']!.isEmpty) {
        AppSnackBar.error("Product name and price are required");
        isLoading.value = false;
        return;
      }

      // Additional validation for price (must be a number)
      if (double.tryParse(productData['price']!) == null) {
        AppSnackBar.error("Price must be a valid number");
        isLoading.value = false;
        return;
      }

      final result = await _repository.sellProduct(
        imageFile: imageFile.value,
        productData: productData,
      );

      if (result != null) {
        AppSnackBar.success("Product posted successfully");
        clearFields();
      } else {
        AppSnackBar.error("Failed to post product");
      }
    } catch (e) {
      AppSnackBar.error("Failed to post product: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void clearFields() {
    imageFile.value = null;
    companyNameController.clear();
    jobDescriptionController.clear();
    priceController.clear();
    countryController.clear();
    stateController.clear();
    cityController.clear();
    phoneNumberController.clear();
    whatsAppController.clear();
  }
}
