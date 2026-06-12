import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itzel/services/storage_services/app_auth_storage.dart';
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
  final RxBool _isFetchingMessages = false.obs;

  // Track message IDs to prevent duplicates
  final Set<String> _messageIds = <String>{};

  final MyGroupRepository _myGroupRepository = MyGroupRepository();
  final UserProfileController _userProfileController =
      Get.find<UserProfileController>();
  Data? userProfile;
  late IO.Socket socket;

  UserGroupChatController({required this.group}) {
    if (group.id == null) {
      print('⚠️ Warning: Group ID is null');
    }
    receiverName.value = group.name ?? 'Unknown Group';
    init();
  }

  Future<void> init() async {
    print('🟠 Initializing controller for group: ${group.id}');
    String ? token=AppAuthStorage().getToken();

    if(token!=null && token.isNotEmpty==true){

      await fetchUserProfile();
      await fetchMessages();
      initSocket();
      _startPeriodicRefresh();
    }
  }

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      print('🔄 Periodic refresh triggered');
      await fetchMessages();
    });
  }

  void initSocket() {
    try {
      print('🟠 Initializing socket to http://10.0.80.49:5030');
      socket = IO.io(
        'http://10.0.80.49:5030',
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(10)
            .setReconnectionDelay(1000)
            .setTimeout(5000)
            .build(),
      );

      socket.onConnect((_) {
        print('🟢 Socket Connected');
        isSocketConnected.value = true;
        joinGroupChat();
        fetchMessages();
      });

      socket.onConnectError((error) {
        print('🔴 Socket Connection Error: $error');
        isSocketConnected.value = false;
        fetchMessages();
      });

      socket.onDisconnect((_) {
        print('🔴 Socket Disconnected');
        isSocketConnected.value = false;
      });

      socket.onError((error) {
        print('⚠️ Socket Error: $error');
        isSocketConnected.value = false;
      });

      socket.connect();
    } catch (e) {
      print('Socket initialization error: $e');
      isSocketConnected.value = false;
      fetchMessages();
    }
  }

  void joinGroupChat() {
    if (group.id == null) {
      print('⚠️ Group ID is null, cannot join group chat');
      return;
    }
    print('🟠 Joining Group Chat: ${group.id}');
    socket.emit('join_group', group.id);
    listenToMessages();
  }

  void listenToMessages() {
    if (group.id == null) {
      print('⚠️ Group ID is null, cannot listen to messages');
      return;
    }

    // Listen for new messages
    socket.off('NEW_MESSAGE::${group.id}');
    socket.on('NEW_MESSAGE::${group.id}', (data) {
      print('📩 New real-time message received: $data');
      try {
        final newMessage = MyGroup.fromJson(data);
        addMessageIfNotExists(newMessage);
      } catch (e) {
        print('Error parsing new message: $e, data: $data');
      }
    });

    // Listen for message deliveries
    socket.off('MESSAGE_DELIVERED::${group.id}');
    socket.on('MESSAGE_DELIVERED::${group.id}', (data) {
      print('✓ Message delivered: $data');
    });
  }

  void addMessageIfNotExists(MyGroup newMessage) {
    if (newMessage.id == null) {
      print('⚠️ Message has no ID, skipping: $newMessage');
      return;
    }

    if (!_messageIds.contains(newMessage.id)) {
      print('✅ Adding message: ${newMessage.id}');
      _messageIds.add(newMessage.id!);
      messages.add(newMessage);
      messages.sort((a, b) => (a.createdAt ?? DateTime(1970))
          .compareTo(b.createdAt ?? DateTime(1970)));
      _lastMessageTimestamp = newMessage.createdAt;
      messages.refresh();
      print('📜 Messages updated, count: ${messages.length}');
      scrollToBottom();
    } else {
      print('🔁 Message ${newMessage.id} already exists, skipping');
    }
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
      print('👤 User profile fetched: ${userProfile?.id}');
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  Future<void> fetchMessages() async {
    if (_isFetchingMessages.value) {
      print('🚫 Already fetching messages, skipping');
      return;
    }

    try {
      _isFetchingMessages.value = true;
      isLoading.value = true;

      if (group.id == null) {
        print('⚠️ Group ID is null, cannot fetch messages');
        return;
      }

      print('🔍 Fetching messages for group: ${group.id}');
      if (isSocketConnected.value) {
        print('📡 Emitting fetch_group_messages');
        socket.emit('fetch_group_messages', {
          'groupId': group.id,
          'after': _lastMessageTimestamp?.toIso8601String(),
        });

        socket.off('group_messages_${group.id}');
        socket.on('group_messages_${group.id}', (data) {
          print('📥 Socket response received: $data');
          try {
            if (data == null) {
              print('⚠️ Received null data from socket');
              return;
            }

            if (data is List) {
              print('📚 Processing ${data.length} messages');
              if (data.isEmpty) {
                print('ℹ️ No new messages received');
              }
              for (var messageData in data) {
                try {
                  final message = MyGroup.fromJson(messageData);
                  addMessageIfNotExists(message);
                } catch (e) {
                  print('Error parsing message: $e, data: $messageData');
                }
              }
            } else {
              print('⚠️ Unexpected data format: $data');
            }
          } catch (e) {
            print('Error processing socket messages: $e');
          } finally {
            isLoading.value = false;
            _isFetchingMessages.value = false;
            print('🏁 Socket fetch completed');
          }
        });

        // Fallback to HTTP if no socket response in 5 seconds
        Future.delayed(const Duration(seconds: 5), () {
          if (_isFetchingMessages.value && isLoading.value) {
            print('⏰ Socket fetch timed out, falling back to HTTP');
            _fetchMessagesViaHttp();
          }
        });
      } else {
        print('🔴 Socket disconnected, using HTTP');
        await _fetchMessagesViaHttp();
      }
    } catch (e) {
      print('Error fetching messages: $e');
      await _fetchMessagesViaHttp();
    }
  }

  Future<void> _fetchMessagesViaHttp() async {
    try {
      print('🌐 Fetching messages via HTTP for group: ${group.id}');
      if (group.id != null) {
        final fetchedMessages =
            await _myGroupRepository.fetchMessagesByGroupId(group.id!);

        if (fetchedMessages != null) {
          print('📚 Received ${fetchedMessages.length} messages via HTTP');
          for (var message in fetchedMessages) {
            addMessageIfNotExists(message);
          }
        } else {
          print('⚠️ No messages received via HTTP');
        }
      } else {
        print('⚠️ Group ID is null, cannot fetch via HTTP');
      }
    } catch (e) {
      print('Error fetching messages via HTTP: $e');
    } finally {
      isLoading.value = false;
      _isFetchingMessages.value = false;
      print('🏁 HTTP fetch completed');
    }
  }

  Future<void> sendMessage(String content) async {
    if (content.isEmpty || group.id == null) {
      print('⚠️ Cannot send empty message or group ID is null');
      return;
    }

    try {
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();
      final newMessage = MyGroup(
        id: tempId,
        message: content,
        from: From(
          id: userProfile?.id,
          name: userProfile?.name,
          email: userProfile?.email,
          profile: userProfile?.profile,
        ),
        createdAt: DateTime.now(),
      );

      print('📤 Optimistically adding message: $tempId');
      addMessageIfNotExists(newMessage);

      if (isSocketConnected.value) {
        print('📡 Sending message via socket: $content');
        socket.emit('send_message',
            {'groupId': group.id, 'content': content, 'tempId': tempId});
      }

      print('🌐 Sending message via HTTP');
      final success = await _myGroupRepository.postMessage(group.id!, content);

      if (!success && !isSocketConnected.value) {
        Get.snackbar(
          'Error',
          'Failed to send message. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
        print('❌ Message sending failed');
      }
    } catch (e) {
      print('Error sending message: $e');
      Get.snackbar(
        'Error',
        'Failed to send message. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> onRefresh() async {
    print('🔄 Pull to refresh triggered');
    await fetchMessages();
  }

  @override
  void onInit() {
    super.onInit();
    print('🟠 Controller onInit');
  }

  @override
  void onClose() {
    print('🧹 Cleaning up controller');
    _refreshTimer?.cancel();
    socket.disconnect();
    socket.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
