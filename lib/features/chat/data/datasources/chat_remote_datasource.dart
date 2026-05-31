import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Stream<List<MessageModel>> initializeSocketStream(String roomId);
  void emitMessage(String roomId, MessageModel message);
  void closeConnection();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  late io.Socket socket;
  final _messageController = StreamController<List<MessageModel>>.broadcast();
  List<MessageModel> _cachedMessages = [];

  ChatRemoteDataSourceImpl() {
    // replace url string reference with your central api_constants config endpoint
    socket = io.io('http://localhost:3000', io.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .build());
    socket.connect();
  }

  @override
  Stream<List<MessageModel>> initializeSocketStream(String roomId) {
    _cachedMessages.clear();
    socket.emit('join_room', roomId);

    socket.on('receive_message', (data) {
      final newMessage = MessageModel.fromJson(data);
      _cachedMessages.add(newMessage);
      _messageController.add(List.from(_cachedMessages));
    });

    return _messageController.stream;
  }

  @override
  void emitMessage(String roomId, MessageModel message) {
    socket.emit('send_message', {
      'roomId': roomId,
      'message': message.toJson(),
    });
    
    // Optimistic local update to instantly refresh user interface
    _cachedMessages.add(message);
    _messageController.add(List.from(_cachedMessages));
  }

  @override
  void closeConnection() {
    socket.disconnect();
  }
}