import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itzel/models/category_model.dart';
import 'package:itzel/services/repository/category_repository/category_repository.dart';

class UserAllCategoryController extends GetxController {
  final CategoryRepository _categoryRepository = CategoryRepository();
  var categories = <CategoryModel>[].obs;
  var isLoading = true.obs;
  var searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final fetchedCategories = await _categoryRepository.fetchAllCategories();
      if (fetchedCategories != null) {
        categories.value = fetchedCategories;
      }
    } catch (e) {
      print('Error fetching categories: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
