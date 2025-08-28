import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/repository/subscription_repository/subscription_repository.dart';
import '../../../../utils/app_all_log/error_log.dart';
import '../../../../widgets/app_snack_bar/app_snack_bar.dart';

class CreatorBusinessInformationController extends GetxController {
  final _repository = SubscriptionRepository();

  final birthdateController = TextEditingController();
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final idNumberController = TextEditingController();
  final accountHolderNameController = TextEditingController();
  final accountHolderTypeController = TextEditingController();
  final currencyController = TextEditingController();
  final routingNumberController = TextEditingController();
  final lineOneController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final postalCodeController = TextEditingController();
  final countryController = TextEditingController();
  final accountNumberController = TextEditingController();

  final RxList<String> fileNames = <String>[].obs;
  final RxList<Uint8List> filesData = <Uint8List>[].obs;
  final RxBool isLoading = false.obs;

  void addFile(String fileName, Uint8List fileData) {
    if (filesData.length < 2) {
      fileNames.add(fileName);
      filesData.add(fileData);
    }
  }

  void removeFile(int index) {
    if (index >= 0 && index < filesData.length) {
      fileNames.removeAt(index);
      filesData.removeAt(index);
    }
  }

  Future<void> submitBusinessInformation() async {
    if (filesData.isEmpty) {
      AppSnackBar.error('Please select a KYC document');
      return;
    }

    try {
      isLoading.value = true;
      print('Submitting business information...');
      print('Files count: ${filesData.length}');
      final result = await _repository.submitBusinessInformation(
        birthdate: birthdateController.text,
        name: nameController.text,
        phoneNumber: phoneNumberController.text,
        email: emailController.text,
        idNumber: idNumberController.text,
        accountHolderName: accountHolderNameController.text,
        accountHolderType: accountHolderTypeController.text,
        currency: currencyController.text,
        routingNumber: routingNumberController.text,
        lineOne: lineOneController.text,
        state: stateController.text,
        city: cityController.text,
        postalCode: postalCodeController.text,
        country: countryController.text,
        imagesData: filesData,
        fileNames: fileNames,
        // Use first image
        accountNumber: accountNumberController.text,
      );
      print('Submission result: $result');

      if (result) {
        AppSnackBar.success('Business information updated successfully');
        Get.back();
      } else {
        AppSnackBar.error('Failed to update business information');
      }
    } catch (e) {
      print('Error in controller: $e');
      AppSnackBar.error(
          'An error occurred while updating business information');
      errorLog('submitBusinessInformation', e);
    } finally {
      isLoading.value = false;
    }
  }

  void validateFields() {
    if (birthdateController.text.isEmpty ||
        nameController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        emailController.text.isEmpty ||
        idNumberController.text.isEmpty ||
        accountHolderNameController.text.isEmpty ||
        accountHolderTypeController.text.isEmpty ||
        currencyController.text.isEmpty ||
        routingNumberController.text.isEmpty ||
        lineOneController.text.isEmpty ||
        stateController.text.isEmpty ||
        cityController.text.isEmpty ||
        postalCodeController.text.isEmpty ||
        accountNumberController.text.isEmpty) {
      throw Exception('Please fill all required fields');
    }
  }

  @override
  void onClose() {
    birthdateController.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    idNumberController.dispose();
    accountHolderNameController.dispose();
    accountHolderTypeController.dispose();
    currencyController.dispose();
    routingNumberController.dispose();
    lineOneController.dispose();
    stateController.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    accountNumberController.dispose();
    countryController.dispose();
    super.onClose();
  }
}
