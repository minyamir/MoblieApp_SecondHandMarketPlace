import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:HaHu/core/di/injection_container.dart';
import 'package:HaHu/features/chat/domain/repositories/chat_repository.dart';
import 'package:HaHu/features/chat/presentation/provider/chat_bloc.dart';
import 'package:HaHu/features/chat/presentation/screens/chat_screen.dart';

class ItemDetailScreen extends StatefulWidget {
  final Map<String, dynamic> itemData;

  const ItemDetailScreen({super.key, required this.itemData});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _hasVideo = false;

  @override
  void initState() {
    super.initState();
    
    final String? videoUrl = widget.itemData['videoUrl'];
    if (videoUrl != null && videoUrl.isNotEmpty) {
      _hasVideo = true;
      _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          if (!mounted) return; 
          setState(() {
            _isVideoInitialized = true;
          });
          _videoController?.setLooping(true);
          _videoController?.play();
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.itemData['title'] ?? 'Market Item';
    final String price = widget.itemData['price'] ?? 'With Agreement';
    final String description = widget.itemData['description'] ?? 'No description provided.';
    final String seller = widget.itemData['seller'] ?? 'Verified Seller';
    final String fallbackImageUrl = widget.itemData['image'] ?? 'https://via.placeholder.com/300'; 

    return Scaffold(
      backgroundColor: const Color(0xFF070B15),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F162A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Media Container Section ---
            Container(
              width: double.infinity,
              height: 320,
              color: Colors.black,
              // ✅ FIXED: Explicitly separated the Image layout block from the Video Player initializing loop
              child: _hasVideo 
                  ? _isVideoInitialized
                      ? Stack(
                          children: [
                            Center(
                              child: AspectRatio(
                                aspectRatio: _videoController!.value.aspectRatio,
                                child: VideoPlayer(_videoController!),
                              ),
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _videoController!.value.isPlaying 
                                        ? _videoController!.pause() 
                                        : _videoController!.play();
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white24, width: 1.5),
                                  ),
                                  child: Icon(
                                    _videoController!.value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                    color: const Color(0xFF00E676),
                                    size: 36,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: VideoProgressIndicator(
                                _videoController!, 
                                allowScrubbing: true,
                                colors: const VideoProgressColors(
                                  playedColor: Color(0xFF00E676),
                                  bufferedColor: Colors.white24,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        )
                      : const Center(child: CircularProgressIndicator(color: Color(0xFF00E676)))
                  : Image.network(
                      fallbackImageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.broken_image_rounded, color: Color(0xFF64748B), size: 42),
                        );
                      },
                    ),
            ),

            // --- Details Content Panel ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(price, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF00E676))),
                      if (_hasVideo)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withOpacity(0.15), 
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3), width: 1),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.videocam_rounded, color: Color(0xFFEF4444), size: 14),
                              SizedBox(width: 4),
                              Text("LIVE VIDEO", style: TextStyle(color: Color(0xFFEF4444), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, height: 1.3)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.verified_user_rounded, color: Color(0xFF64748B), size: 16),
                      const SizedBox(width: 6),
                      Text("Listed by $seller", style: const TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const Divider(color: Color(0xFF1E293B), height: 40, thickness: 1.5),
                  const Text("Item Condition & Details", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.2)),
                  const SizedBox(height: 12),
                  Text(
                    description, 
                    style: const TextStyle(fontSize: 15, color: Color(0xFF94A3B8), height: 1.6, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 40), 
                ],
              ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        decoration: const BoxDecoration(
          color: Color(0xFF0F162A),
          border: Border(top: BorderSide(color: Color(0xFF1E293B), width: 1)),
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E293B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              side: const BorderSide(color: Color(0xFF00E676), width: 1.2),
              elevation: 0,
            ),
            icon: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF00E676), size: 20),
            label: const Text("Negotiate Price", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.3)),
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              
              final String cleanRoomId = "room_${seller.toString().trim().replaceAll(' ', '_')}";

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider<ChatBloc>(
                    create: (_) => ChatBloc(
                      repository: sl<ChatRepository>(),
                    ),
                    child: ChatScreen(
                      roomId: cleanRoomId,
                      sellerName: seller,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}