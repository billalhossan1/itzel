import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../models/my_group_model.dart';
import '../../../../models/profile_model.dart';
import '../../../../services/repository/my_group_repository/my_group_repository.dart';
import '../../../user/user_profile_screen/controllers/user_profile_controller.dart';

class UserGroupChatController extends GetxController {
  final MyGroup group;
  RxList<MyGroup> messages = <MyGroup>[].obs;
  final RxString receiverName = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isSocketConnected = false.obs;
  final ScrollController scrollController = ScrollController();
  Timer? _refreshTimer;
  DateTime? _lastMessageTimestamp;

  final MyGroupRepository _myGroupRepository = MyGroupRepository();
  final UserProfileController _userProfileController =
      Get.put(UserProfileController());
  Data? userProfile;
  late IO.Socket socket;

  UserGroupChatController({required this.group}) {
    receiverName.value = group.name ?? 'Unknown Group';
    init();
  }

  Future<void> init() async {
    await fetchUserProfile();
    await fetchMessages();
    initSocket();
    _startPeriodicRefresh();
  }

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      fetchMessages(); // Fetch regardless of socket connection status
    });
  }

  void initSocket() {
    socket = IO.io(
      'http://10.0.70.127:8001',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection() // Make sure reconnection is enabled
          .setReconnectionAttempts(10) // Set reasonable reconnection attempts
          .setReconnectionDelay(1000) // Start with 1 second delay
          .setExtraHeaders({'foo': 'bar'})
          .build(),
    );

    socket.onConnect((_) {
      print('🟢 Socket Connected');
      isSocketConnected.value = true;
      joinGroupChat();
    });

    socket.onConnectError((error) {
      print('🔴 Socket Connection Error: $error');
      isSocketConnected.value = false;
    });

    socket.onDisconnect((_) {
      print('🔴 Socket Disconnected');
      isSocketConnected.value = false;
      // Attempt to reconnect
      socket.connect();
    });

    socket.onError((error) {
      print('⚠️ Socket Error: $error');
      // Attempt to handle the error
      isSocketConnected.value = false;
    });
  }

  void joinGroupChat() {
    if (group.id == null) return;
    print('🟠 Joining Group Chat: ${group.id}');
    socket.emit('join_group', group.id);
    listenToNewMessages();
  }

  void listenToNewMessages() {
    if (group.id == null) return;
    socket.on('NEW_MESSAGE::${group.id}', (data) {
      print('📩 New message received: $data');
      try {
        final newMessage = MyGroup.fromJson(data);
        // Check if this message already exists in our list to avoid duplicates
        if (!messages.any((msg) => msg.id == newMessage.id)) {
          messages.add(newMessage);
          messages.sort((a, b) => (a.createdAt ?? DateTime(1970))
              .compareTo(b.createdAt ?? DateTime(1970)));
          messages.refresh();
          _lastMessageTimestamp = newMessage.createdAt;
          scrollToBottom();
        }
      } catch (e) {
        print('Error handling new message: $e');
      }
    });
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> fetchUserProfile() async {
    try {
      userProfile = await _userProfileController.fetchProfileData();
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  Future<void> fetchMessages() async {
    try {
      isLoading.value = true;
      if (group.id != null) {
        final fetchedMessages =
            await _myGroupRepository.fetchMessagesByGroupId(group.id!);
        if (fetchedMessages != null) {
          // Create a map of existing messages by ID for faster lookup
          final existingMessageIds = {for (var msg in messages) msg.id: true};

          // Only add messages that don't already exist in the list
          final newMessages = fetchedMessages.where((msg) =>
              msg.id != null && !existingMessageIds.containsKey(msg.id));

          if (newMessages.isNotEmpty) {
            messages.addAll(newMessages);
            if (messages.isNotEmpty && messages.last.createdAt != null) {
              _lastMessageTimestamp = messages.last.createdAt;
            }
            messages.sort((a, b) => (a.createdAt ?? DateTime(1970))
                .compareTo(b.createdAt ?? DateTime(1970)));
            messages.refresh();
            scrollToBottom();
          }
        }
      }
    } catch (e) {
      print('Error fetching messages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage(String content) async {
    if (content.isEmpty || group.id == null) return;

    try {
      final success = await _myGroupRepository.postMessage(group.id!, content);
      if (success) {
        final newMessage = MyGroup(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: content,
          from: From(
            id: userProfile?.id,
            name: userProfile?.name,
            email: userProfile?.email,
            profile: userProfile?.profile,
          ),
          createdAt: DateTime.now(),
        );
        // Check if the message already exists to avoid duplicates
        if (!messages.any((msg) => msg.id == newMessage.id)) {
          messages.add(newMessage);
          messages.sort((a, b) => (a.createdAt ?? DateTime(1970))
              .compareTo(b.createdAt ?? DateTime(1970)));
          _lastMessageTimestamp = newMessage.createdAt;
          messages.refresh();
          scrollToBottom();
        }
      }
    } catch (e) {
      print('Error sending message: $e');
      Get.snackbar(
        'Error',
        'Failed to send message. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Helper method to reconnect socket if disconnected
  void ensureSocketConnection() {
    if (!isSocketConnected.value) {
      print('🔄 Attempting to reconnect socket');
      socket.connect();
    }
  }

  @override
  void onInit() {
    super.onInit();
    ever(messages, (_) => scrollToBottom());

    // Check connection status periodically
    Timer.periodic(const Duration(seconds: 60), (_) {
      ensureSocketConnection();
    });
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    socket.disconnect();
    socket.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
