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

                  SizedBox(height: AppSize.height(value: 40)),

                  Expanded(
                    child: controller.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : controller.subscriptionPlan.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: TextWidget(
                                    text: 'No subscriptions available',
                                    fontSize: 16,
                                    fontColor: Colors.grey,
                                    textAlignment: TextAlign.center,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: controller.subscriptionPlan.length,
                                itemBuilder: (context, index) {
                                  final plan =
                                      controller.subscriptionPlan[index];
                                  final priceLabel = (plan.price ?? 0) > 0
                                      ? '\$${plan.price}'
                                      : 'Free';
                                  return GestureDetector(
                                    onTap: () {
                                      if ((plan.price ?? 0) > 0 &&
                                          plan.productId != null) {
                                        controller
                                            .buyProduct(plan.productId!);
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20.0),
                                      child: Card(
                                        color: AppColors.blue100,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: TextWidget(
                                                      text: plan.name ?? '',
                                                      fontSize: AppSize.height(
                                                          value: 22),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontColor:
                                                          AppColors.blue,
                                                    ),
                                                  ),
                                                  TextWidget(
                                                    text: priceLabel,
                                                    fontSize: AppSize.height(
                                                        value: 24),
                                                    fontWeight: FontWeight.w700,
                                                    fontColor: AppColors.blue,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 20),
                                              ...?(plan.features
                                                  ?.map((f) =>
                                                      _subscriptionTextWidget(
                                                          f))
                                                  .toList()),
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
            color: Colors.white,
          ),
        ),
        SizedBox(width: AppSize.width(value: 10)),
        TextWidget(
          text: text,
          fontSize: AppSize.height(value: 16),
          fontWeight: FontWeight.w400,
          fontColor: AppColors.grey,
        ),
      ],
    );
  }
}
