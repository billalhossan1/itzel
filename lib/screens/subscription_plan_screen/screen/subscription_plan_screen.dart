import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:itzel/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

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
          backgroundColor: const Color(0xFFF0F4FF),
          // ── Proper AppBar — Flutter sizes this, body starts below it ──────
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(44),
            child: AppBar(
              toolbarHeight: 44,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
              ),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF005BEA), Color(0xFF008BF5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              leading: controller.routeFromDrawer
                  ? IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    )
                  : const SizedBox.shrink(),
              title: const Text(
                'Subscription Plans',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              centerTitle: true,
            ),
          ),
          body: Obx(() {
            return Stack(
              children: [
                // ── Background gradient ──────────────────────────────────
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 70,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF005BEA), Color(0xFF008BF5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                  ),
                ),

                // ── Decorative circles ───────────────────────────────────
                Positioned(
                  top: -40,
                  right: -40,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: -30,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                ),

                // ── Main content ─────────────────────────────────────────
                Column(
                  children: [
                    // Hero subtitle
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child: Text(
                        'Choose a plan that works best for you',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),

                    // ── Plan cards ───────────────────────────────────
                    Expanded(
                      child: controller.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.blue,
                              ),
                            )
                          : controller.subscriptionPlan.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.inbox_rounded,
                                        size: 64,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 12),
                                      TextWidget(
                                        text: 'No subscriptions available',
                                        fontSize: 16,
                                        fontColor: Colors.grey,
                                        textAlignment: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                      16, 16, 16, 12),
                                  itemCount: controller.subscriptionPlan.length,
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

                                    return _PlanCard(
                                      plan: plan,
                                      priceLabel: priceLabel,
                                      isSubscribed: isSubscribed,
                                      index: index,
                                      controller: controller,
                                      isPremium: index ==
                                          controller.subscriptionPlan.length - 1,
                                    );
                                  },
                                ),
                    ),

                    // ── Footer links ─────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final uri = Uri.parse(
                                  'https://sites.google.com/view/914-unplugged-privacy-policy/home');
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri,
                                    mode: LaunchMode.externalApplication);
                              }
                            },
                            child: const Text(
                              'Privacy Policy',
                              style: TextStyle(
                                color: AppColors.blue,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.blue,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              width: 1,
                              height: 14,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final uri = Uri.parse(
                                  'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/');
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri,
                                    mode: LaunchMode.externalApplication);
                              }
                            },
                            child: const Text(
                              'Terms of Use',
                              style: TextStyle(
                                color: AppColors.blue,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // ── Purchase loading overlay ──────────────────────────────
                if (controller.isPurchaseLoading.value)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.45),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            );
          }),
        );
      },
    );
  }
}

// ── Plan Card ────────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final dynamic plan;
  final String priceLabel;
  final bool isSubscribed;
  final int index;
  final SubscriptionController controller;
  final bool isPremium;

  const _PlanCard({
    required this.plan,
    required this.priceLabel,
    required this.isSubscribed,
    required this.index,
    required this.controller,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    final features = plan.features as List? ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isPremium
                ? AppColors.blue.withValues(alpha: 0.22)
                : Colors.black.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Card background
            Container(
              decoration: BoxDecoration(
                gradient: isPremium
                    ? const LinearGradient(
                        colors: [Color(0xFF005BEA), Color(0xFF008BF5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isPremium ? null : Colors.white,
              ),
            ),

            // Decorative circle for premium
            if (isPremium)
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                ),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header row ──────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Badge
                            if (isPremium)
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star_rounded,
                                        size: 13, color: Colors.white),
                                    SizedBox(width: 4),
                                    Text(
                                      'Most Popular',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Text(
                              plan.name ?? '',
                              style: TextStyle(
                                fontSize: AppSize.height(value: 22),
                                fontWeight: FontWeight.w800,
                                color: isPremium
                                    ? Colors.white
                                    : const Color(0xFF1A1A2E),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Price pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isPremium
                              ? Colors.white.withValues(alpha: 0.18)
                              : AppColors.blue.withValues(alpha: 0.09),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isPremium
                                ? Colors.white.withValues(alpha: 0.4)
                                : AppColors.blue.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Text(
                          priceLabel,
                          style: TextStyle(
                            fontSize: AppSize.height(value: 16),
                            fontWeight: FontWeight.w700,
                            color: isPremium ? Colors.white : AppColors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ── Divider ─────────────────────────────────────────
                  Divider(
                    color: isPremium
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.grey.shade200,
                    height: 1,
                  ),

                  const SizedBox(height: 14),

                  // ── Features list ────────────────────────────────────
                  ...features.map((f) => _featureRow(f.toString(), isPremium)),

                  const SizedBox(height: 20),

                  // ── CTA Button ───────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isSubscribed) {
                          Get.offAllNamed(AppRoutes.bottomNavScreen);
                        } else {
                          controller.onSubscribe(index);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSubscribed
                            ? (isPremium
                                ? Colors.white.withValues(alpha: 0.25)
                                : Colors.grey.shade300)
                            : (isPremium ? Colors.white : AppColors.blue),
                        foregroundColor: isSubscribed
                            ? (isPremium ? Colors.white : Colors.grey.shade600)
                            : (isPremium ? AppColors.blue : Colors.white),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: isSubscribed && isPremium
                              ? BorderSide(
                                  color: Colors.white.withValues(alpha: 0.5))
                              : BorderSide.none,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isSubscribed)
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Icon(
                                Icons.check_circle_rounded,
                                size: 18,
                                color: isPremium
                                    ? Colors.white
                                    : Colors.grey.shade600,
                              ),
                            ),
                          Text(
                            isSubscribed ? 'Current Plan' : 'Get Started',
                            style: TextStyle(
                              fontSize: AppSize.height(value: 15),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                          if (!isSubscribed)
                            const Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Icon(Icons.arrow_forward_rounded, size: 16),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureRow(String text, bool isPremium) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isPremium
                  ? Colors.white.withValues(alpha: 0.2)
                  : AppColors.blue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              size: 14,
              color: isPremium ? Colors.white : AppColors.blue,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: AppSize.height(value: 14),
                fontWeight: FontWeight.w400,
                color: isPremium
                    ? Colors.white.withValues(alpha: 0.9)
                    : const Color(0xFF4A4A68),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
