import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatorPaymentMethodController extends GetxController {
  final nameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expDateController = TextEditingController();
  final cvvController = TextEditingController();

  DateTime? expiryDate;
  DateTime? cvvDate;

  void setExpiryDate(DateTime date) {
    expiryDate = date;
    update();
  }

  void setCvvDate(DateTime date) {
    cvvDate = date;
    update();
  }

  void updatePaymentMethod() {
    // Implement your payment method update logic here
    print('Updating payment method...');
    print('Name: ${nameController.text}');
    print('Card Number: ${cardNumberController.text}');
    print('Expiry Date: $expiryDate');
    print('CVV: $cvvDate');
  }

  @override
  void onClose() {
    nameController.dispose();
    cardNumberController.dispose();
    expDateController.dispose();
    cvvController.dispose();
    super.onClose();
  }
}
