import 'package:HaHu/features/chat/domain/entities/message.dart';

/// Abstract contract defining the real-time interaction methods 
/// required for the chat negotiation system.
abstract class ChatRepository {
  
  /// Establishes a connection channel to a specific chat room 
  /// and returns a live stream of message list updates.
  Stream<List<Message>> getMessageStream(String roomId);

  /// Dispatches an outbound negotiation text message to the server room channel.
  Future<void> sendMessage(String roomId, String text, String senderId);

  /// Cleans up active real-time connections, closing down 
  /// open socket resources gracefully when exiting the view.
  void disconnect();
}