import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../chat/presentation/screens/chat_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:HaHu/features/chat/presentation/provider/chat_bloc.dart';
import 'package:HaHu/core/di/injection_container.dart'; 
import 'package:HaHu/features/chat/domain/repositories/chat_repository.dart';
import 'package:HaHu/features/home/presentation/pages/item_detail_screen.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  int _selectedCategoryIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Updated customized categories lineup
  final List<String> _categories = const [
    "All",
    "Furniture",
    "Electronics",
    "Vehicles",
    "Property",
    "Clothing"
  ];

  final List<Map<String, dynamic>> marketListings = [
    {
      "title": "Sony A7III Mirrorless Ca...",
      "price": "ETB 42,500",
      "seller": "Dawit M.",
      "rating": "4.9",
      "likes": 124, 
      "isLiked": false,
      "condition": "Excellent",
      "image": "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=500",
      "isVerified": true,
      "description": "Professional-grade full-frame mirrorless camera. Features 24.2MP resolution, 4K HDR video capabilities, and exceptional low-light ISO tracking.",
      "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-photographer-adjusting-lens-on-camera-41710-large.mp4", 
    },
    {
      "title": "MacBook Pro M2 14\" 512...",
      "price": "ETB 87,000",
      "seller": "Selam T.",
      "rating": "4.8",
      "likes": 98,
      "isLiked": true,
      "condition": "Like New",
      "image": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500",
      "isVerified": true,
      "description": "Apple MacBook Pro 14-inch workspace rig driven by the premium M2 Pro processor chip.",
      "videoUrl": null, 
    },
    {
      "title": "Pioneer HiFi Sound System",
      "price": "ETB 18,500",
      "seller": "Hirut B.",
      "rating": "4.8",
      "likes": 45,
      "isLiked": false,
      "condition": "Good",
      "image": "https://images.unsplash.com/photo-1545454675-3531b543be5d?w=500",
      "isVerified": true,
      "description": "Retro-ambient studio acoustic tower set containing deep-frequency subwoofers and explicit spatial mid-tones.",
      "videoUrl": null,
    },
    {
      "title": "Nikon D850 DSLR Kit",
      "price": "ETB 68,000",
      "seller": "Bereket A.",
      "rating": "4.7",
      "likes": 110,
      "isLiked": false,
      "condition": "Excellent",
      "image": "https://images.unsplash.com/photo-1606486668508-34636b2d2777?w=500",
      "isVerified": true,
      "description": "High-resolution 45.7-megapixel multimedia powerhouse.",
      "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-holding-a-dslr-camera-up-close-41708-large.mp4",
    }
    , {
      "title": "Sony A7III Mirrorless Ca...",
      "price": "ETB 42,500",
      "seller": "Dawit M.",
      "rating": "4.9",
      "likes": 124, 
      "isLiked": false,
      "condition": "Excellent",
      "image": "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=500",
      "isVerified": true,
      "description": "Professional-grade full-frame mirrorless camera. Features 24.2MP resolution, 4K HDR video capabilities, and exceptional low-light ISO tracking.",
      "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-photographer-adjusting-lens-on-camera-41710-large.mp4", 
    },
    {
      "title": "MacBook Pro M2 14\" 512...",
      "price": "ETB 87,000",
      "seller": "Selam T.",
      "rating": "4.8",
      "likes": 98,
      "isLiked": true,
      "condition": "Like New",
      "image": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500",
      "isVerified": true,
      "description": "Apple MacBook Pro 14-inch workspace rig driven by the premium M2 Pro processor chip.",
      "videoUrl": null, 
    },
    {
      "title": "Pioneer HiFi Sound System",
      "price": "ETB 18,500",
      "seller": "Hirut B.",
      "rating": "4.8",
      "likes": 45,
      "isLiked": false,
      "condition": "Good",
      "image": "https://images.unsplash.com/photo-1545454675-3531b543be5d?w=500",
      "isVerified": true,
      "description": "Retro-ambient studio acoustic tower set containing deep-frequency subwoofers and explicit spatial mid-tones.",
      "videoUrl": null,
    },
    {
      "title": "Nikon D850 DSLR Kit",
      "price": "ETB 68,000",
      "seller": "Bereket A.",
      "rating": "4.7",
      "likes": 110,
      "isLiked": false,
      "condition": "Excellent",
      "image": "https://images.unsplash.com/photo-1606486668508-34636b2d2777?w=500",
      "isVerified": true,
      "description": "High-resolution 45.7-megapixel multimedia powerhouse.",
      "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-holding-a-dslr-camera-up-close-41708-large.mp4",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF070B15),
      
      // Right-aligned Hamburger EndDrawer Integration
      endDrawer: Drawer(
        backgroundColor: const Color(0xFF0F162A),
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF070B15),
                border: Border(bottom: BorderSide(color: Color(0xFF1E293B), width: 1)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E676).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shopping_bag_rounded, color: Color(0xFF00E676), size: 32),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "HaHu Market",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: Text("CATEGORIES", style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  ),
                  ...List.generate(_categories.length, (index) {
                    final isSelected = _selectedCategoryIndex == index;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      selected: isSelected,
                      selectedTileColor: const Color(0xFF00E676).withOpacity(0.08),
                      leading: Icon(
                        index == 0 ? Icons.grid_view_rounded : Icons.label_important_rounded,
                        color: isSelected ? const Color(0xFF00E676) : const Color(0xFF64748B),
                        size: 20,
                      ),
                      title: Text(
                        _categories[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                        Navigator.pop(context); 
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Minimized Header Section (Title Left, Hamburger Right)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Market Browser",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 26),
                    onPressed: () {
                      _scaffoldKey.currentState?.openEndDrawer(); 
                    },
                  ),
                ],
              ),
            ),

            // 2. Minimized Search & Filter Frame
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 46, // Slimmer height
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F162A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const TextField(
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "Search listings...",
                          hintStyle: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                          prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F162A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune_rounded, color: Color(0xFF64748B), size: 18),
                  ),
                ],
              ),
            ),

            // 3. Horizontal Categories Row
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                height: 32, // Minimized height
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedCategoryIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF00E676) : const Color(0xFF0F162A),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? Colors.transparent : const Color(0xFF1E293B),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _categories[index],
                              style: TextStyle(
                                color: isSelected ? const Color(0xFF070B15) : const Color(0xFF64748B),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 4. Counter Indicator 
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
              child: Text(
                "${marketListings.length} listings found",
                style: const TextStyle(
                  color: Color(0xFF475569), 
                  fontFamily: "monospace", 
                  fontSize: 11
                ),
              ),
            ),

            // 5. High-Performance Anti-Crowded Card Grid Mesh Layout
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65, // Expanded ratio prevents bottom layout overflows
                ),
                itemCount: marketListings.length,
                itemBuilder: (context, index) {
                  final item = marketListings[index];
                  final bool currentlyLiked = item["isLiked"];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ItemDetailScreen(itemData: item),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F162A),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFF1E293B), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Fixed height top image container layout frame
                          SizedBox(
                            height: 115, 
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                                    image: DecorationImage(
                                      image: NetworkImage(item["image"]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                if (item["isVerified"])
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00E676),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(Icons.verified_user_rounded, color: Color(0xFF070B15), size: 9),
                                          SizedBox(width: 3),
                                          Text(
                                            "VERIFIED",
                                            style: TextStyle(
                                              color: Color(0xFF070B15), 
                                              fontWeight: FontWeight.w900, 
                                              fontSize: 8,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (currentlyLiked) {
                                          item["isLiked"] = false;
                                          item["likes"] -= 1;
                                        } else {
                                          item["isLiked"] = true;
                                          item["likes"] += 1;
                                        }
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: currentlyLiked ? Colors.redAccent.withOpacity(0.15) : Colors.black45,
                                        shape: BoxShape.circle,
                                        border: currentlyLiked ? Border.all(color: Colors.redAccent, width: 1) : null,
                                      ),
                                      child: Icon(
                                        currentlyLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                        color: currentlyLiked ? Colors.redAccent : Colors.white70,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["title"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item["price"],
                                  style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.w900, fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item["seller"], 
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                                        const SizedBox(width: 1),
                                        Text(item["rating"], style: const TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          const Spacer(),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 30,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).clearSnackBars();
                                        final String cleanRoomId = "room_${item['seller'].toString().trim().replaceAll(' ', '_')}";

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BlocProvider<ChatBloc>(
                                              create: (context) => ChatBloc(
                                                repository: sl<ChatRepository>(),
                                              ),
                                              child: ChatScreen(
                                                roomId: cleanRoomId,
                                                sellerName: item['seller'] ?? 'Verified Seller',
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFF64748B),
                                        side: const BorderSide(color: Color(0xFF1E293B), width: 1.2),
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: const Text(
                                        "Negotiate", 
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white70),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: SizedBox(
                                    height: 30,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF00E676),
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: const Text("Buy", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: Color(0xFF070B15))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}