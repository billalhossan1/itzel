import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/appbar_widget/appbar_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import 'controllers/faq_controller.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FaqController faqController = Get.put(FaqController());

    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      appBar: const AppbarWidget(text: AppStrings.faqTitle),
      body: Obx(
        () => faqController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    faqController.faqList.length,
                    (index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: faqController.faqList[index].question ?? "",
                          fontColor: AppColors.blackLight2,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          textAlignment: TextAlign.start,
                        ),
                        const SpaceWidget(spaceHeight: 2),
                        TextWidget(
                          text: faqController.faqList[index].answer ?? "",
                          fontColor: AppColors.blackLight2,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          textAlignment: TextAlign.start,
                        ),
                        const SpaceWidget(spaceHeight: 24),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
