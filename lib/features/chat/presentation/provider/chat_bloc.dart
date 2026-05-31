import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

// ✅ Absolute package paths using your exact 'HaHu' package name to guarantee discovery
import 'package:HaHu/features/chat/domain/entities/message.dart';
import 'package:HaHu/features/chat/domain/repositories/chat_repository.dart';

// --- Chat Events ---
abstract class ChatEvent {}

class ConnectToChatRoom extends ChatEvent {
  final String roomId;
  ConnectToChatRoom(this.roomId);
}

class SendChatMessage extends ChatEvent {
  final String roomId;
  final String text;
  final String senderId;
  SendChatMessage({required this.roomId, required this.text, required this.senderId});
}

class UpdateIncomingMessages extends ChatEvent {
  final List<Message> messages;
  UpdateIncomingMessages(this.messages);
}

// --- Chat States ---
abstract class ChatState {}

class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}
class ChatLoaded extends ChatState {
  final List<Message> messages;
  ChatLoaded(this.messages); //  Fixed: explicitly initializing the field
}

// --- Chat BLoC Engine ---
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;
  StreamSubscription? _streamSubscription;

  ChatBloc({required this.repository}) : super(ChatInitial()) {
    
    on<ConnectToChatRoom>((event, emit) {
      emit(ChatLoading());
      _streamSubscription?.cancel();
      
      _streamSubscription = repository.getMessageStream(event.roomId).listen(
        (messages) => add(UpdateIncomingMessages(messages)),
      );
    });

    on<UpdateIncomingMessages>((event, emit) {
      emit(ChatLoaded(event.messages));
    });

    on<SendChatMessage>((event, emit) async {
      if (event.text.trim().isEmpty) return;
      await repository.sendMessage(event.roomId, event.text, event.senderId);
    });
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    repository.disconnect();
    return super.close();
  }
}