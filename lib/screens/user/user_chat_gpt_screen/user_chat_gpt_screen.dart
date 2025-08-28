import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_icons_path.dart';
import '../../../../constants/app_strings.dart';
import '../../../../widgets/appbar_widget/appbar_widget.dart';
import 'controller/chat_gpt_controller.dart';

class ChatGptScreen extends StatelessWidget {
  const ChatGptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        backgroundColor: AppColors.whiteBg,
        appBar: const AppbarWidget(text: AppStrings.askAI),
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 6),
          child: Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.only(bottom: isKeyboardVisible ? 0 : 0),
                    child: _buildChatScreen(controller),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildChatScreen(ChatController controller) {
    return Column(
      children: [
        Expanded(
          child: _buildMessageList(controller),
        ),
        Obx(() => Visibility(
              visible: controller.isLoading.value,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: SpinKitThreeBounce(
                  color: AppColors.blue,
                  size: 20,
                ),
              ),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              _buildInputField(controller),
              _buildSendButton(controller),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageList(ChatController controller) {
    return Obx(() => ListView.builder(
          controller: controller.scrollController,
          itemCount: controller.messages.length,
          reverse: false,
          itemBuilder: (context, index) {
            var message = controller.messages[index];
            return ChatMessageWidget(
              text: message.text,
              chatMessageType: message.chatMessageType,
            );
          },
        ));
  }

  Widget _buildInputField(ChatController controller) {
    return Expanded(
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(color: AppColors.black),
        controller: controller.textController,
        decoration: InputDecoration(
          fillColor: AppColors.white,
          filled: true,
          hintText: "Type here",
          contentPadding: const EdgeInsets.all(16),
          hintStyle: const TextStyle(color: AppColors.grey600),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(width: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton(ChatController controller) {
    return Obx(() => Visibility(
          visible: !controller.isLoading.value,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: CircleAvatar(
              backgroundColor: AppColors.blue,
              maxRadius: 23,
              child: IconButton(
                padding: const EdgeInsets.only(top: 2, right: 0),
                icon: SvgPicture.asset(
                  AppIconsPath.sendIcon,
                  color: AppColors.white,
                ),
                onPressed: controller.sendMessage,
              ),
            ),
          ),
        ));
  }
}

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({
    super.key,
    required this.text,
    required this.chatMessageType,
  });

  final String text;
  final ChatMessageType chatMessageType;

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 2 / 3;
    final isUserMessage = chatMessageType == ChatMessageType.user;
    final borderRadius = BorderRadius.only(
      bottomLeft: Radius.circular(isUserMessage ? 8 : 0),
      bottomRight: Radius.circular(isUserMessage ? 0 : 8),
      topLeft: const Radius.circular(8),
      topRight: const Radius.circular(8),
    );

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: maxWidth),
        decoration: BoxDecoration(
          color: isUserMessage ? AppColors.white : AppColors.blue100,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
