import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:itzel/screens/creator/creator_account_screen/controllers/creator_account_controller.dart';

import '../../../../models/profile_model.dart';
import '../../../../services/repository/profile_repository/profile_repository.dart';
import '../../../../widgets/app_snack_bar/app_snack_bar.dart';

class CreatorProfileController extends GetxController {
  final ProfileRepository _profileRepository = ProfileRepository();
  final ImagePicker _picker = ImagePicker();

  var usernameController = TextEditingController();
  var addressController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var selectedImage = Rx<File?>(null);
  var isUpdated = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    usernameController.text = args['username'];
    addressController.text = args['address'];
    phoneNumberController.text = args['contactNumber'];
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      checkForUpdates();
    }
  }

  void checkForUpdates() {
    isUpdated.value = usernameController.text != Get.arguments['username'] ||
        addressController.text != Get.arguments['address'] ||
        phoneNumberController.text != Get.arguments['contactNumber'] ||
        selectedImage.value != null;
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true; // Show loading
      bool success = await _profileRepository.updateProfile(
        username: usernameController.text,
        address: addressController.text,
        contactNumber: phoneNumberController.text,
        imageFile: selectedImage.value,
      );

      if (success) {
        AppSnackBar.success('Profile updated successfully');
        // Delay Get.back() to ensure snackbar is visible
        await Future.delayed(const Duration(milliseconds: 1500));
        Get.back();
        Get.find<CreatorAccountController>().fetchProfileData();
        isUpdated.value = false;
      } else {
        AppSnackBar.error('Failed to update profile');
        print('Profile update failed: Unknown error from repository');
      }
    } catch (e) {
      AppSnackBar.error('Failed to update profile: $e');
      print('Profile update error: $e');
    } finally {
      isLoading.value = false; // Hide loading
    }
  }

  Future<Data?> fetchProfileData() async {
    try {
      Data? profileData = await _profileRepository.fetchProfile();
      if (profileData != null) {
        usernameController.text = profileData.name;
        addressController.text = profileData.location;
        phoneNumberController.text = profileData.contact;
      }
      return profileData; // Return the fetched profile data
    } catch (e) {
      print('Error fetching profile data: $e');
      return null; // Return null in case of an error
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    super.onClose();
  }
}
