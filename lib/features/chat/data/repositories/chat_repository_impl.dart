import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;

  ChatRepositoryImpl(this.remote);

  @override
  Future<Map<String, dynamic>> sendMessage({
    required String userId,
    required String message,
    String? threadId,
  }) {
    return remote.sendMessage(userId: userId, message: message, threadId: threadId);
  }

  @override
  Future<Map<String, dynamic>> getThread(String threadId) {
    return remote.getThread(threadId);
  }
}
