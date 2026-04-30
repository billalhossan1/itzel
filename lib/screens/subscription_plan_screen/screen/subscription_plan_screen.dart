
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import '../controller/subscription_controller.dart';

class SubscriptionPlanScreen extends StatelessWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(
      init: SubscriptionController(),
      builder: (controller) {
        return Scaffold(
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() {
                return Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios)),
                        Align(
                          alignment: Alignment.center,
                          child: TextWidget(
                            text: 'Subscription Plan',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    // Pending purchases indicator and retry button
                    FutureBuilder<bool>(
                      future: controller.hasPendingPurchases(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data == true) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.orange, width: 1),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.sync_problem,
                                      color: Colors.orange),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextWidget(
                                      text: 'Purchase pending sync',
                                      fontSize: 14,
                                      fontColor: Colors.orange[900]!,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        controller.retryPendingPurchases(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                    child: TextWidget(
                                      text: 'Retry',
                                      fontSize: 12,
                                      fontColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),

                    SizedBox(height: AppSize.height(value: 40)),
                    Padding(
                      padding: const EdgeInsets.only(left: 34.0, right: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.selectPlan(0);
                              controller.isMonthly.value = true;
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: TextWidget(
                                text: 'Monthly',
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                fontColor: controller.selectedPlanIndex.value == 0
                                    ? AppColors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.selectPlan(1);
                              controller.isMonthly.value = false;
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: TextWidget(
                                text: 'Annual',
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                fontColor: controller.selectedPlanIndex.value == 1
                                    ? AppColors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 4,
                      width: double.infinity,
                      color: AppColors.grey50,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 3,
                              width: AppSize.width(value: 120),
                              color: controller.isMonthly.value
                                  ? AppColors.blue
                                  : AppColors.grey50,
                            ),
                            Container(
                              height: 3,
                              width: AppSize.width(value: 120),
                              color: !controller.isMonthly.value
                                  ? AppColors.blue100
                                  : AppColors.grey50,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppSize.height(value: 30)),
                    Expanded(
                      child: controller.selectedPlanIndex.value == 0
                          ? controller.isLoading.value
                              ?Center(child: CircularProgressIndicator(),)
                              : controller.validMonthlySubscriptionList.isEmpty
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: TextWidget(
                                          text:
                                              'No monthly subscriptions available',
                                          fontSize: 16,
                                          fontColor: Colors.grey,
                                          textAlignment: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: controller
                                          .validMonthlySubscriptionList.length,
                                      itemBuilder: (context, index) {
                                        final monthlySubscriptionItem = controller
                                                .validMonthlySubscriptionList[
                                            index];
                                        return GestureDetector(
                                          onTap: () {
                                            // Call the in-app purchase method
                                            if (monthlySubscriptionItem
                                                        .productId !=
                                                    null &&
                                                monthlySubscriptionItem
                                                    .productId!.isNotEmpty) {
                                              controller.buyProduct(
                                                  monthlySubscriptionItem
                                                      .productId!);
                                            } else {
                                            Get.snackbar('Error', "Product Id not available");
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20.0),
                                            child: Card(
                                              color:
                                                  AppColors.blue100,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        // Use IAP price (Apple requirement)
                                                        TextWidget(
                                                          text: controller.getProductPrice(
                                                                  monthlySubscriptionItem
                                                                      .productId) ??
                                                              "€0",
                                                          // data: controller.getProductPrice(monthlySubscriptionItem.productId) ?? "€${monthlySubscriptionItem.price}",
                                                          fontSize:
                                                              AppSize.height(
                                                                  value: 28),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontColor: AppColors
                                                              .blue100,
                                                        ),
                                                        TextWidget(
                                                          text: '/monthly',
                                                          fontSize:
                                                              AppSize.width(
                                                                  value: 13),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: AppSize.height(
                                                            value: 20)),
                                                    Column(
                                                      children: [
                                                        ...monthlySubscriptionItem
                                                                .description
                                                                ?.map(
                                                                    (feature) =>
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              bottom: 10.0),
                                                                          child:
                                                                              _subscriptionTextWidget(
                                                                            feature,
                                                                          ),
                                                                        ))
                                                                .toList() ??
                                                            [],
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                          : controller.isLoading.value
                              ? Center(child: CircularProgressIndicator(),)
                              : controller.validAnnualSubscriptionList.isEmpty
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: TextWidget(
                                          text:
                                              'No annual subscriptions available',
                                          fontSize: 16, fontColor: Colors.grey,
                                          textAlignment: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: controller
                                          .validAnnualSubscriptionList.length,
                                      itemBuilder: (context, index) {
                                        final annualSubscriptionItem = controller
                                            .validAnnualSubscriptionList[index];
                                        return GestureDetector(
                                          onTap: () {
                                            // Call the in-app purchase method
                                            if (annualSubscriptionItem
                                                        .productId !=
                                                    null &&
                                                annualSubscriptionItem
                                                    .productId!.isNotEmpty) {
                                              controller.buyProduct(
                                                  annualSubscriptionItem
                                                      .productId!);
                                            } else {
                                             Get.snackbar("Error", "Product Id not available");
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20.0),
                                            child: Card(
                                              color:
                                                  AppColors.blue100,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        // Use IAP price (Apple requirement)
                                                        TextWidget(
                                                          text: controller.getProductPrice(
                                                                  annualSubscriptionItem
                                                                      .productId) ??
                                                              "€0",
                                                          // data: controller.getProductPrice(annualSubscriptionItem.productId) ?? "€${annualSubscriptionItem.price}",
                                                          fontSize:
                                                              AppSize.height(
                                                                  value: 28),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontColor: AppColors
                                                              .blue100,
                                                        ),
                                                        TextWidget(
                                                          text: '/Yearly',
                                                          fontSize:
                                                              AppSize.width(
                                                                  value: 13),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: AppSize.height(
                                                            value: 20)),
                                                    Column(
                                                      children: [
                                                        ...annualSubscriptionItem
                                                                .description
                                                                ?.map(
                                                                    (feature) =>
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              bottom: 10.0),
                                                                          child:
                                                                              _subscriptionTextWidget(
                                                                            feature,
                                                                          ),
                                                                        ))
                                                                .toList() ??
                                                            [],
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                    ),
                  ],
                );
              }),
            ),

        );
      },
    );
  }

  Widget _subscriptionTextWidget(String text) {
    return Row(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: AppColors.black,
          child: Icon(
            Icons.check,
            size: 15,
            color: AppColors.black400,
          ),
        ),
        SizedBox(width: AppSize.width(value: 10)),
        TextWidget(
          text: text,
          fontSize: AppSize.height(value: 20),
          fontWeight: FontWeight.w400,
          fontColor: AppColors.grey,
        ),
      ],
    );
  }
}
