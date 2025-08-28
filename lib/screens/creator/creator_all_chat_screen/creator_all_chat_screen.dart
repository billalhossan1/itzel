import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_images_path.dart';
import '../../../constants/app_strings.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import '../creator_group_chat_screen/creator_group_chat_screen.dart';
import 'controllers/creator_all_chat_controller.dart';

class CreatorAllChatScreen extends StatefulWidget {
  const CreatorAllChatScreen({super.key});

  @override
  State<CreatorAllChatScreen> createState() => _CreatorAllChatScreenState();
}

class _CreatorAllChatScreenState extends State<CreatorAllChatScreen> {
  final CreatorAllChatController chatController =
      Get.put(CreatorAllChatController());
  final TextEditingController searchController = TextEditingController();
  bool isExpanded = false;

  final List<String> groupImages = [
    AppImagesPath.groupImage1,
    AppImagesPath.groupImage2,
  ];
  final List<String> groupName = [
    AppStrings.groupName1,
    AppStrings.groupName2,
  ];

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.whiteBg,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpaceWidget(spaceHeight: 8),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width / (size.width / 20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: !isExpanded,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: isExpanded ? 0.0 : 1.0,
                        child: const TextWidget(
                          text: AppStrings.allChat,
                          fontColor: AppColors.black500,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     AnimatedContainer(
                    //       duration: const Duration(milliseconds: 200),
                    //       width: isExpanded
                    //           ? size.width / (size.width / 300)
                    //           : size.width / (size.width / 48),
                    //       height: size.height / (size.height / 45),
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(33),
                    //         color: isExpanded
                    //             ? AppColors.white
                    //             : AppColors.whiteBg,
                    //       ),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Material(
                    //             type: MaterialType.transparency,
                    //             child: IconButton(
                    //               onPressed: toggleExpanded,
                    //               icon: isExpanded
                    //                   ? const Icon(Icons.close)
                    //                   : const IconWidget(
                    //                       icon: AppIconsPath.newChatIcon,
                    //                       height: 24,
                    //                       width: 24,
                    //                     ),
                    //               splashColor: Colors.transparent,
                    //               highlightColor: Colors.transparent,
                    //               hoverColor: Colors.transparent,
                    //             ),
                    //           ),
                    //           Flexible(
                    //             child: isExpanded
                    //                 ? TextField(
                    //                     controller: searchController,
                    //                     style: const TextStyle(
                    //                         color: AppColors.black),
                    //                     cursorColor: AppColors.black,
                    //                     decoration: const InputDecoration(
                    //                       hintText: 'Search',
                    //                       hintStyle: TextStyle(
                    //                           color: AppColors.grey600),
                    //                       contentPadding:
                    //                           EdgeInsets.fromLTRB(5, 8, 20, 10),
                    //                       border: InputBorder.none,
                    //                     ),
                    //                   )
                    //                 : const SizedBox.shrink(),
                    //           ),
                    //           if (isExpanded)
                    //             IconButton(
                    //               onPressed: () {},
                    //               icon: const Icon(Icons.search),
                    //               splashColor: Colors.transparent,
                    //               highlightColor: Colors.transparent,
                    //               hoverColor: Colors.transparent,
                    //             ),
                    //         ],
                    //       ),
                    //     ),
                    //     const SpaceWidget(spaceWidth: 12),
                    //     PopupMenuButton<int>(
                    //       icon: const Icon(
                    //         Icons.more_vert,
                    //         color: AppColors.black,
                    //         size: 24,
                    //       ),
                    //       onSelected: (int result) {
                    //         // Handle menu item selection
                    //         switch (result) {
                    //           case 0:
                    //             // Action for first menu item
                    //             break;
                    //         }
                    //       },
                    //       itemBuilder: (BuildContext context) =>
                    //           <PopupMenuEntry<int>>[
                    //         const PopupMenuItem<int>(
                    //           value: 0,
                    //           child: Row(
                    //             children: [
                    //               Icon(Icons.settings, size: 20),
                    //               SpaceWidget(spaceWidth: 6),
                    //               Text('Settings'),
                    //             ],
                    //           ),
                    //         ),
                    //         // Add more PopupMenuItem widgets for additional menu items
                    //       ],
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              const SpaceWidget(spaceHeight: 16),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width / (size.width / 20)),
                child: const TextWidget(
                  text: AppStrings.groupChats,
                  fontColor: AppColors.grey900,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SpaceWidget(spaceHeight: 8),

              // My group

              Obx(() {
                if (chatController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (chatController.creatorGroups.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: size.width / (size.width / 50)),
                      child: const TextWidget(
                        text: 'No groups found',
                        fontColor: AppColors.black500,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      ...List.generate(
                        chatController.creatorGroups.length,
                        (index) {
                          final group = chatController.creatorGroups[index];
                          return InkWell(
                            onTap: () {
                              Get.to(
                                  () => CreatorGroupChatScreen(group: group));
                            },
                            borderRadius: BorderRadius.circular(16),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              margin: EdgeInsets.only(
                                left: size.width / (size.width / 20),
                                right: size.width / (size.width / 20),
                                bottom: size.width / (size.width / 12),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.grey300,
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.asset(
                                          groupImages.length > index
                                              ? groupImages[index]
                                              : AppImagesPath.chatProfileImage,
                                          height:
                                              size.width / (size.width / 48),
                                          width: size.width / (size.width / 48),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SpaceWidget(spaceWidth: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: ResponsiveUtils.width(200),
                                            child: TextWidget(
                                              text:
                                                  group.name ?? 'Unknown Group',
                                              fontColor: AppColors.black500,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlignment: TextAlign.start,
                                            ),
                                          ),
                                          const SpaceWidget(spaceHeight: 7),
                                          // const TextWidget(
                                          //   text: 'Ana : okay?',
                                          //   fontColor: AppColors.black500,
                                          //   fontSize: 12,
                                          //   fontWeight: FontWeight.w400,
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.end,
                                  //   children: [
                                  //     Container(
                                  //       height: size.width / (size.width / 16),
                                  //       width: size.width / (size.width / 16),
                                  //       decoration: BoxDecoration(
                                  //         color: AppColors.red,
                                  //         borderRadius:
                                  //             BorderRadius.circular(100),
                                  //       ),
                                  //       child: const Center(
                                  //         child: TextWidget(
                                  //           text: AppStrings.unreadChatQuantity,
                                  //           fontColor: AppColors.white,
                                  //           fontSize: 12,
                                  //           fontWeight: FontWeight.w600,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     const SpaceWidget(spaceHeight: 8),
                                  //     const TextWidget(
                                  //       text: '1 day',
                                  //       fontColor: AppColors.black300,
                                  //       fontSize: 10,
                                  //       fontWeight: FontWeight.w500,
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
              }),

              const SpaceWidget(spaceHeight: 16),
            ],
          ),
        ),
      ),
    );
  }
}
