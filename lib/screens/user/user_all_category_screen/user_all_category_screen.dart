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
                    horizontal: size.width * 0.05), // 5% of screen width
                child: const TextWidget(
                  fontSize: 18,
                  fontWeight: FontWeight.w500, text: AppStrings.allCategories,
                ),
              ),
              const SpaceWidget(spaceHeight: 24),
              Obx(() {
                if (_controller.isLoading.value) {
                  return SizedBox(
                    height: size.height * 0.5, // Ensures spinner is centered and avoids overflow
                    child: const Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    crossAxisSpacing: size.width * 0.01, // 1% of width
                    mainAxisSpacing: size.height * 0.01, // 1% of height
                    crossAxisCount: 3,
                    childAspectRatio: 2 / 3,
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: AppImage(
                                url: category.image,
                                height: size.width * 0.22, // 22% of width
                                width: size.width * 0.22,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            TextWidget(
                              text: capitalize(category.name),
                              fontColor: AppColors.black500,
                              fontSize: size.width * 0.04, // 4% of width
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
