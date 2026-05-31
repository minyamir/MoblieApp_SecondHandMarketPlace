import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ✅ Fixed to match your actual existing workspace folder structure
import '../provider/chat_bloc.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final String sellerName;

  const ChatScreen({
    super.key, 
    required this.roomId, 
    required this.sellerName
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final String _currentUserId = "CURRENT_USER_ID_HEX"; 

  @override
  void initState() {
    super.initState();
    // Connects to the real-time stream via flutter_bloc
    context.read<ChatBloc>().add(ConnectToChatRoom(widget.roomId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B15), 
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F162A),
        elevation: 0,
        title: Text(widget.sellerName, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF00E676)));
                }
                
                if (state is ChatLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final bool isMe = message.senderId == _currentUserId;

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isMe ? const Color(0xFF00E676) : const Color(0xFF0F162A),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(color: isMe ? const Color(0xFF070B15) : Colors.white),
                          ),
                        ),
                      );
                    },
                  );
                }
                
                return const Center(child: Text("Start negotiating...", style: TextStyle(color: Colors.white30)));
              },
            ),
          ),
          
          // Input layout block
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF0F162A),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF070B15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Type negotiation price proposal...",
                        hintStyle: TextStyle(color: Color(0xFF64748B)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: const Color(0xFF00E676),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      context.read<ChatBloc>().add(
                        SendChatMessage(
                          roomId: widget.roomId,
                          text: _messageController.text,
                          senderId: _currentUserId,
                        ),
                      );
                      _messageController.clear();
                    }
                  },
                  child: const Icon(Icons.send_rounded, color: Color(0xFF070B15)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}