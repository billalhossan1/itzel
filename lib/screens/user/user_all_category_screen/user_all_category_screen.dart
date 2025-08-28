import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import '../user_review_screen/user_review_screen.dart';
import 'controller/user_all_category_controller.dart';

class UserAllCategoryScreen extends StatelessWidget {
  final searchController = TextEditingController();

  final UserAllCategoryController _controller =
      Get.put(UserAllCategoryController());

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  UserAllCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpaceWidget(spaceHeight: 24),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width / (size.width / 20)),
                child: const TextWidget(
                  text: AppStrings.allCategories,
                  fontColor: AppColors.black500,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SpaceWidget(spaceHeight: 24),
              Obx(() {
                if (_controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 8.0,
                    crossAxisCount: 3,
                    childAspectRatio: 2 / 3,
                    // Generate 100 widgets that display their index in the List.
                    children:
                        List.generate(_controller.categories.length, (index) {
                      final category = _controller.categories[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserReviewScreen(
                                categoryTitle: category.name,
                                categoryId: category.id,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: AppImage(
                                url: category.image,
                                height: size.width / (size.width / 103),
                                width: size.width / (size.width / 103),
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SpaceWidget(spaceHeight: 8),
                            TextWidget(
                              text: capitalize(category.name),
                              fontColor: AppColors.black500,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      );
                    }),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
