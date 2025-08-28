import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/appbar_widget/appbar_widget.dart';
import '../../../widgets/button_widget/button_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import 'controller/product_details_controller.dart';

class UserProductDetailsScreen extends StatelessWidget {
  final ProductDetailsController controller =
      Get.put(ProductDetailsController());

  UserProductDetailsScreen({super.key});

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  // Function to initiate a phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      appBar: const AppbarWidget(text: "Product Details"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.productDetails.value.id == null) {
          return const Center(child: Text('Product details not found'));
        } else {
          final product = controller.productDetails.value;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AppImage(
                    url: product.image ?? '',
                    height: size.width / (size.width / 300),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SpaceWidget(spaceHeight: 16),
                // Product Name
                TextWidget(
                  text: capitalize(product.name ?? 'No Name'),
                  fontColor: AppColors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                const SpaceWidget(spaceHeight: 8),
                // Product Price
                TextWidget(
                  text: 'Price: \$${product.price ?? 0}',
                  fontColor: AppColors.black400,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                const SpaceWidget(spaceHeight: 8),
                // Product Description
                TextWidget(
                  text: capitalize(product.description ?? 'No Description'),
                  fontColor: AppColors.black400,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  textAlignment: TextAlign.start,
                ),
                const SpaceWidget(spaceHeight: 16),
                // Seller Details
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seller: ${capitalize(product.createdBy?.name ?? 'Unknown')}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Phone: ${product.phone ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'WhatsApp: ${product.whatsapp ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Email: ${product.createdBy?.email ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      }),
      bottomNavigationBar: Obx(() {
        if (controller.productDetails.value.phone == null) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ButtonWidget(
            onPressed: () {
              _makePhoneCall(controller.productDetails.value.phone!);
            },
            label: 'Contact Now',
            buttonHeight: 50,
            buttonWidth: double.infinity,
          ),
        );
      }),
    );
  }
}
