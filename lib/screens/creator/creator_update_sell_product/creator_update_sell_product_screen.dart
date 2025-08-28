import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/appbar_widget/appbar_widget.dart';
import '../../../widgets/button_widget/button_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import '../creator_job_publish_screen/widgets/creator_job_publish_textfield_widget.dart';
import 'controller/creator_update_sell_product_controller.dart';

class CreatorUpdateSellProductScreen extends StatelessWidget {
  final CreatorUpdateSellProductController controller =
      Get.put(CreatorUpdateSellProductController());

  CreatorUpdateSellProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      appBar: const AppbarWidget(text: 'Update Selling Item'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextWidget(
              text: 'Upload Picture',
              fontColor: AppColors.black500,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            const SpaceWidget(spaceHeight: 4),
            DottedBorder(
              child: InkWell(
                onTap: controller.pickImage, // Call the controller's method
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Obx(() {
                  final localImage = controller.selectedImage.value;
                  final remoteImage = controller.remoteImageUrl.value;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: size.height / (size.height / 143),
                      width: double.infinity,
                      child: localImage != null
                          ? Image.file(
                              File(localImage.path),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.error,
                                        size: 32, color: Colors.red),
                                    Text("Failed to load image"),
                                  ],
                                );
                              },
                            )
                          : remoteImage != null
                              ? Image.network(
                                  remoteImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.error,
                                            size: 32, color: Colors.red),
                                        Text("Failed to load image"),
                                      ],
                                    );
                                  },
                                )
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add, size: 32),
                                    Text("Upload"),
                                  ],
                                ),
                    ),
                  );
                }),
              ),
            ),
            const SpaceWidget(spaceHeight: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextWidget(
                text: 'Product Name',
                fontColor: AppColors.grey900,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SpaceWidget(spaceHeight: 4),
            CreatorJobPublishTextFieldWidget(
              hintText: '',
              controller: controller.companyNameController,
              maxLines: 1,
            ),
            const SpaceWidget(spaceHeight: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextWidget(
                text: 'Product Description',
                fontColor: AppColors.grey900,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SpaceWidget(spaceHeight: 4),
            CreatorJobPublishTextFieldWidget(
              hintText: '',
              controller: controller.jobDescriptionController,
              maxLines: 5,
            ),
            const SpaceWidget(spaceHeight: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextWidget(
                text: 'Price',
                fontColor: AppColors.grey900,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SpaceWidget(spaceHeight: 4),
            CreatorJobPublishTextFieldWidget(
              hintText: '',
              controller: controller.priceController,
              maxLines: 1,
              keyboardType: TextInputType.number,
            ),
            const SpaceWidget(spaceHeight: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextWidget(
                text: 'Country',
                fontColor: AppColors.grey900,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SpaceWidget(spaceHeight: 4),
            CreatorJobPublishTextFieldWidget(
              hintText: '',
              controller: controller.countryController,
              maxLines: 1,
            ),
            const SpaceWidget(spaceHeight: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextWidget(
                text: 'State',
                fontColor: AppColors.grey900,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SpaceWidget(spaceHeight: 4),
            CreatorJobPublishTextFieldWidget(
              hintText: '',
              controller: controller.stateController,
              maxLines: 1,
            ),
            const SpaceWidget(spaceHeight: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextWidget(
                text: 'City',
                fontColor: AppColors.grey900,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SpaceWidget(spaceHeight: 4),
            CreatorJobPublishTextFieldWidget(
              hintText: '',
              controller: controller.cityController,
              maxLines: 1,
            ),
            const SpaceWidget(spaceHeight: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextWidget(
                text: 'Phone Number',
                fontColor: AppColors.grey900,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SpaceWidget(spaceHeight: 4),
            CreatorJobPublishTextFieldWidget(
              hintText: '',
              controller: controller.phoneNumberController,
              maxLines: 1,
            ),
            const SpaceWidget(spaceHeight: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextWidget(
                text: 'WhatsApp Number',
                fontColor: AppColors.grey900,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SpaceWidget(spaceHeight: 4),
            CreatorJobPublishTextFieldWidget(
              hintText: '',
              controller: controller.whatsAppController,
              maxLines: 1,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: ButtonWidget(
          onPressed: controller.updateProduct,
          // Call updateProduct method
          label: 'Update Post',
          buttonWidth: double.infinity,
          buttonHeight: (size.height / (size.height / 56)),
          buttonRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
