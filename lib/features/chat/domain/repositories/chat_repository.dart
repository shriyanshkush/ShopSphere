abstract class ChatRepository {
  Future<Map<String, dynamic>> sendMessage({
    required String userId,
    required String message,
    String? threadId,
  });

  Future<Map<String, dynamic>> getThread(String threadId);
}
