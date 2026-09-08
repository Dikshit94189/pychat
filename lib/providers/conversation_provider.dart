import 'package:flutter_riverpod/legacy.dart';
import '../models/conversation_model.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

final conversationProvider =
StateNotifierProvider<ConversationNotifier,
    ConversationState>((ref) {
  return ConversationNotifier(
    ref.read(apiServiceProvider),
  );
});

class ConversationState {
  final bool isLoading;
  final ConversationModel? conversation;
  final String? error;

  ConversationState({
    this.isLoading = false,
    this.conversation,
    this.error,
  });
}

class ConversationNotifier
    extends StateNotifier<ConversationState> {

  final ApiService apiService;

  ConversationNotifier(this.apiService)
      : super(ConversationState());

  Future<void> createConversation({
    required String token,
    required int receiverId,
  }) async {
    state = ConversationState(
      isLoading: true,
    );

    try {
      final conversation =
      await apiService.createConversation(
        token,
        receiverId,
      );

      state = ConversationState(
        isLoading: false,
        conversation: conversation,
      );
    } catch (e) {
      state = ConversationState(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}