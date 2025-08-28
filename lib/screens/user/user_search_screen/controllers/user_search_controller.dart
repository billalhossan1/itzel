import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSearchController extends GetxController {
  // Text editing controller for search
  final TextEditingController searchController = TextEditingController();

  // State for saved jobs
  List<bool> isSavedList = List.generate(5, (index) => false);

  // Category images and titles
  final List<String> categoryImages = [
    'assets/images/schoolImage.png',
    'assets/images/medicalImage.png',
    'assets/images/fitnessImage.png',
    'assets/images/restaurentImage.png',
    'assets/images/travelImage.png',
  ];

  final List<String> categoryTitles = [
    'Education',
    'Health',
    'Spa/Beauty',
    'Restaurant',
    'Travel',
  ];

  final List<String> jobType = [
    'Part-time',
    'Senior-Level',
  ];

  // Toggle saved state for a specific job
  void toggleSaveState(int index) {
    isSavedList[index] = !isSavedList[index];
    update(); // Notify listeners to rebuild
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
