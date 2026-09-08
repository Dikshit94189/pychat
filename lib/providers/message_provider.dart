import 'package:flutter_riverpod/legacy.dart';

import '../models/message_model.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

final messageProvider =
StateNotifierProvider<MessageNotifier,
    MessageState>((ref) {
  return MessageNotifier(
    ref.read(apiServiceProvider),
  );
});

class MessageState {
  final bool isLoading;
  final List<MessageModel> messages;
  final String? error;

  MessageState({
    this.isLoading = false,
    this.messages = const [],
    this.error,
  });
}

class MessageNotifier
    extends StateNotifier<MessageState> {

  final ApiService apiService;

  MessageNotifier(this.apiService)
      : super(MessageState());

  Future<void> getMessages({
    required String token,
    required int conversationId,
  }) async {
    state = MessageState(
      isLoading: true,
      messages: state.messages,
    );

    try {
      final messages =
      await apiService.getMessages(
        token,
        conversationId,
      );

      state = MessageState(
        isLoading: false,
        messages: messages,
      );
    } catch (e) {
      state = MessageState(
        isLoading: false,
        messages: state.messages,
        error: e.toString(),
      );
    }
  }

  Future<void> sendMessage({
    required String token,
    required int conversationId,
    required String message,
  }) async {
    try {
      final newMessage =
      await apiService.sendMessage(
        token,
        conversationId,
        message,
      );

      state = MessageState(
        messages: [
          ...state.messages,
          newMessage,
        ],
      );
    } catch (e) {
      state = MessageState(
        messages: state.messages,
        error: e.toString(),
      );
    }
  }
}