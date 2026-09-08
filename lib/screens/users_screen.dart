import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../providers/conversation_provider.dart';
import 'chat_screen.dart';

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final conversationState =
    ref.watch(conversationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome ${authState.user?.name ?? ''}',
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: conversationState.isLoading
              ? null
              : () async {

            final token = authState.token;

            if (token == null) {
              return;
            }

            await ref
                .read(conversationProvider.notifier)
                .createConversation(
              token: token,
              receiverId: 4,
            );

            final conversation =
                ref.read(
                  conversationProvider,
                ).conversation;

            if (conversation != null &&
                context.mounted) {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    conversationId:
                    conversation.id,
                  ),
                ),
              );
            }
          },
          child: conversationState.isLoading
              ? const CircularProgressIndicator()
              : const Text(
            'Chat with User B',
          ),
        ),
      ),
    );
  }
}