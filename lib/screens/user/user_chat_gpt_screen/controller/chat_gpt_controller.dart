import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/app_strings.dart';

const String apiSecretKey = AppStrings.chatGptApiKey;

class ChatController extends GetxController {
  final _storage = GetStorage();
  final messages = <ChatMessage>[].obs;
  final isLoading = false.obs;
  final textController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _loadMessages();
  }

  void _loadMessages() {
    List<dynamic>? storedMessages = _storage.read<List>('chatMessages');
    if (storedMessages != null) {
      messages.value =
          storedMessages.map((msg) => ChatMessage.fromJson(msg)).toList();
    }
    if (messages.value.isEmpty) {
      _addBotMessage("Hello!\nHow may I assist you today?");
    }
    if (scrollController.positions.isNotEmpty) {
      scrollController.position.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(microseconds: 500),
          curve: Curves.easeOut);
    }
  }

  void _saveMessages() {
    _storage.write(
        'chatMessages', messages.map((msg) => msg.toJson()).toList());
  }

  void _addBotMessage(String message) {
    messages
        .add(ChatMessage(text: message, chatMessageType: ChatMessageType.bot));
    _saveMessages();
    Future.delayed(const Duration(milliseconds: 1)).then((_) => _scrollDown());
  }

  void sendMessage() async {
    String input = textController.text;
    textController.clear();
    messages
        .add(ChatMessage(text: input, chatMessageType: ChatMessageType.user));
    isLoading.value = true;
    _saveMessages();
    _scrollDown();

    generateResponse(input).then((value) {
      isLoading.value = false;
      messages
          .add(ChatMessage(text: value, chatMessageType: ChatMessageType.bot));
      _saveMessages();
      _scrollDown();
    });
  }

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 50)).then((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<String> generateResponse(String prompt) async {
    var url = Uri.https("api.openai.com", "/v1/chat/completions");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiSecretKey',
      },
      body: json.encode({
        "model": "gpt-4o-mini",
        "messages": [
          {
            "role": "system",
            "content": "You are an assistant and your name is Itzel."
          },
          {"role": "user", "content": prompt}
        ]
      }),
    );

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (jsonResponse.containsKey('choices')) {
      var choices = jsonResponse['choices'] as List<dynamic>;
      if (choices.isNotEmpty && choices[0].containsKey('message')) {
        var message = choices[0]['message'];
        if (message.containsKey('content')) {
          return message['content'] as String;
        }
      }
    }
    return 'Failed to generate response.';
  }
}

class ChatMessage {
  final String text;
  final ChatMessageType chatMessageType;

  ChatMessage({required this.text, required this.chatMessageType});

  Map<String, dynamic> toJson() => {
        'text': text,
        'chatMessageType': chatMessageType.index,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'],
      chatMessageType: ChatMessageType.values[json['chatMessageType']],
    );
  }
}

enum ChatMessageType { user, bot }
