class ChatState {
  final List<Map<String, dynamic>> messages;
  final bool isLoading;
  final String? threadId;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.threadId,
    this.error,
  });

  ChatState copyWith({
    List<Map<String, dynamic>>? messages,
    bool? isLoading,
    String? threadId,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      threadId: threadId ?? this.threadId,
      error: error,
    );
  }
}
