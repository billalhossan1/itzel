// import 'package:get/get.dart';
//
// class ChatMessage {
//   String messageContent;
//   String messageType;
//
//   ChatMessage({
//     required this.messageContent,
//     required this.messageType,
//   });
// }
//
// class CreatorChatController extends GetxController {
//   List<ChatMessage> messages = [
//     ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
//     ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
//     ChatMessage(
//         messageContent: "Hey Kriss, I am doing fine dude. wbu?",
//         messageType: "sender"),
//     ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
//     ChatMessage(
//         messageContent: "Is there any thing wrong?", messageType: "sender"),
//   ];
//
//   // Method to add a new message
//   void sendMessage(String content) {
//     if (content.isNotEmpty) {
//       messages.add(ChatMessage(
//         messageContent: content,
//         messageType: "sender",
//       ));
//       update(); // Notify GetBuilder to rebuild widgets
//     }
//   }
// }
