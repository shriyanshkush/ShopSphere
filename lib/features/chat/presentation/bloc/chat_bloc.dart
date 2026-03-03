import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;

  ChatBloc(this.repository) : super(const ChatState()) {
    on<SendChatMessage>(_onSendMessage);
    on<LoadChatThread>(_onLoadThread);
    on<ClearChat>((event, emit) => emit(const ChatState()));
  }

  Future<void> _onSendMessage(SendChatMessage event, Emitter<ChatState> emit) async {
    final optimistic = [...state.messages, {'role': 'user', 'content': event.message}];
    emit(state.copyWith(messages: optimistic, isLoading: true, error: null));

    try {
      final response = await repository.sendMessage(
        userId: event.userId,
        message: event.message,
        threadId: state.threadId,
      );

      final updated = [
        ...optimistic,
        {'role': 'assistant', 'content': response['reply'] ?? 'No response'},
      ];

      emit(state.copyWith(
        messages: updated,
        isLoading: false,
        threadId: response['threadId'] as String?,
      ));
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '').trim();
      emit(state.copyWith(
        isLoading: false,
        error: message.isEmpty ? 'Could not connect to AI assistant.' : message,
      ));
    }
  }

  Future<void> _onLoadThread(LoadChatThread event, Emitter<ChatState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final response = await repository.getThread(event.threadId);
      final rawMessages = response['messages'] as List<dynamic>? ?? [];
      emit(state.copyWith(
        isLoading: false,
        threadId: event.threadId,
        messages: rawMessages.cast<Map<String, dynamic>>(),
      ));
    } catch (_) {
      emit(state.copyWith(isLoading: false, error: 'Failed to load chat history'));
    }
  }
}
