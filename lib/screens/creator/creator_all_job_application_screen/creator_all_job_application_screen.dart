import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/appbar_widget/appbar_widget.dart';
import '../../../widgets/button_widget/button_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import '../creator_job_details_screen/creator_job_details_screen.dart';
import 'controllers/creator_all_job_application_controller.dart';

class CreatorAllJobApplicationScreen extends StatelessWidget {
  final CreatorAllJobApplicationController controller =
      Get.put(CreatorAllJobApplicationController());

  CreatorAllJobApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      appBar: const AppbarWidget(text: 'All Job Application'),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchAllJobStatuses();
        },
        child: Obx(() {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const SpaceWidget(spaceHeight: 10),
                if (controller.isLoading.value)
                  SizedBox(
                    height: size.height / 2,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                else if (controller.allJobStatuses.isEmpty)
                  SizedBox(
                    height: size.height / 2,
                    child: const Center(
                        child: Text('No job applications available.')),
                  )
                else
                  ...controller.allJobStatuses.map(
                    (jobStatus) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        margin: EdgeInsets.only(
                          left: size.width / (size.width / 20),
                          right: size.width / (size.width / 20),
                          bottom: size.width / (size.width / 12),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.blueNormal,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.grey200,
                              spreadRadius: 1,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: AppImage(
                                        url: jobStatus.image,
                                        height: size.width / (size.width / 43),
                                        width: size.width / (size.width / 45),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SpaceWidget(spaceWidth: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width:
                                              size.width / (size.width / 250),
                                          child: TextWidget(
                                            text: jobStatus.role,
                                            fontColor: AppColors.whiteBg,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            overflow: TextOverflow.ellipsis,
                                            textAlignment: TextAlign.left,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            TextWidget(
                                              text: jobStatus.companyName,
                                              fontColor: AppColors.grey50,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              overflow: TextOverflow.ellipsis,
                                              textAlignment: TextAlign.left,
                                            ),
                                            const SpaceWidget(spaceWidth: 4),
                                            TextWidget(
                                              text: DateFormat(
                                                      'dd.MM.yyyy, hh:mm a')
                                                  .format(jobStatus.createdAt),
                                              fontColor: AppColors.grey500,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              overflow: TextOverflow.ellipsis,
                                              textAlignment: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SpaceWidget(spaceHeight: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: TextWidget(
                                  text:
                                      'Total Applicant - ${jobStatus.totalApplicant}',
                                  fontColor: AppColors.black500,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SpaceWidget(spaceHeight: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                children: [
                                  const SpaceWidget(spaceHeight: 10),
                                  ...jobStatus.allApplicants.map(
                                    (applicant) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: AppImage(
                                                    url: applicant.user.profile,
                                                    height: size.width /
                                                        (size.width / 25),
                                                    width: size.width /
                                                        (size.width / 25),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SpaceWidget(
                                                    spaceWidth: 8),
                                                TextWidget(
                                                  text: applicant.user.name,
                                                  fontColor: AppColors.black500,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ],
                                            ),
                                            ButtonWidget(
                                              onPressed: () {
                                                Get.to(() =>
                                                    CreatorJobDetailsScreen(
                                                        applicant: applicant));
                                              },
                                              label: 'Details',
                                              buttonWidth: size.width /
                                                  (size.width / 79),
                                              buttonHeight: size.width /
                                                  (size.width / 26),
                                              fontSize: size.width /
                                                  (size.width / 12),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                // Ensure there's enough content to scroll when empty
                if (controller.allJobStatuses.isEmpty)
                  SizedBox(height: size.height / 2),
              ],
            ),
          );
        }),
      ),
    );
  }
}
