import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import 'controllers/user_home_controller.dart';

class UserHomeScreen extends StatelessWidget {
  final UserHomeController controller = Get.put(UserHomeController());

  String capitalize(String s) =>
      s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : '';

  UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    ResponsiveUtils.initialize(context);
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.whiteBg,
        body: RefreshIndicator(
          onRefresh: controller.fetchEvents, // Directly return the Future
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceWidget(spaceHeight: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.width(20)),
                    child: const TextWidget(
                      text: 'Featured',
                      fontColor: AppColors.black500,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 5),
                  if (controller.events.isEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height -
                          100, // Ensure enough height for scrolling
                      child: const Center(child: Text('No events found')),
                    )
                  else
                    ...controller.events.map((event) {
                      return InkWell(
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.userHomeDetailsScreen,
                            arguments: {'id': event.id},
                          );
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.all(size.width / (size.width / 8)),
                          margin: EdgeInsets.only(
                              left: size.width / (size.width / 20),
                              right: size.width / (size.width / 20),
                              bottom: size.width / (size.width / 12)),
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.greyLighter,
                                width: size.width / (size.width / 0.7),
                              )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: AppImage(
                                  url: event.thumbnailImage ?? '',
                                  height: size.height / (size.height / 192),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SpaceWidget(spaceHeight: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ...event.tags!.map((type) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  size.width / (size.width / 7),
                                              vertical: size.width /
                                                  (size.width / 4)),
                                          margin: EdgeInsets.only(
                                              right: size.width /
                                                  (size.width / 4)),
                                          decoration: BoxDecoration(
                                            color: AppColors.blue50,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: TextWidget(
                                            text: capitalize(type),
                                            fontColor: AppColors.black,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                  TextWidget(
                                    text: '\$${event.price ?? 0}',
                                    fontColor: AppColors.black500,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              const SpaceWidget(spaceHeight: 8),
                              TextWidget(
                                text:
                                    "Event type: ${capitalize(event.type ?? 'Unknown')}",
                                fontColor: AppColors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlignment: TextAlign.start,
                              ),
                              const SpaceWidget(spaceHeight: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: size.width / (size.width / 210),
                                    child: TextWidget(
                                      text: capitalize(event.name ?? 'Unnamed'),
                                      fontColor: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlignment: TextAlign.start,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    borderRadius: BorderRadius.circular(4),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              size.width / (size.width / 9),
                                          vertical:
                                              size.width / (size.width / 4)),
                                      margin: EdgeInsets.only(
                                          right: size.width / (size.width / 4)),
                                      decoration: BoxDecoration(
                                        color: AppColors.blueNormal,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const TextWidget(
                                        text: 'Go now',
                                        fontColor: AppColors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  const SpaceWidget(spaceHeight: 80),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
