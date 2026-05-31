import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<Message>> getMessageStream(String roomId) {
    return remoteDataSource.initializeSocketStream(roomId);
  }

  @override
  Future<void> sendMessage(String roomId, String text, String senderId) async {
    final messageModel = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: senderId,
      text: text,
      timestamp: DateTime.now(),
    );
    remoteDataSource.emitMessage(roomId, messageModel);
  }

  @override
  void disconnect() {
    remoteDataSource.closeConnection();
  }
}