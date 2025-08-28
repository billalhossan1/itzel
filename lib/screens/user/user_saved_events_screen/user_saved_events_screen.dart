import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itzel/constants/app_colors.dart';
import 'package:itzel/routes/app_routes.dart';
import 'package:itzel/widgets/appbar_widget/appbar_widget.dart';
import 'package:itzel/widgets/space_widget/space_widget.dart';
import 'package:itzel/widgets/text_widget/text_widgets.dart';

import '../../../models/profile_model.dart';
import '../../../widgets/app_image/app_image.dart';

class UserSavedEventsScreen extends StatelessWidget {
  UserSavedEventsScreen({super.key});

  final List<EventWishList> eventWishlist = Get.arguments;

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      appBar: const AppbarWidget(text: 'Saved Events'),
      body: eventWishlist.isEmpty
          ? const Center(child: Text('No saved events'))
          : ListView.builder(
              itemCount: eventWishlist.length,
              itemBuilder: (context, index) {
                final event = eventWishlist[index];
                return InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.userHomeDetailsScreen,
                        arguments: {'id': event.id});
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(size.width / (size.width / 8)),
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
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: AppImage(
                            url: event.thumbnailImage,
                            height: size.height / (size.height / 192),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SpaceWidget(spaceHeight: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ...event.tags.map((type) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            size.width / (size.width / 7),
                                        vertical:
                                            size.width / (size.width / 4)),
                                    margin: EdgeInsets.only(
                                        right: size.width / (size.width / 4)),
                                    decoration: BoxDecoration(
                                      color: AppColors.blue50,
                                      borderRadius: BorderRadius.circular(4),
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
                              text: '\$${event.price}',
                              fontColor: AppColors.black500,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        const SpaceWidget(spaceHeight: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: size.width / (size.width / 210),
                              child: TextWidget(
                                text: capitalize(event.name),
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
                                    horizontal: size.width / (size.width / 9),
                                    vertical: size.width / (size.width / 4)),
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
              },
            ),
    );
  }
}
