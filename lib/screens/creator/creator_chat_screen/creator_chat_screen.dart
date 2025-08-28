import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:itzel/routes/app_routes.dart';
import 'package:itzel/widgets/space_widget/space_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_icons_path.dart';
import '../../../widgets/icon_widget/icon_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';

import 'widgets/creator_appbar_widget.dart';

class ChatMessage {
  String messageContent;
  String messageType;

  ChatMessage({
    required this.messageContent,
    required this.messageType,
  });
}

class CreatorChatScreen extends StatefulWidget {
  const CreatorChatScreen({super.key});

  @override
  State<CreatorChatScreen> createState() => _CreatorChatScreenState();
}

class _CreatorChatScreenState extends State<CreatorChatScreen> {
  final TextEditingController messageController = TextEditingController();

  // Move messages list to state
  List<ChatMessage> messages = [
    ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
    ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
    ChatMessage(
        messageContent: "Hey Kriss, I am doing fine dude. wbu?",
        messageType: "sender"),
    ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    ChatMessage(
        messageContent: "Is there any thing wrong?", messageType: "sender"),
  ];

  void sendMessage(String content) {
    if (content.isNotEmpty) {
      setState(() {
        messages.add(ChatMessage(
          messageContent: content,
          messageType: "sender",
        ));
      });
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.whiteBg,
        appBar: UserAppBarWidget(
          onTitleTap: () {
            Get.toNamed(AppRoutes.creatorChatReceiverInfoScreen);
          },
          onInfoTap: () {
            Get.toNamed(AppRoutes.creatorChatReceiverInfoScreen);
          },
          onMoreTap: () {
            showMenu(
              context: context,
              position: const RelativeRect.fromLTRB(
                  100, 100, 0, 0), // Adjust the position as needed
              items: [
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
            ).then((value) {
              if (value != null) {
                // Handle menu item selection
                switch (value) {
                  case 0:
                    // Action for first menu item
                    break;
                  case 1:
                    // Action for second menu item
                    break;
                  // Add more cases for additional menu items
                  case 2:
                    // Action for second menu item
                    break;
                  // Add more cases for additional menu items
                }
              }
            });
          },
          titleText: 'Bryan Lewis',
          subTitleText: 'Last Seen 12h ago',
        ),
        body: Stack(
          children: [
            // Chat messages list
            ListView.builder(
              itemCount: messages.length,
              padding: const EdgeInsets.only(top: 10, bottom: 70),
              itemBuilder: (context, index) {
                final message = messages[index];
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width / (size.width / 14),
                    vertical: size.width / (size.width / 10),
                  ),
                  child: Align(
                    alignment: message.messageType == "receiver"
                        ? Alignment.topLeft
                        : Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: message.messageType == "receiver"
                            ? AppColors.white
                            : AppColors.blueNormal,
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.grey300,
                            spreadRadius: 1,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(size.width / (size.width / 16)),
                      child: TextWidget(
                        text: message.messageContent,
                        fontColor: message.messageType == "receiver"
                            ? AppColors.black500
                            : AppColors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
            // Bottom input field
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(right: size.width / (size.width / 20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          left: size.width / (size.width / 20),
                          bottom: size.width / (size.width / 20),
                          right: size.width / (size.width / 11),
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
                        child: TextField(
                          controller: messageController,
                          cursorColor: AppColors.blueNormal,
                          decoration: InputDecoration(
                            hintText: "Type here...",
                            hintStyle: TextStyle(
                              color: AppColors.black300,
                              fontSize: size.width / (size.width / 14),
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: size.width / (size.width / 16),
                              vertical: size.width / (size.width / 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Send button
                    GestureDetector(
                      onTap: () {
                        sendMessage(messageController.text);
                        messageController.clear();
                      },
                      child: Container(
                        height: size.width / (size.width / 48),
                        width: size.width / (size.width / 48),
                        padding: EdgeInsets.all(size.width / (size.width / 12)),
                        margin: EdgeInsets.only(
                          bottom: size.width / (size.width / 20),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.blueDarker,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const IconWidget(
                          icon: AppIconsPath.sendIcon,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
