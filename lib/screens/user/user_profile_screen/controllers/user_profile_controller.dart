import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../models/profile_model.dart';
import '../../../../services/repository/profile_repository/profile_repository.dart';
import '../../../../widgets/app_snack_bar/app_snack_bar.dart';
import '../../user_account_screen/controllers/user_account_controller.dart';

class UserProfileController extends GetxController {
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
    final args = Get.arguments ?? {};
    usernameController.text = args['username'] ?? '';
    addressController.text = args['address'] ?? '';
    phoneNumberController.text = args['contactNumber'] ?? '';
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
        // Delay Get.back() to ensure snackbar is visible

        await Get.find<UserAccountController>().fetchProfileData();
        isLoading.value = false;
        
        Get.back();
        AppSnackBar.success('Profile updated successfully');


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
      return profileData;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
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
