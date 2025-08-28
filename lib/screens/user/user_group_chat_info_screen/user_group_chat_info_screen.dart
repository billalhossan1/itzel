import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_images_path.dart';
import '../../../constants/app_strings.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/appbar_widget/appbar_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class UserGroupChatInfoScreen extends StatelessWidget {
  final List<String> infoMedia = [
    AppImagesPath.infoMedia1,
    AppImagesPath.infoMedia2,
    AppImagesPath.infoMedia3,
    AppImagesPath.infoMedia4,
    AppImagesPath.infoMedia5,
    AppImagesPath.infoMedia1,
    AppImagesPath.infoMedia2,
    AppImagesPath.infoMedia3,
    AppImagesPath.infoMedia4,
    AppImagesPath.infoMedia5,
  ];

  void onMoreTap() {
    print("More icon tapped!");
  }

  UserGroupChatInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.whiteBg,
        appBar: AppbarWidget(
          text: AppStrings.back,
          action: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PopupMenuButton<int>(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColors.black,
                  size: 24,
                ),
                onSelected: (int result) {
                  // Handle menu item selection
                  switch (result) {
                    case 0:
                      // Action for first menu item
                      break;
                    case 1:
                      // Action for first menu item
                      break;
                    case 2:
                      // Action for first menu item
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline,
                            color: AppColors.black500, size: 20),
                        SpaceWidget(spaceWidth: 6),
                        Text('Delete Chat'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Icons.block, color: AppColors.black500, size: 20),
                        SpaceWidget(spaceWidth: 6),
                        Text('Block'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Icons.report, color: AppColors.black500, size: 20),
                        SpaceWidget(spaceWidth: 6),
                        Text('Report Problem'),
                      ],
                    ),
                  ),
                  // Add more PopupMenuItem widgets for additional menu items
                ],
              ),
              const SpaceWidget(spaceWidth: 8),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    AppImagesPath.groupImage1,
                    height: size.width / (size.width / 202),
                    width: size.width / (size.width / 202),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SpaceWidget(spaceHeight: 10),
              const Center(
                child: TextWidget(
                  text: AppStrings.groupName1,
                  fontColor: AppColors.black500,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SpaceWidget(spaceHeight: 4),
              const Center(
                child: TextWidget(
                  text: AppStrings.lastActiveTime,
                  fontColor: AppColors.grey900,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SpaceWidget(spaceHeight: 10),
              const TextWidget(
                text: AppStrings.chatMedia,
                fontColor: AppColors.black500,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SpaceWidget(spaceHeight: 8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(
                  size.width / (size.width / 16),
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.greyLighter,
                      width: size.width / (size.width / 0.7)),
                ),
                child: Container(
                  constraints: BoxConstraints(
                    //below mentioned sizes for reference only
                    minWidth: size.width / (size.width / 100),
                    maxWidth: size.width / (size.width / 320),
                    minHeight: size.height / (size.height / 100),
                    maxHeight: size.height / (size.height / 450),
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.width / 0.9),
                      crossAxisCount: 3,
                      crossAxisSpacing: AppSize.width(value: 12),
                      mainAxisSpacing: AppSize.width(value: 6),
                    ),
                    itemCount: infoMedia.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    color: Colors.black,
                                    child: Image.asset(
                                      infoMedia[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: SizedBox(
                          height: size.width / (size.width / 94),
                          width: size.width / (size.width / 94),
                          child: Image.asset(
                            infoMedia[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SpaceWidget(spaceHeight: 20),
            ],
          ),
        ),
      ),
    );
  }
}
