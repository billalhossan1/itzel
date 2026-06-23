import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itzel/routes/app_routes.dart';

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
            padding: EdgeInsets.only(
                left: 16, right: 16, top: MediaQuery.of(context).padding.top),
            child: Obx(() {
              return Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                if (controller.routeFromDrawer)
                                  Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back_ios)),
                          Align(
                            alignment: Alignment.center,
                            child: TextWidget(
                              text: 'Subscription Plan',
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
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
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount:
                                        controller.subscriptionPlan.length,
                                    itemBuilder: (context, index) {
                                      final plan =
                                          controller.subscriptionPlan[index];
                                      final durationStr =
                                          controller.getPlanDuration(plan);
                                      final priceLabel = (plan.price ?? 0) > 0
                                          ? '\$${plan.price} / $durationStr'
                                          : 'Free';

                                      final isSubscribed = controller
                                              .profileModel
                                              .value
                                              ?.subscriptionPackageId ==
                                          plan.sId;

                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 8),
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                              AppSize.height(value: 12)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextWidget(
                                                  text: plan.name ?? '',
                                                  fontSize:
                                                      AppSize.height(value: 24),
                                                  fontWeight: FontWeight.w700,
                                                  fontColor: AppColors.blue,
                                                ),
                                                TextWidget(
                                                  text: priceLabel,
                                                  fontSize:
                                                      AppSize.height(value: 22),
                                                  fontWeight: FontWeight.w600,
                                                  fontColor: AppColors.blue,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            ...?(plan.features
                                                ?.map((f) =>
                                                    _subscriptionTextWidget(f))
                                                .toList()),
                                            SizedBox(height: 20),
                                            Center(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  if (isSubscribed) {
                                                    Get.offAllNamed(AppRoutes
                                                        .bottomNavScreen);
                                                  } else {
                                                    controller
                                                        .onSubscribe(index);
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: isSubscribed
                                                      ? Colors.grey
                                                      : AppColors.blue,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppSize.height(
                                                                value: 10)),
                                                  ),
                                                ),
                                                child: Text(
                                                  isSubscribed
                                                      ? "Subscribed"
                                                      : 'Subscribe',
                                                  style: TextStyle(
                                                    color: AppColors.white,
                                                    fontSize: AppSize.height(
                                                        value: 16),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
                  if (controller.isPurchaseLoading.value)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.3),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
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
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      margin: EdgeInsets.only(bottom: 4),
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
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
          Expanded(
            child: TextWidget(
              text: text,
              maxLines: 50,
              textAlignment: TextAlign.left,
              fontSize: AppSize.height(value: 16),
              fontWeight: FontWeight.w400,
              fontColor: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
