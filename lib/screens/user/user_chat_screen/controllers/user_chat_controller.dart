// lib/screens/user/user_chat_screen/controllers/user_chat_controller.dart
import 'package:get/get.dart';

import '../../../../models/my_group_model.dart';

class UserChatController extends GetxController {
  final MyGroup group;
  RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxString receiverName = ''.obs;
  final RxString lastSeen = ''.obs;

  UserChatController({required this.group}) {
    // Initialize controller with group data
    receiverName.value = group.name ?? 'Unknown Group';

    // Initialize messages if group has a message
    if (group.message != null && group.message!.isNotEmpty) {
      messages.add(
          ChatMessage(messageContent: group.message!, messageType: "receiver"));
    }
  }

  void sendMessage(String content) {
    if (content.isNotEmpty) {
      messages.add(ChatMessage(
        messageContent: content,
        messageType: "sender",
      ));
    }
  }
}

class ChatMessage {
  String messageContent;
  String messageType;

  ChatMessage({
    required this.messageContent,
    required this.messageType,
  });
}
