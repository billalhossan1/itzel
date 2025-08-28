import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itzel/models/all_organizations_model.dart';
import 'package:itzel/services/repository/category_repository/category_repository.dart';

import '../../../../widgets/app_snack_bar/app_snack_bar.dart';

class UserReviewController extends GetxController {
  final CategoryRepository _categoryRepository = CategoryRepository();
  final String categoryId;
  var organizations = <AllOrganizations>[].obs;
  var isLoading = true.obs;
  var searchController = TextEditingController();

  UserReviewController({required this.categoryId});

  @override
  void onInit() {
    super.onInit();
    fetchOrganizations();
  }

  Future<void> fetchOrganizations() async {
    try {
      isLoading.value = true;
      print(
          'Fetching organizations for category: $categoryId, search: ${searchController.text}');
      final fetchedOrganizations =
          await _categoryRepository.fetchOrganizationsByCategory(
        categoryId,
        searchController.text,
      );
      if (fetchedOrganizations != null && fetchedOrganizations.isNotEmpty) {
        organizations.value = fetchedOrganizations;
        print('Organizations fetched: ${fetchedOrganizations.length}');
      } else {
        organizations.clear();
        print('No organizations found');
      }
    } catch (e) {
      print('Error fetching organizations: $e');
      AppSnackBar.error('Failed to fetch organizations');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitReview({
    required AllOrganizations organization,
    required String description,
    required int star,
  }) async {
    try {
      final organizationId = organization.id;
      if (organizationId == null) {
        AppSnackBar.error('Organization ID is missing');
        return;
      }

      final isSuccess = await _categoryRepository.postReview(
        organizationId: organizationId,
        description: description,
        star: star,
      );

      if (isSuccess) {
        AppSnackBar.success('Review submitted successfully');
        await fetchOrganizations(); // Refresh the list after posting
      }
    } catch (e) {
      print('Error submitting review: $e');
      AppSnackBar.error('Failed to submit review');
    }
  }
}
