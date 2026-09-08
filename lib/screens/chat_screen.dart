import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../providers/message_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final int conversationId;

  const ChatScreen({
    super.key,
    required this.conversationId,
  });

  @override
  ConsumerState<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState
    extends ConsumerState<ChatScreen> {

  final messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final authState = ref.read(authProvider);

      if (authState.token != null) {
        ref
            .read(messageProvider.notifier)
            .getMessages(
          token: authState.token!,
          conversationId:
          widget.conversationId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final messageState = ref.watch(messageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),

      body: Column(
        children: [

          Expanded(
            child: messageState.isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
              padding:
              const EdgeInsets.all(10),
              itemCount:
              messageState.messages.length,
              itemBuilder:
                  (context, index) {

                final message =
                messageState.messages[index];

                final isMe =
                    message.senderId ==
                        authState.user?.id;

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin:
                    const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    padding:
                    const EdgeInsets.all(12),
                    decoration:
                    BoxDecoration(
                      color: isMe
                          ? Colors.blue
                          : Colors.grey,
                      borderRadius:
                      BorderRadius.circular(
                        12,
                      ),
                    ),
                    child: Text(
                      message.message,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller:
                    messageController,
                    decoration:
                    const InputDecoration(
                      hintText:
                      'Type message...',
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(
                    Icons.send,
                  ),
                  onPressed: () async {

                    final text =
                    messageController
                        .text
                        .trim();

                    if (text.isEmpty) {
                      return;
                    }

                    final token =
                        authState.token;

                    if (token == null) {
                      return;
                    }

                    await ref
                        .read(
                      messageProvider
                          .notifier,
                    )
                        .sendMessage(
                      token: token,
                      conversationId:
                      widget.conversationId,
                      message: text,
                    );

                    messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}