abstract class ChatEvent {}

class SendChatMessage extends ChatEvent {
  final String userId;
  final String message;

  SendChatMessage({required this.userId, required this.message});
}

class LoadChatThread extends ChatEvent {
  final String threadId;

  LoadChatThread(this.threadId);
}

class ClearChat extends ChatEvent {}
