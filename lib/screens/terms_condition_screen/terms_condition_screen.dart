import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/appbar_widget/appbar_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import 'controllers/terms_condition_controller.dart';

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TermsConditionController termsConditionController =
        Get.put(TermsConditionController());

    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      appBar: const AppbarWidget(text: AppStrings.termsConditions),
      body: Obx(
        () => termsConditionController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    termsConditionController.termsList.length,
                    (index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: termsConditionController
                                  .termsList[index].description ??
                              "",
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
